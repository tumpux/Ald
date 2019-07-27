import 'package:cloud_firestore/cloud_firestore.dart';

class RecordProduct {
  final String name;
  final DocumentReference reference;
  final String productURL;
  final String category;
  final String description;
  final String productId;
  final num price;
  final num stockQty;

  RecordProduct.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
  //assert(map['productURL'] != null),
        name = map['name'],
        productURL = map['productURL'],
        category = map['category'],
        description = map['description'],
        price = map['price'],
        stockQty = map ['stockQty'],
        productId = reference.documentID

  ;

  RecordProduct.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name;$productURL;$category;$description;$price;$stockQty;$productId>";

}