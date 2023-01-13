import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
   bool _isSubmitting= false, _obscureText = true;
  late String _email, _password;

  Widget _showTitle() {
    return RichText(
        text: TextSpan(
        style: const TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold,color: Colors.white,
    ),
    children: <TextSpan>[
    const TextSpan(text: 'Sign'),
    TextSpan(text: 'In', style: TextStyle(fontSize: 72.0,fontWeight: FontWeight.bold,color: Colors.cyan[400])),
    ],
    ));
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _email = val!,
            validator: (val) => !val!.contains('@') ? 'Invalid Email' : null,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter a valid email',
                icon: Icon(Icons.mail, color: Colors.grey))));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _password = val!,
            validator: (val) => val!.length < 6 ? 'Password too short' : null,
            obscureText: _obscureText,
            decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                    child: Icon(_obscureText
                        ? Icons.visibility
                        : Icons.visibility_off)),
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter password, min length 6',
                icon: Icon(Icons.lock, color: Colors.grey))));
  }

  Widget _showFormActions() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation(Theme.of(context).accentColor)):
          ElevatedButton(
              child: Text('Submit',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan[400], // background
                onPrimary: Colors.black, // foreground
              ),
              onPressed: _submit),

          TextButton(
              child: const Text('New user? Register'),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, '/register'))
        ]));
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();
      _registerUser();
    }
  }


  void _registerUser() async {
    setState(() => _isSubmitting=true );
    http.Response  response = await http.post(Uri.parse('http://172.19.250.153:1337/auth/local'), body: {
      "identifier": _email,
      "password": _password,
    });
    final responseData = json.decode(response.body);
    if (response.statusCode ==200){
      setState(() => _isSubmitting=false );
      _storeUserData(responseData);
      Fluttertoast.showToast(
          msg:'User successfully logged_in!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0

      );
      _formKey.currentState!.reset();
      print(responseData);
      Future.delayed(Duration(seconds : 2),(){
        _redirectUser();

      });
    }
    else{
      setState(() => _isSubmitting=false);
      final List<dynamic> errorMsg = responseData['message'];
      Fluttertoast.showToast(
          msg:'Please check your email and password and try again!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0

      );
      throw Exception ('Error logging_in :$errorMsg');
    }
  }

  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map <String,dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user',json.encode(user));
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('SignIn')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          _showTitle(),
                          _showEmailInput(),
                          _showPasswordInput(),
                          _showFormActions()
                        ]))))));
  }
}
