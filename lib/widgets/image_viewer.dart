import 'package:flutter/material.dart';
import 'package:testovoye/models/photo_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:testovoye/widgets/flexible_space_background.dart';

class ImageViewer extends StatefulWidget {
  final PhotoModel photo;

  const ImageViewer({Key? key, required this.photo}) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.photo.title),
        elevation: 2,
        flexibleSpace: flexibleSpaceBackground(context),
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(widget.photo.url),
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
        ),
      ),
    );
  }
}
