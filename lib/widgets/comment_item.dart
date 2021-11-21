import 'package:flutter/material.dart';
import 'package:testovoye/models/comment_model.dart';

Widget commentItem(CommentModel item) {
  return Column(
    children: [
      ListTile(
        onTap: () {},
        leading: CircleAvatar(
          child: Text(item.name.substring(0, 2)),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name),
            Text(item.email, style: TextStyle(color: Colors.blue),),
          ],
        ),
        subtitle: Text(item.body),
      ),
      Divider(
        color: Colors.grey,
      ),
    ],
  );
}