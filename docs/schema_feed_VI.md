# Schema Tính năng Bảng tin

Tài liệu này mô tả cấu trúc cơ sở dữ liệu cho tính năng **Bảng tin**, cụ thể là bảng `posts`. Nó lưu trữ nội dung do người dùng tạo bao gồm chú thích văn bản và URL hình ảnh.

## Điều kiện tiên quyết

- **Bảng Profiles phải tồn tại**: Bảng `posts` liên kết với `profiles.id`. Đảm bảo bạn đã triển khai [Schema Xác thực](schema_auth_VI.md) trước.

## Triển khai SQL

Thực thi đoạn SQL sau trong Supabase SQL Editor.

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

-- 2. Bật Row Level Security (RLS)
alter table public.posts enable row level security;

-- 3. Tạo các chính sách RLS

-- Quyền đọc công khai: Mọi người đều có thể xem bài viết
create policy "Public posts are viewable by everyone."
  on posts for select
  using ( true );

-- Quyền tạo: Người dùng đã xác thực có thể tạo bài viết của chính họ
create policy "Users can insert their own posts."
  on posts for insert
  with check ( auth.uid() = profile_id );

-- Quyền cập nhật: Người dùng chỉ có thể cập nhật nội dung của chính họ
create policy "Users can update own posts."
  on posts for update
  using ( auth.uid() = profile_id );

-- Quyền xóa: Người dùng chỉ có thể xóa nội dung của chính họ
create policy "Users can delete own posts."
  on posts for delete
  using ( auth.uid() = profile_id );
```

## Tích hợp mô hình dữ liệu

Bảng `posts` được ánh xạ tới `PostModel` trong ứng dụng Flutter. Đảm bảo các trường khớp với logic tuần tự hóa JSON trong lớp domain của bạn.
