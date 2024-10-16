import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/data/repository/repository.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'dart:io';
part 'form_screen_state.dart';

class FormScreenCubit extends Cubit<FormScreenState> {
  FormScreenCubit() : super(FormScreenInitial());
  Repository _repository = Repository();
  void addperson(
      {String? documentId,
      String? name,
      Timestamp? dob,
      String? place,
      String? mobile,
      String? idFile,
      String? status,
      Timestamp? entryDate,
      String? imageUrl,
      String? lastImageUrl,
      String? lastIdFile,
      bool? editFlag,
      String? remarks}) async {
    emit(AddPersonLoading());
    try {
      String? finalUrl;
      String? finalIdproofUrl;
      if (imageUrl != null) {
        TaskSnapshot task = await FirebaseStorage.instance
            .ref("employeePic")
            .child("$name+${DateTime.now().millisecond}")
            .putFile(File(imageUrl));
        finalUrl = await task.ref.getDownloadURL();
      }
      if (idFile != null) {
        TaskSnapshot task = await FirebaseStorage.instance
            .ref("employeeIdProof")
            .child("$name+${DateTime.now().millisecond}")
            .putFile(File(idFile));
        finalIdproofUrl = await task.ref.getDownloadURL();
      }
      if (editFlag == false) {
        DocumentReference result = await _repository.addPerson(PersonModel(
            dob: dob,
            entryDate: entryDate,
            idFile: finalIdproofUrl,
            imgeUrl: finalUrl,
            mobile: mobile,
            name: name,
            place: place,
            status: status,
            remarks: remarks));
        emit(AddpersonSuccess(result.id));
      } else {
        var updateEmployee = PersonModel(
            dob: dob,
            entryDate: entryDate,
            idFile: lastIdFile,
            imgeUrl: lastImageUrl,
            mobile: mobile,
            name: name,
            place: place,
            status: status,
            remarks: remarks);
        if (finalUrl != null || finalIdproofUrl != null) {
          updateEmployee = PersonModel(
              dob: dob,
              entryDate: entryDate,
              idFile: finalIdproofUrl ?? lastIdFile,
              imgeUrl: finalUrl ?? lastImageUrl,
              mobile: mobile,
              name: name,
              place: place,
              status: status,
              remarks: remarks);
        }
        await Repository()
            .persons
            .doc(documentId)
            .set(updateEmployee.toJson(), SetOptions(merge: true));
        emit(UpdateEmployee(documentId.toString()));
      }
    } catch (e) {
      emit(Addpersonfailure(e.toString()));
    }
  }
}
