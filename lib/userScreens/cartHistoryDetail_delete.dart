import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girlies_store/tools/recCart.dart';

class AldreyCartHistoryDetail extends StatefulWidget {
  final String vAcctFullName;
  //final String param2;


  AldreyCartHistoryDetail({Key key, @required this.vAcctFullName}) : super(key: key);

  @override
  _AldreyCartHistoryDetailState createState() => _AldreyCartHistoryDetailState(vAcctFullName);
}

class _AldreyCartHistoryDetailState extends State<AldreyCartHistoryDetail> {

  String vAcctFullName;
 // String param2;

  _AldreyCartHistoryDetailState(this.vAcctFullName);

  // yohan added below
  @override
  void initState() {
    acctName = vAcctFullName;

     getNumberOfItems(acctName);

    buildInd = false;
    print ('buildInd : ${buildInd}');

  }

  num cartAmount ;
  String countItemStr;
  String acctName;
  bool buildInd = false;
  String totalAmount ='' ;
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(

      // Yohan try to filter using key word
      stream: Firestore.instance.collection('carts')
          .where('acctFullName', isEqualTo:vAcctFullName )
          .where('confirmedPurchase', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();


        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Future getNumberOfItems(String acctName) async {
    print ('go in');

    //int count;
    cartAmount = 0;
    await print ('user id: ${acctName}');

    await Firestore.instance.collection('carts')
        .where('acctFullName', isEqualTo:acctName )
        .where('confirmedPurchase', isEqualTo: true)
        .getDocuments().then((data) {

      //countItemStr = data.documents.length.toString();
      num cnt = 0;

      List<DocumentSnapshot> listDocSnapshot =data.documents ;
       listDocSnapshot.forEach((snap) {
          final record2 =  RecordCart.fromSnapshot(snap);

          setState(() {
            cartAmount = cartAmount + (record2.productPrice * record2.qty);
            cnt = cnt + record2.qty;
            countItemStr = cnt.toString();
          });

      });
    }


    );

    await print('countItemStr - cart : ${countItemStr}');
     await print (totalAmount);
    //await print('cartAmount - cart : ${cartAmount}');
    /* .snapshots().length.then((data) {
          print(data.toString());*/
    //);
    // print (countItem);

    setState(()
    {
      //print ('cartAmount = ${cartAmount}');


    });
  } // getnumber of item


  // square in, still can't do because doesn't support singapore yet
  /*void _pay() {
    print ('in payment');
    InAppPayments.setSquareApplicationId('sandbox-sq0idp-toIKQEHT0Kh-w0ocVo3siQ');
    print ('in payment 1');
    InAppPayments.startCardEntryFlow(
      onCardEntryCancel: _cardEntryCancel,
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
    );
  }
  void _cardEntryCancel() {
    // Cancel
    print ('in payment cancel ');
  }
  void _cardNonceRequestSuccess(mdl.CardDetails result) {
    // Use this nonce from your backend to pay via Square API

    print ('in payment success');
    print(result.nonce);

    final bool _invalidZipCode = false;

    if (_invalidZipCode) {
      // Stay in the card flow and show an error:
      InAppPayments.showCardNonceProcessingError('Invalid ZipCode');
    }

    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }
  void _cardEntryComplete() {
    // Success
    print('success payment');
  }*/
  // finish square in


  // yohan try email

  /*String attachment;

  final _recipientController = TextEditingController(
    text: 'yohan_i@yahoo.com',
  );

  final _subjectController = TextEditingController(text: 'The subject');

  final _bodyController = TextEditingController(
    text: 'Mail body.',
  );
  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPath: attachment,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      print ('send out email');
    } catch (error) {
      platformResponse = error.toString();
    }

 /*   if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));*/
  } */
  // end yohan try email

 // bool pendingOrder = false;

   Future<bool> _havePendingOrder() async  {

     bool pendingOrder = false;
     print (pendingOrder);
    await Firestore.instance.collection('carts')
        .where('acctFullName', isEqualTo:acctName )
        .where('confirmedPurchase', isEqualTo: true)
        //.where('orderFulfill', isEqualTo: false).limit(1)
        .getDocuments().then((data) {

      //countItemStr = data.documents.length.toString();
      num cnt = 0;

      print ('inside loop');
      List<DocumentSnapshot> listDocSnapshot =data.documents ;
      listDocSnapshot.forEach((snap)  {

        final record2 = RecordCart.fromSnapshot(snap);

        print (record2.name);
        //print (record2.orderFulfil);
        if(record2.orderFulfil == false){
          pendingOrder = true;
        }

      });
    });

    print ('pending order : ${pendingOrder}');
    //return pendingOrder;


     pendingOrder = false;
     if (pendingOrder == true) {

       print ('go in 2');
       showDialog(
         context: context,
         builder: (BuildContext context) {
           // return object of type Dialog
           return AlertDialog(
             title: new Text("Have pending order, can not proceed "),
             //content: new Text("Alert Dialog body"),
             actions: <Widget>[
               // usually buttons at the bottom of the dialog
               new FlatButton(
                 child: new Text("OK"),
                 onPressed: () {
                   //print ('order done');
                   Navigator.of(context).pop();
                 },
               ),

             ],
           );
         },
       );
     } else {
       showDialog(
         context: context,
         builder: (BuildContext context) {
           // return object of type Dialog
           return AlertDialog(
             title: new Text("Confirm the order? "),
             //content: new Text("Alert Dialog body"),
             actions: <Widget>[
               // usually buttons at the bottom of the dialog
               new FlatButton(
                 child: new Text("Order"),
                 onPressed: () {
                   print ('order done');


                  DateTime currDate = DateTime.now();

                   print ('updating cart');

                   Firestore.instance.collection('carts')
                       .where('acctFullName', isEqualTo: acctName)
                       .where('confirmedPurchase', isEqualTo: true)
                       .getDocuments().then((data) {
                     //countItemStr = data.documents.length.toString();
                     num cnt = 0;

                     List<DocumentSnapshot> listDocSnapshot = data.documents;
                     listDocSnapshot.forEach((snap) {
                       final record2 = RecordCart.fromSnapshot(snap);

                       Firestore.instance.collection('carts').document(
                           record2.cartId).updateData({
                         //'qty': record2.qty - 1
                         'confirmedPurchase': true,
                         'confirmedDate': currDate,

                         //'orderFulfill' : false,
                         //'orderQty' : 0
                       });
                     });
                   });


                   Navigator.of(context).pop();
                 },
               ),
               new FlatButton(
                 child: new Text("Cancel"),
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
               ),
             ],
           );
         },
       );
     }




   }


  @override
  Widget build(BuildContext context) {
    void _showConfirmOrder(//RecordProduct record
        ) {
      // flutter defined function

      final pendOrder =  _havePendingOrder();
      print ('go in 1 pendOrder ${pendOrder}');
      /*if (pendOrder == true) {

        print ('go in 2');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
                title: new Text("Have pending order, can not proceed "),
                //content: new Text("Alert Dialog body"),
                actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
            child: new Text("OK"),
            onPressed: () {
            //print ('order done');
            Navigator.of(context).pop();
            },
            ),

            ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Confirm the order? "),
              //content: new Text("Alert Dialog body"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Order"),
                  onPressed: () {
                    print ('order done');




                      print ('updating cart');

                      Firestore.instance.collection('carts')
                          .where('acctFullName', isEqualTo: acctName)
                          .where('confirmedPurchase', isEqualTo: false)
                          .getDocuments().then((data) {
                        //countItemStr = data.documents.length.toString();
                        num cnt = 0;

                        List<DocumentSnapshot> listDocSnapshot = data.documents;
                        listDocSnapshot.forEach((snap) {
                          final record2 = RecordCart.fromSnapshot(snap);

                          Firestore.instance.collection('carts').document(
                              record2.cartId).updateData({
                            //'qty': record2.qty - 1
                            'confirmedPurchase': true,
                            'confirmedDate': DateTime.now(),

                            //'orderFulfill' : false,
                            //'orderQty' : 0
                          });
                        });
                      });


                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
*/


    /*  showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Confirm the order? "),
            //content: new Text("Alert Dialog body"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Order"),
                onPressed: () {
                  print ('order done');


                  if ( pendingOrder == false) {

                    print ('updating cart');

                    Firestore.instance.collection('carts')
                        .where('acctFullName', isEqualTo: acctName)
                        .where('confirmedPurchase', isEqualTo: false)
                        .getDocuments().then((data) {
                      //countItemStr = data.documents.length.toString();
                      num cnt = 0;

                      List<DocumentSnapshot> listDocSnapshot = data.documents;
                      listDocSnapshot.forEach((snap) {
                        final record2 = RecordCart.fromSnapshot(snap);

                        Firestore.instance.collection('carts').document(
                            record2.cartId).updateData({
                          //'qty': record2.qty - 1
                          'confirmedPurchase': true,
                          'confirmedDate': DateTime.now(),

                          //'orderFulfill' : false,
                          //'orderQty' : 0
                        });
                      });
                    });
                  }

          Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );*/
    }



    return new Scaffold(
      appBar: new AppBar(

        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> //new MyHomePage( countItemStr)
            Navigator.pop(context,countItemStr)
        ),
        title: new Text("Cart"),
        centerTitle: false,

        actions: <Widget>[

      new IconButton(
      icon: new Icon(
        Icons.email,
        color: Colors.white,
      ),
        onPressed: () {

          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => null));

          //_pay();

        }),

    ]

      ),
     /* body: new Center(
        child: new Text(
          "My Cart",
          style: new TextStyle(fontSize: 25.0),
        ),
      ),*/
      body:  _buildBody(context),
      persistentFooterButtons: <Widget> [
        new Text('Total S\$ $cartAmount',
            style: new TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold)),
        new IconButton(
            icon: new Icon(
              Icons.email,
              color: Colors.black,

            ),
            onPressed: () {
               _showConfirmOrder();

            /*  Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => null));*/
            }),

      ],

      /*new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Card(
                child: new Container(
                  padding: new EdgeInsets.all(32.0),
                  child: new Column(
                    children: <Widget>[
                      new Text('Hello World'),
                      new Text('How are you?')
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),*/



