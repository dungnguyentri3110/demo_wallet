import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_action.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_state.dart';
import 'package:demo_ewallet/blocs/models/home_model.dart';
import 'package:demo_ewallet/global.dart';
import 'package:demo_ewallet/navigation/home_naviagtion_params.dart';
import 'package:demo_ewallet/screens/home_screen.dart';
import 'package:demo_ewallet/services/api_manager.dart';
import 'package:demo_ewallet/widgets/loading.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:math';

import 'dart:convert';

class LoginModel {
  String Token;
  String phone;

  LoginModel({required this.Token, required this.phone});

  factory LoginModel.fromJson(Map<String, dynamic> json, String phone) {
    return LoginModel(Token: json['Token'], phone: phone);
  }
}

class LoginBloc extends Bloc<LoginAction, LoginState> {
  LoginBloc()
      : super(LoginState(phoneExist: false, phoneNumber: '', userName: '')) {
    createIsolate();
    on(onLogin);
    on(onFetchAllDataSuccess);
    on(onCheckExistPhone);
    on(onCheckLockFeature);
    // on(onGetAllInfo);
    // on(onGetWalletInfo);
    // on(onGetConnectedBank);
    // on(onGetBanner);
    // on(checkSmartOtpActive);
  }

  Isolate? isolate;
  SendPort? sendPort;
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  BuildContext? context;

  WalletInfo? walletInfo;
  String? phoneNumber;

  ApiManager apiManager = ApiManager();

  void createIsolate() async {
    ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(onListen, receivePort.sendPort);
    receivePort.listen((message) {
      if (message is SendPort) {
        sendPort = message;
      }
      if (message is List<dynamic>) {
        print("sendPort ${message[0]}");
        Loading.hideLoading();

        walletInfo = WalletInfo.fromJson(message[message.length - 1]);
        add(FetchAllDataSuccess(context: context!, listBanner: message[0]));
      }
    });
  }

