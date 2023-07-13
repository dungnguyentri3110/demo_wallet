import 'package:demo_ewallet/blocs/login_bloc/login_bloc.dart';
import 'package:demo_ewallet/blocs/login_bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderLogin extends StatelessWidget {
  HeaderLogin({super.key, required this.phoneNumber});
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final statusBar = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 200 + statusBar,
      child: Stack(
        children: [
          Image.asset('lib/assets/bg-blue-gradient.png'),
          Container(
            padding: EdgeInsets.only(top: statusBar),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/favicon.png',
                        color: Colors.white,
                        width: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "epay",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(phoneNumber.isNotEmpty)...{
                          Text("Xin chào $phoneNumber", style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                          Text(phoneNumber,
                            style:
                            const TextStyle(fontSize: 16, color: Color(0xff666666)),
                          )
                        }else...{
                          Text(
                            state?.phoneExist == true
                                ? "Nhập mật khẩu"
                                : "Nhập số điện thoại",
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text(
                            state?.phoneExist == true
                                ? "Mật khẩu để bảo mật tài khoản và xác nhận giao dịch khi thanh toán"
                                : "Đăng ký/ Đăng nhập EPAY ngay",
                            style:
                            TextStyle(fontSize: 16, color: Color(0xff666666)),
                          )
                        }

                      ],
                    ),
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
