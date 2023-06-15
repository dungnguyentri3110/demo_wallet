import 'package:demo_ewallet/blocs/models/home_model.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  bool phoneExist;
  String phoneNumber;
  String userName;
  List<BannerH>? listBanner;

  LoginState(
      {required this.phoneExist, required this.phoneNumber, required this.userName, this.listBanner});

  LoginState copy({bool? exist, String? phoneNum, String? name, List<BannerH>? list}) {
    return LoginState(
        phoneExist: exist ?? phoneExist, phoneNumber: phoneNum ?? phoneNumber,
        userName: name ?? userName, listBanner: list ?? listBanner);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [phoneExist, phoneNumber, userName, listBanner];
}
