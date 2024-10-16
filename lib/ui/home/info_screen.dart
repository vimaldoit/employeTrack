import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/ui/home/view_employee.dart';
import 'package:employeetracker/utils/sizer_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoScreen extends StatelessWidget {
  final PersonModel infoData;
  const InfoScreen({super.key, required this.infoData});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ItemListDetail(
                title: "Mobile NO:",
                val: "${this.infoData.mobile}",
              ),
              DivideLine(),
              ItemListDetail(
                title: "DOB:",
                val:
                    "${DateFormat("dd-MM-yyyy").format((this.infoData.dob!).toDate())}",
              ),
              DivideLine(),
              ItemListDetail(
                title: "Place:",
                val: "${this.infoData.place}",
              ),
              DivideLine(),
              ItemListDetail(
                title: "Status:",
                val:
                    "${this.infoData.status == "True" ? "Active" : "Not Active"}",
                docId: this.infoData.id,
              ),
              DivideLine(),
              ItemListDetail(
                title: "Remarks:",
                val: "${this.infoData.remarks}",
              ),
              DivideLine(),
              Row(
                children: [
                  Text(
                    "ID Proof:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizerHelper.adaptiveSpToPx(14),
                        color: Colors.green),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) =>
                          imageDialog(context, this.infoData.idFile),
                    ),
                    child: Text("View"),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    onPressed: () {
                      downloadFile(this.infoData.idFile, context);
                    },
                    child: Icon(Icons.download),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
