import 'package:flutter/material.dart';

class DemoBottomSheet {
  static BuildContext? context;

  static void show(BuildContext context) {
    DemoBottomSheet.context = context;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 650,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: Colors.white,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Chọn nguồn tiền',
                  style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      children: [
                        Image.asset(
                          "lib/assets/favicon.png",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ví EPAY 09000000000",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 16)),
                            Text("Số dư: 10.000.000đ")
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      children: [
                        Image.asset(
                          "lib/assets/bank.png",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Vietcombank",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 16)),
                            Text("************000")
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      children: [
                        Image.asset(
                          "lib/assets/bank.png",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Eximbank",
                                style: TextStyle(
                                    fontStyle: FontStyle.normal, fontSize: 16)),
                            Text("************000")
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Thêm ngân hàng',
                  style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: const Row(
                      children: [
                        Text("Thêm tài khoản ngân hàng",
                            style: TextStyle(
                                fontStyle: FontStyle.normal, fontSize: 16)),
                      ],
                    )),
                const SizedBox(
                  height: 12,
                ),
                // const SizedBox(
                //   height: 32,
                // ),
                // ElevatedButton(
                //   child: const Text('Close BottomSheet'),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
