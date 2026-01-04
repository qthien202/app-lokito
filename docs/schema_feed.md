[ 🇬🇧 English ](#english) | [ 🇻🇳 Tiếng Việt ](#vietnamese)

---

<a name="english"></a>
# Feed Feature Schema

## Introduction
This document outlines the database schema required for the **Feed** feature, specifically the posts table. It stores user-generated content including text captions and image URLs.

## Prerequisites
- **Profiles Table must exist**: The `posts` table links to `profiles.id`. Ensure you have run the [Auth Schema](schema_auth.md) script first.

## SQL Script

Run the following SQL in the Supabase SQL Editor.

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

-- 2. Enable Row Level Security
alter table public.posts enable row level security;

-- 3. Create RLS Policies

-- Everyone can view posts
create policy "Public posts are viewable by everyone."
  on posts for select
  using ( true );

-- Authenticated users can create posts (linked to their ID)
create policy "Users can insert their own posts."
  on posts for insert
  with check ( auth.uid() = profile_id );

-- Users can update only their own posts
create policy "Users can update own posts."
  on posts for update
  using ( auth.uid() = profile_id );

-- Users can delete only their own posts
create policy "Users can delete own posts."
  on posts for delete
  using ( auth.uid() = profile_id );
```

---

<a name="vietnamese"></a>
# Schema Tính năng Bảng tin

## Giới thiệu
Tài liệu này mô tả cấu trúc cơ sở dữ liệu (schema) cần thiết cho tính năng **Bảng tin**, cụ thể là bảng bài viết (posts). Nó lưu trữ nội dung do người dùng tạo ra, bao gồm chú thích (caption) và đường dẫn ảnh.

## Điều kiện tiên quyết
- **Bảng Profiles phải tồn tại**: Bảng `posts` liên kết với `profiles.id`. Hãy chắc chắn bạn đã chạy script [Schema Xác thực](schema_auth.md) trước.

## Mã SQL

Chạy đoạn SQL sau trong Supabase SQL Editor.

```sql
-- 1. Tạo bảng posts
create table public.posts (
  id uuid not null default gen_random_uuid() primary key,
  profile_id uuid references public.profiles(id) not null,
  content text,
  image_url text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  
  -- Các bộ đếm tương tác
  likes_count bigint default 0,
  comments_count bigint default 0
);

-- 2. Bật bảo mật RLS (Row Level Security)
alter table public.posts enable row level security;

-- 3. Tạo các quy tắc bảo mật (Policies)

-- Ai cũng xem được bài viết
create policy "Public posts are viewable by everyone."
  on posts for select
  using ( true );

-- User đã đăng nhập có thể đăng bài (gắn với ID của họ)
create policy "Users can insert their own posts."
  on posts for insert
  with check ( auth.uid() = profile_id );

-- Chỉ chính chủ mới được sửa bài của mình
create policy "Users can update own posts."
  on posts for update
  using ( auth.uid() = profile_id );

-- Chỉ chính chủ mới được xóa bài của mình
create policy "Users can delete own posts."
  on posts for delete
  using ( auth.uid() = profile_id );
```