  void onListen(SendPort sendPort) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      print("Message $message");
      if (message is LoginModel) {
        List<dynamic> list = await Future.wait([
          onGetBanner(message.Token, message.phone),
          onGetConnectedBank(message.Token, message.phone),
          onGetWalletInfo(message.Token, message.phone),
          checkSmartOtpActive(message.Token, message.phone),
          onGetAllInfo(message.Token, message.phone)
        ]);

        print("Call all api ${list.length}");
        sendPort.send(list);
      }
    });
  }

  void onCheckExistPhone(
      CheckPhoneExist event, Emitter<LoginState> emitter) async {
    try {
      Loading.showLoading(event.context);
      phoneNumber = event.phoneNumber;
      Response? res = await apiManager.request('account/check_exist', 'POST',
          data: {"PhoneNumber": event.phoneNumber});
      Loading.hideLoading();
      if (res?.statusCode == 200 && res?.data["ErrorCode"] == 3) {
        emit(state.copy(exist: true, phoneNum: event.phoneNumber));
        // Response? response = await apiManager.request(
        //     "account/get_all_info", "POST",
        //     data: {"PhoneNumber": event.phoneNumber},);
        // print("Info $response");
      }
      print("resssss $res");
    } catch (e) {
      Loading.hideLoading();
    }
  }

  void onFetchAllDataSuccess(
      FetchAllDataSuccess event, Emitter<LoginState> emitter) {
    Navigator.pushAndRemoveUntil(
        event.context, createRoute(event.listBanner!), (route) => false);
  }

  Route createRoute(List<BannerH> list) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(
        homeParams: HomeNavigationParams(
            walletInfo: walletInfo!,
            phoneNumber: phoneNumber!,
            listBanner: list),
      ),
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void onLogin(Login event, Emitter<LoginState> emit) async {
    try {
      context = event.context;
      Loading.showLoading(event.context);
      final bytes = utf8.encode(event.passworld);
      final encodePassword = sha256.convert(bytes);
      Map<String, dynamic> requestData = {
        "PhoneNumber": event.phoneNumber,
        "Password": encodePassword.toString(),
        "PushToken": ""
      };

      Response? res = await apiManager.request('account/login_account', 'POST',
          data: requestData);
      print("token ${res}");
      if (res?.statusCode == 200 && res?.data["ErrorCode"] == 0) {
        final token = jsonDecode(res?.data['Data']);
        LoginModel login = LoginModel.fromJson(token, event.phoneNumber);
        tokenApp = token['Token'];

        sendPort?.send(login);
      } else if (res?.statusCode == 200 && res?.data["ErrorCode"] == 27) {
        final params = {
          "PhoneNumber": event.phoneNumber,
          "FunctionType": 19,
          "OtpCode": "666666",
          "OtpType": 0,
        };
        Response? res = await apiManager
            .request('common/otp/confirm_otp', 'POST', data: params);
        if (res?.statusCode == 200 && res?.data["ErrorCode"] == 0) {
          Response? res = await apiManager
              .request('account/login_account', 'POST', data: requestData);
          if (res?.statusCode == 200 && res?.data["ErrorCode"] == 0) {
            final token = jsonDecode(res?.data['Data']);
            LoginModel login = LoginModel.fromJson(token, event.phoneNumber);
            tokenApp = token['Token'];
            sendPort?.send(login);
          }
        }
        print("OTP: $res");
      }
    } catch (e) {
      print("Login error: $e");
    }
  }

  Future onGetAllInfo(String token, String phone) async {
    try {
      Response? response = await apiManager.request(
          "account/get_all_info", "POST",
          data: {"PhoneNumber": phone}, token: token);

      final data = jsonDecode(response?.data["Data"]);
      final info = data["WalletInfo"];
      // walletInfo = WalletInfo.fromJson(info);

      return info;
    } catch (e) {
      print("GetAllInfo error: $e");
      Loading.hideLoading();
    }
  }

  Future onGetWalletInfo(String token , String phone) async {
    try {
      Response? response = await apiManager.request(
          "account/get_wallet_info", "POST",
          data: {"PhoneNumber": phone}, token: token);
      print("onGetWalletInfo: $response");
      return response;
    } catch (e) {
      print("onGetWalletInfo error: $e");
      Loading.hideLoading();
    }
  }

  Future onGetConnectedBank(String token, String phone) async {
    try {
      Response? response = await apiManager.request(
          "wallet/get_connected_bank", "POST",
          data: {"PhoneNumber": phone}, token: token);
      print("onGetConnectedBank: $response");
      return response;
    } catch (e) {
      print("onGetConnectedBank error: $e");
      Loading.hideLoading();
    }
  }

  Future checkSmartOtpActive(String token, String phone) async {
    try {
      Response? response = await apiManager.request(
          "smartotp/smartotp_check_active", "POST",
          data: {"PhoneNumber": phone}, token: token);
      print("checkSmartOtpActive: $response");
      return response;
    } catch (e) {
      print("checkSmartOtpActive error: $e");
      Loading.hideLoading();
    }
  }

  Future onGetBanner(String token, String phone) async {
    try {
      Response? response = await apiManager.request("ads/get_banner", "POST",
          data: {"PhoneNumber": phone}, token: token);
      print("onGetBanner: ${response?.data["Data"]}");
      final data = jsonDecode(response?.data["Data"]);
      List<BannerH> banner = [];
      for (int i = 0; i < data["Banners"].length; i++) {
        BannerH item = BannerH.fromJson(data["Banners"][i]);
        banner.add(item);
      }
      print("coNVER $banner");
      return banner.toList();
    } catch (e) {
      print("onGetBanner error: $e");
      Loading.hideLoading();
    }
  }

  Future onCheckLockFeature(
      CheckLockFeature event, Emitter<LoginState> emitter) async {
    try {
      Response? response =
          await apiManager.request("account/check_lock_feature", "POST");
      print("response: $response");
    } catch (e) {
      print("onCheckLockFeature error: $e");
    }
  }
}
