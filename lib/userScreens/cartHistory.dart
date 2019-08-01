import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girlies_store/tools/recCart.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:flutter_girlies_store/tools/app_data.dart';
import 'package:flutter_girlies_store/tools/recProduct.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_girlies_store/userScreens/cartHistoryDetail.dart';




// class have filter in stream

class AldreyCartHistory extends StatefulWidget {
  @override
  _AldreyCartHistoryState createState() => _AldreyCartHistoryState();
}

abstract class ListItem {}
class cartItem implements ListItem{
  final String acctFullName;
  cartItem(this.acctFullName);
}

//List<String> _confirmAcctFullName=["Category","yohan","yohan2"];
List<String> _confirmAcctFullName=["Category"];
List<DropdownMenuItem<String>> dropDownCategories;
List<String> categoryList = new List();



class _AldreyCartHistoryState extends State<AldreyCartHistory> {

  //DateFormat format = new DateFormat("dd MMM yyyy hh:mm");
  //final df = new DateFormat("dd-MM-yy hh:mm:ss");

  bool checkOneTime = false;
  String acctName = "";
  String acctEmail = "";

  Future getCurrentUser() async {
    acctName =  await getStringDataLocally(key: acctFullName);
    /*acctEmail = await getStringDataLocally(key: userEmail);
    acctPhotoURL = await getStringDataLocally(key: photoURL);
    isLoggedIn = await getBoolDataLocally(key: loggedIN);
    userId = await getStringDataLocally(key:userID);*/

    acctName == null ? acctName = "Guest User" : acctName;
    acctEmail == null ? acctEmail = "guestUser@email.com" : acctEmail;
    setState(()
    {


    });
    //await print ('user id: ${acctName}');
  }

