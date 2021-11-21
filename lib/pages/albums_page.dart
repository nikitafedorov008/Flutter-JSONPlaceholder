import 'package:flutter/material.dart';
import 'package:testovoye/models/album_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/api/fetch_data.dart';
import 'package:testovoye/widgets/album_item.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';

class Albums extends StatefulWidget {
  final UserModel user;

  const Albums({Key? key, required this.user}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s albums"),
        elevation: 24,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchAlbums(widget.user,),
          builder: (BuildContext context, AsyncSnapshot<List<AlbumModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  for (var item in snapshot.requireData)
                    albumItem(context, widget.user, item,),
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
