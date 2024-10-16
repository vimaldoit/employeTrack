import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/ui/common%20widgets/apploader.dart';
import 'package:employeetracker/ui/formScreen/form_screen_cubit.dart';
import 'package:employeetracker/ui/home/home.dart';
import 'package:employeetracker/ui/home/home_cubit.dart';
import 'package:employeetracker/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datePickerPlugin;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  final PersonModel editData;
  const FormScreen({super.key, required this.editData});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dobController = TextEditingController();
  final _remarksController = TextEditingController();

  DateTime? userSignUp = DateTime(2022, 4, 1);
  DateTime dropdowndate = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime? currentDate = DateTime.now();
  String _selectedDate = "";
  String _selectedTime = "";
  String? filePath;
  String? idProofFilePath;
  bool propicErrorFlag = false;
  bool idProofErrorFlag = false;
  final ImagePicker _picker = ImagePicker();
  var items = ['Select status', 'True', 'False'];
  String dropdownvalue = 'Select status';
  void _openGallery(String type) async {
    var result = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxHeight: 512,
        maxWidth: 512);
    if (result != null) {
      if (type == "proPic") {
        filePath = result.path;
      } else if (type == "idPic") {
        idProofFilePath = result.path;
      }

      setState(() {});
    }
    Navigator.pop(context);
  }

  void _openCamera(String type) async {
    var result = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 40,
        maxHeight: 512,
        maxWidth: 512);
    if (result != null) {
      if (type == "proPic") {
        filePath = result.path;
      } else if (type == "idPic") {
        idProofFilePath = result.path;
      }
      setState(() {});
    }
    Navigator.pop(context);
  }

  void showDateBottomSheetDialog(BuildContext context, String type) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0)),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(20.0)),
                      width: MediaQuery.of(context).size.width / 7,
                      height: 4.0,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _openCamera(type);
                        },
                        label: const Text(
                          'Camera',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        // textColor: Colors.white,
                        // color: Colors.blueGrey,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      ElevatedButton.icon(
                        // padding: EdgeInsets.all(10),
                        onPressed: () {
                          _openGallery(type);
                        },

                        label: const Text(
                          'Gallery',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        icon: const Icon(
                          Icons.photo_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        // textColor: Colors.white,

                        // color: Colors.lightBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.editData.name != null) {
      _nameController.text = widget.editData.name.toString();
      _placeController.text = widget.editData.place.toString();
      _mobileController.text = widget.editData.mobile.toString();
      _remarksController.text = widget.editData.remarks ?? "";

      _dobController.text =
          "${DateFormat("dd/MM/yyyy").format((widget.editData.dob!).toDate())}";
      _selectedDate = widget.editData.dob.toString();
      dropdownvalue = widget.editData.status.toString();
      filePath = widget.editData.imgeUrl.toString();
      idProofFilePath = widget.editData.idFile.toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editData.name != null ? "Edit Employee" : "Add Employee"),
      ),
      body: SafeArea(
          child: BlocConsumer<FormScreenCubit, FormScreenState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is Addpersonfailure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Something wrong please try again"),
              duration: Duration(milliseconds: 300),
            ));
          }
          if (state is AddpersonSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider(
                        create: (context) => HomeCubit(),
                        child: const HomeScreen(),
                      )),
              (route) => false,
            );
          }
          if (state is UpdateEmployee) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider(
                        create: (context) => HomeCubit(),
                        child: const HomeScreen(),
                      )),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AddPersonLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.person),
                        hintText: 'Enter your full name',
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value == "") {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _dobController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.calendar_month),
                        hintText: 'Date of birth',
                        labelText: 'Dob',
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        datePickerPlugin.DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            // minTime: userSignUp!,
                            maxTime: DateTime.now(),
                            theme: const datePickerPlugin.DatePickerTheme(
                              backgroundColor: Colors.white,
                              itemStyle: TextStyle(color: AppColors.hintColor),
                              cancelStyle: TextStyle(color: Colors.grey),
                              doneStyle: TextStyle(color: Colors.grey),
                            ), onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          print('confirm $date');
                          print('confirm ${currentDate}');

                          setState(() {
                            print("DATE IS ${date}");
                            dropdowndate = date;
                            selectedDate = date;
                            // selectedDate=date;
                            if (DateFormat("dd/MM/yyyy").format(date) ==
                                DateFormat("dd/MM/yyyy")
                                    .format(DateTime.now())) {
                              _selectedDate = "Today";
                            } else {
                              print(DateFormat("h:mma").format(date));

                              _selectedDate =
                                  "${DateFormat("dd/MM/yyyy").format(date)}";
                              // _selectedDate=DateFormat("dd/MM/yyyy").format(date);
                              /*_selectedDate = DateFormat("dd/MM/yyyy,hh:mm ")
                                                            .format(date!);*/
                            }
                            setState(() {
                              _dobController.text = _selectedDate;
                            });
                            print(selectedDate);
                          });

                          Future.delayed(Duration.zero, () async {
                            print("DATE_SETTSTATE" + selectedDate.toString());
                            var createdt = DateFormat("yyyyMMdd").format(date);

                            setState(() {});
                          });
                        }, currentTime: dropdowndate);
                      },
                      validator: (value) {
                        if (value == "") {
                          return 'Please select Dob';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _placeController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.place),
                        hintText: 'Enter Place',
                        labelText: 'Place',
                      ),
                      validator: (value) {
                        if (value == "") {
                          return 'Please enter place';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.phone_android),
                        hintText: 'Enter Mobile number',
                        labelText: 'Mobile number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == "") {
                          return 'Please enter Mobile Number';
                        } else if (value!.length > 10 || value.length < 10) {
                          return 'Please enter Valid Mobile Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            // width: double.infinity,
                            child: DropdownButtonFormField(
                              validator: (value) => value == "Select status"
                                  ? 'Please select status'
                                  : null,
                              // Initial Value
                              value: dropdownvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _remarksController,
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.note_alt_outlined),
                        hintText: 'Enter Remarks',
                        labelText: 'Remarks',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      // validator: (value) {
                      //   if (value == "") {
                      //     return 'Please enter Mobile Number';
                      //   } else if (value!.length > 10 || value.length < 10) {
                      //     return 'Please enter Valid Mobile Number';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.photo,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Add Profile Photo",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: 126.04,
                                  height: 121,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.lightBlue,
                                  ),
                                  child: filePath == null
                                      ? IconButton(
                                          onPressed: () {
                                            // pickUpImage();
                                            showDateBottomSheetDialog(
                                                context, "proPic");
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 28.0,
                                            color: Colors.white,
                                          ))
                                      : Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              child: CachedNetworkImage(
                                                  imageUrl: filePath!,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const AppLoader(),
                                                  errorWidget:
                                                      (context, url, error) {
                                                    print("ERROR IS" +
                                                        error.toString());
                                                    if (filePath!.isNotEmpty) {
                                                      print(filePath);
                                                      return Image.file(
                                                        File(filePath!),
                                                        fit: BoxFit.cover,
                                                      );
                                                    } else {
                                                      return IconButton(
                                                          onPressed: () {
                                                            _openGallery(
                                                                "proPic");
                                                          },
                                                          icon: const Icon(
                                                            Icons.camera_alt,
                                                            size: 40.0,
                                                            color: Colors.white,
                                                          ));
                                                    }
                                                  }),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    filePath = null;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black26,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            offset: Offset.zero,
                                                            blurRadius: 3)
                                                      ]),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                              Visibility(
                                visible: propicErrorFlag,
                                child: const Text(
                                  "Plese upload your profile photo",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.photo,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Upload ID Proof",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: 126.04,
                                  height: 121,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.lightBlue,
                                  ),
                                  child: idProofFilePath == null
                                      ? IconButton(
                                          onPressed: () {
                                            // pickUpImage();
                                            showDateBottomSheetDialog(
                                                context, "idPic");
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 28.0,
                                            color: Colors.white,
                                          ))
                                      : Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              child: CachedNetworkImage(
                                                  imageUrl: idProofFilePath!,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const AppLoader(),
                                                  errorWidget:
                                                      (context, url, error) {
                                                    print("ERROR IS" +
                                                        error.toString());
                                                    if (idProofFilePath!
                                                        .isNotEmpty) {
                                                      print(idProofFilePath);
                                                      return Image.file(
                                                        File(idProofFilePath!),
                                                        fit: BoxFit.cover,
                                                      );
                                                    } else {
                                                      return IconButton(
                                                          onPressed: () {
                                                            _openGallery(
                                                                "proPic");
                                                          },
                                                          icon: const Icon(
                                                            Icons.camera_alt,
                                                            size: 40.0,
                                                            color: Colors.white,
                                                          ));
                                                    }
                                                  }),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    idProofFilePath = null;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black26,
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            offset: Offset.zero,
                                                            blurRadius: 3)
                                                      ]),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 20.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                              Visibility(
                                visible: idProofErrorFlag,
                                child: const Text(
                                  "Plese upload your ID proof",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    new Container(
                        width: double.infinity,
                        // padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                        child: new ElevatedButton(
                          child: Text(widget.editData?.name == null
                              ? 'Submit'
                              : "Update"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (filePath == null) {
                                if (widget.editData.imgeUrl == null) {
                                  setState(() {
                                    propicErrorFlag = true;
                                  });
                                } else {
                                  setState(() {
                                    propicErrorFlag = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  propicErrorFlag = false;
                                });
                              }

                              if (idProofFilePath == null) {
                                if (widget.editData.idFile == null) {
                                  setState(() {
                                    propicErrorFlag = false;
                                    idProofErrorFlag = true;
                                  });
                                } else {
                                  setState(() {
                                    idProofErrorFlag = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  idProofErrorFlag = false;
                                });
                              }

                              if (!idProofErrorFlag && !propicErrorFlag) {
                                BlocProvider.of<FormScreenCubit>(context)
                                    .addperson(
                                        documentId: widget.editData.id,
                                        name: _nameController.text,
                                        dob: Timestamp.fromDate(selectedDate!),
                                        entryDate:
                                            Timestamp.fromDate(DateTime.now()),
                                        idFile:
                                            idProofFilePath ==
                                                    widget.editData.idFile
                                                ? null
                                                : idProofFilePath,
                                        imageUrl:
                                            filePath == widget.editData.imgeUrl
                                                ? null
                                                : filePath,
                                        mobile: _mobileController.text,
                                        remarks: _remarksController.text,
                                        place: _placeController.text,
                                        status: dropdownvalue,
                                        lastIdFile: widget.editData?.idFile,
                                        lastImageUrl: widget.editData?.imgeUrl,
                                        editFlag: widget.editData.name == null
                                            ? false
                                            : true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Completed"),
                                    duration: Duration(milliseconds: 300),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please Complete Form"),
                                  duration: Duration(milliseconds: 300),
                                ),
                              );
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}
