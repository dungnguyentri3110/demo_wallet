import 'package:demo_ewallet/widgets/demo_bottom_sheet.dart';
import 'package:flutter/material.dart';

class StatusActive extends StatelessWidget {
  const StatusActive({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: (){
          DemoBottomSheet.show(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                child: Image.asset('lib/assets/ic-notice-user-alert.png'),
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Cập nhật định danh để tăng cường bảo mật cho tài khoản của quý khách",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}
