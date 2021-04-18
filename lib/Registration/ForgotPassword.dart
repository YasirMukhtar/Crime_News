import 'package:crime_news/API.dart';
import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Component/Style/style.dart';
import 'package:crime_news/Registration/Signup.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  static ProgressDialog pr;
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  void initState() {
    ForgotPassword.pr = ProgressDialog(context);
    super.initState();
  }
  @override
  void setState(fn)async {
    // TODO: implement setState
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.setBool("isLoggedIn", true);
    super.setState(fn);
  }

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final ForgotButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10),
      color: AppColors.lightColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_formKey.currentState.validate()) {
            ForgotPassword.pr.show();
            API.ForgetPassword( context ,emailController.text );
          }

          // API.login(context, 'abc@gmail.com', '123456');
        },
        child: Text(
          "Forgot",
          textAlign: TextAlign.center,
          style: AppFonts.monm20,
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      AppColors.lighterColor,
                      AppColors.mainColor,
                    ],
                    stops: [
                      0.0,
                      1.0
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    tileMode: TileMode.repeated)),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'Assets/logo.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';

                          }
                          const pattern = "^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*";
                          final regExp = RegExp(pattern);

                          if (!regExp.hasMatch(value)) {
                            return 'Please enter correct email address';
                          }
                          return null;
                          // const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                          // final regExp = RegExp(pattern);
                          //
                          // if (!regExp.hasMatch(value)) {
                          //   return 'Enter Correct E-mail';
                          // }
                         // return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.email,
                            color: AppColors.lightgrey,
                          ),
                          filled: true,
                          border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              )),
                          fillColor: Colors.white70,
                          hintText: 'Email',
                          hintStyle: AppFonts.monm12bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

                    ForgotButon,
                    Center(
                      child: Container(
                        height: 20,
                        width: 200,
                        child: Row(
                          children: [
                            Container(
                              child: Text('Not have an account?'),
                            ),
                            InkWell(
                              onTap: () {

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => Signup()));
                              },
                              child: Container(
                                child: Text(
                                  ' Signup',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
