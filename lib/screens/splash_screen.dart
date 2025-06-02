import 'package:flutter/material.dart';
import 'package:pharmacy_store/screens/home_screen.dart';
import 'package:pharmacy_store/screens/login_screen.dart';
import 'package:pharmacy_store/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnLogin();
  }

  Future<void> _navigateBasedOnLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // انتظار بسيط (للتصميم)

    final isLoggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_pharmacy, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'جارٍ تحميل التطبيق...',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
