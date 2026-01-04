# Authentication Feature Schema

This document defines the database structure required for **User Authentication** and profiles management using Supabase.

## Overview

Supabase manages user credentials in the internal `auth.users` table. We utilize a `public.profiles` table to store extended user information (avatars, usernames, display names) that needs to be accessible via the application.

## SQL Implementation

Execute the following SQL in the Supabase SQL Editor.

```sql
-- 1. Create profiles table
create table public.profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  username text unique,
  full_name text,
  avatar_url text,
  website text,

  -- Constraint: Username integrity package
  constraint username_length check (char_length(username) >= 3)
);

-- 2. Enable Row Level Security (RLS)
alter table profiles enable row level security;

-- 3. Create RLS Policies

-- Read Access: Profiles are public for social discovery
create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

-- Create Access: Users create their profile upon signup
create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

-- Update Access: Users can modify their own profile data
create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- 4. Automation: Profile Creation Trigger
-- Automatically populates the public profiles table when a user registers.

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, avatar_url, username)
  values (
    new.id, 
    new.raw_user_meta_data->>'full_name', 
    new.raw_user_meta_data->>'avatar_url',
    new.email -- Fallback to email as username if metadata is absent
  );
  return new;
end;
$$ language plpgsql security definer;

-- Bind trigger to auth.users
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

## Security Note

Ensure that `PostgreSQL Policy` is strictly enforced to protect user data. The `security definer` on the trigger function allows it to run with elevated privileges to bypass RLS during the initialization phase.
