import 'package:ewaste_banksampah/main.dart';
import 'package:ewaste_banksampah/pages/auth/login.dart';
import 'package:ewaste_banksampah/utils/get_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String userId = supabase.auth.currentUser!.id;

  Future<void> _logout(BuildContext context) async {
    await supabase.auth.signOut();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getUserId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const CircularProgressIndicator();
                      }
                      return Text("User ID: ${snapshot.data}");
                    },
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder(
                    future: getUserFullname(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const CircularProgressIndicator();
                      }
                      return Text("Nama Lengkap: ${snapshot.data}");
                    },
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder(
                    future: getUserEmail(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const CircularProgressIndicator();
                      }
                      return Text("Email: ${snapshot.data}");
                    },
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder(
                    future: getBanksampahId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const CircularProgressIndicator();
                      }
                      return Text("Id Bank Sampah: ${snapshot.data}");
                    },
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder(
                    future: getBanksampahName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const CircularProgressIndicator();
                      }
                      return Text("Nama Bank Sampah: ${snapshot.data}");
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _logout(context),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
