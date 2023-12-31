import 'package:demo_ewallet/screens/widgets/header_login.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: HeaderLogin(phoneNumber: "",),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // child: Column(
        //   children: [
        //     Expanded(
        //         child: Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 23),
        //           child: BlocBuilder<LoginBloc, LoginState>(
        //             builder: (context, state) {
        //               return Column(
        //                 children: [
        //                   Container(
        //                     padding: EdgeInsets.symmetric(horizontal: 10),
        //                     decoration: BoxDecoration(
        //                         border: Border.all(
        //                             color: Color(0xffEEEEEE), width: 1.0),
        //                         borderRadius: BorderRadius.circular(8)),
        //                     child: Row(
        //                       children: [
        //                         Expanded(
        //                           child: TextField(
        //                             controller: state?.phoneExist == true
        //                                 ? passwordController
        //                                 : textEditingController,
        //                             keyboardType: state?.phoneExist == true
        //                                 ? TextInputType.text
        //                                 : TextInputType.phone,
        //                             obscureText: state!.phoneExist,
        //                             decoration: InputDecoration(
        //                                 border: InputBorder.none,
        //                                 hintText: state?.phoneExist == true
        //                                     ? "Nhập mật khẩu"
        //                                     : "Nhập số điện thoại"),
        //                           ),
        //                         ),
        //                         if (state?.phoneExist == true) ...{
        //                           GestureDetector(
        //                             onTap: () {},
        //                             child: Icon(Icons.remove_red_eye_outlined),
        //                           )
        //                         }
        //                       ],
        //                     ),
        //                   ),
        //                   if (state?.phoneExist == true) ...{
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Container(
        //                           alignment: Alignment.centerLeft,
        //                           margin: EdgeInsets.only(top: 10),
        //                           child: GestureDetector(
        //                             onTap: () {},
        //                             child: Text(
        //                               "Quên mật khẩu?",
        //                               style: TextStyle(color: Color(0xff666666)),
        //                             ),
        //                           ),
        //                         ),
        //                         Container(
        //                           alignment: Alignment.centerRight,
        //                           margin: EdgeInsets.only(top: 10),
        //                           child: GestureDetector(
        //                             onTap: () {},
        //                             child: Text(
        //                               "Đổi SĐT",
        //                               style: TextStyle(color: Color(0xff666666)),
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     )
        //                   }
        //                 ],
        //               );
        //             },
        //           ),
        //         )),
        //     BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        //       return Container(
        //         width: screenWidth,
        //         height: 80,
        //         padding: EdgeInsets.symmetric(horizontal: 23),
        //         child: GestureDetector(
        //           onTap: () {
        //             FocusScope.of(context).unfocus();
        //             //TODO: Login action
        //             if (state?.phoneExist == true) {
        //               context.read<LoginBloc>().add(Login(
        //                   phoneNumber: state.phoneNumber,
        //                   passworld: passwordController.text,
        //                   context: context));
        //             } else {
        //               context.read<LoginBloc>().add(CheckPhoneExist(
        //                   phoneNumber: textEditingController.text,
        //                   context: context));
        //             }
        //           },
        //           child: Container(
        //             child: Stack(
        //               alignment: Alignment.center,
        //               children: [
        //                 ClipRRect(
        //                   child: Image.asset(
        //                     'lib/assets/bg-button-blue.png',
        //                     fit: BoxFit.fitHeight,
        //                   ),
        //                   borderRadius: BorderRadius.circular(8),
        //                 ),
        //                 Text(
        //                   "Đăng nhập",
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.w700,
        //                       fontSize: 20,
        //                       color: Colors.white),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       );
        //     })
        //   ],
        // ),
      ),
    );
  }
}
