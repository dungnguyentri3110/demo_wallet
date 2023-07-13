import 'package:demo_ewallet/blocs/log_time_bloc/log_time_bloc.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_bloc.dart';
import 'package:demo_ewallet/global.dart';
import 'package:demo_ewallet/screens/home_screen.dart';
import 'package:demo_ewallet/screens/log_time_view.dart';
import 'package:demo_ewallet/screens/login_screen.dart';
import 'package:demo_ewallet/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainAppBloc extends StatelessWidget {
  const MainAppBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LogTimeBloc(), child: const MainApp(),);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        const MyApp(),
        Positioned(top: 30, child: LogTimeView())
      ],
    );
  }
}




void main() {
  runApp(const MainAppBloc());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigationState,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            const LoginScreen(),
            Text("hellow")
          ],
        ),
      ),
    );
  }
}
