
import 'dart:async';

import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/constants/cons.dart';
import 'package:agribenin/tests/timer_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:flutter_sound_lite/public/tau.dart';
import 'package:flutter_sound_lite/public/ui/recorder_playback_controller.dart';
import 'package:flutter_sound_lite/public/ui/sound_player_ui.dart';
import 'package:flutter_sound_lite/public/ui/sound_recorder_ui.dart';
import 'package:flutter_sound_lite/public/util/enum_helper.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_ffmpeg.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_helper.dart';
import 'package:flutter_sound_lite/public/util/temp_file_system.dart';
import 'package:flutter_sound_lite/public/util/wave_header.dart';
import 'package:permission_handler/permission_handler.dart';

///classe SoundRecorder
class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();


    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException("Permission micro");
    }
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  void dispose() {
    if(!_isRecorderInitialised) return;
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  // chemin de sauvegarde des fichiers audios
  String pathToSaveAudio = 'agriConnect_audio.aac';

  //fonction pour démarrer l'enregistrement
  Future _record() async {
    if(!_isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

//fonction pour stopper l'enregistrement
  Future _stop() async {
    if(!_isRecorderInitialised) return;
    await _audioRecorder!.stopRecorder();
  }

  //fonction vérifier l'état de l'enregistrement afin de savoir s'il faut arrêter ou démarrer
  Future toogleRecording() async {
    if(_audioRecorder!.isStopped){
      await _record();
    } else {
      await _stop();
    }
  }
}



class Test1 extends StatefulWidget {
  const Test1({super.key});

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> with SingleTickerProviderStateMixin {
  final timeController  = TimeController();
  late AnimationController controller;
  late Animation<double> animation;
  final recorder = SoundRecorder();


  /// initState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();

    controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),)
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    recorder.init();
  }

  /// dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    recorder.dispose();
  }

  /// fonction d'initialisation de Firebase
  void initFirebase() async {
    await Firebase.initializeApp();
  }

 /* /// pickImage
  void pickImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if(result != null){
      //File file = File(result.files.single.path!);
    }
  }*/

  //bool val = false;
  bool recording = false;

  @override
  Widget build(BuildContext context) {
  final isRecording = recorder.isRecording;

    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Container(
              height: appHeightSize(context)*0.3,
              width: appHeightSize(context)*0.3,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(appHeightSize(context)),
                border: Border.all(color: Colors.white, width: 6)

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic,size: 32, color: Colors.white,),
                  SizedBox(
                      height: appHeightSize(context)*0.2,
                      width: appHeightSize(context)*0.25,
                      child: TimerWidget(controller: timeController))
                ],
              ),
            ),

            InkWell(
              onTap: () async {
                final isRecording = await recorder.toogleRecording();
                setState(() {});
                setState(() {
                  recording = !recording;
                });
              },
              child: recording? const Icon(Icons.pause, color: Colors.red, size: 100,) : const Icon(Icons.play_arrow_rounded, color: PRIMARY_COLOR, size: 140,),
            )
          ],
        )

      ),
    );
  }
}
