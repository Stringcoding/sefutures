import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Sign up with email and password (v2.x syntax)
  Future<AuthResponse> signUpWithEmail({
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
    try {
      final response = await _client.auth.signUp(
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
        emailRedirectTo:
            'app://login-callback', // Deep link for email confirmation
      );

      // Immediately create profile if signup is successful
      if (response.user != null) {
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          institution: institution,
          currentLevel: currentLevel,
          fieldOfStudy: fieldOfStudy,
          monthlyIncome: monthlyIncome,
          graduationYear: graduationYear,
          referralCode: referralCode,
        );
      }

      return response;
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  /// Get current auth session (with automatic refresh)
  Future<Session?> getCurrentSession() async {
    try {
      return _client.auth.currentSession ?? await _client.auth.refreshSession();
    } catch (_) {
      return null;
    }
  }

  /// Get current user with profile data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final session = await getCurrentSession();
    if (session == null) return null;

    final profile = await getProfile(session.user.id);
    return {...session.user.toJson(), 'profile': profile};
  }

  /// Password reset with email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'app://reset-password', // Deep link for password reset
      );
    } on AuthException catch (e) {
      throw AuthException(message: e.message);
    }
  }

  /// Update user profile
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
    try {
      await _client.from('profiles').upsert({
        'id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'institution': institution,
        'current_level': currentLevel,
        'field_of_study': fieldOfStudy,
        'monthly_income': monthlyIncome,
        'graduation_year': graduationYear,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  /// Realtime auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Private method to create user profile
  Future<void> _createUserProfile({
    required String userId,
    required String email,
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
    await _client.from('profiles').insert({
      'id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'institution': institution,
      'current_level': currentLevel,
      'field_of_study': fieldOfStudy,
      'monthly_income': monthlyIncome,
      'graduation_year': graduationYear,
      'referral_code': referralCode,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
