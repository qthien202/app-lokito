# Schema Tính năng Xác thực

Tài liệu này định nghĩa cấu trúc cơ sở dữ liệu cần thiết cho tính năng **Xác thực** và quản lý hồ sơ người dùng bằng Supabase.

## Tổng quan

Supabase quản lý thông tin đăng nhập trong bảng nội bộ `auth.users`. Chúng ta sử dụng một bảng công khai `public.profiles` để lưu trữ thông tin người dùng mở rộng (ảnh đại diện, tên người dùng, tên hiển thị) cần thiết để truy cập qua ứng dụng.

## Triển khai SQL

Chạy đoạn mã SQL sau trong Supabase SQL Editor.

```sql
-- 1. Tạo bảng profiles
create table public.profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  username text unique,
  full_name text,
  avatar_url text,
  website text,

  -- Ràng buộc: Độ dài username
  constraint username_length check (char_length(username) >= 3)
);

-- 2. Bật Row Level Security (RLS)
alter table profiles enable row level security;

-- 3. Tạo các chính sách RLS

-- Quyền đọc: Hồ sơ được công khai để mọi người có thể tìm thấy nhau
create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

-- Quyền tạo: Người dùng tạo hồ sơ của chính mình khi đăng ký
create policy "Users can insert their own profile."
  on profiles for insert
  with check ( auth.uid() = id );

-- Quyền cập nhật: Người dùng chỉ có thể sửa dữ liệu hồ sơ của chính họ
create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- 4. Tự động hóa: Trigger tạo hồ sơ mới
-- Tự động điền dữ liệu vào bảng profiles khi có người dùng đăng ký mới.

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name, avatar_url, username)
  values (
    new.id, 
    new.raw_user_meta_data->>'full_name', 
    new.raw_user_meta_data->>'avatar_url',
    new.email -- Sử dụng email làm username mặc định nếu không có metadata
  );
  return new;
end;
$$ language plpgsql security definer;

-- Gắn trigger vào bảng auth.users
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

## Lưu ý bảo mật

Đảm bảo rằng các chính sách RLS được thực thi nghiêm ngặt để bảo vệ dữ liệu người dùng. Quyền `security definer` trên hàm trigger cho phép nó chạy với đặc quyền cao để bỏ qua RLS trong giai đoạn khởi tạo ban đầu.
