import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HomeAction extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetHomeInfo extends HomeAction{
  String phone;
  BuildContext context;
  GetHomeInfo({required this.phone, required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [phone, context];
}