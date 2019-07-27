// change this, as I need to change to list view, with the name and the oder date

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girlies_store/tools/recCart.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:flutter_girlies_store/tools/app_data.dart';
import 'package:flutter_girlies_store/tools/recProduct.dart';
import 'package:intl/intl.dart';

class AppOrders extends StatefulWidget {
  @override
  _AppOrdersState createState() => _AppOrdersState();
}


//List<String> _confirmAcctFullName=["Category","yohan","yohan2"];
List<String> _confirmAcctFullName=["Category"];
List<DropdownMenuItem<String>> dropDownCategories;
List<String> categoryList = new List();



class _AppOrdersState extends State<AppOrders> {

  //DateFormat format = new DateFormat("dd MMM yyyy hh:mm");
  final df = new DateFormat("dd-MM-yy hh:mm");

  void fillCategory() async {
     _confirmAcctFullName=["Category"];

     //print ('update recod cart ${record2.name}  ${record2.cartId}');
     //Firestore.instance.collection('carts').document(record2.cartId).updateData(


     String tempAcct = '';
     await Firestore.instance.collection('carts')
         .where('confirmedPurchase', isEqualTo: true)
         .where('orderFulfill', isEqualTo: false)
         .orderBy('acctFullName')
         .orderBy('confirmedDate')
         .getDocuments().then((data) {
       List<DocumentSnapshot> listDocSnapshot =data.documents ;
       listDocSnapshot.forEach((snap) {
         try {
           final record2 = RecordCart.fromSnapshot(snap);

           if (tempAcct != record2.acctFullName &&
               record2.acctFullName != null) {
             print(record2.acctFullName);
             if (record2.acctFullName != null) {

               _confirmAcctFullName.add(record2.acctFullName);
               //_earlyConfirmedDate=df.format(record2.confirmedDate);

             }
             tempAcct = record2.acctFullName;
           };


          // checkStockQty  (String productId) async {
             Firestore.instance.collection('products').document(record2.productId).snapshots().forEach((snap){
               final record3  =  RecordProduct.fromSnapshot(snap);
               print ('stockqty = ${record3.stockQty}');
               stockQty= record3.stockQty;

               if (record2.qty <= record3.stockQty) {
                 Firestore.instance.collection('carts').document(
                     (record2.cartId)).updateData(
                     { 'stockQty': record3.stockQty,
                       'orderFulfillQty' : record2.qty
                     });
               } else {
                 Firestore.instance.collection('carts').document(
                     (record2.cartId)).updateData(
                     { 'stockQty': record3.stockQty,
                       'orderFulfillQty' : record3.stockQty
                     });
               }

             });
           //}





         } on Exception {
           print ('exception');
         }
       });
     });

     setState(() {
       print ('go in');

       categoryList = new List.from(_confirmAcctFullName);
       dropDownCategories= buildAndGetDropDownItems(categoryList);
     });

     //super.initState();
}


  @override
  void initState() {
    // TODO: implement initState
   fillCategory();
   //stockQty = 0;
  }



  String _earlyConfirmedDate;
  int stockQty ;
  String _value = 'Category';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: //new Text("App Orders"),
          new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new DropdownButton<String>(
                value: _value,
                items: dropDownCategories,
                onChanged: (String value) {
                  //setState(() => _value = value);

                  print(value);
                  Firestore.instance.collection('carts')
                      .where('confirmedPurchase', isEqualTo: true)
                      .where('orderFulfill', isEqualTo: false)
                      .where('acctFullName',isEqualTo: value)
                      .orderBy('confirmedDate') //.limit(1)
                      .getDocuments().then((data) {
                    List<DocumentSnapshot> listDocSnapshot =data.documents ;
                    listDocSnapshot.forEach((snap) {
                      final record2 = RecordCart.fromSnapshot(snap);
                      //print(record2.confirmedDate);
                      //print(DateTime.now().timeZoneName);
                      setState(() {
                        _earlyConfirmedDate = df.format(record2.confirmedDate);
                      });
                     // _earlyConfirmedDate = df.format(record2.confirmedDate);
                    });
                  });


                  setState(() { _value = value;
                      print (value);



                            });
                },
              ),

            ],
          ),


        centerTitle: false,
      ),
      /*body: new Center(
        child: new Text(
          "App Orders",
          style: new TextStyle(fontSize: 25.0),
        ),
      ),*/
      body : _buildBody(context),

        persistentFooterButtons: <Widget> [
    //new Text('Confirmed date: ${_earlyConfirmedDate}',
    _earlyConfirmedDate == null ? new Text('') : new Text('Confirmed date: ${_earlyConfirmedDate}',
        style: new TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold)),
    ],


      floatingActionButton: new Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[


          // below yohan 2nd june - deduct stock
          new FloatingActionButton(
            onPressed: () {
              print ('order fulfill');

              Firestore.instance.collection('carts')
                  .where('acctFullName', isEqualTo:_value )
                  .where('confirmedPurchase', isEqualTo: true)
                  .where('orderFulfill', isEqualTo: false)
                  .getDocuments().then((data) {

                //countItemStr = data.documents.length.toString();
                //num cnt = 0;

                List<DocumentSnapshot> listDocSnapshot =data.documents ;
                listDocSnapshot.forEach((snap) {
                  final record2 = RecordCart.fromSnapshot(snap);


                  Firestore.instance.collection('products').document(
                      (record2.productId)).updateData(
                      { 'stockQty':  this.stockQty - record2.orderFulfillQty,
                      });

                  Firestore.instance.collection('carts').document(record2.cartId).updateData({
                    //'qty': record2.qty - 1
                    //'confirmedPurchase': true,
                    'orderFulfill' : true,
                    //'orderQty' : 0
                  });

                });
              });


              Navigator.of(context).pop();
            },

            child : new Icon(Icons.account_balance_wallet),



          ),


          /*new CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.red,
            child: new Text(
              //"0",
              countItemStr,
              style: new TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          )*/
        ],
      ),


    );
  }

