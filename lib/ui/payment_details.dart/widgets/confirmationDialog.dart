import 'package:employeetracker/data/repository/repository.dart';
import 'package:employeetracker/ui/home/view_employee.dart';
import 'package:employeetracker/utils/colors.dart';
import 'package:employeetracker/utils/sizer_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final Function()? clickEvent;
  const ConfirmDialog({super.key, required this.title, this.clickEvent});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      iconPadding: EdgeInsets.zero,
      // icon: Icon(
      //   Icons.question_mark,
      //   size: 40,
      // ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Are you sure",
            style: TextStyle(
                color: Colors.black,
                fontSize: SizerHelper.adaptiveSpToPx(18),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: SizerHelper.adaptiveToPxHeight(15),
          ),
          Text(
            this.title,
            style: TextStyle(
                color: Colors.black,
                fontSize: SizerHelper.adaptiveSpToPx(15),
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: SizerHelper.adaptiveToPxHeight(30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black),
                  ),
                  //   color: AppColors.redColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(
                width: 10,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: AppColors.redColor,
                  onPressed: this.clickEvent,
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
