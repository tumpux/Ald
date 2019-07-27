import 'package:cloud_firestore/cloud_firestore.dart';

class RecordCart {
  final DocumentReference reference;
  final String acctFullName;
  final bool confirmedPurchase;
  final DateTime confirmedDate;
  final String name;
  final String productId;
  final String productURL;
  final num productPrice;
  final String userId;
  final String cartId;
  final num qty;
  final num stockQty;
  final num orderFulfillQty;
  final bool orderFulfil;

  RecordCart.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
  //assert(map['productURL'] != null),
        acctFullName = map ['acctFullName'],
        confirmedPurchase = map ['confirmedPurchase'],
        confirmedDate = map ['confirmedDate'],
        name = map['name'],
        productId = map ['productId'],
        productURL = map['productURL'],
        productPrice = map['productPrice'],
        userId = map['userId'],
        cartId= reference.documentID,
        qty = map['qty'],
        stockQty = map['stockQty'],
        orderFulfillQty = map['orderFulfillQty'],
        orderFulfil = map['orderFulfill']

  ;


  RecordCart.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);




  @override
  String toString() => "Record<$cartId;$acctFullName;$confirmedPurchase;$confirmedDate;$name;$productId;$productURL;$productPrice;$userId;$qty;$stockQty;$orderFulfillQty;$orderFulfil;>";

}