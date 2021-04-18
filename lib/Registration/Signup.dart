import 'package:crime_news/API.dart';
import 'package:crime_news/Component/Color/color.dart';
import 'package:crime_news/Component/Style/style.dart';
import 'package:crime_news/Registration/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:location_permissions/location_permissions.dart';

class Signup extends StatefulWidget {
  static ProgressDialog pr;

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool obs = true;
  bool hide = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final nameController = TextEditingController();
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  void initState() {
    super.initState();
    Signup.pr = ProgressDialog(context);
    _listenForPermissionStatus();
     _getCurrentLocation();

  }
  void _listenForPermissionStatus() {
    final Future<PermissionStatus> statusFuture =
    LocationPermissions().checkPermissionStatus();

    statusFuture.then((PermissionStatus status) {
      setState(() {
        _permissionStatus = status;
      });
    });
  }
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      //_getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);
  //
  //     Placemark place = p[0];
  //
  //     setState(() {
  //       _currentAddress =
  //       "${place.locality}, ${place.postalCode}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final SignupButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10),
      color: AppColors.lightColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if(passwordController.text != confirmpasswordController.text){
              print("confirm password does not match");
              return  Fluttertoast.showToast(
                  msg: 'confirm password does not match!', toastLength: Toast.LENGTH_LONG);;
            }
            else if(_currentPosition == null){
              print("Give Location Permission");
              return  Fluttertoast.showToast(
                  msg: 'Give Your Location Permission', toastLength: Toast.LENGTH_LONG);;
            }
            else{
              Signup.pr.show() ;
              API.SignupUser(
                context,
                nameController.text,
                emailController.text,
                passwordController.text,
                _currentPosition.latitude,
                _currentPosition.longitude,
              );
            }

          }
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: AppFonts.monm20,
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
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
            padding: const EdgeInsets.only(left:36.0, right: 36 , ),
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
                  SizedBox(height: 30.0),
                  Container(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
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
                        hintText: 'Name',
                        hintStyle: AppFonts.monm12bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 350,
                    height: 60,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter correct email address';
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
                  SizedBox(height: 5.0),
                  Container(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obs,
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
                  SizedBox(height: 5.0),
                  Container(
                    width: 350,
                    height: 50,
                    child: TextFormField(
                      controller: confirmpasswordController,
                      obscureText: hide,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            hide== true? Icons.remove_red_eye : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              hide = !hide;
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
                        hintText: 'Confirm Password',
                        hintStyle: AppFonts.monm12bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  if (_currentPosition != null &&
                      _currentAddress != null)
                    Text(_currentAddress,
                        style:TextStyle(color: Colors.black)),
                  SizedBox(
                    height: 15.0,
                  ),
                  SignupButon,
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Container(
                      height: 20,
                      width: 210,
                      child: Row(
                        children: [
                          Container(
                            child: Text('Already have an account?'),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => Login()));
                            },
                            child: Container(
                              child: Text(
                                ' Signin',
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
    );
  }
}
