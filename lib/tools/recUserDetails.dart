import 'package:cloud_firestore/cloud_firestore.dart';

class RecordUserDetails {
  final DocumentReference reference;
  final String userDetailsId;
  final String acctFullName;
  final String address1;
  final String address2;
  final String address3;


  RecordUserDetails.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['acctFullName'] != null),
  //assert(map['productURL'] != null),

        userDetailsId= reference.documentID,
        acctFullName = map ['acctFullName'],
        address1 = map ['address1'],
        address2 = map ['address2'],
        address3 = map['address3']

  ;


  RecordUserDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);




  @override
  String toString() => "Record<$userDetailsId;$acctFullName;$address1;$address2;$address3;>";

}