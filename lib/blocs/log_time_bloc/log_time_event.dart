import 'package:equatable/equatable.dart';

abstract class LogTimeEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class StartLog extends LogTimeEvent{}

class LogProgress extends LogTimeEvent{
  final int count;
  LogProgress({required this.count});

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class LogDone extends LogTimeEvent{}

class ResetTime extends LogTimeEvent{}