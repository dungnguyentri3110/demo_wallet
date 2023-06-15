import 'package:demo_ewallet/blocs/models/home_model.dart';
import 'package:demo_ewallet/navigation/home_naviagtion_params.dart';
import 'package:demo_ewallet/screens/cash_in_screen.dart';
import 'package:flutter/material.dart';

class HeaderHome extends StatefulWidget {
  HeaderHome({super.key, required this.homeParams});

  HomeNavigationParams homeParams;

  @override
  State<StatefulWidget> createState() {
    return HeaderHomeState();
  }
}

class HeaderHomeState extends State<HeaderHome> {
  bool showBalance = false;

  @override
  Widget build(BuildContext context) {
    print("Wallet info ${widget.homeParams.phoneNumber}");
    final statusBar = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: 210,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28)),
              child: Image.asset(
                'lib/assets/bg-home-header.jpg',
                width: screenWidth,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: statusBar + 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 23, right: 23),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.homeParams.walletInfo.FullName ?? "",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  widget.homeParams.phoneNumber,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.fromBorderSide(BorderSide(
                                      width: 1.0, color: Colors.white))),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Số dư",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    (showBalance == true
                                            ? widget.homeParams.walletInfo
                                                .AvailableBlance!
                                            : "**********") +
                                        'đ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showBalance = !showBalance;
                                        });
                                      },
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonHome(
                        image: 'lib/assets/ic-btn-cash-in.png',
                        title: 'Nạp tiền',
                        phone: widget.homeParams.phoneNumber,
                      ),
                      ButtonHome(
                        image: 'lib/assets/ic-btn-cash-out.png',
                        title: 'Rút tiền',
                        phone: widget.homeParams.phoneNumber,
                      ),
                      ButtonHome(
                        image: 'lib/assets/ic-btn-transfer.png',
                        title: 'Chuyển tiền',
                        phone: widget.homeParams.phoneNumber,
                      ),
                      ButtonHome(
                        image: 'lib/assets/ic-btn-history.png',
                        title: 'Lịch sử',
                        phone: widget.homeParams.phoneNumber,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class ButtonHome extends StatelessWidget {
  const ButtonHome({super.key, required this.image, required this.title, required this.phone});

  final String image;
  final String title;
  final String phone;

  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CashInScreen(phone: phone),
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(context, createRoute());
        },
        child: Container(
          child: Column(
            children: [
              Image.asset(
                image,
                width: 30,
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(title,
                      style: TextStyle(fontSize: 13, color: Colors.white)))
              // Image.asset('lib/assets/ic-btn-cash-in.png', width: 30, height: 30,),
              // Text("Nạp tiền", style: TextStyle(fontSize: 13, color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
