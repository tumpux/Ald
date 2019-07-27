// change this, as I need to change to list view, with the name and the oder date

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girlies_store/tools/recCart.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:flutter_girlies_store/tools/recProduct.dart';
import 'package:intl/intl.dart';

class AldreyCartHistoryDetail extends StatefulWidget {

  final String pAcctFullName;
  final DateTime pConfirmedDate;

  AldreyCartHistoryDetail({Key key, @required this.pAcctFullName, @required this.pConfirmedDate  }) : super(key: key);


  @override
  _AldreyCartHistoryDetailState createState() => _AldreyCartHistoryDetailState(pAcctFullName, pConfirmedDate);
}


//List<String> _confirmAcctFullName=["Category"];
List<DropdownMenuItem<String>> dropDownCategories;
List<String> categoryList = new List();

List<Map<String, dynamic>> cartCustConfirmation = new List();

class _AldreyCartHistoryDetailState extends State<AldreyCartHistoryDetail> {

  String vAcctFullName;
  DateTime vConfirmedDate;
  _AldreyCartHistoryDetailState (this.vAcctFullName, this.vConfirmedDate);

  //DateFormat format = new DateFormat("dd MMM yyyy hh:mm");
  final df = new DateFormat("dd-MM-yy hh:mm");
  @override
  void initState() {
    // TODO: implement initState
  }
 int stockQty ;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: //new Text("App Orders"),
          new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              new Text("Order Detail"),
            ],
          ),


        centerTitle: false,
      ),

      body : _buildBody(context),

        persistentFooterButtons: <Widget> [
          new Text('$vAcctFullName - ${df.format(vConfirmedDate)}',
        style: new TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold)),
    ],


      floatingActionButton: new Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[

        ],
      ),


    );
  }


  Widget _buildBody(BuildContext context) {

      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('carts').where('acctFullName',isEqualTo: vAcctFullName)
              .where('confirmedPurchase', isEqualTo: true)
              //.where('orderFulfill', isEqualTo: false)
              .where('confirmedDate', isEqualTo: vConfirmedDate)
              .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        },
      );

   // }
     
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
     children:  snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }



  checkStockQty  (String productId, num orderFulfillQty) async {
     await Firestore.instance.collection('products').document(productId).snapshots().forEach((snap){
       final record2  =  RecordProduct.fromSnapshot(snap);
        print ('stockqty = ${record2.stockQty}');
          stockQty= record2.stockQty;
    });

  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {

   final record = RecordCart.fromSnapshot(data);

   checkStockQty(record.productId, record.orderFulfillQty);

   String _checkStr(String str)  {  return str != null ? str : '';   }
   return Card (

     child:
     new Column(
         children: <Widget> [
           ListTile(

             leading: new Image.network(record.productURL,
               fit: BoxFit.cover,
               width: 70.0,
               height: 70.0,
             ),
             title: new Row (
               children: <Widget>[
                 new Text(record.name ,
                   style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                 ),

                 //new Text(cartAmount.toString()),
               /*  new IconButton(
                     icon: new Icon(
                       Icons.remove_circle,
                       color: Colors.green,
                     ),

                     onPressed: () {
                       //_showDialogDelete(record);
                       print('delete');
                     }),

                 new Text(' Buy Qty : ${_checkStr(record.qty.toString())}')*/

               ],


             ),


             subtitle: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[


                   Padding (
                     padding: EdgeInsets.all(8.0),
                     child:  //new Text(_checkStr(cartAmount.toString()),
                     new Text('Price : ${_checkStr(record.productPrice.toString())}   Buy Qty : ${_checkStr(record.qty.toString())} ',
                         style: new TextStyle(
                             fontSize: 16.0, fontWeight: FontWeight.normal)),
                   ),

                 ]),
             contentPadding: const EdgeInsets.only(top: 0.0),
           ),

         ]
     ),


   );


  }
}
