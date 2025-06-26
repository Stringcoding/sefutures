import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository({required SupabaseClient supabase}) : _supabase = supabase;

  // 1. Sign Up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? institution,
    String? currentLevel,
    String? fieldOfStudy,
    double? monthlyIncome,
    int? graduationYear,
    String? referralCode,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'institution': institution,
        'current_level': currentLevel,
        'field_of_study': fieldOfStudy,
        'monthly_income': monthlyIncome,
        'graduation_year': graduationYear,
        'referral_code': referralCode,
      },
    );

    return response;
  }

  // 2. Sign In
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 3. Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // 4. Get Current User
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // 5. Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // 6. Get User Profile
  Future<Map<String, dynamic>> getProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  // 7. Update Profile
  Future<void> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? institution,
    String? currentLevel,
    String? fieldOfStudy,
    double? monthlyIncome,
    int? graduationYear,
  }) async {
    await _supabase.from('profiles').upsert({
      'id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'institution': institution,
      'current_level': currentLevel,
      'field_of_study': fieldOfStudy,
      'monthly_income': monthlyIncome,
      'graduation_year': graduationYear,
    });
  }

  // 8. Check if session exists
  Session? getCurrentSession() {
    return _supabase.auth.currentSession;
  }
}
