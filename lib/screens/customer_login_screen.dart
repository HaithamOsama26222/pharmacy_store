import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/customer_auth_service.dart';
import 'dashboard_screen.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // ✅ تحقق من صيغة البريد الإلكتروني
  bool _isValidEmail(String email) {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(email);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await CustomerAuthService.login(email, password);

    setState(() => _isLoading = false);

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      await prefs.setInt("customerId", result['customerId']);
      await prefs.setString("customerName", result['name']);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "فشل تسجيل الدخول")),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تسجيل الدخول")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.person, size: 80),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "يرجى إدخال البريد الإلكتروني";
                  } else if (!_isValidEmail(value.trim())) {
                    return "صيغة البريد الإلكتروني غير صحيحة";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "كلمة المرور"),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? "يرجى إدخال كلمة المرور" : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text("دخول"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
