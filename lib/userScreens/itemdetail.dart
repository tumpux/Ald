import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '_product.dart';

import 'package:photo_view/photo_view.dart';
import 'package:flutter_girlies_store/tools/recProduct.dart';


class AldreyItemDetail extends StatefulWidget {
  final RecordProduct data;

  //AldreyItemDetail({this.data});
  AldreyItemDetail({Key key, @required this.data}) : super(key: key);

  @override
  _AldreyItemDetailState createState() => _AldreyItemDetailState(data);
}

class _AldreyItemDetailState extends State<AldreyItemDetail> {

  RecordProduct data;
  _AldreyItemDetailState (this.data);

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Product Picture"),
        centerTitle: false,
      ),
      body: new Center(
        child :  PhotoView(
            imageProvider : NetworkImage(data.productURL,
              //fit: BoxFit.cover,

        ),

            maxScale: PhotoViewComputedScale.covered
        /*imageProvider: new Image.network(data.productURL,
          fit: BoxFit.cover,
          //width: 480.0,
          //height: 480.0,
        )*/,)
       /* new Image.network(data.productURL,
          fit: BoxFit.cover,
          //width: 480.0,
          //height: 480.0,
        ),*/

        /*child: new Text(
          "My Messages",
          style: new TextStyle(fontSize: 25.0),
        ),*/
      ),
    );
  }
}
