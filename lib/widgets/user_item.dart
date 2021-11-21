import 'package:flutter/material.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/pages/user_page.dart';

Widget userItem(BuildContext context, UserModel item) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
    child: Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0),),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(
                user: item,
              ),
            ),
          );
        },
        leading: CircleAvatar(
          child: Text(item.username.substring(0, 2)),
        ),
        // trailing: Container(
        //     child: OutlineButton(
        //   child: Text('Albums'),
        //   onPressed: () {},
        // )),
        title: Row(
          children: [
            Text(item.name),
            Flexible(child: Text(" aka '${item.username}'", style: TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis,)),
          ],
        ),
        subtitle: Text(item.email),
      ),
    ),
  );
}