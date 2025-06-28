import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'core/services/auth_service.dart';
import 'app.dart';

void main() async {
  // 1. Ensure binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load environment variables with error handling
  try {
    await dotenv.load();
  } catch (e) {
    debugPrint("⚠️ Error loading .env: $e");
    rethrow; // Fail fast in development
  }

  // 3. Validate required environment variables
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];
  
  if (supabaseUrl == null || supabaseKey == null) {
    throw Exception(
      "Missing Supabase configuration in .env file. "
      "Required: SUPABASE_URL and SUPABASE_ANON_KEY"
    );
  }

  // 4. Initialize Supabase with secure config
  try {
    await Supabase.initialize(
   await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  storageOptions: const StorageOptions(
    retryAttempts: 5,
  ),
);
  } catch (e) {
    debugPrint("🔥 Supabase initialization failed: $e");
    rethrow;
  }

  // 5. Run app with BLoC provider
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(),
          )..add(AuthCheckRequested()),
      ,],
      child: const SavingsApp(),
    ),
  );
}