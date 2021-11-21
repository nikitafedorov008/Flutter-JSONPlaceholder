import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testovoye/models/album_model.dart';
import 'package:testovoye/models/photo_model.dart';
import 'package:testovoye/models/post_model.dart';
import 'package:testovoye/models/todo_model.dart';
import 'package:testovoye/models/user_model.dart';
import 'package:testovoye/pages/todos_page.dart';
import 'package:testovoye/api/fetch_data.dart';
import 'package:testovoye/utils/data_storage.dart';
import 'package:testovoye/utils/launch_url.dart';
import 'package:testovoye/widgets/album_item.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';
import 'package:testovoye/widgets/post_item.dart';
import 'package:testovoye/widgets/todo_item.dart';
import 'albums_page.dart';
import 'posts_page.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  final UserModel user;

  const UserPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  int _section = 0;

  postDataStorage() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?userId='
        + widget.user.id.toString()));
    String postDatabase;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200) {
      postDatabase = response.body;
      prefs.setString('posts: ${widget.user.id}', postDatabase);
    } else {
      prefs.getString('posts: ${widget.user.id}');
    }
    setState(() {});
    return prefs;
  }

  Future<List<PostModel>> fetchPosts() async {
    postDataStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return List<PostModel>.from(
      json.decode(prefs.getString('posts: ${widget.user.id}').toString()).map((x) => PostModel.fromJson(x)),
    );
  }

  albumDataStorage() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?userId='
        + widget.user.id.toString()));
    String albumDatabase;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200) {
      albumDatabase = response.body;
      prefs.setString('albums: ${widget.user.id}', albumDatabase);
    } else {
      prefs.getString('albums: ${widget.user.id}');
    }
    setState(() {});
    return prefs;
  }

  Future<List<AlbumModel>> fetchAlbums() async {
    albumDataStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return List<AlbumModel>.from(
      json.decode(prefs.getString('albums: ${widget.user.id}').toString()).map((x) => AlbumModel.fromJson(x)),
    );
  }

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
    setState(() {});
    return prefs;
  }

  Future<List<PhotoModel>> fetchPhotos(AlbumModel album) async {
    photoDataStorage(album);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return List<PhotoModel>.from(
      json.decode(prefs.getString('photos: ${album.userId + album.id}').toString()).map((x) => PhotoModel.fromJson(x)),
    );
  }

  todoDataStorage() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos?userId='
        + widget.user.id.toString()));
    String todoDatabase;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(response.statusCode == 200) {
      todoDatabase = response.body;
      prefs.setString('todos: ${widget.user.id}', todoDatabase);
    } else {
      prefs.getString('todos: ${widget.user.id}');
    }
    setState(() {});
    return prefs;
  }

  Future<List<TodoModel>> fetchTodos() async {
    todoDataStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return List<TodoModel>.from(
      json.decode(prefs.getString('todos: ${widget.user.id}').toString()).map((x) => TodoModel.fromJson(x)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.username,
          style: GoogleFonts.lato(),
        ),
        elevation: 24,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      child: Text(
                        widget.user.username.substring(0, 2),
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w300,
                          fontSize: 34,
                        ),
                      ),
                      radius: 50,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            widget.user.name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Icon(Icons.email_outlined, size: 16),
                              SizedBox(width: 2,),
                              Text(widget.user.email, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone_outlined, size: 16),
                              SizedBox(width: 2,),
                              Text(widget.user.phone, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Icon(Icons.web, size: 16),
                              SizedBox(width: 2,),
                              Text(widget.user.website, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Icon(Icons.map_outlined, size: 16),
                              SizedBox(width: 2,),
                              Text(widget.user.address.street + ' ' + widget.user.address.city,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: const [
                        Icon(Icons.email_outlined),
                        Text('Email'),
                      ],
                    ),
                    onPressed: () {
                      launchURL('mailto:${widget.user.email}'
                        '?subject=Shelf app - ${widget.user.name}'
                        '&body=<body>, e.g. mailto:smith@example.org'
                        '?subject=News&body=Hi%20there,%20its%20shelf%20app%20user');
                      },
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone_outlined),
                        Text('Call'),
                      ],
                    ),
                    onPressed: () { launchURL('tel:${widget.user.phone}'); },
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.web),
                        Text('Go WEB'),
                      ],
                    ),
                    onPressed: () { launchURL('https://${widget.user.website}'); },
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.map_outlined),
                        Text('Route'),
                      ],
                    ),
                    onPressed: () { MapsLauncher.launchQuery(
                        widget.user.address.street + ' ' + widget.user.address.city
                    ); },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.domain),
                          SizedBox(width: 2,),
                          Text('company: ${widget.user.company.name}', overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.apartment_outlined),
                          SizedBox(width: 2,),
                          Text('bs: ${widget.user.company.bs}', overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_fix_high),
                          SizedBox(width: 2,),
                          Flexible(
                            child: Text(
                              'catchPharse: ${widget.user.company.catchPhrase}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).backgroundColor,
                  elevation: 12,
                  shadowColor: _section == 0 ? Colors.blue : Colors.grey,
                  shape: CircleBorder(),
                ),
                child: Icon(Icons.feed,
                color: _section == 0 ? Colors.blue : Colors.grey,),
                onPressed: () {setState(() {
                  _section = 0;
                });},
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: _section == 1 ? Colors.blue : Colors.grey,
                  primary: Theme.of(context).backgroundColor,
                  elevation: 12,
                  shape: CircleBorder(),
                ),
                child: Icon(Icons.photo_album,
                color: _section == 1 ? Colors.blue : Colors.grey,),
                //tooltip: 'Albums',
                onPressed: () {setState(() {
                  _section = 1;
                });},
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: _section == 2 ? Colors.blue : Colors.grey,
                  primary: Theme.of(context).backgroundColor,
                  elevation: 12,
                  shape: CircleBorder(),
                ),
                child: Icon(Icons.add_task,
                  color: _section == 2 ? Colors.blue : Colors.grey,),
                onPressed: () {setState(() {
                  _section = 2;
                });},
              ),
            ],
          ),
          buildList(_section),
        ],
      ),
    );
  }

  buildList(int section) {
    if(section == 0) {
      setState(() {});
      return Expanded(child: postsList());
      //return Expanded(child: Posts(user: widget.user,));
    } else if(section == 1) {
      setState(() {});
      return Expanded(child: albumList());
      //return Expanded(child: Albums(user: widget.user,));
    } else {
      setState(() {});
      return Expanded(child: todoList());
      //return Expanded(child: Todos(user: widget.user,));
    }
  }

  Widget postsList() {
    setState(() {

    });
    return Container(
      child: FutureBuilder(
        future: fetchPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                postItem(context, snapshot.requireData[0], widget.user),
                postItem(context, snapshot.requireData[1], widget.user),
                postItem(context, snapshot.requireData[2], widget.user),
                postItem(context, snapshot.requireData[4], widget.user),
                TextButton(child: Text('Load more'), onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Posts(
                        user: widget.user,
                      ),
                    ),
                  );
                },),
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
    );
  }

  Widget albumList () {
    return Container(
      child: FutureBuilder(
        future: fetchAlbums(),
        builder: (BuildContext context, AsyncSnapshot<List<AlbumModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                albumItem(context, widget.user, snapshot.requireData[0]),
                albumItem(context, widget.user, snapshot.requireData[1]),
                albumItem(context, widget.user, snapshot.requireData[2]),
                albumItem(context, widget.user, snapshot.requireData[4]),
                TextButton(child: Text('Load more'), onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Albums(
                        user: widget.user,
                      ),
                    ),
                  );
                },),
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
    );
  }

  Widget todoList() {
    return Container(
      child: FutureBuilder(
        future: fetchTodos(),
        builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                todoItem(snapshot.requireData[0].completed, snapshot.requireData[0].title),
                todoItem(snapshot.requireData[1].completed, snapshot.requireData[1].title),
                todoItem(snapshot.requireData[2].completed, snapshot.requireData[2].title),
                todoItem(snapshot.requireData[3].completed, snapshot.requireData[3].title),
                TextButton(child: Text('Load more'), onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Todos(
                        user: widget.user,
                      ),
                    ),
                  );
                },),
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
    );
  }

}
