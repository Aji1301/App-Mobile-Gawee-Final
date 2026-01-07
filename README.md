# gawe_gawe

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



DIBAWAH INI UNTUK MENGATUR ROLE & ID DI DATABASE👇🏻👇🏻👇🏻👇🏻
UPDATE public.profiles
SET 
  role = 'company',               -- Mengubah role jadi company
  company_id = 'GOOGLE-01',       -- ID Unik Perusahaan (PENTING)
  username = 'Google Indonesia',  -- Nama Perusahaan
  full_name = 'Recruitment Team', -- Nama HRD
  job_title = 'HR Manager',
  location = 'Jakarta Selatan'
WHERE id = (
  SELECT id FROM auth.users WHERE email = 'admin@google.com'
);

