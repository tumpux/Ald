import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseCartAPI {
  static Stream<QuerySnapshot> cartStream =
      Firestore.instance.collection('carts').snapshots();

  static CollectionReference reference =
      Firestore.instance.collection('carts');

  static addCart(String acctFullName) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "acctFullName": acctFullName,
      });
    });
  }

 /* static removePlayer(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  } */

  static updateCart(String id, String newName) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "confirmedPurchase": false,
      }).catchError((error) {
        print(error);
      });
    });
  }
}