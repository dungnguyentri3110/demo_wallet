import 'package:demo_ewallet/blocs/models/home_model.dart';
import 'package:demo_ewallet/navigation/home_naviagtion_params.dart';
import 'package:demo_ewallet/screens/widgets/banner_home.dart';
import 'package:demo_ewallet/screens/widgets/header_home.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.homeParams});
  HomeNavigationParams homeParams;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: HeaderHome(homeParams: widget.homeParams,),
          preferredSize: Size.fromHeight(200),
        ),
      body: BannerHome(listBanner: widget.homeParams.listBanner,),
    );
  }
}
