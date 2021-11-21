import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testovoye/models/comment_model.dart';
import 'package:testovoye/models/post_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/api/fetch_data.dart';
import 'package:testovoye/widgets/comment_item.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';
import 'package:http/http.dart' as http;

class Comments extends StatefulWidget {
  final PostModel post;
  final UserModel user;

  const Comments({Key? key, required this.post, required this.user}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  dataStorage() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments?postId='
        + widget.post.id.toString()));
    String postDatabase;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200) {
      postDatabase = response.body;
      prefs.setString('comments: ${widget.post.userId + widget.post.id}', postDatabase);
    } else {
      prefs.getString('comments: ${widget.post.userId + widget.post.id}');
    }
    setState(() {});
    return prefs;
  }

  Future<List<CommentModel>> fetchComments() async {
    dataStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return List<CommentModel>.from(
      json.decode(prefs.getString('comments: ${widget.post.userId + widget.post.id}').toString()).map((x) => CommentModel.fromJson(x)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title + "'s comments"),
        elevation: 24,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
              elevation: 12,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(widget.user.name.substring(0, 2)),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user.name),
                    Text(widget.user.email, style: TextStyle(color: Colors.blue),),
                  ],
                ),
                subtitle: Text(widget.post.body),
              ),
            ),
          ),
          Text('comments:'),
          Expanded(
            child: Container(
              child: FutureBuilder(
                future: fetchComments(),
                builder: (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: [
                        for (var item in snapshot.requireData)
                          commentItem(item),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.comment_outlined),
        label: Text('Comment'),
        onPressed: ()=> commentBottomSheet(),
      ),
    );
  }

  commentBottomSheet() {

    String _name;
    String _email;
    String _body;

    final _formKey = GlobalKey<FormState>();

    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _bodyController = TextEditingController();

    _submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        addComment(
          context,
          widget.post,
          _nameController.text,
          _emailController.text,
          _bodyController.text,
        );
      }
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: Icon(Icons.comment_outlined),
                  title: Text('Add comment'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8.0,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              borderSide: new BorderSide(color: Colors.greenAccent),
                            ),
                            labelText: 'Name',
                            hintStyle: TextStyle(fontFamily: 'ProductSans'),),
                          validator: (input) => input!.length < 6
                              ? 'Must be at least 6 characters'
                              : null,
                          onSaved: (input) => _name = input!,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8.0,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              borderSide: new BorderSide(color: Colors.greenAccent),
                            ),
                            labelText: 'Email',
                            hintStyle: TextStyle(fontFamily: 'ProductSans'),),
                          validator: (input) => !input!.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (input) => _email = input!,
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8.0,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              borderSide: new BorderSide(color: Colors.greenAccent),
                            ),
                            labelText: 'Comment',
                            hintStyle: TextStyle(fontFamily: 'ProductSans'),),
                          validator: (input) => input!.length < 6
                              ? 'Must be at least 6 characters'
                              : null,
                          onSaved: (input) => _body = input!,
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Container(
                        width: 250.0,
                        child: MaterialButton(
                          onPressed: _submit,
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(28.0)),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Send Comment',
                            style: TextStyle(
                              fontFamily: 'ProductSans',
                              //color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
