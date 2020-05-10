import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String _error;

  Widget showAlert(){
    if(_error!=null){
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ),
      );
    }
    else {
      return SizedBox(height: 0,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email=value;
                },
                decoration: kHintTextDecoration.copyWith(hintText:'Enter your email.')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password=value;
                },
                decoration: kHintTextDecoration.copyWith(hintText:'Enter your password.')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.blueAccent,
                title:'Register',
                onPressed: ()async{
                  setState(() {
                    showSpinner=true;
                  });
                  try{
                  final newUser = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
                  if(newUser != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    showSpinner=false;
                  });
                }
                  catch(e){
                    setState(() {
                      _error=e.message;
                      showSpinner=false;
                    });
                    print(_error);
                  }
                },
              ),
              showAlert(),
            ],
          ),
        ),
      ),
    );
  }
}