/*      bottomNavigationBar: BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //IconButton(icon: Icon(Icons.menu), onPressed: () {},),
          //new Text('Total S\$ ${cartAmount}'),
          new Text (totalAmount, style: TextStyle(color: Colors.black),  ),
          IconButton(icon: Icon(Icons.search), onPressed: () {},),
        ],
      ),
    ),*/


    )

;


  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      //padding: const EdgeInsets.only(top: 20.0),
      children:  snapshot.map((data) => _buildListItem(context, data)).toList(),


     /* new Text(_checkStr(cartAmount.toString()),
          style: new TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.normal)),*/
    );

  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    //yohan 07 april 2019
    //String prodId = Record.fromSnapshot(data).reference.documentID;

    final record = RecordCart.fromSnapshot(data );

    /*print ('buildInd loop: ${buildInd}');
    if (buildInd == false) {
      Firestore.instance.collection('products')
          .document(record.productId)
          .snapshots()
          .forEach((data) {
        cartAmount = cartAmount + RecordProduct
            .fromSnapshot(data)
            .price;
      }
      );
    };
*/
     totalAmount = 'Total S\$ ${cartAmount}';
   String _checkStr(String str)  {
      return str != null ? str : '';
    }
    void _showDialogDelete(RecordCart record) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Confirm remove from Cart?"),
            //content: new Text("Alert Dialog body"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Delete"),
                onPressed: () {
                  buildInd = true;
                  print ('record : ${record.qty.toString()}');
                  print ('cart id : ${record.cartId}');
                  if (record.qty>1) {
                    Firestore.instance.collection('carts').document(record.cartId).updateData(
                        { 'qty': record.qty - 1
                        });
                  } else {

                    Firestore.instance
                        .collection('carts')
                        .document(record.cartId)
                        .delete()
                        .catchError((e) {
                      print(e);
                    });
                  }

                  /*Firestore.instance.collection('carts').document(record.cartId).updateData(
                      { 'qty': snap.data['qty'] - 1
                      },
                  )    ;*/










                  getNumberOfItems(acctName);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
                        _showDialogDelete(record);
                      }),

                ],


              ),


              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    Padding (
                      padding: EdgeInsets.all(8.0),
                      child:  //new Text(_checkStr(cartAmount.toString()),
                            new Text('Price : ${_checkStr(record.productPrice.toString())}   Qty : ${_checkStr(record.qty.toString())} ',
                          style: new TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.normal)),
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
