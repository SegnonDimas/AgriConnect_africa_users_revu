import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';



class EnregistreurAudio extends StatefulWidget {
  @override
  _EnregistreurAudioState createState() => _EnregistreurAudioState();
}

class _EnregistreurAudioState extends State<EnregistreurAudio> {
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  String _pathEnregistrement = '';
  var tempDir = '';
  var path = '';

  bool _enregistrementEnCours = false;
  bool jouerEnregistrement = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
  }

  @override
  void dispose() {
    _audioRecorder?.closeAudioSession();
    _audioPlayer?.closeAudioSession();
    super.dispose();
  }

  Future<void> _demanderAutorisationMicrophone() async {
    // Vérifiez si l'autorisation est déjà accordée
    PermissionStatus status = await Permission.microphone.status;
    if (!status.isGranted) {
      // Si l'autorisation n'est pas accordée, demandez-la
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        // Si l'utilisateur refuse l'autorisation, affichez un message d'erreur
        print('Autorisation refusée pour utiliser le microphone');
        return;
      }
    }
  }

/// _commencerEnregistrement
  void _commencerEnregistrement() async {
    // Demander l'autorisation d'utiliser le microphone
    await _demanderAutorisationMicrophone();

    await _audioRecorder!.openAudioSession();
    setState(() {
      _enregistrementEnCours = true;
    });

    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';

    setState(() {
      _pathEnregistrement = path;
    });

    // Commencer l'enregistrement
    await _audioRecorder!.startRecorder(
      toFile: _pathEnregistrement,
      //codec: Codec.aacADTS,
    ).catchError((error) {
      // Gérer les erreurs d'enregistrement
      print('Erreur lors de l\'enregistrement : $error');
    });
  }

/// _arrêterEnregistrement
  Future<void> _arreterEnregistrement() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      _enregistrementEnCours = false;
    });
  }


 /* Future<void> _jouerEnregistrement() async {
    // Obtenir le chemin complet du fichier audio enregistré
    //String? path = await _audioRecorder!.getPath(_pathEnregistrement);
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';
    setState(() {
      _pathEnregistrement = path;
    });
    if (_pathEnregistrement != null) {
      // Ouvrir une session audio
      await _audioPlayer!.openAudioSession();
      // Démarrer la lecture du fichier audio
      await _audioPlayer!.startPlayer(
        fromURI: path,
      );
      setState(() {
        jouerEnregistrement = !jouerEnregistrement;
      });
    } else {
      // Gérer le cas où le chemin du fichier audio est nul
      print('Le chemin du fichier audio est nul');
    }
  }*/
/// _jouerEnregistrement
  Future<void> _jouerEnregistrement() async {
    if (_pathEnregistrement.isNotEmpty) {
      // Ouvrir une session audio
      await _audioPlayer!.openAudioSession();
      // Démarrer la lecture du fichier audio
      await _audioPlayer!.startPlayer(
        fromURI: _pathEnregistrement,
      );
      setState(() {
        jouerEnregistrement = !jouerEnregistrement;
      });
    } else {
      // Afficher un message si aucun enregistrement n'a été effectué
      print('Aucun enregistrement à jouer');
    }
  }




  /*Future<String?> enregistrerAudioSurFirebase(File audioFile) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child('audio/${DateTime.now().millisecondsSinceEpoch}.aac');
      UploadTask uploadTask = storageReference.putFile(audioFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erreur lors de l\'enregistrement de l\'audio sur Firebase Storage : $e');
      return null;
    }
  }*/

  /*Future<void> jouerAudioDepuisFirebase(String audioUrl) async {
    try {
      // Ouvrir une session audio
      await _audioPlayer!.openAudioSession();
      // Démarrer la lecture du fichier audio depuis Firebase Storage
      await _audioPlayer!.startPlayer(
        fromURI: audioUrl,
      );
      setState(() {
        jouerEnregistrement = !jouerEnregistrement;
      });
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio depuis Firebase Storage : $e');
    }
  }*/





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        title: const Text('Enregistreur Audio'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //if (_pathEnregistrement != null)
              Center(child: SizedBox(child: Text('Enregistrement sauvegardé à: $_pathEnregistrement', style: const TextStyle(color: Colors.white, fontSize: 12),))),
            const SizedBox(height: 20),
            if (!_enregistrementEnCours)
              SizedBox(
                height: appHeightSize(context)*0.25,
                width: appHeightSize(context)*0.25,
                child: ElevatedButton(
                  onPressed: _commencerEnregistrement,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //SizedBox(),
                      jouerEnregistrement? Lottie.asset('animations/lotties/audioPlaying.json') : const Icon(Icons.mic, color: Colors.red, size: 90,),
                      jouerEnregistrement? const Text('Enregistrement...', style: TextStyle(color: Colors.black, fontSize: 10),) : const Text('Tapez pour enregistrer', style: TextStyle(color: Colors.black, fontSize: 9),)
                    ],
                  )
                ),
              ),
            if (_enregistrementEnCours)
            SizedBox(
            height: appHeightSize(context)*0.25,
            width: appHeightSize(context)*0.25,
              child: ElevatedButton(
                onPressed: _arreterEnregistrement,
                child: SizedBox(
                    child: Lottie.asset('animations/lotties/audioRecording.json'))//Text('Commencer l\'enregistrement'),/*Text('Arrêter l\'enregistrement'),*/
              ),),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _jouerEnregistrement,
              child: const Text('Jouer l\'enregistrement'),
            ),
          ],
        ),
      ),
    );
  }
}

