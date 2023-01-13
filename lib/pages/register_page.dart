import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _issubmitting = false;
  late String _username, _email, _password,_phone,_address;

  Widget _showTitle() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 72.0, fontWeight: FontWeight.bold,color: Colors.white,
        ),
        children: <TextSpan>[
          const TextSpan(text: 'Sign'),
          TextSpan(text: 'Up', style: TextStyle(fontSize: 72.0,fontWeight: FontWeight.bold,color: Colors.cyan[400])),
        ],
      ),
    );
  }

  Widget _showUsernameInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _username = val!,
            validator: (val) => val!.length < 6 ? 'Username too short' : null,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
                hintText: 'Enter username, min length 6',
                icon: Icon(Icons.face, color: Colors.grey))));
  }

  Widget _showAddressInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TextFormField(
            onSaved: (val) => _address = val!,
            validator:(val) => !val!.contains('-') ? 'Invalid Address' : null,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
                hintText: 'Ex: Nablus-Baita',
                icon: Icon(Icons.add_location_alt_outlined, color: Colors.grey))));
  }

  Widget _showPhoneInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
     child: TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (val) => _phone = val!,
        validator: (val) => val!.length < 10 ? 'Phone Number is too short' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        icon: Icon(Icons.phone, color: Colors.grey)
      ),
    ));
  }


  Widget _showEmailInput() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
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
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(children: [_issubmitting == true
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
              child: const Text('Existing user? Login'),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'))
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
    setState(() => _issubmitting =true );
    http.Response  response = await http.post(Uri.parse('http://172.19.250.153:1337/auth/local/register'), body: {
      "username": _username,
      "email": _email,
      "password": _password,
      "phone":_phone,
      "address":_address,
    });
    final responseData = json.decode(response.body);
    print (response.statusCode);
    if (response.statusCode ==200){
      setState(() => _issubmitting=false );
      _storeUserData(responseData);
      Fluttertoast.showToast(
          msg:'User $_username successfully created!',
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
      setState(() => _issubmitting=false);
     final List<dynamic> errorMsg = responseData['message'];
      Fluttertoast.showToast(
          msg:'Please Check your email address and try again!',
          toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
         backgroundColor: Colors.red,
          textColor: Colors.white,
        fontSize: 16.0

     );
      throw Exception ('Error signing up :$errorMsg');
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
        appBar: AppBar(title: const Text('SignUp')),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          _showTitle(),
                          _showUsernameInput(),
                          _showEmailInput(),
                          _showPasswordInput(),
                          _showPhoneInput(),
                          _showAddressInput(),
                          _showFormActions()
                        ]))))));
  }
}
