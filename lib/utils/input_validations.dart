import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AppValidations {
  static FilteringTextInputFormatter priceFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"^\d+\.?\d{0,2}"));

  static String? validateTextInput(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter mandatory field';
    }
    return null;
  }

  static String? validateEmailInput(String? email) {
    bool emailValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email!.trim());

    print("called $emailValid");
    if (email.trim().isEmpty || !emailValid) {
      return 'Please enter appropriate email address';
    }
    return null;
  }

  static String? validatePasswordInput(String? password) {
    if (password!.trim().isEmpty || password.trim().length < 6) {
      return 'Password must be 6 characters long';
    }
    return null;
  }

  static void showSnackBar(BuildContext? context, String? value) {
    final snackBar = SnackBar(content: Text(value!));
    ScaffoldMessenger.of(context!).showSnackBar(snackBar);
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg.trim(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static String getdateformat(DateTime date) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date);
    print("FORMATTED DATE" + formatted);

    var todayDate = new DateFormat("yyyy-MM-dd").format(DateTime.now());
    var yesterdaydate = new DateFormat("yyyy-MM-dd")
        .format(DateTime.now().subtract(Duration(days: 1)));

    if (formatted == todayDate) {
      return "Today";
      // } else if (formatted == yesterdaydate) {
      //   return "Yesterday";
    } else {
      var day = date.day;
      final _dayMap = {
        1: 'st',
        2: 'nd',
        3: 'rd',
        21: 'st',
        22: 'nd',
        23: 'rd',
        31: 'st'
      };

      // String dayOfMonth = "$day${_dayMap[day] ?? 'th'}";
      String dayOfMonth = "$day";

      return DateFormat("MMM").format(date) + " " + dayOfMonth;
    }
  }

  static Widget dayWithTh(
      {required String day,
      required double fontsize,
      required Color txtColor,
      String year = ""}) {
    final _dayMap = {
      1: 'st',
      2: 'nd',
      3: 'rd',
      21: 'st',
      22: 'nd',
      23: 'rd',
      31: 'st'
    };
    var daynum = day.replaceAll(new RegExp(r'[^0-9]'), '');

    String dayOfMonth = "${_dayMap[int.parse(daynum)] ?? 'th'}";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day.toString(),
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.w400,
            color: txtColor,
          ),
        ),
        Text(
          dayOfMonth,
          style: TextStyle(
            fontSize: fontsize - 1.sp,
            fontWeight: FontWeight.w400,
            color: txtColor,
          ),
        ),
        year != ""
            ? Text(
                " ${year}",
                style: TextStyle(
                  fontSize: fontsize,
                  fontWeight: FontWeight.w400,
                  color: txtColor,
                ),
              )
            : SizedBox()
      ],
    );
  }
}
