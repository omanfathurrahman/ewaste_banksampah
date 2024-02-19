import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'E Waste',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Bank Sampah'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/splash'),
              child: const Text('Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}
