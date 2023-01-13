import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:g_p/models/app_state.dart';
import 'package:http/http.dart' as http;
 String ? _name,_address,_phone,_email;
final _formKey = GlobalKey<FormState>();
class SettingsUI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ProfilePage",
      home: EditProfilePage(),
        theme: ThemeData(  brightness: Brightness.dark),
    );

  }
}

class EditProfilePage extends StatefulWidget {
  @override

  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Container(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(

                  children: [

                    Text(
                      "Edit Profile",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme
                                        .of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Cat-512.png",
                                    ))),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme
                                        .of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: Colors.blueGrey,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                    buildTextnameField(state.user.username),
                    buildTextemailField(state.user.email),
                    buildTextaddressField(state.user.address),
                    buildTextphoneField(state.user.phone)])),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () => Navigator.pushNamed(context, '/'),
                          child: Text("CANCEL",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white)),
                        ),
                        RaisedButton(

                          onPressed: () async {
                            final form = _formKey.currentState;
                            form!.save();
                            if(_name==null){
                              _name=state.user.username;
                                }
                            if(_email==null){
                              _email=state.user.email;
                            }
                            if(_address==null){
                              _address=state.user.address;
                            }
                            if(_phone==null){
                              _phone=state.user.phone;
                            }
                            http.Response response = await http.put(Uri.parse('http://172.19.250.153:1337/users/${state.user.id}'), body: {
                              "username": _name,
                              "email": _email,
                              "address" : _address,
                              "phone": _phone,

                            },headers: {
                            'Authorization': 'Bearer ${state.user.jwt}'
                            });
                            },
                          color: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )

                      ],
                    )
                  ],
                ),
              ),

            ),
          );
        });




  }

  Widget buildTextnameField( String nameplaceholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        onSaved: (val) => _name = val!,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: "User Name",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: nameplaceholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }
  Widget buildTextemailField( String Emailplaceholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        onSaved: (val) => _email = val!,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: "Email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: Emailplaceholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }

  Widget buildTextaddressField( String addressplaceholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        onSaved: (val) => _address = val!,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: "Address",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: addressplaceholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }
  Widget buildTextphoneField( String phoneplaceholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        onSaved: (val) => _phone = val!,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: "Phone",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: phoneplaceholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
      ),
    );
  }


}