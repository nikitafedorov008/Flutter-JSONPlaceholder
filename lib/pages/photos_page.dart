import 'package:flutter/material.dart';
import 'package:testovoye/models/album_model.dart';
import 'package:testovoye/models/photo_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/widgets/image_viewer.dart';
import 'package:testovoye/api/fetch_data.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';

class Photos extends StatefulWidget {
  final UserModel user;
  final AlbumModel album;

  const Photos({Key? key, required this.user, required this.album}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username + "'s photos"),
        elevation: 24,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchPhotos(widget.album),
          builder: (BuildContext context, AsyncSnapshot<List<PhotoModel>> snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 3,
                children: <Widget>[
                  for (var item in snapshot.requireData)
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            elevation: 24,
                            title: Text(item.title),
                            content: Image.network(
                              item.url,
                              height: 300,
                              width: 300,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        );
                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewer(
                              photo: item,
                            ),
                          ),
                        );
                        */
                      },
                      child: Container(
                        color: Theme.of(context).accentColor.withAlpha(10),
                        child: Image.network(
                          item.thumbnailUrl,
                        ),
                      ),
                    ),
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
