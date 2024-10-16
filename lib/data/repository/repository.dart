import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeetracker/data/model/payment_model.dart';
import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/data/model/stock_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final CollectionReference persons =
      FirebaseFirestore.instance.collection('person_data');
  final CollectionReference paymentHistory =
      FirebaseFirestore.instance.collection('payment_history');
  final CollectionReference stock =
      FirebaseFirestore.instance.collection('stock');
  var authInstance = FirebaseAuth.instance;

  Future<DocumentReference> addPerson(PersonModel personModel) {
    return persons.add(personModel.toJson());
  }

  Future<DocumentReference> addStock(StockModel stockdata) {
    return stock.add(stockdata.toJson());
  }

  Future<DocumentReference> addPayment(PaymentModel paymentData) {
    return paymentHistory.add(paymentData.toJson());
  }

  Future<List<PersonModel>> getPersonData() async {
    try {
      List<PersonModel> listData = [];
      var data = await persons.get();
      if (data.docs.isNotEmpty) {
        listData =
            data.docs.map((e) => PersonModel.fromJson(e.data(), e.id)).toList();
      }
      return listData;
    } catch (e) {
      return [];
    }
  }

  Future<List<PaymentModel>> getPaymentHistory(personId) async {
    try {
      List<PaymentModel> paylistData = [];
      var data = await paymentHistory
          .where("personID", isEqualTo: personId)
          .orderBy('date', descending: true)
          .get();
      if (data.docs.isNotEmpty) {
        paylistData = data.docs
            .map((e) => PaymentModel.fromJson(e.data(), e.id))
            .toList();
      }
      return paylistData;
    } catch (e) {
      return [];
    }
  }

  Future<List<StockModel>> getStock() async {
    try {
      List<StockModel> listData = [];
      var data = await stock.get();
      if (data.docs.isNotEmpty) {
        listData =
            data.docs.map((e) => StockModel.fromJson(e.data(), e.id)).toList();
      }
      return listData;
    } catch (e) {
      return [];
    }
  }

  Future userLogin(String email, String password) async {
    var data = await authInstance.signInWithEmailAndPassword(
        email: email, password: password);
    return Future.value(data);
  }

  Future<void> deleteEmploye(String id) async {
    return persons.doc(id).delete();
  }

  Future<void> updatePaymentDetail(String id, PaymentModel paymentData) async {
    var data = await paymentHistory.doc(id).set(paymentData.toJson());
  }

  Future<void> deletePaymentDetails(String id) async {
    await paymentHistory.doc(id).delete();
  }
}
