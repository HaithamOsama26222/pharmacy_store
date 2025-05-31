import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // هنا يتم استيراد الكلاس

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
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const LoginScreen(), // 🔥 هنا يتم استخدام الكلاس فعليًا
    );
  }
}


