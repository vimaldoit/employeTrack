import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_form_state.dart';

class EditFormCubit extends Cubit<EditFormState> {
  EditFormCubit() : super(EditFormInitial());
}
