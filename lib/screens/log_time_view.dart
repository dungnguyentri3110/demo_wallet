import 'package:demo_ewallet/blocs/log_time_bloc/log_time_bloc.dart';
import 'package:demo_ewallet/blocs/log_time_bloc/log_time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogTimeView extends StatelessWidget {
  const LogTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LogTimePage();
  }
}

class LogTimePage extends StatefulWidget {
  const LogTimePage({Key? key}) : super(key: key);

  @override
  State<LogTimePage> createState() => _LogTimePageState();
}

class _LogTimePageState extends State<LogTimePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogTimeBloc, LogTimeState>(builder: (_, state) {
      return Container(
        color: Colors.red,
        width: 150,
        alignment: Alignment.center,
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              '${state.count/1000}s',
              style: const TextStyle(fontSize: 30),
            )),
      );
    });
  }
}
