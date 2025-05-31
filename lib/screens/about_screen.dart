import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // 📤 مشاركة التطبيق
  void _shareApp() {
    Share.share('جرّب تطبيق الصيدلية26222 لإدارة صيدليتك بكل سهولة! 💊\n'
        'رابط التطبيق: https://www.PharmacyApp26222.com/app');
  }

  // 🌟 تقييم التطبيق
  void _rateApp() async {
    const url =
        'https://www.PharmacyApp26222.com/rate'; // ضع رابط متجر التطبيق الفعلي هنا
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'تعذر فتح الرابط: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن التطبيق'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.local_pharmacy, size: 80, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            const Text(
              'الصيدلية26222',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('الإصدار: v1.0.0'),
            const SizedBox(height: 20),
            const Text(
              'تطبيق الصيدلية26222 يُتيح للعملاء استعراض منتجات الصيدلية وطلبها بسهولة من خلال الهاتف، '
              'مع نظام متكامل لإدارة المبيعات والمخزون.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text('المطور: هيثم أسامة عبد الغفار'),
            const SizedBox(height: 10),
            const Text('بريد التواصل: hithmosama2020@gmail.com'),
            const SizedBox(height: 30),

            // 🔘 زر مشاركة التطبيق
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text("مشاركة التطبيق"),
                onPressed: _shareApp,
              ),
            ),

            const SizedBox(height: 10),

            // 🔘 زر تقييم التطبيق
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.star_rate),
                label: const Text("تقييم التطبيق"),
                onPressed: _rateApp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
