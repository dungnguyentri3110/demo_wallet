import 'package:demo_ewallet/blocs/log_time_bloc/log_time_bloc.dart';
import 'package:demo_ewallet/blocs/log_time_bloc/log_time_event.dart';
import 'package:demo_ewallet/navigation/home_naviagtion_params.dart';
import 'package:demo_ewallet/screens/home_screen.dart';
import 'package:demo_ewallet/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabHomeNavigation extends StatefulWidget {
  const TabHomeNavigation({super.key, required this.homeNavigationParams});

  final HomeNavigationParams homeNavigationParams;

  @override
  State<StatefulWidget> createState() {
    return TabHomeNavigationState();
  }
}

class TabHomeNavigationState extends State<TabHomeNavigation>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomeScreen(homeParams: widget.homeNavigationParams),
          const Icon(
            Icons.qr_code_scanner,
            size: 50,
          ),
          Container(
            width: 200,
            height: 50,
            child: FittedBox(
              fit: BoxFit.none,
              child: ElevatedButton(
                onPressed: () {
                  context.read<LogTimeBloc>().add(ResetTime());
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false);
                },
                child: Text("Logout"),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (ind) {
          setState(() {
            index = ind;
          });
          controller.animateTo(ind,
              duration: const Duration(milliseconds: 150),
              curve: Curves.linear);
        },
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 28,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner, size: 28), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28), label: ""),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.orange,
      //   onPressed: (){},
      // ) ,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
