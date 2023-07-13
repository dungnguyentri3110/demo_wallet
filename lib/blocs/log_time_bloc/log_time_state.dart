import 'package:equatable/equatable.dart';

class LogTimeState extends Equatable{
  const LogTimeState({required this.count});
  final int count;

  factory LogTimeState.initState(){
    return const LogTimeState(count: 0);
  }


  LogTimeState copy(int c){
    return LogTimeState(count: c);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [count];

}