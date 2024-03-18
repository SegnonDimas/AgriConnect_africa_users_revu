import 'package:flutter/material.dart';
import  'dart:async';


  class TimeController extends ValueNotifier<bool>{
  TimeController({bool isPlaying = false}) : super(isPlaying);

  void startTimer() => value = true;
  void stopTimer() => value = false;
}

class TimerWidget extends StatefulWidget {
    final TimeController controller;
  const TimerWidget({super.key, required this.controller});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = const Duration();

  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(() {
      if(widget.controller.value){
        startTimer();
      } else{
        stopTimer();
      }
    });
  }

  void reset() => setState(() => const Duration());

  void addTime(){
    const addSecond = 1;

    setState(() {
      final  seconds = duration.inSeconds + addSecond;

      if(seconds < 0){
        timer?.cancel();
      }else{
        duration = Duration(seconds: seconds);
      }
    });
  }



  void startTimer({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();

      timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    }
  }

  void stopTimer({bool resets = true}){
    if(!mounted) return;
    if(resets){
      reset();

      setState(() => timer?.cancel());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(this.duration.toString(), style: TextStyle(color: Colors.white, fontSize: 20),),);
  }
}
