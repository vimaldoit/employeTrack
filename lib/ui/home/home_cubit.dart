import 'package:bloc/bloc.dart';
import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/data/repository/repository.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  Repository _repository = Repository();
  getData() async {
    try {
      emit(DataLoading());
      List<PersonModel> result = await _repository.getPersonData();
      emit(DataSuccess(result));
    } catch (e) {
      emit(Datafalilure(e.toString()));
    }
  }
}
