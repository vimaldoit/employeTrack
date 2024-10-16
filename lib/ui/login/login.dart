import 'package:employeetracker/ui/home/home.dart';
import 'package:employeetracker/ui/home/home_cubit.dart';
import 'package:employeetracker/ui/login/login_cubit.dart';
import 'package:employeetracker/utils/colors.dart';
import 'package:employeetracker/utils/input_validations.dart';
import 'package:employeetracker/utils/sizer_helper.dart';
import 'package:employeetracker/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  bool _passwordVisible = true;

  Color pwdcolor = AppColors.accentColor;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              AppValidations.showToast(state.error);
            }
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => BlocProvider(
                            create: (context) => HomeCubit(),
                            child: HomeScreen(),
                          ))));
            }
          },
          builder: (context, state) {
            return Center(
              child: Form(
                  key: _loginFormKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: AppStyles.inputBoxStyleEmail,
                          width: 80.w,
                          child: TextFormField(
                            onTap: () {
                              setState(() {});
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                            enabled: true,
                            controller: _emailController,
                            style: // AppStyles.inputTextStyle,
                                TextStyle(
                              fontSize: SizerHelper.adaptiveSpToPx(16),
                              color: AppColors.accentColor,
                            ),
                            validator: AppValidations.validateEmailInput,
                            decoration: AppStyles.getInputDecorationStyle(
                                    hint: "Enter your email id",
                                    icon: Icons.email_outlined)
                                .copyWith(
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                size: 25,
                                color: _emailController.text.isNotEmpty
                                    ? AppColors.accentColor
                                    : AppColors.accentColor,
                              ),
                              errorStyle: TextStyle(color: Colors.white),
                              hintStyle:
                                  const TextStyle(color: AppColors.accentColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.accentColor, width: 1.0),
                            borderRadius: BorderRadius.circular(4.0),
                            color: AppColors.textColor,
                          ),
                          width: 80.w,
                          child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  pwdcolor = AppColors.accentColor;
                                });
                              },
                              onTap: () {
                                setState(() {});
                              },
                              obscureText: _passwordVisible,
                              controller: _passwordController,
                              style: // AppStyles.inputTextStyle,
                                  TextStyle(
                                fontSize: SizerHelper.adaptiveSpToPx(16),
                                color: pwdcolor,
                              ),
                              validator: AppValidations.validatePasswordInput,
                              decoration: InputDecoration(
                                  hintText: "Enter password",
                                  prefixIcon: Icon(Icons.lock,
                                      size: 25,
                                      color: _passwordController.text.isNotEmpty
                                          ? pwdcolor
                                          : pwdcolor),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: _passwordController.text.isNotEmpty
                                          ? pwdcolor
                                          : pwdcolor,
                                    ),
                                  ),
                                  errorStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: pwdcolor),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none)),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              if (_loginFormKey.currentState!.validate()) {
                                BlocProvider.of<LoginCubit>(context).login(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim());
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.accentColor, width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: AppColors.backgroundColor),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: SizerHelper.adaptiveSpToPx(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }
}
