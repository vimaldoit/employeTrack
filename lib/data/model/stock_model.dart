class StockModel {
  String? _stockId;
  String? _name;
  int? _quantiry;
  int? _price;

  StockModel({String? stockId, String? name, int? quantity, int? price}) {
    _stockId = stockId;
    _name = name;
    _quantiry = quantity;
    _price = price;
  }
  StockModel.fromJson(dynamic json, String id) {
    _stockId = json["stockId"];
    _name = json["name"];
    _quantiry = json["quantity"];
    _price = json["price"];
  }
  String? get stockId => _stockId;
  String? get name => _name;
  int? get quantity => _quantiry;
  int? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["name"] = _name;
    map["quantity"] = _quantiry;
    map["price"] = _price;
    return map;
  }
}
