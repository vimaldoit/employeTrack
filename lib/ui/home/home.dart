import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:employeetracker/data/model/personModel.dart';
import 'package:employeetracker/data/repository/repository.dart';
import 'package:employeetracker/main.dart';
import 'package:employeetracker/ui/common%20widgets/apploader.dart';
import 'package:employeetracker/ui/formScreen/formScreen.dart';
import 'package:employeetracker/ui/formScreen/form_screen_cubit.dart';

import 'package:employeetracker/ui/home/home_cubit.dart';
import 'package:employeetracker/ui/home/testpdf.dart';
import 'package:employeetracker/ui/home/view_employee.dart';
import 'package:employeetracker/utils/colors.dart';

import 'package:employeetracker/utils/commonFunction.dart';
import 'package:employeetracker/utils/sizer_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Future<void> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        content: new Text(
          'Do you want to exit App',
          style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: SizerHelper.adaptiveSpToPx(15),
              fontFamily: 'robotobold'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: SizerHelper.adaptiveSpToPx(15)),
            ),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: new Text(
              'Yes',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: SizerHelper.adaptiveSpToPx(15)),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          return _onWillPop();
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Employee List",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              bottom: TabBar(
                indicatorColor: Colors.green,
                tabs: [
                  TabbarItem(
                    title: "Active",
                    iconColor: Colors.green,
                  ),
                  TabbarItem(
                    title: "Inactive",
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ListViewItem(status: true),
                ListViewItem(
                  status: false,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                    create: (context) => FormScreenCubit(),
                                    child: FormScreen(editData: PersonModel()),
                                  )))
                    })),
      ),
    );
  }
}

class TabbarItem extends StatefulWidget {
  final String title;
  final Color iconColor;
  const TabbarItem({
    Key? key,
    required this.title,
    required this.iconColor,
  }) : super(key: key);

  @override
  State<TabbarItem> createState() => _TabbarItemState();
}

class _TabbarItemState extends State<TabbarItem> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Icon(
              Icons.circle,
              color: widget.iconColor,
              size: 14,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.title,
            style: TextStyle(
                fontSize: SizerHelper.adaptiveSpToPx(14), color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class ListViewItem extends StatefulWidget {
  final bool status;
  const ListViewItem({super.key, required this.status});

  @override
  State<ListViewItem> createState() => _ListViewItemState();
}

class _ListViewItemState extends State<ListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is Datafalilure) {
            final error = state.error;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error),
              duration: Duration(milliseconds: 300),
            ));
          }
        },
        builder: (context, state) {
          if (state is DataLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is DataSuccess) {
            var ListData = state.personData;
            var empData = [];
            if (widget.status) {
              empData = ListData.where((dta) => dta.status == "True").toList();
            } else {
              empData = ListData.where((dta) => dta.status == "False").toList();
            }
            return empData.length > 0
                ? Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: empData.length,
                              itemBuilder: ((context, index) {
                                final data = empData[index];
                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                EmployeeDetails(pData: data)))),
                                    leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          child: CachedNetworkImage(
                                            imageUrl: "${data.imgeUrl}",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                AppLoader(),
                                          ),
                                        )),
                                    title: Text(
                                      data.name.toString(),
                                      style: TextStyle(
                                          fontSize:
                                              SizerHelper.adaptiveSpToPx(14),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      data.place,
                                      style: TextStyle(
                                        fontSize:
                                            SizerHelper.adaptiveSpToPx(11),
                                      ),
                                    ),
                                    trailing: InkWell(
                                      onTap: () => callNumber(data.mobile),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })))
                    ],
                  )
                : Center(child: Text("No data"));
          }
          return Container(
            child: Center(child: Text("No data")),
          );
        },
      ),
    );
  }
}