/*  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      //padding: const EdgeInsets.only(top: 20.0),
      children:  snapshot.map((data) => _buildListItem(context, data)).toList(),
    );

  }*/

  Widget _buildBody(BuildContext context) {
    //return _buildList(context, dummySnapshot);

      if (_value !='Category') {
      return StreamBuilder<QuerySnapshot>(
           // Yohan try to filter using key word
          stream: Firestore.instance.collection('carts').where('acctFullName',isEqualTo: _value)
              .where('confirmedPurchase', isEqualTo: true)
              .where('orderFulfill', isEqualTo: false).snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        },
      );

   // );
    }
     // return new Text('test');
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
     children:  snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }



  checkStockQty  (String productId, num orderFulfillQty) async {
   // _itemCount = await orderFulfillQty;
    //print ('itemcount : ${_itemCount}');
     await Firestore.instance.collection('products').document(productId).snapshots().forEach((snap){
       final record2  =  RecordProduct.fromSnapshot(snap);
        print ('stockqty = ${record2.stockQty}');
          stockQty= record2.stockQty;
    });

  }

  //num _itemCount = 0;

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    //yohan 07 april 2019
    //String prodId = Record.fromSnapshot(data).reference.documentID;
   final record = RecordCart.fromSnapshot(data);

   checkStockQty(record.productId, record.orderFulfillQty);

   String _checkStr(String str)  {  return str != null ? str : '';   }
   return Card (
     // margin: const EdgeInsets.only(top: 1.0),

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
                 new IconButton(
                     icon: new Icon(
                       Icons.remove_circle,
                       color: Colors.green,
                     ),

                     onPressed: () {
                       //_showDialogDelete(record);
                       print('delete');
                     }),

                 new Text('Buy Qty : ${_checkStr(record.qty.toString())}')

               ],


             ),


             subtitle: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[


                   Padding (
                     padding: EdgeInsets.all(8.0),
                     child:  //new Text(_checkStr(cartAmount.toString()),
                     new Text('Price : ${_checkStr(record.productPrice.toString())}   Stock Qty : ${record.stockQty.toString()} ',
                         style: new TextStyle(
                             fontSize: 16.0, fontWeight: FontWeight.normal)),
                   ),

                   Padding (
                     padding: EdgeInsets.all(2.0),
                     child:  //new Text(_checkStr(cartAmount.toString()),
                     Row(
                       children: <Widget>[
                         new Text('Fulfill Qty : '
                             //'${record.orderFulfillQty.toString()}'
                              ,
                             style: new TextStyle(
                                 fontSize: 16.0, fontWeight: FontWeight.bold)),

                        record.orderFulfillQty!=0? new  IconButton(icon: new Icon(Icons.remove),color: Colors.black,
                          onPressed: ()=>setState(()=>
                         //_itemCount--
                          Firestore.instance.collection('carts').document(
                              (record.cartId)).updateData(
                              {
                                'orderFulfillQty' : record.orderFulfillQty -1
                              })
                           //print ('test minus')
                         ),):new Container(),

                         new Text(record.orderFulfillQty.toString(), style:
                         new TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                         ),
                         //new IconButton(icon: new Icon(Icons.add),onPressed: ()=>setState(()=>_itemCount++))
                         new IconButton(icon: new Icon(Icons.add),color: Colors.black,onPressed: (){
                           Firestore.instance.collection('carts').document(
                               (record.cartId)).updateData(
                               {
                                 'orderFulfillQty' : record.orderFulfillQty +1
                               });
                           //print ('test add');
                           //_itemCount=_itemCount+1;
                           //setState((){_itemCount;});
                         })


                       ],
                     )

                     /*new Text('Fulfill Qty : ${record.orderFulfillQty.toString()}',
                         style: new TextStyle(
                             fontSize: 16.0, fontWeight: FontWeight.bold)),*/


                   ),


                 ]),
             contentPadding: const EdgeInsets.only(top: 0.0),
           ),
           /* ListTile(
            title: new Text(_checkStr(cartAmount.toString()),
                style: new TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.normal)),
    )*/
         ]
     ),


   );


  }
}
