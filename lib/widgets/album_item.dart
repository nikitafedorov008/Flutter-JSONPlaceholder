import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testovoye/models/album_model.dart';
import 'package:testovoye/models/photo_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/pages/photos_page.dart';
import 'package:http/http.dart' as http;
import 'package:testovoye/utils/data_storage.dart';

Widget albumItem (BuildContext context, UserModel user, AlbumModel item) {

  photoDataStorage(AlbumModel album) async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos?albumId='
        + album.id.toString()));
    String postDatabase;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200) {
      postDatabase = response.body;
      prefs.setString('photos: ${album.userId + album.id}', postDatabase);
    } else {
      prefs.getString('photos: ${album.userId + album.id}');
    }
    //setState(() {});
    return prefs;
  }

  Future<List<PhotoModel>> fetchPhotos(AlbumModel album) async {
    photoDataStorage(album);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return List<PhotoModel>.from(
      json.decode(prefs.getString('photos: ${album.userId + album.id}').toString()).map((x) => PhotoModel.fromJson(x)),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
    child: Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Photos(
                user: user,
                album: item,
              ),
            ),
          );
        },
        title: Text('Album: ' + item.title, style: TextStyle(fontSize: 18),),
        subtitle: FutureBuilder(
          future: fetchPhotos(item),
          builder: (BuildContext context, AsyncSnapshot<List<PhotoModel>> snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(
                      snapshot.requireData[0].url,
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width / 4.84,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(
                      snapshot.requireData[1].thumbnailUrl,
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width / 4.84,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(
                      snapshot.requireData[2].thumbnailUrl,
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width / 4.84,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(
                      snapshot.requireData[3].thumbnailUrl,
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width / 4.84,
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
    ),
  );
}