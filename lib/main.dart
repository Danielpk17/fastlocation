import 'package:flutter/material.dart';

import 'src/app_widget.dart';
import 'src/shared/storage/hive_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();
  runApp(AppWidget());
}
