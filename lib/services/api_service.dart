import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:file_picker/file_picker.dart'; // Import File Picker

class ApiService {
  // Instance Supabase Client
  static final _supabase = Supabase.instance.client;

  // getter agar bisa diakses dari luar jika perlu (misal: realtime subscription)
  static SupabaseClient get client => _supabase;

  // ===========================================================================
  // AUTHENTICATION (LOGIN & REGISTER)
  // ===========================================================================

  static Future<bool> register(
      String username, String email, String password, {String role = 'seeker'}) async {
    try {
      print("🔵 Mencoba mendaftar ke Supabase: $email"); 

      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'role': role, 
        },
      );
      
      print("🟢 Respon Supabase User ID: ${res.user?.id}");

      if (res.user != null) {
        return true;
      } else {
        print("🔴 Pendaftaran Gagal: User null");
        return false;
      }

    } catch (e) {
      print('====================================');
      print('🔴 ERROR REGISTER: $e');
      print('====================================');
      return false;
    }
  }

  static Future<bool> login(String email, String password, String role,
      {String? companyId}) async {
    try {
      print("🔵 Mencoba Login: $email ($role)");
      
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        final profile = await _supabase
            .from('profiles')
            .select()
            .eq('id', res.user!.id)
            .single();

        print("🟢 Login Berhasil. Role di DB: ${profile['role']}");

        if (profile['role'] == role) {
          if (role == 'company' && companyId != null) {
              if (profile['company_id'] != companyId) {
                print("🔴 Company ID Salah!");
                return false;
              }
          }
          return true; 
        } else {
          print("🔴 Role Salah! User adalah ${profile['role']}, mencoba login sbg $role");
        }
      }
      return false;
    } catch (e) {
      print('🔴 Error login: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // ===========================================================================
  // DASHBOARD & PROFILE
  // ===========================================================================

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      
      return {
        'name': data['full_name'] ?? data['username'] ?? 'User', 
        'avatar': data['avatar_url'], 
        'job_title': data['job_title'],
        'location': data['location'],
        ...data,
      };
    } catch (e) {
      print('🔴 Error get profile: $e');
      return null;
    }
  }

  // ===========================================================================
  // JOBS (LOWONGAN KERJA - SISI SEEKER)
  // ===========================================================================

 static Future<List<Map<String, dynamic>>> getJobs({
    String? query, 
    String? location,
    String? companyName,
    String? category, // ✅ TAMBAHAN: Parameter Khusus Kategori
  }) async {
    try {
      var db = _supabase.from('jobs').select();

      // 1. Filter Kategori (Wajib Sama Persis)
      if (category != null && category.isNotEmpty) {
        db = db.eq('category', category); 
      }

      // 2. Filter Perusahaan
      if (companyName != null && companyName.isNotEmpty) {
        db = db.eq('company_name', companyName);
      }

      // 3. Filter Lokasi
      if (location != null && location.isNotEmpty) {
        db = db.ilike('location', '%$location%');
      }

      // 4. Filter Search Bar (Cari Judul)
      if (query != null && query.isNotEmpty) {
        db = db.ilike('title', '%$query%'); 
      }

      final data = await db.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('🔴 Error get jobs: $e');
      return [];
    }
  }
  
  // Fungsi fetchJobs (Alias untuk getJobs tanpa filter, digunakan di Job List Screen)
  static Future<List<Map<String, dynamic>>?> fetchJobs() async {
    try {
      final response = await _supabase
          .from('jobs')
          .select('id, title, company_name, description, location, category, created_at, requirements') // Include location & category
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching jobs: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getCompanies() async {
    try {
      final data = await _supabase.from('jobs').select('company_name, location');
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('🔴 Error get companies: $e');
      return [];
    }
  }

// Fungsi khusus untuk mengambil hanya pekerjaan yang is_featured = true
  static Future<List<Map<String, dynamic>>> getFeaturedJobs() async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('is_featured', true) // Filter Featured
          .order('created_at', ascending: false)
          .limit(5); 
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching featured jobs: $e");
      return [];
    }
  }

  // ===========================================================================
  // APPLICATIONS (MELAMAR KERJA - SISI SEEKER)
  // ===========================================================================

  // 1. Fungsi untuk Melamar Pekerjaan (Sederhana - digunakan di Job List Screen)
  static Future<bool> applyJob(String jobId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Cek dulu apakah user sudah pernah melamar pekerjaan ini?
      final existing = await _supabase
          .from('applications')
          .select()
          .eq('job_id', jobId)
          .eq('applicant_id', user.id)
          .maybeSingle();

      if (existing != null) {
        // Sudah pernah melamar
        return false; 
      }

      // Ambil data resume URL jika ada
      final profile = await _supabase
          .from('profiles')
          .select('resume_url, full_name, email, phone') 
          .eq('id', user.id)
          .single();

      // Jika belum, lakukan insert
      await _supabase.from('applications').insert({
        'job_id': jobId,
        'applicant_id': user.id,
        'applicant_name': profile['full_name'] ?? user.userMetadata?['username'] ?? 'Unknown',
        'applicant_email': profile['email'] ?? user.email,
        'applicant_phone': profile['phone'],
        'resume_url': profile['resume_url'],
        'status': 'pending',
      });

      return true;
    } catch (e) {
      print("Error applying job: $e");
      return false;
    }
  }

  // 2. Fungsi Apply Job Lengkap (dengan parameter eksplisit)
  static Future<bool> applyJobWithDetails({
    required String jobId,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // 1. AMBIL RESUME DARI PROFIL DULU
      final profile = await _supabase
          .from('profiles')
          .select('resume_url')
          .eq('id', user.id)
          .single();
      
      final String? existingResume = profile['resume_url'];

      // 2. KIRIM LAMARAN DENGAN RESUME TERLAMPIR
      await _supabase.from('applications').insert({
        'job_id': jobId,
        'applicant_id': user.id,
        'applicant_name': name,
        'applicant_email': email,
        'applicant_phone': phone,
        'resume_url': existingResume, 
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // UPDATE PROFILE (WEB SUPPORT: MENGGUNAKAN XFile)
  // ===========================================================================
  
  static Future<bool> updateAvatar(XFile imageFile) async {
    try {
      print("🔵 Mulai Upload Avatar...");
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final bytes = await imageFile.readAsBytes();
      
      final fileExt = imageFile.name.split('.').last;
      final fileName = '${user.id}/avatar.$fileExt';

      await _supabase.storage.from('avatars').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final imageUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
      final imageUrlWithCache = '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}';

      await _supabase.from('profiles').update({
        'avatar_url': imageUrlWithCache
      }).eq('id', user.id);

      print("🟢 Upload Berhasil: $imageUrlWithCache");
      return true;
    } catch (e) {
      print('🔴 Error update avatar: $e');
      return false;
    }
  }

  // ===========================================================================
  // DASHBOARD STATISTICS (SISI SEEKER)
  // ===========================================================================

  static Future<Map<String, int>> getDashboardStats() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return {'applied': 0, 'interviews': 0};

      final appliedCount = await _supabase
          .from('applications')
          .count(CountOption.exact)
          .eq('applicant_id', user.id);

      final interviewCount = await _supabase
          .from('applications')
          .count(CountOption.exact)
          .eq('applicant_id', user.id)
          .eq('status', 'interview'); 

      return {
        'applied': appliedCount,
        'interviews': interviewCount,
      };
    } catch (e) {
      print('🔴 Error get stats: $e');
      return {'applied': 0, 'interviews': 0};
    }
  }

  // ===========================================================================
  // COMPANY FEATURES
  // ===========================================================================

  static Future<List<Map<String, dynamic>>> getCompanyJobs() async {
      try {
        final user = _supabase.auth.currentUser;
        if (user == null) return [];

        // ✅ UPDATE: Tambahkan ', applications(*)' di dalam select 
        // untuk mengambil data pelamar sekaligus.
        final data = await _supabase
            .from('jobs')
            .select('*, applications(*)') 
            .eq('created_by', user.id)
            .order('created_at', ascending: false);
        
        return List<Map<String, dynamic>>.from(data);
      } catch (e) {
        print('🔴 Error get company jobs: $e');
        return [];
      }
    }

  static Future<List<Map<String, dynamic>>> getApplicants(String jobId) async {
    try {
      final data = await _supabase
          .from('applications')
          .select()
          .eq('job_id', jobId)
          .order('created_at', ascending: false);
          
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('🔴 Error get applicants: $e');
      return [];
    }
  }

  static Future<bool> updateApplicationStatus(String applicationId, String newStatus) async {
    try {
      await _supabase
          .from('applications')
          .update({'status': newStatus})
          .eq('id', applicationId);
      return true;
    } catch (e) {
      print('🔴 Error update status: $e');
      return false;
    }
  }

  // ✅ UPDATE: Menambahkan parameter Category agar tersimpan di DB
  static Future<bool> postJob({
    required String title,
    required String companyName,
    required String location,
    required String salaryRange,
    required String description,
    required String category,
    String? requirements, // <--- PARAMETER BARU
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('jobs').insert({
        'created_by': user.id,
        'title': title,
        'company_name': companyName,
        'location': location,
        'salary_range': salaryRange,
        'description': description,
        'category': category, 
        'requirements': requirements,
        'is_featured': false,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('🔴 Error post job: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getMyApplications() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final data = await _supabase
          .from('applications')
          .select('*, jobs(title, company_name, location, salary_range)')
          .eq('applicant_id', user.id)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('🔴 Error get my applications: $e');
      return [];
    }
  }

  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .delete()
          .eq('id', notificationId);
      return true;
    } catch (e) {
      print('🔴 Error delete notification: $e');
      return false;
    }
  }

  // 7. UPLOAD RESUME
  static Future<bool> uploadResume(PlatformFile file) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final fileExt = file.extension ?? 'pdf';
      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      if (kIsWeb) {
        if (file.bytes != null) {
          await _supabase.storage.from('resumes').uploadBinary(
                fileName,
                file.bytes!,
                fileOptions: const FileOptions(upsert: true),
              );
        } else {
          print("🔴 Error: File bytes kosong di Web");
          return false;
        }
      } else {
        if (file.path != null) {
          await _supabase.storage.from('resumes').upload(
                fileName,
                File(file.path!),
                fileOptions: const FileOptions(upsert: true),
              );
        } else {
          print("🔴 Error: File path kosong di Mobile");
          return false;
        }
      }

      final String publicUrl = _supabase.storage.from('resumes').getPublicUrl(fileName);

      await _supabase.from('profiles').update({
        'resume_url': publicUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      print("🟢 Resume Upload Berhasil: $publicUrl");
      return true;
    } catch (e) {
      print('🔴 Error upload resume: $e');
      return false;
    }
  }

  // 8. UPDATE RESUME DETAIL (Generik)
  static Future<bool> updateResumeDetail(String columnName, dynamic value) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('profiles').update({
        columnName: value,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      print("🟢 Berhasil update $columnName");
      return true;
    } catch (e) {
      print('🔴 Error update resume detail: $e');
      return false;
    }
  }
  
// 9. AMBIL DATA RESUME LENGKAP
  static Future<Map<String, dynamic>?> getResumeData({String? userId}) async {
    try {
      final targetId = userId ?? _supabase.auth.currentUser?.id;
      
      if (targetId == null) return null;

      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', targetId)
          .single();
      
      return data;
    } catch (e) {
      print('🔴 Error get resume data: $e');
      return null;
    }
  }

  // ===========================================================================
  // SOCIAL LOGIN (GOOGLE / FACEBOOK)
  // ===========================================================================

  static Future<bool> signInWithOAuth(OAuthProvider provider) async {
    try {
      final redirectUrl = kIsWeb ? null : 'io.supabase.gawe://login-callback';

      await _supabase.auth.signInWithOAuth(
        provider,
        redirectTo: redirectUrl,
        authScreenLaunchMode: LaunchMode.externalApplication, 
      );
      
      return true;
    } catch (e) {
      print('🔴 Error Social Login: $e');
      return false;
    }
  }

  // 🔥 UPDATE DATA DARI SOCIAL (GOOGLE / FB) KE DATABASE
static Future<void> syncSocialUserData() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Ambil Data dari Metadata Google
      final meta = user.userMetadata;
      final String? googleName = meta?['full_name'] ?? meta?['name'];
      final String? googleAvatar = meta?['avatar_url'] ?? meta?['picture'];

      // 2. Cek apakah user sudah punya data di tabel 'profiles'
      final existingProfile = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // 3. JIKA PROFIL BELUM ADA (User Baru) -> INSERT
      if (existingProfile == null) {
        print("🆕 User baru terdeteksi. Membuat profil...");
        await _supabase.from('profiles').insert({
          'id': user.id,
          'email': user.email,
          'role': 'seeker', // Default role
          'full_name': googleName,
          // 'name': googleName, 
          'avatar_url': googleAvatar, // Sesuai kolom database Anda
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        print("✅ Profil baru berhasil dibuat.");
      } 
      
      // 4. JIKA PROFIL SUDAH ADA (User Lama) -> CEK DATA KOSONG & UPDATE
      else {
        Map<String, dynamic> updates = {};

        // Cek Nama: Jika di database kosong, ambil dari Google
        if ((existingProfile['full_name'] == null || existingProfile['full_name'] == '') && googleName != null) {
          updates['full_name'] = googleName;
          // updates['name'] = googleName;
        }

        // Cek Avatar: Jika di database kosong, ambil dari Google
        if ((existingProfile['avatar_url'] == null || existingProfile['avatar_url'] == '') && googleAvatar != null) {
          updates['avatar_url'] = googleAvatar;
        }

        // Lakukan Update jika ada perubahan
        if (updates.isNotEmpty) {
          updates['updated_at'] = DateTime.now().toIso8601String();
          await _supabase.from('profiles').update(updates).eq('id', user.id);
          print("🔄 Profil lama diperbarui dengan data Google (Nama/Avatar).");
        } else {
          print("✅ Profil sudah lengkap. Tidak ada perubahan.");
        }
      }
    } catch (e) {
      print("⚠️ Gagal sync data Social: $e");
    }
  }

// 1. Ambil Review berdasarkan Nama Perusahaan
static Future<List<Map<String, dynamic>>> getCompanyReviews(String companyName) async {
  try {
    final response = await _supabase
        .from('company_reviews')
        .select()
        .eq('company_name', companyName)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    return [];
  }
}

// 2. Kirim Review Baru
static Future<bool> addCompanyReview(String companyName, int rating, String comment, String reviewerName) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    await _supabase.from('company_reviews').insert({
      'company_name': companyName,
      'reviewer_id': user.id,
      'reviewer_name': reviewerName,
      'rating': rating,
      'comment': comment,
    });
    return true;
  } catch (e) {
    return false;
  }
}

  // ===========================================================================
  // USER SKILLS (TABEL user_skills)
  // ===========================================================================

  // 1. Ambil daftar skill milik user yang sedang login
  static Future<List<Map<String, dynamic>>> getUserSkills() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final data = await _supabase
          .from('user_skills') // <--- Nama tabel BARU
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: true);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('🔴 Error get skills: $e');
      return [];
    }
  }

  // 2. Tambah skill baru ke tabel user_skills
  static Future<bool> addUserSkill(String skillName, double level) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('user_skills').insert({ // <--- Nama tabel BARU
        'user_id': user.id,
        'skill_name': skillName,
        'level': level,
      });

      return true;
    } catch (e) {
      print('🔴 Error add skill: $e');
      return false;
    }
  }
}