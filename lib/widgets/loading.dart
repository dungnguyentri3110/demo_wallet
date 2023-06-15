import 'package:demo_ewallet/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  static BuildContext? context;

  static Future<void> showLoading(BuildContext context){
    Loading.context = context;
    return showDialog(context: context, builder: (_){
      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    });
  }

  static void hideLoading(){
    if(navigationState.currentState != null){
      Navigator.pop(Loading.context!);
    }
  }
}