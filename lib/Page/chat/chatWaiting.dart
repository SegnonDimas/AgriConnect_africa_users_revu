import 'package:agribenin/Page/app_colors.dart';
import 'package:agribenin/Page/screen/app_sizes.dart';
import 'package:agribenin/constants/cons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWaiting extends StatelessWidget {
  ChatWaiting({super.key});

  void _launchPhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not launch tel:$phoneNumber';
    }
  }

  //String? phone;

  @override
  Widget build(BuildContext context) {
    String phone = "+22953197881";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
        title: const Text('Discussion'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          height: appHeightSize(context)*0.6,
          width: appWidthSize(context)*0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Lottie.asset('animations/lotties/chatWaiting.json'),
              ),
              const Text('Cette fonctionnalité sera bientôt disponible', style: TextStyle(fontSize: 12, color: PRIMARY_COLOR),),

              GestureDetector(
                onTap: () {
                  _launchPhoneCall(phone);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: appHeightSize(context)*0.2,
                        width: appWidthSize(context)*0.3,
                        child: Lottie.asset('animations/lotties/phoneCall.json')),
                    Text('Vous pouvez nous contacter par téléphone en attendant', style: TextStyle(fontSize: 14, color: PRIMARY_COLOR),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
