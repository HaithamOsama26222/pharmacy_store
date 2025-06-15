import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const PharmacyStoreApp(),
    ),
  );
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
