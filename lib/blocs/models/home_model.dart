class HomeModel {}

class PersonalInfo {}

class WalletInfo {
  String? FullName;
  String? DateOfBirth;
  int? SexType;
  int? ActiveEmail;
  String? AvailableBlance;

  WalletInfo(
      {required this.FullName,
      required this.DateOfBirth,
      required this.SexType,
      required this.ActiveEmail,
      required this.AvailableBlance});
  factory WalletInfo.initState(){
    return WalletInfo(FullName: "", DateOfBirth: "", SexType: 0, ActiveEmail: 0, AvailableBlance: "");
  }

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
        FullName: json['FullName'],
        DateOfBirth: json['DateOfBirth'],
        SexType: json['SexType'],
        ActiveEmail: json['ActiveEmail'],
        AvailableBlance: json['AvailableBlance']);
  }
}

class BannerH {
  int Id;
  String Title;
  String Content;
  String ImageUrl;
  String RedirectUrl;
  String? StartDate;
  String? FinishDate;
  String Priority;

  BannerH(
      {required this.Id,
      required this.Title,
      required this.Content,
      required this.ImageUrl,
      required this.RedirectUrl,
      this.StartDate,
      this.FinishDate,
      required this.Priority});

  factory BannerH.fromJson(Map<String, dynamic> json) {
    return BannerH(
        Id: json['Id'],
        Title: json['Title'],
        Content: json['Content'],
        ImageUrl: json['ImageUrl'],
        RedirectUrl: json['RedirectUrl'],
        Priority: json['Priority'],
        StartDate: json['StartDate'],
        FinishDate: json['FinishDate']);
  }
}
