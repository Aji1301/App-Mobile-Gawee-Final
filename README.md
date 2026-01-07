
```markdown
# Gawee - Job Finder Application 🚀

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue?logo=dart)
![Supabase](https://img.shields.io/badge/Backend-Supabase-green?logo=supabase)
![Status](https://img.shields.io/badge/Status-In%20Development-orange)

**Gawee** is a modern mobile application built with Flutter that connects job seekers with recruiters. It features a seamless onboarding experience, real-time job updates, dynamic job posting, and social authentication, powered by a Supabase backend.

---

## 📱 Screenshots

| Onboarding | Dashboard | Job Details | Post Job |
|:---:|:---:|:---:|:---:|
| <img src="assets/images/onboarding_1.png" width="200" alt="Onboarding"> | <img src="screenshots/dashboard.png" width="200" alt="Dashboard"> | <img src="screenshots/detail.png" width="200" alt="Detail"> | <img src="screenshots/post_job.png" width="200" alt="Post Job"> |

*(Note: Replace the paths above with your actual screenshot paths)*

---

## ✨ Key Features

* **🔐 Authentication:**
    * Secure Email/Password Login & Register.
    * **Google Sign-In Integration** with auto-sync to user profiles.
    * Role-based access (Job Seeker / Recruiter).

* **👋 Onboarding & User Experience:**
    * Interactive Onboarding Carousel with `smooth_page_indicator`.
    * Role selection screen (Seeker vs Recruiter).
    * Dark Mode & Light Mode support (`ThemeProvider`).

* **🏠 Dashboard:**
    * **Real-time Stats:** Track "Jobs Applied" and "Interviews" updated via Supabase Realtime.
    * **Dynamic Categories:** Automatically generated based on available jobs in the database.
    * **Featured & Recent Jobs:** Horizontal and vertical lists with bookmark functionality.

* **💼 Job Management:**
    * **Post a Job:** Recruiters can post jobs with dynamic **Requirements** (bullet points), Salary Range, and Categories.
    * **Job Details:** Tabbed view for Job Description, Requirements (dynamically rendered), and Company Gallery.
    * **Search:** Filter jobs by title or keyword.

* **💬 Chat & Apply:**
    * Direct Chat feature between applicants and companies.
    * "Apply Job" mechanism using bottom sheet submission.

---

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/)
* **Language:** Dart
* **Backend & Database:** [Supabase](https://supabase.com/)
* **State Management:** Provider
* **Key Packages:**
    * `supabase_flutter`: For Auth, Database, and Realtime.
    * `google_fonts`: For custom typography (Poppins).
    * `provider`: For managing Theme and User state.
    * `smooth_page_indicator`: For the onboarding UI.
    * `google_sign_in`: For Google Authentication.

---

## 🗄️ Database Schema (Supabase)

This app requires the following tables in Supabase:

### 1. `profiles`
Stores user information synced with Auth.
- `id` (uuid, primary key, references auth.users)
- `full_name` (text)
- `email` (text)
- `avatar_url` (text)
- `role` (text) - 'seeker' or 'recruiter'

### 2. `jobs`
Stores job postings.
- `id` (int8, primary key)
- `title` (text)
- `company_name` (text)
- `location` (text)
- `salary_range` (text)
- `description` (text)
- `requirements` (text) - *Stores multiline text separated by enter*
- `category` (text)
- `is_saved` (boolean)
- `created_by` (uuid)

### 3. `applications`
Tracks job applications.
- `id` (int8, primary key)
- `job_id` (int8, fk)
- `applicant_id` (uuid, fk)
- `status` (text) - 'applied', 'interview', 'rejected'

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK installed.
* A Supabase project created.

### Installation

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/username/gawee.git](https://github.com/username/gawee.git)
    cd gawee
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Configure Supabase**
    * Create a file `lib/utils/constants.dart` (if not exists) or locate your Supabase initialization config.
    * Add your Supabase URL and Anon Key:
    ```dart
    const supabaseUrl = 'YOUR_SUPABASE_URL';
    const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
    ```

4.  **Run the App**
    ```bash
    flutter run
    ```

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
---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

<center>Made with ❤️ by Team </center>

```
