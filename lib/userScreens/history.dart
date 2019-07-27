import 'package:flutter/material.dart';

class AldreyHistory extends StatefulWidget {
  @override
  _AldreyHistoryState createState() => _AldreyHistoryState();
}


//const String _imageUrlOne = 'https://firebasestorage.googleapis.com/v0/b/aldrey-craft.appspot.com/o/20190301_213014.jpg?alt=media&token=5f32bc38-1ced-4589-92b5-7e586ecec034';

/*class ImageUrl extends StatelessWidget {
  final String imageUrl;
  ImageUrl({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Image.network(imageUrl);
  }
}*/


class _AldreyHistoryState extends State<AldreyHistory> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Order History"),
        centerTitle: false,
      ),
      body: new Center(
        child: new Text(
          "My History2",
          style: new TextStyle(fontSize: 25.0),
        ),
        /*new ImageUrl(
          imageUrl: _imageUrlOne,
        ),*/
      ),
    );
  }
}
