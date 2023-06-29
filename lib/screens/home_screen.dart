import 'dart:developer';

import 'package:audio_example/models/user_model.dart';
import 'package:audio_example/screens/audio_room_screen.dart';
import 'package:audio_example/widgets/create_room.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
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

  StreamVideo get video => StreamVideo.instance;

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
    final call = await createRoom(
      roomInfo.$1,
      roomInfo.$2,
    );
    final result = await call.goLive();
    final room = result.getDataOrNull()!;
    log('Joining Call: ${call.callCid}');
    Navigator.of(context).push(
      AudioRoomScreen.routeTo(call, room, user),
    );
  }

  Future<Call> createRoom(final String title, final String description) async {
    final room = video.makeCall(
      type: "audio_room",
      id: const Uuid().v4(),
    );

    await room.getOrCreateCall();
    await room.update(
      custom: {
        'name': title,
        'description': description,
        "flutterAudioRoomCall": true,
      },
    );

    return room;
  }

  Future<void> joinRoom(QueriedCall room) async {
    final cid = room.call.cid;
    final call = video.makeCall(type: cid.type, id: cid.id);

    await call.connect();
    log('Joining Call: $cid');
    Navigator.of(context).push(
      AudioRoomScreen.routeTo(call, room.call, user),
    );
  }

  Future<List<QueriedCall>> queryCalls() async {
    final result = await video.queryCalls(
      filterConditions: {
        "custom.flutterAudioRoomCall": true,
      },
    );

    if (result.isSuccess) {
      return result.getDataOrNull()?.calls ?? [];
    } else {
      final error = result.getErrorOrNull();
      log('[queryCalls] failed with error $error');
      throw Exception('No rooms found');
    }
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
        child: FutureBuilder<List<QueriedCall>>(
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
