import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? _oid;
  String? _name;
  Timestamp? _orderDate;
  String? _imgurl;
  String? _status;
  String? _assignedChefName;
  String? _chefId;

  OrderModel(
      {String? oid,
      String? name,
      Timestamp? orderDate,
      String? imgurl,
      String? status,
      String? assignedChefName,
      String? chefId}) {
    _oid = oid;
    _name = name;
    _orderDate = orderDate;
    _imgurl = imgurl;
    _status = status;
    _assignedChefName = assignedChefName;
    _chefId = chefId;
  }
  OrderModel.fromjson(dynamic json, String oid) {
    _oid = oid;
    _name = json["name"];
    _orderDate = json["order_date"];
    _status = json["status"];
    _imgurl = json["imgurl"];
    _assignedChefName = json["assingned_chef_name"];
    _chefId = json["chefId"];
  }
  String? get oid => _oid;
  String? get name => _name;
  Timestamp? get orderDate => _orderDate;
  String? get status => _status;
  String? get imgUrl => _imgurl;
  String? get assingedChefName => _assignedChefName;
  String? get chefId => _chefId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["name"] = _name;
    map["order_date"] = _orderDate;
    map["status"] = _status;
    map["imgurl"] = _imgurl;
    map["assingned_chef_name"] = _assignedChefName;
    map["chefId"] = _chefId;
    return map;
  }
}
