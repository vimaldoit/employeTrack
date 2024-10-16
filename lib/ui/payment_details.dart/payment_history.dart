import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeetracker/data/model/payment_model.dart';
import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/data/repository/repository.dart';
import 'package:employeetracker/ui/common%20widgets/apploader.dart';
import 'package:employeetracker/ui/home/view_employee.dart';
import 'package:employeetracker/ui/payment_details.dart/payment_details_cubit.dart';
import 'package:employeetracker/ui/payment_details.dart/widgets/add_payment_bottom_sheet.dart';
import 'package:employeetracker/ui/payment_details.dart/widgets/confirmationDialog.dart';
import 'package:employeetracker/utils/colors.dart';
import 'package:employeetracker/utils/input_validations.dart';
import 'package:employeetracker/utils/sizer_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datePickerPlugin;

class PaymentHistoryScreen extends StatefulWidget {
  final String personId;
  final PersonModel personData;
  const PaymentHistoryScreen(
      {super.key, required this.personId, required this.personData});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _balanceController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime dropdowndate = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateTime? currentDate = DateTime.now();
  String _selectedDate = "";
  @override
  void initState() {
    BlocProvider.of<PaymentDetailsCubit>(context)
        .getPaymentHistoryList(widget.personId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: BlocConsumer<PaymentDetailsCubit, PaymentDetailsState>(
            listener: (context, state) {
              if (state is PaymentHistoryFailure) {
                AppValidations.showToast(state.msge.toString());
              }
            },
            builder: (context, state) {
              if (state is PaymentLoading) {
                return AppLoader();
              }
              if (state is PaymentHistorySuccess) {
                var listData = state.paymentHistoryData;
                return ListView.separated(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    var dataItem = listData[index];
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat("dd-MMM-yyyy")
                                      .format(dataItem.date!.toDate())
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizerHelper.adaptiveSpToPx(11)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Ammount",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  SizerHelper.adaptiveSpToPx(
                                                      12)),
                                        ),
                                        Text(
                                          "\u20B9 ${dataItem.amount}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  SizerHelper.adaptiveSpToPx(
                                                      12)),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Balance",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  SizerHelper.adaptiveSpToPx(
                                                      12)),
                                        ),
                                        Text(
                                          "\u20B9 ${dataItem.balance}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  SizerHelper.adaptiveSpToPx(
                                                      12)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _amountController.text =
                                  dataItem.amount.toString();
                              _balanceController.text =
                                  dataItem.balance.toString();
                              _dateController.text =
                                  "${DateFormat("dd/MM/yyyy").format(dataItem.date!.toDate())}";
                              paymentBottomsheet(context,
                                      isEdit: true, id: dataItem.id)
                                  .whenComplete(() => BlocProvider.of<
                                          PaymentDetailsCubit>(context)
                                      .getPaymentHistoryList(widget.personId));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 0.5, color: AppColors.hintColor)),
                              child: Icon(
                                Icons.edit,
                                size: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                );
              }
              return SizedBox();
            },
          )),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          _amountController.clear();
          _balanceController.clear();
          _dateController.clear();

          paymentBottomsheet(context).whenComplete(() =>
              BlocProvider.of<PaymentDetailsCubit>(context)
                  .getPaymentHistoryList(widget.personId));
          ;

          // showDialog(
          //   context: context,
          //   builder: (context) => AddPaymentPopup(),
          // );
        },
        child: Icon(
          Icons.add,
          color: AppColors.textColor,
        ),
        backgroundColor: AppColors.accentColor,
      ),
    );
  }

  Future<void> paymentBottomsheet(BuildContext context,
      {bool? isEdit = false, String? id}) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext context) {
          // we set up a container inside which
          // we create center column and display text

          // Returning SizedBox instead of a Container
          return BlocProvider(
            create: (context) => PaymentDetailsCubit(Repository()),
            child: BlocConsumer<PaymentDetailsCubit, PaymentDetailsState>(
              listener: (context, state) {
                if (state is PaymentAddedSuccess) {
                  Navigator.of(context).pop();
                }
                if (state is PaymentAddFailure) {
                  AppValidations.showToast(state.msge);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: state is PaymentLoading
                        ? AppLoader()
                        : Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Add Payment",
                                      style: TextStyle(
                                          color: AppColors.textColor2,
                                          fontSize:
                                              SizerHelper.adaptiveSpToPx(17),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Icon(
                                            size: 15,
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  readOnly: true,
                                  controller: _dateController,
                                  keyboardType: TextInputType.none,
                                  decoration: InputDecoration(
                                    labelText: "Date",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    datePickerPlugin.DatePicker.showDatePicker(
                                        context,
                                        showTitleActions: true,
                                        // minTime: userSignUp!,
                                        maxTime: DateTime.now(),
                                        theme: const datePickerPlugin
                                            .DatePickerTheme(
                                          backgroundColor: Colors.white,
                                          itemStyle: TextStyle(
                                              color: AppColors.hintColor),
                                          cancelStyle:
                                              TextStyle(color: Colors.grey),
                                          doneStyle:
                                              TextStyle(color: Colors.grey),
                                        ), onChanged: (date) {
                                      print('change $date in time zone ' +
                                          date.timeZoneOffset.inHours
                                              .toString());
                                    }, onConfirm: (date) {
                                      print('confirm $date');
                                      print('confirm ${currentDate}');

                                      setState(() {
                                        print("DATE IS ${date}");
                                        dropdowndate = date;
                                        selectedDate = date;
                                        // selectedDate=date;
                                        if (DateFormat("dd/MM/yyyy")
                                                .format(date) ==
                                            DateFormat("dd/MM/yyyy")
                                                .format(DateTime.now())) {
                                          _selectedDate = "Today";
                                        } else {
                                          print(
                                              DateFormat("h:mma").format(date));

                                          _selectedDate =
                                              "${DateFormat("dd/MM/yyyy").format(date)}";
                                          // _selectedDate=DateFormat("dd/MM/yyyy").format(date);
                                          /*_selectedDate = DateFormat("dd/MM/yyyy,hh:mm ")
                                                                                          .format(date!);*/
                                        }
                                        setState(() {
                                          _dateController.text = _selectedDate;
                                        });
                                        print(selectedDate);
                                      });

                                      Future.delayed(Duration.zero, () async {
                                        print("DATE_SETTSTATE" +
                                            selectedDate.toString());
                                        var createdt =
                                            DateFormat("yyyyMMdd").format(date);

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
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Amount",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == "") {
                                      return 'Please enter amount';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _balanceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Balance",
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == "") {
                                      return 'Please enter balance';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                isEdit == false
                                    ? MaterialButton(
                                        minWidth: double.infinity,
                                        color: AppColors.accentColor,
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            BlocProvider.of<
                                                        PaymentDetailsCubit>(
                                                    context)
                                                .addPaymentDetail(
                                                    date: Timestamp.fromDate(
                                                        selectedDate!),
                                                    amount: int.parse(
                                                        _amountController.text),
                                                    balance: int.parse(
                                                        _balanceController
                                                            .text),
                                                    personid: widget.personId);
                                          }
                                        },
                                        child: Text(
                                          "ADD",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  SizerHelper.adaptiveSpToPx(
                                                      14)),
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: MaterialButton(
                                              //minWidth: double.infinity,
                                              color: AppColors.redColor,
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      ConfirmDialog(
                                                    title:
                                                        "Do you want to delete?",
                                                    clickEvent: () {
                                                      Repository repository =
                                                          Repository();
                                                      repository
                                                          .deletePaymentDetails(
                                                        id.toString(),
                                                      );
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: ((context) =>
                                                                  EmployeeDetails(
                                                                      index: 1,
                                                                      pData: widget
                                                                          .personData))));
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizerHelper
                                                        .adaptiveSpToPx(14)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: MaterialButton(
                                              //  minWidth: double.infinity,
                                              color: AppColors.accentColor,
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  BlocProvider.of<PaymentDetailsCubit>(context)
                                                      .updatePaymentDetails(
                                                          id.toString(),
                                                          PaymentModel(
                                                              amount: int.parse(
                                                                  _amountController
                                                                      .text),
                                                              balance: int.parse(
                                                                  _balanceController
                                                                      .text),
                                                              personid: widget
                                                                  .personId,
                                                              date: Timestamp
                                                                  .fromDate(
                                                                      selectedDate!)));
                                                }
                                              },
                                              child: Text(
                                                "Update",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizerHelper
                                                        .adaptiveSpToPx(14)),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                              ],
                            )),
                  ),
                );
              },
            ),
          );
        });
  }
}
