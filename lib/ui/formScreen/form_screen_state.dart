part of 'form_screen_cubit.dart';

@immutable
abstract class FormScreenState {}

class FormScreenInitial extends FormScreenState {}

class AddPersonLoading extends FormScreenState {}

class AddpersonSuccess extends FormScreenState {
  final String id;
  AddpersonSuccess(this.id);
}

class UpdateEmployee extends FormScreenState {
  final String id;

  UpdateEmployee(this.id);
}

class Addpersonfailure extends FormScreenState {
  final String error;

  Addpersonfailure(this.error);
}
