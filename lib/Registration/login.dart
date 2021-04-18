
import 'package:crime_news/Registration/ForgotPassword.dart';
import 'package:crime_news/Registration/Signup.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crime_news/API.dart';
import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Component/Style/style.dart';

class Login extends StatefulWidget {
   static ProgressDialog pr;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool obs = true;
  // ProgressDialog pr;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  void initState() {
    Login.pr = ProgressDialog(context);
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
  final passwordController = TextEditingController();





  @override
  Widget build(BuildContext context) {
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10),
      color: AppColors.lightColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            Login.pr.show();
            API.login(context, emailController.text, passwordController.text);
          }

          // API.login(context, 'abc@gmail.com', '123456');
        },
        child: Text(
          "Login",
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
                      height: 60,
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

                        },
                        decoration: InputDecoration(
                          errorMaxLines: 2,
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
                    SizedBox(height: 20.0),
                    Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        obscureText: obs,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              obs== true? Icons.remove_red_eye : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                obs = !obs;
                              });
                            },
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
                          hintText: 'Password',
                          hintStyle: AppFonts.monm12bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  ForgotPassword()),);

                          },
                            child: Text(
                          'Forget Password',
                          style: AppFonts.monmwhit12,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 5,
                    ),
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
                                    color: AppColors.lightColor,
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
