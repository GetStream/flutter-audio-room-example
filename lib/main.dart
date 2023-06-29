import 'package:audio_example/env.dart';
import 'package:audio_example/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StreamVideo.init(Env.apiKey, logPriority: Priority.debug);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}
