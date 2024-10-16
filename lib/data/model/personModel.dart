import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PersonModel {
  String? _id;
  String? _name;
  Timestamp? _dob;
  String? _place;
  String? _mobile;
  String? _idFile;
  String? _status;
  Timestamp? _entryDate;
  String? _imgeUrl;
  String? _remarks;

  PersonModel(
      {String? id,
      String? name,
      Timestamp? dob,
      String? place,
      String? mobile,
      String? idFile,
      String? status,
      Timestamp? entryDate,
      String? imgeUrl,
      String? remarks}) {
    _id = id;
    _name = name;
    _dob = dob;
    _place = place;
    _mobile = mobile;
    _idFile = idFile;
    _status = status;
    _entryDate = entryDate;
    _imgeUrl = imgeUrl;
    _remarks = remarks;
  }
  PersonModel.fromJson(dynamic json, String id) {
    _id = id;
    _name = json['name'];
    _dob = json["dob"];
    _place = json['place'];
    _mobile = json["mobile"];
    _idFile = json['idFile'];
    _status = json['status'];
    _entryDate = json['entryDate'];
    _imgeUrl = json["imgeUrl"];
    _remarks = json["remarks"];
  }
  String? get id => _id;
  String? get name => _name;
  Timestamp? get dob => _dob;
  String? get place => _place;
  String? get mobile => _mobile;
  String? get idFile => _idFile;
  String? get status => _status;
  Timestamp? get entryDate => _entryDate;
  String? get imgeUrl => _imgeUrl;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['dob'] = _dob;
    map['place'] = _place;
    map['mobile'] = _mobile;
    map['idFile'] = _idFile;
    map['status'] = _status;
    map['entryDate'] = _entryDate;
    map['imgeUrl'] = _imgeUrl;
    map["remarks"] = _remarks;
    return map;
  }
}
