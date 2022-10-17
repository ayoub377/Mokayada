import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mokayada/features/listing/home.page.dart';
import '../../../service/FirebaseService.dart';
import '../../widgets/BottomNavBar.dart';


// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  String name='';
  String email='';
  String password='';
  bool _showSpinner = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;
  String _emailText = 'Please use a valid email';
  String _passwordText = 'Please use a strong password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage("assets/images/AjiTeBADL0(1).png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          color: Colors.blueAccent,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 60.0, bottom: 20.0, left: 20.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            name = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Full Name',
                            labelText: 'Full Name',
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: _wrongEmail ? _emailText : null,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText: _wrongPassword ? _passwordText : null,
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                    ElevatedButton(
                      // padding: EdgeInsets.symmetric(vertical: 10.0),
                      // color: Color(0xff447def),
                      onPressed:(){
                        _firebaseService.handleSignUp(email, password, name).then((value){
                          if(value){
                            Navigator.pushNamed(context, '/done');
                          }
                          else{
                            setState(() {
                              _showSpinner = false;
                            });
                          }
                        });
                        },
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            // padding: EdgeInsets.symmetric(vertical: 5.0),
                            // color: Colors.white,
                            // shape: ContinuousRectangleBorder(
                            //   side:
                            //   BorderSide(width: 0.5, color: Colors.grey),
                            // ),
                            onPressed: () {
                              _firebaseService.Google_handle_signIn();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/google.png',
                                    fit: BoxFit.contain,
                                    width: 20.0,
                                    height: 20.0),
                                Text(
                                  'Google',
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        GestureDetector(
                          onTap: () {
                               Navigator.pushNamed(context, "/login");
                          },
                          child: Text(
                            ' Sign In',
                            style: TextStyle(fontSize: 15.0, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