  void fillCategory() async {
    _confirmAcctFullName=["Category"];

    //print ('update recod cart ${record2.name}  ${record2.cartId}');
    //Firestore.instance.collection('carts').document(record2.cartId).updateData(


    String tempAcct = '';
    await Firestore.instance.collection('carts')
        //.where('confirmedPurchase', isEqualTo: true)
        .where('acctFullName', isEqualTo: acctName)
        //.where('orderFulfill', isEqualTo: false)
        //.orderBy('acctFullName')
        .orderBy('confirmedDate')
        .getDocuments().then((data) {
      List<DocumentSnapshot> listDocSnapshot =data.documents ;
      listDocSnapshot.forEach((snap) {
        try {
          final record2 = RecordCart.fromSnapshot(snap);

          if (tempAcct != record2.acctFullName &&
              record2.acctFullName != null) {
            //print(record2.acctFullName);
            if (record2.acctFullName != null) {

              _confirmAcctFullName.add(record2.acctFullName);
              //_earlyConfirmedDate=df.format(record2.confirmedDate);

            }
            tempAcct = record2.acctFullName;
          };


          // checkStockQty  (String productId) async {
          Firestore.instance.collection('products').document(record2.productId).snapshots().forEach((snap){
            final record3  =  RecordProduct.fromSnapshot(snap);
            //print ('stockqty = ${record3.stockQty}');
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
    getCurrentUser();
    fillCategory();

    checkOneTime = false;
    print ('checkOneTime initstate: $checkOneTime');
    //stockQty = 0;
  }




  String _earlyConfirmedDate;
  int stockQty ;
  String _value = 'Category';
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Orders"),
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


   /*   floatingActionButton: new Stack(
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


        ],
      ),*/


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

    //_value = 'yohan';
    //print ('isrepeat *********************');
    //print ('go in 2 ${acctName}');




    //if (_value !='Category') {
      return StreamBuilder<QuerySnapshot>(
        // Yohan try to filter using key word
       // stream: Firestore.instance.collection('carts').where('acctFullName',isEqualTo: _value)
          stream: Firestore.instance.collection('carts')
              .where('acctFullName',isEqualTo: acctName)
            .where('confirmedPurchase', isEqualTo: true)
            //.where('orderFulfill', isEqualTo: false)
              .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        },
      );

    //}
    // return new Text('test');
  }



  List<Map<String, dynamic>> cartCustConfirmation = new List();

  //bool checkOneTime = false;
  // 22 june check

  _checkduplicate() async {

    String _acctFullName='';
    DateTime _confirmedDate;

    bool exitInd = true;
    int removeIndex = 0;
    int count = 0;
    bool haveDuplicate = true;
    //print (cartCustConfirmation);
    while (haveDuplicate ) {
      removeIndex = 0;
      exitInd = true;
      haveDuplicate = false;
      _acctFullName = '';
      _confirmedDate = null;

      // ('Start , list length : ${cartCustConfirmation.length}');
      await cartCustConfirmation.asMap().forEach((i, value) {

        //print ('I: $i');
        count = i;
        //print ('count: $count');

        //print ('_confirmedDate : $_confirmedDate  value[confirmedDate] :  ${value['confirmedDate']}');

        // yohan 01 aug
        //  if (_acctFullName != value['acctFullName'] || _confirmedDate != value['confirmedDate']) {
        if (_acctFullName != value['acctFullName'] || _confirmedDate != parseTime(value['confirmedDate'])) {

          _acctFullName = value['acctFullName'];

          // yohan 01 aug
          //_confirmedDate = value['confirmedDate'];
          _confirmedDate = parseTime(value['confirmedDate']);

        } else {


          //print ('go in i to remove: $i');
          removeIndex = i;
          haveDuplicate = true;
          print ('removeIndex : $removeIndex');
          // i = cartCustConfirmation.length ;
        }
      });
      //print ('to remove index : $removeIndex');
      if (removeIndex != 0 ) {
        //print ('removee ***********');
        setState(() {
          cartCustConfirmation.removeAt(removeIndex);
        });

      } else {
        exitInd = false;
      }

      count = 0;

      //print ('before loop haveDuplicate : $haveDuplicate');
      //print ('removeIndex : $removeIndex');
      //print ('exitInd : $exitInd');
    }


    checkOneTime = true;
  }


  _getCartData() async {

      //print ('isrepeat ***********************');

   // List<Map<String, dynamic>> cartCustConfirmation = new List();


    await Firestore.instance.collection('carts')
        .where('confirmedPurchase', isEqualTo: true)
        .where('acctFullName', isEqualTo: acctName)
        //.where('orderFulfill', isEqualTo: false)
        //.orderBy('acctFullName')
        .orderBy('confirmedDate', descending: true)
        .getDocuments().then((data) {
            List<DocumentSnapshot> listDocSnapshot = data.documents;

             cartCustConfirmation = listDocSnapshot.map((DocumentSnapshot docSnapshot) {
              return docSnapshot.data;
            }).toList();



            } );



    await _checkduplicate();
    /*print ('checkOneTime: $checkOneTime');

   if (!checkOneTime) {
      await _checkduplicate();
     checkOneTime = true;
    }*/
    //print ('finish haveDuplicate : $haveDuplicate ****************');



  }


  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {



      _getCartData();

     //return Scaffold();

    return ListView.builder(
        itemCount: cartCustConfirmation.length,
        itemBuilder: (context,index) {
          var group = cartCustConfirmation[index];
             return ListTile(
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (context) => AldreyCartHistoryDetail(pAcctFullName: group['acctFullName'], pConfirmedDate : group['confirmedDate'])));



              },

              title: new Row (
                children: <Widget>[



                 /* new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (context) => AppOrder()));
                    },

                  ),*/

                 /* Text('${group['acctFullName']}',
                    // style: Theme.of(context).textTheme.headline,
                      style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold )
                  ),*/
                  Text('Date: ',
                       style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                    ),
                Text ('${df.format(group['confirmedDate'])}'),



          group['orderFulfill'] ?
              Tooltip(message: "Order Fulfill", child:
                  new Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 20.0,
                  )
              ) : Container() ],
              ),

      /*        subtitle: new Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                 Row(
                 children:[
                 new Text( 'Order Fulfill :  ${group['orderFulfill']}', //record.price.toString(),
                 style: new TextStyle(
                     fontSize: 13.0, fontWeight: FontWeight.normal)),


          ]),
          ]),*/


            );

        }
    );
    /*return ListView(
      children:  snapshot.map((data) => _buildListItem(context, data)).toList(),
    );*/






      }



  checkStockQty  (String productId, num orderFulfillQty) async {
    // _itemCount = await orderFulfillQty;
    //print ('itemcount : ${_itemCount}');
    await Firestore.instance.collection('products').document(productId).snapshots().forEach((snap){
      final record2  =  RecordProduct.fromSnapshot(snap);
      //print ('stockqty = ${record2.stockQty}');
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
                        //print('delete');
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
