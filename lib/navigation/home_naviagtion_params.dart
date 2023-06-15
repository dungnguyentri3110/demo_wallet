import 'package:demo_ewallet/blocs/models/home_model.dart';

class HomeNavigationParams {
  String phoneNumber;
  WalletInfo walletInfo;
  List<BannerH> listBanner;

  HomeNavigationParams(
      {required this.walletInfo,
      required this.phoneNumber,
      required this.listBanner});
}
