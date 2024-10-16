import 'package:bloc/bloc.dart';
import 'package:employeetracker/data/repository/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Repository _repository;
  LoginCubit(this._repository) : super(LoginInitial());

  void login(String email, String password) async {
    emit(LoginLoading());
    try {
      UserCredential userData = await _repository.userLogin(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
