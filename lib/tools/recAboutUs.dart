import 'package:cloud_firestore/cloud_firestore.dart';

class RecordAboutUs {
  final DocumentReference reference;
  final num picNo;
  final String URL;
  final String aboutUsID;

  RecordAboutUs.fromMap(Map<String, dynamic> map, {this.reference})
      : //assert(map['name'] != null),
  //assert(map['productURL'] != null),
        picNo = map['picNo'],
        URL = map['URL'],
        aboutUsID = reference.documentID

  ;

  RecordAboutUs.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$picNo;$URL;$aboutUsID;>";

}