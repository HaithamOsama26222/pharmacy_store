import 'dart:io';
import 'dart:developer' as developer;

void checkStructure() {
  final structure = {
    'lib': [
      'models',
      'screens',
      'services',
      'widgets',
      'data',
      'tools',
    ],
    'assets': [],
    'test': [],
  };

  for (var folder in structure.entries) {
    final dir = Directory(folder.key);
    if (!dir.existsSync()) {
      developer.log('❌ Missing folder: ${folder.key}', name: 'StructureCheck');
      continue;
    }

    for (var sub in folder.value) {
      final subDir = Directory('${dir.path}/$sub');
      if (!subDir.existsSync()) {
        developer.log('⚠️ Missing subfolder: ${subDir.path}',
            name: 'StructureCheck');
      } else {
        developer.log('✅ Found: ${subDir.path}', name: 'StructureCheck');
        checkFolder(subDir, sub);
      }
    }
  }
}

void checkFolder(Directory dir, String name) {
  final files = dir.listSync(recursive: false).whereType<File>();
  if (files.isEmpty) {
    developer.log('📂 [$name] is empty!', name: 'StructureCheck');
    return;
  }

  for (var file in files) {
    developer.log('  📄 ${file.path.split(Platform.pathSeparator).last}',
        name: 'StructureCheck');
  }

  developer.log('', name: 'StructureCheck');
}
