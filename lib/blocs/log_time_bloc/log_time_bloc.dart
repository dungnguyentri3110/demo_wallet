import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:demo_ewallet/blocs/log_time_bloc/log_time_event.dart';
import 'package:demo_ewallet/blocs/log_time_bloc/log_time_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogTimeBloc extends Bloc<LogTimeEvent, LogTimeState> {
  LogTimeBloc() : super(LogTimeState.initState()) {
    createIsolate();
    on(onStartLog);
    on(onLogProgress);
    on(onLogDone);
    on(onResetTime);
  }

  Isolate? isolate;
  SendPort? sendPort;
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

  int count = 0;

  late Timer timer;

  void createIsolate()async{
    ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(listen, receivePort.sendPort);
    receivePort.listen((message) {
      if(message is SendPort){
        sendPort = message;
      }else if(message is Map<String, dynamic>){
        add(LogProgress(count: message["count"]));
      }
    });
  }

  void listen(SendPort sendPort){
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    final recievePort = ReceivePort();
    sendPort.send(recievePort.sendPort);
    recievePort.listen((message) {
      print("Mesasge");
      if(message is String && message == "start"){
        log(sendPort);
      }else if(message is String && message == "done"){
        count = 0;
        timer.cancel();
        sendPort.send("Done");
      }
    });
  }

  void log(SendPort sendPort) {
    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      count += 1;
      Map<String, dynamic> obj = {
        "count" : count
      };
      sendPort?.send(obj);
    });
  }

  void cancel() {
    timer.cancel();
  }

  void onStartLog(StartLog event, Emitter<LogTimeState> emit) {
    // log();
    sendPort?.send("start");
  }

  void onLogProgress(LogProgress event, Emitter<LogTimeState> emit) {
    emit(state.copy(event.count));
  }

  void onLogDone(LogDone event, Emitter<LogTimeState> emit) {
    sendPort?.send("done");

  }

  void onResetTime(ResetTime event, Emitter<LogTimeState> emit){
    count = 0;
    emit(state.copy(0));
  }
}
