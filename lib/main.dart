import 'package:flutter/material.dart';
import 'package:pharmacy_store/screens/splash_screen.dart'; // ✅ استيراد SplashScreen

void main() {
  runApp(const PharmacyStoreApp());
}

class PharmacyStoreApp extends StatelessWidget {
  const PharmacyStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacy Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Cairo', // أو الخط الافتراضي إذا لم تستخدم GoogleFonts
      ),
      home: const SplashScreen(), // ✅ أول شاشة عند تشغيل التطبيق
    );
  }
}
