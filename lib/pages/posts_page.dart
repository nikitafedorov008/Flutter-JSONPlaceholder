import 'package:flutter/material.dart';
import 'package:testovoye/models/post_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/api/fetch_data.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';
import 'package:testovoye/widgets/post_item.dart';
import 'comments_page.dart';

class Posts extends StatefulWidget {
  final UserModel user;

  const Posts({Key? key, required this.user}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s posts"),
        elevation: 24,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchPosts(widget.user,),
          builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var item in snapshot.requireData)
                    postItem(context, item, widget.user),
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
    );
  }
}
