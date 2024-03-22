import 'package:ewaste_banksampah/pages/after_login_layout.dart';
import 'package:ewaste_banksampah/pages/buang/berangkat/berangkat.dart';
import 'package:ewaste_banksampah/pages/auth/login.dart';
import 'package:ewaste_banksampah/pages/auth/signup.dart';
import 'package:ewaste_banksampah/pages/buang/berangkat/ambil/ambil.dart';
import 'package:ewaste_banksampah/pages/buang/detail_sampah_dibuang.dart';
import 'package:ewaste_banksampah/pages/buang/riwayat/riwayat_buang.dart';
import 'package:ewaste_banksampah/pages/donasi/berangkat/ambil/ambil.dart';
import 'package:ewaste_banksampah/pages/donasi/berangkat/berangkat.dart';
import 'package:ewaste_banksampah/pages/donasi/detail_sampah_didonasikan.dart';
import 'package:ewaste_banksampah/pages/donasi/riwayat/riwayat_donasi.dart';
import 'package:ewaste_banksampah/pages/landing_page.dart';
import 'package:ewaste_banksampah/splash_screen.dart';
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
      debugShowCheckedModeBanner: false,
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
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/afterLoginLayout',
      builder: (context, state) => const AfterLoginLayout(),
    ),
    GoRoute(
      path: '/detailSampahDibuang/detail/:id',
      builder: (context, state) => DetailSampahDibuangPage(sampahDibuangId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/detailSampahDidonasikan/detail/:id',
      builder: (context, state) => DetailSampahDidonasikanPage(sampahDidonasikan: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/detailSampahDibuang/berangkat',
      builder: (context, state) => const BerangkatBuangList(),
    ),
    GoRoute(
      path: '/detailSampahDidonasikan/berangkat',
      builder: (context, state) => const BerangkatDonasiList(),
    ),
    GoRoute(
      path: '/riwayat-buang',
      builder: (context, state) => const RiwayatBuangPage(),
    ),
    GoRoute(
      path: '/riwayat-donasi',
      builder: (context, state) => const RiwayatDonasiPage(),
    ),
    GoRoute(
      path: '/detailSampahDibuang/berangkat/:id',
      builder: (context, state) => AmbilBuang(sampahDibuangId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/detailSampahDidonasikan/berangkat/:id',
      builder: (context, state) => AmbilDonasi(sampahDidonasikanId: int.parse(state.pathParameters['id']!)),
    ),
  ],
);