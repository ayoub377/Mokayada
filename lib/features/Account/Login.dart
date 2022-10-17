import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../service/FirebaseService.dart';
import '../../widgets/BottomNavBar.dart';
import 'Forgot.dart';
import 'package:get_it/get_it.dart';

bool _wrongEmail = false;
bool _wrongPassword = false;


// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  String email='';
  String password='';

  bool _showSpinner = false;


  String emailText = 'Email doesn\'t match';
  String passwordText = 'Password doesn\'t match';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                    top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            errorText: _wrongEmail ? emailText : null,
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
                            hintText: 'Password',
                            labelText: 'Password',
                            errorText: _wrongPassword ? passwordText : null,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style:
                              TextStyle(fontSize: 20.0, color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF00B0FF)),
                      ),
                      onPressed:(){
                        _firebaseService.SignIn(email, password).then((value) {
                          if (value) {
                            Navigator.pushNamed(context, '/');
                          } else {
                            setState(() {
                              _wrongEmail = true;
                            });
                          }
                        });
                        },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            ' Sign Up',
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
