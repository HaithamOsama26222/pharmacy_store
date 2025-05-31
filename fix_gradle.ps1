Write-Host "🛑 إغلاق العمليات: gradle.exe, java.exe, javaw.exe..."
Get-Process gradle -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process javaw -ErrorAction SilentlyContinue | Stop-Process -Force

# الخطوة 2: حذف ملفات القفل
$lockPath = "$env:USERPROFILE\.gradle\caches\journal-1\journal-1.lock"
if (Test-Path $lockPath) {
    Remove-Item $lockPath -Force
    Write-Host "🧹 تم حذف ملف القفل: journal-1.lock"
} else {
    Write-Host "✅ لا يوجد ملف قفل حاليًا"
}

# الخطوة 3: تنظيف كاش Gradle اختياريًا
Write-Host "🧹 تنظيف كاش Gradle..."
$cachePath = "$env:USERPROFILE\.gradle\caches"
Remove-Item "$cachePath\*" -Recurse -Force -ErrorAction SilentlyContinue

# الخطوة 4: تنظيف مشروع Flutter
Write-Host "🚀 تشغيل flutter clean..."
cd "D:\PROJECT\pharmacy_store"
flutter clean

Write-Host "✅ العملية اكتملت بنجاح"
