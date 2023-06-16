import 'dart:convert';

import 'package:demo_ewallet/blocs/home_bloc/home_action.dart';
import 'package:demo_ewallet/blocs/home_bloc/home_state.dart';
import 'package:demo_ewallet/blocs/home_bloc/model.dart';
import 'package:demo_ewallet/global.dart';
import 'package:demo_ewallet/services/api_manager.dart';
import 'package:demo_ewallet/widgets/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeAction, HomeState> {
  HomeBloc() : super(HomeState(listServices: [])) {
    on(onGetHomeOnfo);
  }

  ApiManager apiManager = ApiManager();

  Future onGetHomeOnfo(GetHomeInfo event, Emitter<HomeState> emitter) async {
    try {
      Loading.showLoading(event.context);
      final params = {"PhoneNumber": event.phone};
      Response? response = await apiManager
          .request('home/get_home_info', "POST", data: params, token: tokenApp);
      Loading.hideLoading();
      if (response?.statusCode == 200 && response?.data['ErrorCode'] == 0) {
        final dataHome = jsonDecode(response?.data["Data"]);
        List<ServiceAvailable> listService = [];
        print("onGetHomeOnfo ${dataHome}");
        for (int i = 0; i < dataHome['Services'].length; i++) {
          ServiceAvailable item =
              ServiceAvailable.fromJson(dataHome['Services'][i]);
          listService.add(item);
        }

        emitter(state.copy(listServ: listService.toList()));
      }


    } catch (e) {
      print("Error $e");
      Loading.hideLoading();
    }
  }
}
