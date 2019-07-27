import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_girlies_store/tools/recUserDetails.dart';


// NEED to change this to Addressss  *******************
class Address extends StatefulWidget {
  final String pAcctName;
  final bool fromOrder;

  //AldreyItemDetail({this.data});
  Address({Key key, @required this.pAcctName, @required this.fromOrder}) : super(key: key);


  @override
  _AddressState createState() => _AddressState(pAcctName, fromOrder);
}



class Record {
  final String name;
  final DocumentReference reference;
  final String productURL;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),

        name = map['name'],
        productURL = map['productURL']

  ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name;$productURL>";

}

class _AddressState extends State<Address>  {

  String pAcctName;
  bool fromOrder;

  _AddressState(this.pAcctName, this.fromOrder);

  List<DropdownMenuItem<String>> dropDownCategories;
  String selectedCategory;
  List<String> categoryList = new List();

  Map<int, File> imagesMap = new Map();

  TextEditingController address1 = new TextEditingController();
  TextEditingController address2 = new TextEditingController();
  TextEditingController address3 = new TextEditingController();


  @override
  void clearTxt() {

    print ('3 ****');
    address1.clear();
    address2.clear();
    address3.clear();
     setState(() {

    });

    initState();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _downloadURL;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  num _itemCount = 1 ;

  @override
  Widget build(BuildContext context) {

    File file;


    checkAddress() {

      if (address1.text == "") {
        showSnackBar("Address cannot be empty", scaffoldKey);
        return;
      }

    }

    Future<String> addAddress(String refId) async {

      print ('1 ****');
      if (refId != null ){
        Firestore.instance.collection('userDetails').document(refId).setData(
            { 'acctFullName': pAcctName,
              'address1': address1.text, //'Test123',
              'address2': address2.text,
              'address3': address3.text,

            });

      }else {
        Firestore.instance.collection('userDetails').document().setData(
            { 'acctFullName': pAcctName,
              'address1': address1.text, //'Test123',
              'address2': address2.text,
              'address3': address3.text,

            });

        print('2 ****');
        //clearTxt();
      }
    }

    Widget _buildbody() {

      String refId;

      Firestore.instance.collection('userDetails')
          .where('acctFullName', isEqualTo:pAcctName )
          //.where('confirmedPurchase', isEqualTo: false)
          .getDocuments().then((data) {

        List<DocumentSnapshot> listDocSnapshot =data.documents ;
        listDocSnapshot.forEach((snap) {
           final record = RecordUserDetails.fromSnapshot(snap);
           address1.text = record.address1;
           address2.text = record.address2;
           address3.text = record.address3;
           refId = record.userDetailsId;
           print ('refId: $refId');

        });
      });

      return
        new SingleChildScrollView(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            <Widget>[
              new SizedBox(
                height: 10.0,
              ),

              //new ImageUrl(imageUrl: _imageUrlOne,),
              /*  new SizedBox(
              height: 10.0,
            ),*/

              appTextField(
                  isPassword: false,
                  sidePadding: 18.0,
                  textHint: "Shipment Address1",
                  textIcon: Icons.local_shipping,
                  controller: address1),

              new SizedBox(
                height: 30.0,
              ),

              appTextField(
                  isPassword: false,
                  sidePadding: 18.0,
                  textHint: "Shipment Address2",
                  textIcon: Icons.local_shipping,
                  controller: address2),

              new SizedBox(
                height: 30.0,
              ),

              appTextField(
                  isPassword: false,
                  sidePadding: 18.0,
                  textHint: "Shipment Address3",
                  textIcon: Icons.local_shipping,
                  controller: address3),




              appButton(
                  btnTxt: "Update Address",
                  onBtnclicked: ()  {
                    //file = await compressImage(file);

                    checkAddress();
                    addAddress(refId);

                    if(fromOrder){
                      Navigator.pop(context);
                    }

                  },
                  //{ uploadImage(); },
                  // ys- change this, folow tutor - addNewProducts,
                  btnPadding: 20.0,
                  btnColor: Theme.of(context).primaryColor),
              new SizedBox(
                height: 20.0,
              ),





            ],
          ),
        );
    }

    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Address"),
        centerTitle: false,
        elevation: 0.0,

      ),
      body: _buildbody()
    );




  }





/*
  List<File> imageList;
  String filename;
  removeImage(int index) async {
    imageList.removeAt(index);*/

  }









  // yohan added to try save to database
/*  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }*/
/*
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      // padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
  }*/
// end yohan

//}
