import 'package:ewaste_banksampah/pages/auth/login.dart';
import 'package:ewaste_banksampah/pages/auth/signup.dart';
import 'package:ewaste_banksampah/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



final supabase = Supabase.instance.client;

void main() {
    WidgetsFlutterBinding.ensureInitialized();

    Supabase.initialize(
    url: 'https://oexltokstwraweaozqav.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9leGx0b2tzdHdyYXdlYW96cWF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ1NjM5OTEsImV4cCI6MjAyMDEzOTk5MX0.4IB_1dfaBU6Ew-CtE4Uvs2Pmfd5SPi1Lan1oe5PSwIU',
  );

  runApp(const MainApp());
}

/// The main app.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: 'signUp',
      builder: (context, state) => const SignUpPage(),
    ),
  ],
);