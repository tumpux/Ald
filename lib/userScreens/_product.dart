import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_girlies_store/tools/recProduct.dart';

/*class RecordProduct {
  final String name;
  final DocumentReference reference;

  final String productURL;
  final String category;
  final String description;
  final String productId;


  //final Decimal price;

  RecordProduct.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
  //assert(map['productURL'] != null),
        name = map['name'],
        productURL = map['productURL'],
        category = map['category'],
        description = map['description'],
        productId = reference.documentID
      ;


  RecordProduct.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);




  @override
  String toString() => "Record<$name;$productURL;$category;$description;$productId>";

}*/

class RecordCart {
  final DocumentReference refCart;
  final String acctFullName;
  final bool confirmedPurchase;
  final String cartId;

  RecordCart.fromMap(Map<String, dynamic> map, {this.refCart})
      : assert(map['acctFullName'] != null),
        acctFullName = map['acctFullName'],
        confirmedPurchase = map['confirmedPurchase'],
        cartId = refCart.documentID
       ;
  RecordCart.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, refCart: snapshot.reference);
  @override
  String toString() => "Record<$acctFullName;$confirmedPurchase;$cartId>";

}
