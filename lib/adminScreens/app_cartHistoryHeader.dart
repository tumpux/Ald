import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girlies_store/tools/recCart.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:flutter_girlies_store/tools/recProduct.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_girlies_store/adminScreens/app_cartHistDet1.dart';



// class have filter in stream

class AppCartHistoryHeader extends StatefulWidget {
  @override
  _AppCartHistoryHeaderState createState() => _AppCartHistoryHeaderState();
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



class _AppCartHistoryHeaderState extends State<AppCartHistoryHeader> {

  //DateFormat format = new DateFormat("dd MMM yyyy hh:mm");
  final df = new DateFormat("dd-MM-yy hh:mm:ss");



  void fillCategory() async {
    _confirmAcctFullName=["Category"];

    //print ('update recod cart ${record2.name}  ${record2.cartId}');
    //Firestore.instance.collection('carts').document(record2.cartId).updateData(


    String tempAcct = '';
    await Firestore.instance.collection('carts')
        .where('confirmedPurchase', isEqualTo: true)
        .where('orderFulfill', isEqualTo: true)
        .orderBy('acctFullName')
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
      // ('go in');

      categoryList = new List.from(_confirmAcctFullName);
      dropDownCategories= buildAndGetDropDownItems(categoryList);
    });

    //super.initState();
  }


  @override
  void initState() {

    print('initState');
    // TODO: implement initState
    fillCategory();
    //stockQty = 0;
  }



  String _earlyConfirmedDate;
  int stockQty ;
  String _value = 'Category';
  @override
  Widget build(BuildContext context) {

    print ('build');




    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Orders History"),
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

  Widget _buildBody(BuildContext context)  {
    //return _buildList(context, dummySnapshot);

    print (_buildBody);
    _value = 'yohan';
    //print ('go in 3 ${_value}');

    if (_value !='Category') {

      print ('before stream');

      return StreamBuilder<QuerySnapshot>(
        // Yohan try to filter using key word
       // stream: Firestore.instance.collection('carts').where('acctFullName',isEqualTo: _value)
          stream:  Firestore.instance.collection('carts')
              //.where('acctFullName',isEqualTo: 'yohan')
            .where('confirmedPurchase', isEqualTo: true)
            .where('orderFulfill', isEqualTo: true).snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        },





      );
    }
    // return new Text('test');
  }





  List<Map<String, dynamic>> cartCustConfirmation = new List();
  // 22 june check
  _getCartData() async {


   // List<Map<String, dynamic>> cartCustConfirmation = new List();


    await Firestore.instance.collection('carts')
        .where('confirmedPurchase', isEqualTo: true)
        .where('orderFulfill', isEqualTo: true)
        .orderBy('acctFullName')
        //.orderBy('confirmedDate')
        .getDocuments().then((data) {
            List<DocumentSnapshot> listDocSnapshot = data.documents;

            cartCustConfirmation = listDocSnapshot.map((DocumentSnapshot docSnapshot) {
              return docSnapshot.data;
            }).toList();



            } );

    String _acctFullName='';
    //DateTime _confirmedDate;
/*   // int removeidx;
    var remvindex = List<int>();
    await cartCustConfirmation.asMap().forEach((i, value) {

      if (_acctFullName == value['acctFullName'] && _confirmedDate == value['confirmedDate']) {

        print ('go in 3 $i');
        remvindex.add(i);
      } else {
        _acctFullName = value['acctFullName'];
        _confirmedDate = value['confirmedDate'];
      }
    });

    await remvindex.asMap().forEach((i,data){
      cartCustConfirmation.removeAt(data);
    });*/

    int removeIndex = 0;
    int count = 0;
    bool haveDuplicate = true;
    while (haveDuplicate ) {
      haveDuplicate = false;
      _acctFullName = '';
      //_confirmedDate = null;
      removeIndex = 0;
      //print ('Start , list length : ${cartCustConfirmation.length}');
      await cartCustConfirmation.asMap().forEach((i, value) {

        //print (i);
        count = i;
        //print ('count: $count');

        //print ('_confirmedDate : $_confirmedDate  value[confirmedDate] :  ${value['confirmedDate']}');
        //if (_acctFullName != value['acctFullName'] || _confirmedDate != value['confirmedDate']) {
        if (_acctFullName != value['acctFullName'] ) {
          if (cartCustConfirmation.length == 3) {
            //print ('3 _confirmedDate : $_confirmedDate  value[confirmedDate] :  ${value['confirmedDate']}');
          }
          _acctFullName = value['acctFullName'];
          //_confirmedDate = value['confirmedDate'];
        } else {
          if (cartCustConfirmation.length == 3) {
            //print ('3 else:  _confirmedDate : $_confirmedDate  value[confirmedDate] :  ${value['confirmedDate']}');
          }

          //print ('go in i to remove: $i');
          removeIndex = i;
          haveDuplicate = true;
          //print ('removeIndex : $removeIndex');
         // i = cartCustConfirmation.length ;
        }
      });
      //print ('to remove index : $removeIndex');
      if (removeIndex != 0 ) cartCustConfirmation.removeAt(removeIndex);
      count = 0;
    }

    //print ('finish ****************');

  }


  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {

      _getCartData();


    return ListView.builder(
        itemCount: cartCustConfirmation.length,
        itemBuilder: (context,index) {
          var group = cartCustConfirmation[index];
             return ListTile(
              onTap: () {
               // Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (context) => AppCartHistDet1(pAcctFullName: group['acctFullName'], )));
                   // .whenComplete(_getCartData());


                //Navigator.of(context).pop();
              },

              title: new Row (
                children: <Widget>[



                 /* new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (context) => AppOrder()));
                    },

                  ),*/

                  Text('${group['acctFullName']}',
                    // style: Theme.of(context).textTheme.headline,
                      style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold )
                  ),
                  Text('     Order Date: ${df.format(group['confirmedDate'])}',
                    ),




                ],
              ),



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
      // ('stockqty = ${record2.stockQty}');
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
