import 'dart:io';

import 'package:demo_ewallet/blocs/log_time_bloc/log_time_bloc.dart';
import 'package:demo_ewallet/blocs/log_time_bloc/log_time_event.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_action.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_bloc.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_state.dart';
import 'package:demo_ewallet/screens/widgets/dialog_error.dart';
import 'package:demo_ewallet/screens/widgets/header_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const LoginScreenView(),
    );
  }
}

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenView>
    with WidgetsBindingObserver {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LocalAuthentication auth = LocalAuthentication();

  static const platform = MethodChannel("e_wallet_app_v03");
  bool showBio = false;
  SharedPreferences? sharePref;
  List<String> authen = [];

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> init() async {
    checkIsEnroll();
    sharePref = await SharedPreferences.getInstance();
    List<String> authenValue =
        sharePref?.getStringList("authen")?.toList() ?? [];
    if (authenValue.isNotEmpty) {
      setState(() {
        authen = sharePref?.getStringList("authen")?.toList() ?? [];
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState

    super.didChangeAppLifecycleState(state);
    print("App state $state");
    if (state == AppLifecycleState.resumed) {
      checkIsEnroll();
    }
  }

  Future<void> checkIsEnroll() async {
    try {
      final enroll = await platform.invokeMethod("CHECK_IS_ENROLL");
      final oldToken = sharePref?.getString("token");
      if (enroll["isEnrolled"] == false) {
        print("Nhay vaop day ${enroll["token"].length == 0}");
        if (oldToken != null &&
            oldToken.isNotEmpty &&
            enroll["token"].length == 0) {
          sharePref?.setString("token", "");
          setState(() {
            showBio = false;
          });
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext _) {
              return AlertDialog(
                title: const Text('Thông báo'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Sinh trắc học trong máy đã bị thay đổi'),
                      Text(
                          'Sinh trắc học trong máy của bạn đã thay đổi. Vui lòng kích hoạt lại xác thực bằng sinh trắc học'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (oldToken == null || oldToken.isEmpty) {
          sharePref?.setString("token", enroll["token"]);
          setState(() {
            showBio = true;
          });
        } else if ((oldToken != null && oldToken.isNotEmpty) &&
                enroll["token"] != oldToken ||
            enroll["errorCode"] == -1) {
          sharePref?.setString("token", "");
          setState(() {
            showBio = false;
          });
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext _) {
              return AlertDialog(
                title: const Text('Thông báo'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Sinh trắc học trong máy đã bị thay đổi'),
                      Text(
                          'Sinh trắc học trong máy của bạn đã thay đổi. Vui lòng kích hoạt lại xác thực bằng sinh trắc học'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
      print("enroll $enroll");
    } catch (error) {
      print("Error $error");
    }
  }

  Future<void> signBiometric(String phone, String password) async {
    try {
      if (Platform.isAndroid) {
        final result = await platform.invokeMethod("AUTHEN_BIOMETRIC", {
          "config": {
            "sensorDescription": "Xác thực vân tay để đăng nhập",
            // Android
            "sensorErrorDescription": "Thực hiện lại",
            // Android
            "sensorTooManyAttemptDescription":
                "Vân tay không hợp lệ quá số lần cho phép. Quý khách vui lòng thử lại sau.",
            // Android
            "cancelText": "Huỷ",
            // Android
            "cancelTextTooManyAttempt": "Đóng",
            "reason": "Hãy xác thực vân tay để đăng nhập"
          }
        });
        if (result["success"] == true) {
          context.read<LogTimeBloc>().add(StartLog());
          context.read<LoginBloc>().add(
              Login(phoneNumber: phone, passworld: password, context: context));
        }
        print("Result $result");
      } else {
        final authened = await auth.authenticate(
            localizedReason: "Xác thực touch id của bạn",
            options: const AuthenticationOptions(
                biometricOnly: true, stickyAuth: true));
        if (authened) {
          context.read<LogTimeBloc>().add(StartLog());
          context.read<LoginBloc>().add(
              Login(phoneNumber: phone, passworld: password, context: context));
        }
      }
    } catch (error) {
      print("Error $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: HeaderLogin(
          phoneNumber:
              authen.isNotEmpty && authen[1].isNotEmpty ? authen[1] : "",
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffEEEEEE), width: 1.0),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: state?.phoneExist == true
                                    ? passwordController
                                    : textEditingController,
                                keyboardType: state?.phoneExist == true
                                    ? TextInputType.text
                                    : TextInputType.phone,
                                obscureText: state!.phoneExist,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: state?.phoneExist == true
                                        ? "Nhập mật khẩu"
                                        : "Nhập số điện thoại"),
                              ),
                            ),
                            if (state?.phoneExist == true) ...{
                              GestureDetector(
                                onTap: () {},
                                child: Icon(Icons.remove_red_eye_outlined),
                              )
                            }
                          ],
                        ),
                      ),
                      if (state?.phoneExist == true) ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Quên mật khẩu?",
                                  style: TextStyle(color: Color(0xff666666)),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Đổi SĐT",
                                  style: TextStyle(color: Color(0xff666666)),
                                ),
                              ),
                            ),
                          ],
                        )
                      }
                    ],
                  );
                },
              ),
            )),
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return Container(
                width: screenWidth,
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    //TODO: Login action
                    // checkIsEnroll();
                    if (state?.phoneExist == true) {
                      context.read<LoginBloc>().add(Login(
                          phoneNumber: state.phoneNumber,
                          passworld: passwordController.text,
                          context: context));
                      context.read<LogTimeBloc>().add(StartLog());
                    } else {
                      context.read<LoginBloc>().add(CheckPhoneExist(
                          phoneNumber: textEditingController.text,
                          context: context));
                    }
                  },
                  child: Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            'lib/assets/bg-button-blue.png',
                            fit: BoxFit.fitHeight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        Text(
                          "Đăng nhập",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        if (authen.isNotEmpty && showBio) ...{
                          Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  signBiometric(authen[1], authen[0]);
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  child: Container(
                                    width: 50,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff6FC3EA),
                                        border: Border(
                                            left: BorderSide(
                                                width: 2,
                                                color: Colors.white))),
                                    child: Wrap(
                                      children: [
                                        Image.asset(
                                          "lib/assets/ic-fingerprint-white.png",
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                        }
                      ],
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
