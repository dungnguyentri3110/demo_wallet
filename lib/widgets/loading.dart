import 'package:demo_ewallet/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  static BuildContext? context;

  static Future<void> showLoading(BuildContext context)async{
    Loading.context = context;
    Navigator.of(context).push(LoadingView());
  }

  static void hideLoading(){
    if(Loading.context != null){
      Navigator.pop(Loading.context!);
    }
  }
}

class LoadingView extends ModalRoute<void>{
  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black.withOpacity(0.3);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => false;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Center(
      child: Wrap(
        children: [
          Container(
            width: 60,
            height: 60,
            color: Colors.white,
            child: const FittedBox(
              fit: BoxFit.none,
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 100);

}