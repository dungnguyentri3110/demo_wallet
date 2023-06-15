import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:demo_ewallet/blocs/models/home_model.dart';

abstract class LoginAction extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Login extends LoginAction{
  String phoneNumber;
  String passworld;
  BuildContext context;

  Login({required this.phoneNumber, required this.passworld, required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber, passworld];
}

class GetAllInfo extends LoginAction{
  String phoneNumber;
  GetAllInfo({required this.phoneNumber});

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber];
}

class GetWalletInfo extends LoginAction{

}

class GetConnectBank extends LoginAction{

}
class CheckSmartOtpActive extends LoginAction{

}
class GetBanner extends LoginAction{

}

class FetchAllDataSuccess extends LoginAction{
  BuildContext context;
  List<BannerH>? listBanner;

  FetchAllDataSuccess({required this.context, this.listBanner});

  @override
  // TODO: implement props
  List<Object?> get props => [context, listBanner];
}

class CheckPhoneExist extends LoginAction{
  String phoneNumber;
  BuildContext context;
  CheckPhoneExist({required this.phoneNumber, required this.context});

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber, context];
}

class CheckLockFeature extends LoginAction {
  String phoneNumber;
  CheckLockFeature({required this.phoneNumber});
  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber];
}