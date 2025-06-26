import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'core/services/auth_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
    authFlowType: AuthFlowType.pkce,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authService: AuthService())..add(AuthCheckRequested()),
        ),
      ],
      child: const SavingsApp(),
    ),
  );
}
