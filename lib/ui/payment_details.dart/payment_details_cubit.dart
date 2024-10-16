// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeetracker/data/model/payment_model.dart';
import 'package:meta/meta.dart';

import 'package:employeetracker/data/repository/repository.dart';

part 'payment_details_state.dart';

class PaymentDetailsCubit extends Cubit<PaymentDetailsState> {
  Repository _repository;
  PaymentDetailsCubit(
    this._repository,
  ) : super(PaymentDetailsInitial());
  void addPaymentDetail(
      {required Timestamp date,
      required int amount,
      required int balance,
      required String personid}) async {
    emit(PaymentLoading());
    try {
      await _repository.addPayment(PaymentModel(
          amount: amount, balance: balance, date: date, personid: personid));
      emit(PaymentAddedSuccess());
    } catch (e) {
      emit(PaymentAddFailure(e.toString()));
    }
  }

  void updatePaymentDetails(String id, PaymentModel pdata) async {
    emit(PaymentLoading());
    try {
      await _repository.updatePaymentDetail(id.toString(), pdata);
      emit(PaymentAddedSuccess());
    } catch (e) {
      emit(PaymentAddFailure(e.toString()));
    }
  }

  void getPaymentHistoryList(personId) async {
    emit(PaymentLoading());
    try {
      var payListData = await _repository.getPaymentHistory(personId);
      emit(PaymentHistorySuccess(payListData));
    } catch (e) {
      emit(PaymentHistoryFailure(e.toString()));
    }
  }
}
