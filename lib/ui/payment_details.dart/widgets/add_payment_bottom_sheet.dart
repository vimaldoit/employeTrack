import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPaymentBottomSheet extends StatefulWidget {
  const AddPaymentBottomSheet({super.key});

  @override
  State<AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _balanceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(""),
              TextFormField(
                controller: _amountController,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _balanceController,
              ),
              MaterialButton(onPressed: () {})
            ],
          )),
    );
  }
}
