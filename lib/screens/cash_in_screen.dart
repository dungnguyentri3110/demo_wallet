import 'package:demo_ewallet/blocs/login_bloc/login_action.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_bloc.dart';
import 'package:demo_ewallet/screens/widgets/dialog_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashInScreen extends StatelessWidget {
  const CashInScreen({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: CashInView(
        phone: phone,
      ),
    );
  }
}

class CashInView extends StatefulWidget {
  CashInView({super.key, required this.phone});

  String phone;

  @override
  State<CashInView> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInView> {
  List<String> listMoney = [
    "10.000",
    "20.000",
    "50.000",
    "100.000",
    "200.000",
    "1 triệu"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<LoginBloc>().add(CheckLockFeature(phoneNumber: widget.phone));
  }

  List<Widget> listWarp() {
    List<Widget> list = [];
    for (int i = 0; i < listMoney.length; i++) {
      Widget item = Container(
        margin: EdgeInsets.all(3),
        color: Color(0xffC8DFF4),
        width: 100,
        height: 40,
        child: Text(listMoney[i]),
      );
      list.add(item);
    }
    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          height: 60 + statusBarHeight,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                child: SizedBox(
                  width: screenWidth,
                  child: Image.asset(
                    'lib/assets/bg-header-gradient.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Positioned(
                top: statusBarHeight,
                width: screenWidth,
                child: Container(
                  height: 60,
                  padding: EdgeInsets.only(left: 23, right: 23),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Nạp tiền",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            )),
                      ),
                      Container(
                        width: 25,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 270,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 23, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                  )
                ]),
            child: Column(
              children: [
                Container(
                  color: Color(0xffF8F8F8),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Số dư ví",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text("******đ", style: TextStyle(fontSize: 14))
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.fromBorderSide(
                          BorderSide(width: 1, color: Colors.grey))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Nhập số tiền",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text("đ")
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listMoney.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 2),
                      itemBuilder: (contex, index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: 100,
                          height: 40,
                          child: Text(
                            listMoney[index],
                            style: TextStyle(
                                color: Color(0xff437EC0),
                                fontWeight: FontWeight.w700),
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xffC8DFF4),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        );
                      }),
                )
              ],
            ),
          ),
          Container(
            height: 120,
            alignment: Alignment.center,
            width: screenWidth,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 5,
                    offset: Offset(0, 0),
                  )
                ]),
            child: Container(
              width: screenWidth,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                        height: 50,
                        child: Image.asset(
                          "lib/assets/bg-button-blue.png",
                          fit: BoxFit.fill,
                        )),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 50,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print("tabbb");
                            DialogError.show(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                              child: Text(
                            "Tiếp tục",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 18),
                          )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
