import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String itemName;
  double itemPrice;
  String itemImage;
  double itemRating;

  Store.items({this.itemName, this.itemPrice, this.itemImage, this.itemRating});
}

/* yohan to try :

return new Column(
  children: <Widget>[
    new Flexible(
      child: StreamBuilder(
        stream: Firestore.instance.collection('chats').document('ROOM_1').collection('messages').snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData){
            return Container(
              child: Center(
                child: Text("No data")
              )
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (_, int ) {
              return ChatMessage(text: snapshot.data.documents[index]["messageField"]); //I just assumed that your ChatMessage class takes a parameter message text
            }
          );
        }
      )

    ),
    new Divider(
      height: 1.0,
    ),

 */


List<Store> storeItems = [
  Store.items(
      itemName: "Pink Can",
      itemPrice: 2500.00,
      itemImage: "https://goo.gl/X6mMdH",
      itemRating: 0.0),
  Store.items(
      itemName: "Black Strip White",
      itemPrice: 2499.00,
      itemImage: "https://goo.gl/ANKP4k",
      itemRating: 0.0),
  Store.items(
      itemName: "Pink Can",
      itemPrice: 2500.00,
      itemImage: "https://goo.gl/X6mMdH",
      itemRating: 0.0),
  Store.items(
      itemName: "Black Strip White",
      itemPrice: 2499.00,
      itemImage: "https://goo.gl/77AUhb",
      itemRating: 0.0),
  Store.items(
      itemName: "Pink Can",
      itemPrice: 2500.00,
      itemImage: "https://goo.gl/X6mMdH",
      itemRating: 0.0),
  Store.items(
      itemName: "Black Strip White",
      itemPrice: 2499.00,
      itemImage: "https://goo.gl/RXqqSK",
      itemRating: 0.0),
  Store.items(
      itemName: "Pink Can",
      itemPrice: 2500.00,
      itemImage: "https://goo.gl/8f9WDy",
      itemRating: 0.0),
  Store.items(
      itemName: "Black Strip White",
      itemPrice: 2499.00,
      itemImage: "https://goo.gl/f1SRdM",
      itemRating: 0.0),
  Store.items(
      itemName: "Pink Can",
      itemPrice: 2500.00,
      itemImage: "https://goo.gl/X6mMdH",
      itemRating: 0.0),
  Store.items(
      itemName: "Black Strip White",
      itemPrice: 2499.00,
      itemImage: "https://goo.gl/X6mMdH",
      itemRating: 0.0),
];



// yohan below try to get data still error
/*
class Product {
  String name;
  String productURL;
  Product(this.name,this.productURL);
}

List<Product> list=new List();



class Record {
  final String name;
  final DocumentReference reference;
  final String productURL;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
  //assert(map['productURL'] != null),
        name = map['name'],
        productURL = map['productURL']

  ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name;$productURL>";

} */



  /*await mainReference.child("wall").once().then((DataSnapshot dataSnapshot){
    this.setState((){
      for(var value in dataSnapshot.value.values) {
        list.add(new Post.fromJson(value));
      }
    });
  });
}*/
