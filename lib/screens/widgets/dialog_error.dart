import 'package:flutter/material.dart';

class DialogError {
  static BuildContext? context;

  static void show(BuildContext context) {
    DialogError.context = context;
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.3),
            body: Center(
              child: Container(
                height: 350,
                margin: const EdgeInsets.symmetric(horizontal: 35),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Image.asset('lib/assets/bg-popup.png')),
                      Positioned(
                          right: 10,
                          top: 10,
                          child: GestureDetector(
                            onTap: () {
                              hide();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          )),
                      Positioned(
                        top: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: Image.asset("lib/assets/bank.png"),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.only(top: 35),
                                  child: Text(
                                    "Liên kết ngân hàng",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  margin: EdgeInsets.only(
                                      top: 10, left: 35, right: 35),
                                  child: SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Quý khách liên kết ngân hàng để tiếp tục thực hiện",
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                  width: 280,
                                  height: 50,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'lib/assets/bg-button-blue.png',
                                        fit: BoxFit.none,
                                      )),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        hide();
                                      },
                                      child: SizedBox(
                                        width: 280,
                                        height: 50,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text("Hoàn tất",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  static void hide() {
    Navigator.pop(DialogError.context!);
  }
}
