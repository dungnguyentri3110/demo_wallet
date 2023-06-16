import 'package:demo_ewallet/blocs/home_bloc/model.dart';
import 'package:flutter/material.dart';

class ServiceHome extends StatelessWidget {
  ServiceHome({super.key, required this.listServices});

  final List<ServiceAvailable> listServices;
  PageController pageController = PageController();

  List<Widget> renderWarp(BuildContext context) {
    List<Widget> list = [];
    List<Widget> row = [];
    int countItem = 0;
    for (int i = 0; i < listServices.length; i++) {
      Widget item = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 5,
            height: MediaQuery.of(context).size.width / 2 - 100,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 0),
              width: 80,
              child: Image.network(
                listServices[i].Icon!,
                fit: BoxFit.contain,
                width: 80,
                height: 80,
                errorBuilder: (context, object, stacktrace) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Khong tim thay hinh anh"),
                  );
                },
              ),
            ),
          ),
          Text(
            listServices[i].ServiceName ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )
        ],
      );

      if (countItem < 3) {
        row.add(item);
        countItem += 1;
        if (i == listServices.length - 1) {
          Widget wrap = Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.yellow,
            alignment: Alignment.center,
            child: Wrap(
              direction: Axis.horizontal,
              children: row,
            ),
          );
          list.add(wrap);
        }
      } else if (row.length == 3) {
        row.add(item);
        countItem = 0;
        Widget wrap = Wrap(
          direction: Axis.horizontal,
          children: row,
        );
        list.add(wrap);
        row = [];
      } else {
        countItem = 0;
        row = [];
      }
    }

    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2 + 50,
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: renderWarp(context),
      ),
    );
  }
}
