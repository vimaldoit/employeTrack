import 'package:employeetracker/data/repository/repository.dart';
import 'package:employeetracker/ui/home/home.dart';
import 'package:employeetracker/ui/home/home_cubit.dart';
import 'package:employeetracker/ui/login/login.dart';
import 'package:employeetracker/ui/login/login_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.green,
          ),
          home: (Repository().authInstance.currentUser != null)
              ? BlocProvider(
                  create: (context) => HomeCubit(),
                  child: HomeScreen(),
                )
              : BlocProvider(
                  create: (context) => LoginCubit(Repository()),
                  child: LoginScreen(),
                ));
    });
  }
}
