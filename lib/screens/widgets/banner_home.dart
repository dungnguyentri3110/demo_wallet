import 'package:demo_ewallet/blocs/models/home_model.dart';
import 'package:flutter/material.dart';

class BannerHome extends StatelessWidget {
  const BannerHome({super.key, required this.listBanner});

  final List<BannerH> listBanner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listBanner.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                margin: EdgeInsets.only(left: 20),
                child: Image.network(
                  listBanner[index].ImageUrl,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, object, trace) {
                    return Text("Không tìm thấy ảnh! ");
                  },
                ),
              ),
            );
          }),
    );
  }
}
