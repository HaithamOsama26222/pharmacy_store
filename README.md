# 📱 Pharmacy Store App – تطبيق متجر صيدلية

تطبيق Flutter متكامل لإدارة الجرد في صيدلية، مرتبط بـ Web API (ASP.NET Core) وقاعدة بيانات SQL Server.

---

## 🚀 الميزات

- ✅ عرض أصناف الجرد المخزنة
- ➕ إضافة صنف جديد للمخزون
- ✏️ تعديل صنف موجود
- 🗑️ حذف صنف من الجرد
- 🔄 مزامنة مباشرة مع قاعدة البيانات عبر Web API

---

## 🛠️ التقنيات المستخدمة

| الطبقة | التقنية |
|--------|----------|
| التطبيق | Flutter 3.22.0 + Dart 3.4.0 |
| الخادم | ASP.NET Core Web API |
| قاعدة البيانات | SQL Server |
| الاتصال | REST API باستخدام `http` |

---

## 🗂️ هيكل المشروع

lib/
├─ models/
│ └─ inventory.dart
├─ services/
│ └─ inventory_service.dart
├─ screens/
│ └─ inventory_admin_screen.dart
├─ widgets/
│ └─ add_inventory_dialog.dart
main.dart

---

## 🧑‍💻 المطور

- الاسم: **هيثم أسامة عبد الغفار**
- الوصف: مشروع  متكامل يجمع بين التقنيات الحديثة لإدارة الصيدليات (مكتب + جوال)

---

## 📦 طريقة التشغيل

```bash
flutter pub get
flutter run
