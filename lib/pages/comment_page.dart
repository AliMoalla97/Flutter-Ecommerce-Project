import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:g_p/models/app_state.dart';

class TestMe extends StatefulWidget {
  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<TestMe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Ali',
      'pic': 'https://picsum.photos/300/30',
      'message': 'انصح به'
    },
    {
      'name': 'Bashar',
      'pic': 'https://picsum.photos/300/30',
      'message': 'منتج جميل'
    },
    {
      'name': 'Derar',
      'pic': 'https://picsum.photos/300/30',
      'message': 'رائع'
    },
    {
      'name': 'Nizar',
      'pic': 'https://picsum.photos/300/30',
      'message': 'انصح بالمنتج'
    },
  ];

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data[i]['pic'] + "$i")),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
    builder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: CommentBox(
          userImage:
          "https://cdn3.iconfinder.com/data/icons/avatars-9/145/Avatar_Cat-512.png",
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  'name': state.user.username,
                  'pic':
                  'https://picsum.photos/300/30',
                  'message': commentController.text
                };
                filedata.insert(0, value);
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
    );
  }

}
