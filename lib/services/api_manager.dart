import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

final option =
    BaseOptions(baseUrl: 'https://test.epayservices.com.vn:11002/api/v2/');

final dio = Dio(option);

class ApiManager {
  ApiManager();

  // String token  = '';

  Future<Response?> request(String url, String method,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParams,
      String? token}) async {
    try {
      var deviceInfo;
      if (Platform.isAndroid) {
        deviceInfo = await DeviceInfoPlugin().androidInfo;
      } else if (Platform.isIOS) {
        deviceInfo = await DeviceInfoPlugin().iosInfo;
      }

      final requestTime = DateFormat('dd-MM-y HH:mm:ss').format(DateTime.now());
      final message = url.split("/");
      Map<String, dynamic> postParams = {
        "MsgID":
            (Platform.isIOS ? deviceInfo.identifierForVendor : deviceInfo.id) +
                requestTime,
        "MsgType": message[message.length - 1],
        "TransactionID": DateTime.now().toString() +
            (Random().nextInt(10) * 10000).floor().toString(),
      };

      Map<String, dynamic> headers = {
        "Authorization": "Bearer ${token}",
        'Content-Type': 'application/json',
      };
      print("Requestsssss ${headers}");

      if (data != null) {
        postParams = {...postParams, ...data};
      }

      final requestData = {
        "MsgType": message[message.length - 1],
        "RequestTime": requestTime,
        "Lang": 'vi',
        "Channel": 'App',
        "AppVersion": "2.5.2",
        "AppCode": "2.5.2.23040509",
        "DeviceOS": 'android',
        "OsVersion": "33",
        "IpAddress": '222.252.30.205',
        // "DeviceInfo": deviceInfo.model,
        "DeviceInfo": (Platform.isIOS ? 'Iphone iOS ' : 'Android ') +
            ((Platform.isIOS)
                ? deviceInfo.localizedModel
                : deviceInfo.version.release),
        "DeviceID": deviceInfo.id,
        "Data": jsonEncode(postParams),
        "Signature": "FAKE",
      };

      // print("Request: ${requestData} - ${postParams}");
      Response response = await dio.request(url,
          data: requestData,
          queryParameters: queryParams,
          options: Options(method: method, headers: headers));
      return response;
    } on DioException catch (e) {
      print(e);
    }
  }
}
