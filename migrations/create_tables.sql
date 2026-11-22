
create table public.profiles (
    id uuid not null default auth.uid (),
    created_at timestamp with time zone not null default now(),
    username text not null,
    constraint profiles_pkey primary key (id),
    constraint profiles_username_key unique (username),
    constraint profiles_id_fkey foreign KEY (id) references auth.users (id) on delete CASCADE
) TABLESPACE pg_default;

alter table public.profiles
    enable row level security;

create policy "Users can read their own profile."
on "public"."profiles"
as PERMISSIVE
for SELECT
to authenticated
using (
    (select auth.uid()) = id
);

create policy "Users can update their own profile."
on "public"."profiles"
as PERMISSIVE
for UPDATE
to authenticated
using (
    (select auth.uid()) = id
) with check (
    (select auth.uid()) = id
);

-- -------------------------------------------------------------------------------

create table public.modules (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    title text null,
    description text null,
    "position" bigint null,
    published boolean null default false,
    constraint modules_pkey primary key (id),
    constraint modules_position_key unique ("position"),
    constraint modules_title_key unique (title)
) TABLESPACE pg_default;

alter table public.modules
    enable row level security;

create policy "Everyone can read modules"
on "public"."modules"
as PERMISSIVE
for SELECT
to public
using (
    published = true
);



-- -------------------------------------------------------------------------------

create table public.lessons (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    module_id uuid not null,
    title text null,
    description text null,
    content text null,
    "position" bigint null,
    starter_code text null,
    validation_rules json null,
    published boolean null default false,
    constraint lessons_pkey primary key (id),
    constraint lessons_title_key unique (title),
    constraint lessons_module_id_fkey foreign KEY (module_id) references modules (id)
) TABLESPACE pg_default;

alter table public.lessons
    enable row level security;

create policy "Everyone can read lessons"
on "public"."lessons"
as PERMISSIVE
for SELECT
to public
using (
    published = true
);

-- -------------------------------------------------------------------------------

create table public.progresses (
    id uuid not null default gen_random_uuid (),
    user_id uuid null,
    lesson_id uuid null,
    status text null,
    attempts bigint null,
    completed_at timestamp with time zone null,
    updated_at timestamp with time zone null,
    constraint progresses_pkey primary key (id),
    constraint progresses_lesson_id_fkey foreign KEY (lesson_id) references lessons (id),
    constraint progresses_user_id_fkey foreign KEY (user_id) references profiles (id)
) TABLESPACE pg_default;

alter table public.progresses
    enable row level security;

create policy "Users can read their own progress"
on "public"."progresses"
as PERMISSIVE
for SELECT
to authenticated
using (
    (select auth.uid()) = user_id
);

create policy "Users can insert their own progress"
on "public"."progresses"
as PERMISSIVE
for INSERT
to authenticated
with check (
    (select auth.uid()) = user_id
);

create policy "Users can update their own progress"
on "public"."progresses"
as PERMISSIVE
for UPDATE
to authenticated
using (
    (select auth.uid()) = user_id
) with check (
    (select auth.uid()) = user_id
);

-- -------------------------------------------------------------------------------

INSERT INTO public.modules (id, created_at, title, description, "position", published)
VALUES
    ('17273826-1c9b-486d-980b-dfe60ee4da10', '2026-11-22 08:10:11.045761+00', 'Lists', null, 3, false),
    ('1a3d0490-d5b8-4146-ad61-eb35bc14fd7a', '2026-11-22 08:10:48.574278+00', 'Media', null, 6, false),
    ('26049907-4486-418f-b793-c013263aa94d', '2026-11-22 08:11:27.581523+00', 'Debugging HTML', null, 9, false),
    ('32a66fe3-833b-4072-9ba8-ee17073c512a', '2026-11-22 08:11:07.265515+00', 'HTML tables', null, 8, false),
    ('764e8c1a-76e6-4b11-9248-0329527a07ad', '2026-11-22 08:10:38.898175+00', 'Links', null, 5, false),
    ('7c3416e1-475f-4172-bed5-c716b14050cf', '2026-11-22 08:10:26.415772+00', 'Advanced text techniques', null, 4, false),
    ('81d9121c-5850-4cff-b506-dc16554349ad', '2026-11-22 08:09:29.035325+00', '2.1 Basic HTML syntax', null, 1, false),
    ('8bac08c9-346e-493b-8f7b-ca2154062949', '2026-11-22 08:09:54.763316+00', 'Good document structure', null, 2, false),
    ('fc005710-4e65-400f-9405-e911b3a7e0be', '2026-11-22 08:10:58.231616+00', 'Other interactive elements', null, 7, false);