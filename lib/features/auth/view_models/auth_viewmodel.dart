// File: lib/features/auth/view_models/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel({required AuthService authService})
    : _authService = authService;

  // ViewModel State
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  Map<String, dynamic>? _userProfile;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoggedIn => _currentUser != null;

  // Sign Up Method
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? referralCode,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        referralCode: referralCode,
      );

      if (response.user != null) {
        _currentUser = response.user;
        await _fetchUserProfile();
      } else {
        _errorMessage = 'Email verification required';
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Signup failed. Please try again.';
      debugPrint('Signup error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Sign In Method
  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      _currentUser = response.user;
      await _fetchUserProfile();
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
      debugPrint('Login error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _currentUser = null;
      _userProfile = null;
    } catch (e) {
      _errorMessage = 'Logout failed';
      debugPrint('Logout error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Check Auth Status
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final session = await _authService.getCurrentSession();
      if (session != null) {
        _currentUser = session.user;
        await _fetchUserProfile();
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Password reset failed';
      debugPrint('Password reset error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update Profile
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      await _authService.updateProfile(
        userId: _currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      await _fetchUserProfile();
    } catch (e) {
      _errorMessage = 'Profile update failed';
      debugPrint('Profile update error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Private Methods
  Future<void> _fetchUserProfile() async {
    if (_currentUser == null) return;

    try {
      _userProfile = await _authService.getProfile(_currentUser!.id);
    } catch (e) {
      debugPrint('Fetch profile error: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
