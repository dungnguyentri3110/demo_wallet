import 'package:equatable/equatable.dart';

class ServiceAvailable extends Equatable{
  int? ServiceId;
  int? ParentId;
  String? ServiceName;
  String? MerchantCode;
  String? Code;
  String? ScreenKey;
  int? Status;
  String? Icon;
  ServiceAvailable({this.ScreenKey, this.ServiceName,
    this.Status,
    this.ServiceId,
    this.MerchantCode,
    this.Code,
    this.ParentId,
  this.Icon});

  factory ServiceAvailable.fromJson(Map<String, dynamic> json){
    return ServiceAvailable(
      ScreenKey: json['ScreenKey'],
      ServiceId: json['ServiceId'],
      Status: json['Status'],
      ServiceName: json['ServiceName'],
      ParentId: json['ParentId'],
      MerchantCode: json['MerchantCode'],
      Code: json['Code'],
      Icon: json['Icon']
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [ScreenKey,
    ServiceId,
    Status,
    ServiceName,
    ParentId,
    MerchantCode,
        Code,];
}