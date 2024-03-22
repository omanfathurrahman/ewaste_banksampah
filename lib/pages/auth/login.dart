import 'package:ewaste_banksampah/main.dart';
import 'package:ewaste_banksampah/pages/after_login_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late User? user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(String email, String password) async {
    try {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    user = res.user;
    if (!mounted) return;
    context.replace('/afterLoginLayout');
    } on AuthException catch (e){
      if (e.message == 'Invalid login credentials') {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau password salah'),
          ),
        );
      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Form(
          child: ListView(
          shrinkWrap: true,
          reverse: true,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Text('Masuk ke akunmu'),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    _login(email, password);
                    if (user != null) {
                      context.go('/afterLoginLayout');
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun? '),
                  TextButton(
                    onPressed: () => context.go('/signUp'),
                    child: const Text('Daftar'),
                  ),
                ],
              )
            ].reversed.toList(),
          ),
        ),
      ),
    );
  }
}
