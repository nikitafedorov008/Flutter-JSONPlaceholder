import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testovoye/models/comment_model.dart';
import 'package:testovoye/models/post_model.dart';
import 'package:testovoye/models/album_model.dart';
import 'package:testovoye/models/photo_model.dart';
import 'package:testovoye/models/todo_model.dart';
import 'package:http/http.dart' as http;
import 'package:testovoye/models/user_model.dart';
import '../utils/data_storage.dart';
import 'dart:convert';

Future<List<UserModel>> fetchUsers() async {
  dataStorage(
    'https://jsonplaceholder.typicode.com/users',
    'users',
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return List<UserModel>.from(
    json.decode(prefs.getString('users').toString()).map((x) => UserModel.fromJson(x)),
  );
}

Future<List<PostModel>> fetchPosts(UserModel user) async {
  dataStorage(
    'https://jsonplaceholder.typicode.com/posts?userId=${user.id.toString()}',
    'posts: ${user.id}',
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return List<PostModel>.from(
    json.decode(prefs.getString('posts: ${user.id}').toString()).map((x) => PostModel.fromJson(x)),
  );
}

Future<List<CommentModel>> fetchComments(PostModel post, ) async {
  dataStorage(
    'https://jsonplaceholder.typicode.com/comments?postId='
        + post.id.toString(),
    'comments: ${post.userId + post.id}',
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return List<CommentModel>.from(
    json.decode(prefs.getString('comments: ${post.userId + post.id}').toString()).map((x) => CommentModel.fromJson(x)),
  );
}

Future<List<AlbumModel>> fetchAlbums(UserModel user,) async {
  dataStorage(
    'https://jsonplaceholder.typicode.com/posts?userId=${user.id.toString()}',
    'albums: ${user.id}',
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return List<AlbumModel>.from(
    json.decode(prefs.getString('albums: ${user.id}').toString()).map((x) => AlbumModel.fromJson(x)),
  );
}

Future<List<PhotoModel>> fetchPhotos(AlbumModel album,) async {
  dataStorage(
    'https://jsonplaceholder.typicode.com/photos?albumId=${album.id.toString()}',
    'photos: ${album.userId + album.id}',
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return List<PhotoModel>.from(
    json.decode(prefs.getString('photos: ${album.userId + album.id}').toString()).map((x) => PhotoModel.fromJson(x)),
  );
}

Future<List<TodoModel>> fetchTodos(UserModel user, dynamic dataStorage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return List<TodoModel>.from(
    json.decode(prefs.getString('todos: ${user.id}').toString()).map((x) => TodoModel.fromJson(x)),
  );
}

addComment(BuildContext context, PostModel post, String name, String email, String body) async {
  var response = await http.post(Uri.parse('https://jsonplaceholder.typicode.com/comments'),
    headers: <String, String>{
      'content-type': 'application/json',
    },
    body: jsonEncode(<String, dynamic> {
      'postId': post.id,
      'id': 4,
      'name': name,
      'email': email,
      'body': body,
    }),
  );

  if (response.statusCode == 201) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Comment send'),
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.green,
          onPressed: () {
          },
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Comment was not send'),
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.red,
          onPressed: () {},
        ),
      ),
    );
    throw Exception('Failed to send' + post.title + "'s comment");
  }
}