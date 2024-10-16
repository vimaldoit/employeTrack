part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class DataLoading extends HomeState {}

class DataSuccess extends HomeState {
  final List<PersonModel> personData;

  DataSuccess(this.personData);
}

class Datafalilure extends HomeState {
  final String error;

  Datafalilure(this.error);
}
