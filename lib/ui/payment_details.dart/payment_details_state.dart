// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_details_cubit.dart';

@immutable
abstract class PaymentDetailsState {}

class PaymentDetailsInitial extends PaymentDetailsState {}

class PaymentLoading extends PaymentDetailsState {}

class PaymentAddedSuccess extends PaymentDetailsState {}

class PaymentAddFailure extends PaymentDetailsState {
  final String msge;
  PaymentAddFailure(
    this.msge,
  );
}

class PaymentHistorySuccess extends PaymentDetailsState {
  final List<PaymentModel> paymentHistoryData;

  PaymentHistorySuccess(this.paymentHistoryData);
}

class PaymentHistoryFailure extends PaymentDetailsState {
  final String msge;

  PaymentHistoryFailure(this.msge);
}
