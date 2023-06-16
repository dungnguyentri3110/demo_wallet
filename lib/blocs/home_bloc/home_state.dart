import 'package:demo_ewallet/blocs/home_bloc/model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable{
  HomeState({this.listServices});
  List<ServiceAvailable>? listServices = [];

  HomeState copy({List<ServiceAvailable>? listServ}){
    return HomeState(listServices: listServ ?? listServices);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [listServices];
}