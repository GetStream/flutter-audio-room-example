import 'dart:developer';

import 'package:audio_example/screens/audio_room_screen.dart';
import 'package:audio_example/models/user_model.dart';
import 'package:audio_example/widgets/create_room.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final UserModel user;

  static Route<dynamic> routeTo(UserModel user) {
    return MaterialPageRoute(
      builder: (context) {
        return HomeScreen(user: user);
      },
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel get user => widget.user;

  Future<void> showCreationDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: CreateRoomDialog(
            onCreatePressed: _onDialogPressed,
          ),
        );
      },
    );
  }

  Future<void> _onDialogPressed((String, String) roomInfo) async {
    // TODO: Implement
  }

  Future createRoom(final String title, final String description) async {
    // TODO: Create call
  }

  Future<void> joinRoom(room) async {
    // TODO: Implement
  }

  Future<List> queryCalls() async {
    // TODO: Implement
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.imageURL),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreationDialog,
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List>(
          future: queryCalls(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Could not fetch calls'),
              );
            }

            if (snapshot.hasData) {
              final data = snapshot.data ?? [];
              return ListView(
                children: [
                  for (final room in data)
                    ListTile(
                      title: Text(
                        room.call.details.custom['name'] as String,
                      ),
                      subtitle: Text(
                        room.call.details.custom['description'] as String,
                      ),
                      onTap: () => joinRoom(room),
                    )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
