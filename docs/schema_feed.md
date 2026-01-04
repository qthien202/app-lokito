# Feed Feature Schema

This document outlines the database schema required for the **Feed** feature, specifically the `posts` table. It stores user-generated content including text captions and image URLs.

## Prerequisites

- **Profiles Table must exist**: The `posts` table links to `profiles.id`. Ensure you have implemented the [Auth Schema](schema_auth.md) first.

## SQL Implementation

Execute the following SQL in your Supabase SQL Editor.

```sql
-- 1. Create posts table
create table public.posts (
  id uuid not null default gen_random_uuid() primary key,
  profile_id uuid references public.profiles(id) not null,
  content text,
  image_url text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  
  -- Interaction counters
  likes_count bigint default 0,
  comments_count bigint default 0
);

-- 2. Enable Row Level Security (RLS)
alter table public.posts enable row level security;

-- 3. Create RLS Policies

-- Public Read Access: Everyone can view posts
create policy "Public posts are viewable by everyone."
  on posts for select
  using ( true );

-- Create Access: Authenticated users can create their own posts
create policy "Users can insert their own posts."
  on posts for insert
  with check ( auth.uid() = profile_id );

-- Update Access: Users can update only their own content
create policy "Users can update own posts."
  on posts for update
  using ( auth.uid() = profile_id );

-- Delete Access: Users can delete only their own content
create policy "Users can delete own posts."
  on posts for delete
  using ( auth.uid() = profile_id );
```

## Data Model Integration

The `posts` table is mapped to the `PostModel` in the Flutter application. Ensure the fields match the JSON serialization logic in your domain layer.
