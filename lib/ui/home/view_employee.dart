import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/data/repository/repository.dart';
import 'package:employeetracker/ui/common%20widgets/apploader.dart';
import 'package:employeetracker/ui/formScreen/formScreen.dart';
import 'package:employeetracker/ui/formScreen/form_screen_cubit.dart';
import 'package:employeetracker/ui/home/home.dart';
import 'package:employeetracker/ui/home/home_cubit.dart';
import 'package:employeetracker/ui/home/info_screen.dart';
import 'package:employeetracker/ui/payment_details.dart/payment_details_cubit.dart';
import 'package:employeetracker/ui/payment_details.dart/payment_history.dart';
import 'package:employeetracker/ui/payment_details.dart/widgets/confirmationDialog.dart';
import 'package:employeetracker/utils/colors.dart';
import 'package:employeetracker/utils/input_validations.dart';
import 'package:employeetracker/utils/sizer_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

_callNumber(String number) async {
  var url = Uri.parse("tel:$number");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class EmployeeDetails extends StatefulWidget {
  final PersonModel pData;
  final int? index;
  const EmployeeDetails({super.key, required this.pData, this.index = 0});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails>
    with TickerProviderStateMixin {
  late TabController tabController;
  _launchWhatsapp(String whatsapp) async {
    var whatsappAndroid = Uri.parse(
        "whatsapp://send?phone=$whatsapp&text=Hi ${widget.pData.name},\n");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => HomeCubit(),
                child: const HomeScreen(),
              )),
      (route) => false,
    );
    return Future<bool>.value(true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
      initialIndex: widget.index!,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title: "Do you want to delete ?",
                      clickEvent: () async {
                        try {
                          Repository repository = Repository();
                          await repository
                              .deleteEmploye(widget.pData.id.toString());
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                        create: (context) => HomeCubit(),
                                        child: HomeScreen(),
                                      )));
                        } catch (e) {
                          AppValidations.showToast(e.toString());
                        }
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.hintColor, width: 1.5),
                      //color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.delete,
                    size: 16,
                    //color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) => FormScreenCubit(),
                                child: FormScreen(editData: widget.pData),
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.hintColor, width: 1.5),
                      //color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    //color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: SizerHelper.adaptiveToPxHeight(0),
                        ),
                        Row(
                          children: [
                            Center(
                              child: Container(
                                  height: SizerHelper.adaptiveToPxWidth(100),
                                  width: SizerHelper.adaptiveToPxWidth(100),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              SizerHelper.adaptiveToPxWidth(
                                                  100)))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            SizerHelper.adaptiveToPxWidth(
                                                150))),
                                    child: InkWell(
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (_) => imageDialog(
                                            context, widget.pData.imgeUrl),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: "${widget.pData.imgeUrl}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            AppLoader(),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.pData.name.toString(),
                                  style: TextStyle(
                                      fontSize: SizerHelper.adaptiveSpToPx(22),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ContactTile(
                                      icon: Icons.call,
                                      title: "Call",
                                      shadeColor: [
                                        Colors.blue.shade800,
                                        Colors.blue.shade700,
                                        Colors.blue.shade600,
                                        Colors.blue.shade400,
                                      ],
                                      callback: () => _callNumber(
                                          widget.pData.mobile.toString()),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    ContactTile(
                                      icon: FontAwesomeIcons.whatsapp,
                                      title: "Chat",
                                      shadeColor: [
                                        Colors.green.shade800,
                                        Colors.green.shade700,
                                        Colors.green.shade600,
                                        Colors.green.shade400,
                                      ],
                                      callback: () => _launchWhatsapp(
                                          widget.pData.mobile.toString()),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 15,
                                ),
                                Text("Check In"),
                                Text(": "),
                                Text(
                                  "10-Oct-2024",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizerHelper.adaptiveSpToPx(12)),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 15,
                                ),
                                Text("Check Out"),
                                Text(": "),
                                Text(
                                  "10-Oct-2024",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizerHelper.adaptiveSpToPx(12)),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: AppBar(
                            bottom: TabBar(
                              controller: tabController,
                              tabs: [
                                Tab(
                                  text: "Info",
                                ),
                                Tab(
                                  text: "Payment Details",
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: TabBarView(
                                controller: tabController,
                                children: [
                              InfoScreen(infoData: widget.pData),
                              // second tab bar viiew widget
                              BlocProvider(
                                create: (context) =>
                                    PaymentDetailsCubit(Repository()),
                                child: PaymentHistoryScreen(
                                  personData: widget.pData,
                                  personId: widget.pData.id.toString(),
                                ),
                              )
                            ]))
                      ],
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     InkWell(
                  //       onTap: () async {
                  //         showDialog(
                  //             context: context,
                  //             builder: (context) => AlertDialog(
                  //                   title: Text("Are you sure for delete?"),
                  //                   actions: [
                  //                     TextButton(
                  //                         onPressed: () =>
                  //                             {Navigator.of(context).pop()},
                  //                         child: Text("Cancel")),
                  //                     TextButton(
                  //                         onPressed: () async {
                  //                           try {
                  //                             Repository repository =
                  //                                 Repository();
                  //                             await repository.deleteEmploye(
                  //                                 widget.pData.id.toString());
                  //                             Navigator.of(context)
                  //                                 .pushReplacement(
                  //                                     MaterialPageRoute(
                  //                                         builder: (context) =>
                  //                                             BlocProvider(
                  //                                               create: (context) =>
                  //                                                   HomeCubit(),
                  //                                               child:
                  //                                                   HomeScreen(),
                  //                                             )));
                  //                           } catch (e) {
                  //                             AppValidations.showToast(
                  //                                 e.toString());
                  //                           }
                  //                         },
                  //                         child: Text("Delete"))
                  //                   ],
                  //                 ));
                  //       },
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Icon(
                  //             Icons.delete_outline,
                  //             size: 25,
                  //           ),
                  //           Text("Delete")
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: SizerHelper.adaptiveToPxWidth(50),
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (_) => BlocProvider(
                  //                       create: (context) => FormScreenCubit(),
                  //                       child:
                  //                           FormScreen(editData: widget.pData),
                  //                     )));
                  //       },
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Icon(
                  //             Icons.edit_note_outlined,
                  //             size: 25,
                  //           ),
                  //           Text("Edit")
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DivideLine extends StatelessWidget {
  const DivideLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(),
    );
  }
}

class ContactTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> shadeColor;
  final VoidCallback callback;
  const ContactTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.shadeColor,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: shadeColor)),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}

class ItemListDetail extends StatefulWidget {
  const ItemListDetail({
    Key? key,
    required this.title,
    required this.val,
    this.docId,
  }) : super(key: key);

  final String title;
  final String val;
  final String? docId;

  @override
  State<ItemListDetail> createState() => _ItemListDetailState();
}

class _ItemListDetailState extends State<ItemListDetail> {
  bool satatusFlag = false;
  @override
  void initState() {
    if (widget.title == "Status:") {
      if (widget.val == "Active") {
        satatusFlag = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: SizerHelper.adaptiveSpToPx(12), color: Colors.grey),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.val,
              style: TextStyle(
                  fontSize: SizerHelper.adaptiveSpToPx(12),
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Spacer(),
        // title == "Mobile NO:"
        //     ? InkWell(
        //         onTap: (() => _callNumber(val)),
        //         child: Icon(
        //           Icons.call,
        //           color: Colors.green,
        //           size: SizerHelper.adaptiveSpToPx(20),
        //         ),
        //       )
        //     : const SizedBox(),
        widget.title == "Status:"
            ? Transform.scale(
                scale: 0.75,
                child: CupertinoSwitch(
                    activeColor: Colors.green,
                    thumbColor: Colors.white,
                    trackColor: Colors.black12,
                    value: satatusFlag,
                    onChanged: (value) async {
                      setState(() {
                        satatusFlag = value;
                      });

                      await Repository()
                          .persons
                          .doc(widget.docId)
                          .update({'status': value ? "True" : "False"});
                    }),
              )
            : SizedBox()
      ],
    );
  }
}

Widget imageDialog(context, url) {
  return Dialog(
    child: Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.transparent,
              child: CachedNetworkImage(

                  // width: MediaQuery.of(context).size.width - 100,
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child:
                          SizedBox(height: 50, width: 50, child: AppLoader())),
                  errorWidget: (context, url, error) {
                    print("ERROR IS" + error.toString());
                    return Container(
                      // "assets/images/fork spoon.svg",
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width - 100,
                    );
                  }),
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: InkWell(
              // style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onTap: () {
                downloadFile(url, context);
              },
              child: FloatingActionButton.small(
                  backgroundColor: Colors.green,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  onPressed: () => downloadFile(url, context))
              //  Column(
              //   children: [
              //     Container(color: Colors.white, child: Icon(Icons.download)),
              //   ],
              // ),
              ),
        ),
      ],
    ),
  );
}

Future<void> downloadFile(url, cntx) async {
  final tempDir = await getTemporaryDirectory();
  final path = '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}';
  var response = await Dio()
      .get(url.toString(), options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "${DateTime.now().microsecondsSinceEpoch}");
  AppValidations.showSnackBar(cntx, "Downlaod completed");
  print(result);
}
