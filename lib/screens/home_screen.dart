import 'package:demo_ewallet/blocs/home_bloc/home_action.dart';
import 'package:demo_ewallet/blocs/home_bloc/home_bloc.dart';
import 'package:demo_ewallet/blocs/home_bloc/home_state.dart';
import 'package:demo_ewallet/blocs/models/home_model.dart';
import 'package:demo_ewallet/navigation/home_naviagtion_params.dart';
import 'package:demo_ewallet/screens/widgets/banner_home.dart';
import 'package:demo_ewallet/screens/widgets/header_home.dart';
import 'package:demo_ewallet/screens/widgets/service_home.dart';
import 'package:demo_ewallet/screens/widgets/status_active.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.homeParams});

  HomeNavigationParams homeParams;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: HomeScreenView(homeParams: homeParams),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  HomeScreenView({super.key, required this.homeParams});

  HomeNavigationParams homeParams;

  @override
  State<HomeScreenView> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeBloc>().add(
        GetHomeInfo(phone: widget.homeParams.phoneNumber, context: context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child:  HeaderHome(
          homeParams: widget.homeParams,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            StatusActive(),
            BannerHome(
              listBanner: widget.homeParams.listBanner,
            ),
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state){
              return ServiceHome(listServices: state.listServices ?? [],);
            })
          ],
        ),
      ),
    );
  }
}
