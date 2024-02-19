
import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final String userId = supabase.auth.currentUser!.id; 

  Future<void> _logout(BuildContext context) async {
    await supabase.auth.signOut();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Text(userId),
      ElevatedButton(onPressed: (){_logout(context);}, child: Text('Logout')),
    ],);
  }
}