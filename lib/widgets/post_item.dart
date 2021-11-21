import 'package:flutter/material.dart';
import 'package:testovoye/models/post_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/pages/comments_page.dart';

Widget postItem(BuildContext context, PostModel item, UserModel user) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 12,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Comments(
                post: item,
                user: user,
              ),
            ),
          );
        },
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(user.username, style: TextStyle(fontWeight: FontWeight.w700),),
                  Text(' '+user.email, style: TextStyle(color: Colors.blue),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(item.title),
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(item.body),
        ),
      ),
    ),
  );
}