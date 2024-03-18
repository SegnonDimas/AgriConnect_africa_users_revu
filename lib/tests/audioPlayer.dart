/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enregistrement et lecture audio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioRecorderPlayer(),
    );
  }
}

class AudioRecorderPlayer extends StatefulWidget {
  @override
  _AudioRecorderPlayerState createState() => _AudioRecorderPlayerState();
}

class _AudioRecorderPlayerState extends State<AudioRecorderPlayer> {
  late AudioPlayer _audioPlayer;
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _filePath = '';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Fonction pour demander et vérifier les permissions d'enregistrement audio.
  Future<bool> _checkPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  // Fonction pour démarrer l'enregistrement audio.
  Future<void> _startRecording() async {
    if (await _checkPermission()) {
      _filePath = await FilePicker.platform.getDirectoryPath()! + '/recording.aac';
      await _audioPlayer.startRecorder(toFile: _filePath, codec: Codec.aacADTS);
    } else {
      print('Permission de microphone non accordée !');
    }
  }

  // Fonction pour arrêter l'enregistrement audio.
  Future<void> _stopRecording() async {
    await _audioPlayer.stopRecorder();
  }

  // Fonction pour jouer l'audio enregistré.
  Future<void> _playRecording() async {
    if (_filePath.isNotEmpty) {
      await _audioPlayer.play(_filePath, isLocal: true);
    } else {
      print('Aucun fichier audio enregistré !');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enregistrement et lecture audio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _startRecording();
              },
              child: Text('Démarrer l\'enregistrement'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _stopRecording();
              },
              child: Text('Arrêter l\'enregistrement'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _playRecording();
              },
              child: Text('Lire l\'enregistrement'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
