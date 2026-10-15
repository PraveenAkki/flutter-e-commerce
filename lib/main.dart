import 'package:flutter/material.dart';
import 'app.dart';
import 'config/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const App());
}