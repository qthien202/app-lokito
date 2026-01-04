[ 🇬🇧 English ](#english) | [ 🇻🇳 Tiếng Việt ](#vietnamese)

---

<a name="english"></a>
# Auth Feature Schema

## Introduction
This document outlines the database schema required for the **Authentication** feature, specifically the user profiles.

Supabase handles user credentials in the `auth.users` table. We need a public `public.profiles` table to store extra user information like avatars and display names.

## SQL Script

Run the following SQL in the Supabase SQL Editor.

```sql
-- 1. Create profiles table
-- Stores public user information
create table public.profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  username text unique,
  full_name text,
  avatar_url text,
  website text,

  -- Constraint: Username must be at least 3 chars
  constraint username_length check (char_length(username) >= 3)
);

-- 2. Enable Row Level Security
alter table profiles enable row level security;

-- 3. Create RLS Policies

-- Everyone can view profiles
create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

-- Users can insert their own profile
create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

-- Users can update only their own profile
create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- 4. Create Trigger for New Users
-- Automatically creates a profile entry when a user signs up via Auth

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, avatar_url, username)
  values (
    new.id, 
    new.raw_user_meta_data->>'full_name', 
    new.raw_user_meta_data->>'avatar_url',
    new.email -- Default username to email if not provided
  );
  return new;
end;
$$ language plpgsql security definer;

-- Bind the trigger to auth.users
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

---

<a name="vietnamese"></a>
# Schema Tính năng Xác thực

## Giới thiệu
Tài liệu này mô tả cấu trúc cơ sở dữ liệu (schema) cần thiết cho tính năng **Xác thực**, cụ thể là hồ sơ người dùng (profiles).

Supabase quản lý thông tin đăng nhập trong bảng `auth.users`. Chúng ta cần bảng công khai `public.profiles` để lưu thêm thông tin như ảnh đại diện và tên hiển thị.

## Mã SQL

Chạy đoạn SQL sau trong Supabase SQL Editor.

```sql
-- 1. Tạo bảng profiles
-- Lưu thông tin công khai của user
create table public.profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  username text unique,
  full_name text,
  avatar_url text,
  website text,

  -- Ràng buộc: Username phải có ít nhất 3 ký tự
  constraint username_length check (char_length(username) >= 3)
);

-- 2. Bật bảo mật RLS (Row Level Security)
alter table profiles enable row level security;

-- 3. Tạo các quy tắc bảo mật (Policies)

-- Ai cũng xem được profile
create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

-- User có thể tự tạo profile cho mình
create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

-- Chỉ chính chủ mới được sửa profile của mình
create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- 4. Tạo Trigger cho User mới
-- Tự động tạo dòng trong bảng profiles khi có user đăng ký qua Auth

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, avatar_url, username)
  values (
    new.id, 
    new.raw_user_meta_data->>'full_name', 
    new.raw_user_meta_data->>'avatar_url',
    new.email -- Tạm lấy email làm username mặc định nếu không có
  );
  return new;
end;
$$ language plpgsql security definer;

-- Gắn trigger vào bảng auth.users
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```
