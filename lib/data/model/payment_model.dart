import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String? _id;
  String? _personId;
  Timestamp? _date;
  int? _amount;
  int? _balance;
  PaymentModel(
      {Timestamp? date,
      int? amount,
      int? balance,
      String? personid,
      String? id}) {
    _id = id;
    _date = date;
    _amount = amount;
    _balance = balance;
    _personId = personid;
  }
  PaymentModel.fromJson(dynamic json, String id) {
    _id = id;
    _personId = json["personID"];
    _amount = json["amount"];
    _balance = json["balance"];
    _date = json["date"];
  }
  String? get id => _id;
  String? get personId => _personId;
  int? get amount => _amount;
  int? get balance => _balance;
  Timestamp? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["date"] = _date;
    map["personID"] = _personId;
    map['amount'] = _amount;
    map["balance"] = _balance;
    return map;
  }
}
