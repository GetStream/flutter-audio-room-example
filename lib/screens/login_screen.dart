import 'package:audio_example/models/user_model.dart';
import 'package:audio_example/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const v20 = SizedBox(height: 20);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select a User',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            v20,
            for (final user in kUsers)
              ListTile(
                title: Text(user.name),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.imageURL),
                ),
                onTap: () async {
                  await StreamVideo.instance.connectUser(
                    user.toUserInfo(),
                    user.token,
                  );
                  Navigator.of(context).pushReplacement(
                    HomeScreen.routeTo(user),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
