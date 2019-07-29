import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_girlies_store/adminScreens/admin_home.dart';
import 'package:flutter_girlies_store/tools/app_data.dart';
import 'package:flutter_girlies_store/tools/app_methods.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:flutter_girlies_store/tools/firebase_methods.dart';
import 'package:flutter_girlies_store/tools/recProduct.dart';
import 'package:flutter_girlies_store/userScreens/itemdetail.dart';
import 'messages.dart';
import 'cart.dart';
import 'package:flutter_girlies_store/userScreens/cartHistory.dart';
import 'profile.dart';
import 'delivery.dart';
import 'aboutUs.dart';
import 'login.dart';
import 'package:flutter_girlies_store/tools/recCart.dart';
import 'package:flutter_girlies_store/userScreens/address.dart';



class MyHomePage extends StatefulWidget {
  // yohan added for 2nd page cart to return value
  MyHomePage(this.indx) ;
  final String indx;


  @override
  _MyHomePageState createState() => _MyHomePageState(indx);
}
class _MyHomePageState extends State<MyHomePage> {



  // yohan added for 2nd page cart to return value
   String indx;
   _MyHomePageState(this.indx);

  BuildContext context;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  String userId = "";
  //String userEmail =  "";
  int countItem = 0;
  String countItemStr = "";
  bool isLoggedIn;
  bool isAdmin = false;

  AppMethods appMethods = new FirebaseMethods();

  // yohan added for drop down list
  List<DropdownMenuItem<String>> dropDownCategories;
  List<String> categoryList = new List();

// yohan added 21 july
   final scaffoldKey = new GlobalKey<ScaffoldState>();

   void _showDialogMoreThanStock() {
     // flutter defined function
     showDialog(
       context: context,
       builder: (BuildContext context) {
         // return object of type Dialog
         return AlertDialog(
           title: new Text("Stock is not enough, can not add more"),
           //content: new Text("Alert Dialog body"),
           actions: <Widget>[
             // usually buttons at the bottom of the dialog
             new FlatButton(
               child: new Text("OK"),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
           ],
         );
       },
     );
   }

  @override
  void initState() {
    // TODO: implement initState



    print('test yohan here ******************************************');
    getCurrentUser();
    super.initState();

    getNumberOfItems();
    categoryList = new List.from(localCatgeories);
    dropDownCategories = buildAndGetDropDownItems(categoryList);
  }

  bool inprocess = false;



   Future<bool> addUpdateCarts  (RecordProduct recordTemp) async  {
   bool isExist = false;
    //print ('go in');
    await Firestore.instance.collection('carts')
        .where('acctFullName', isEqualTo:acctName )
        .where('confirmedPurchase', isEqualTo: false)
        .where('productId', isEqualTo: recordTemp.productId)
        .getDocuments().then((data) {
              //print ('go in 2');
              List<DocumentSnapshot> listDocSnapshot = data.documents;
              listDocSnapshot.forEach((snap) {
                final record2 = RecordCart.fromSnapshot(snap);

                String docid2 = snap.documentID;
                //print ('yohan docID: $docid2');


                if (snap.data['qty'] + 1 > recordTemp.stockQty) {
                  //print ('more than stock');
                  _showDialogMoreThanStock();
                  //return true;
                } else {
                  Firestore.instance.collection('carts').document(
                      snap.documentID).updateData(
                    { 'qty': snap.data['qty'] + 1
                    },

                  );
                };
               isExist = true;

                //print ('go to true');

                return  true;


              });
    }).whenComplete(() {
      print ('test');

      if (!isExist) {
        print ('to add');

      }
    });

    print('yohan last return : $isExist');

    if (!isExist) {
      //print ('to add');
      if (!inprocess) {
        Firestore.instance.collection('carts')
            .document()
            .setData(
            { 'userId': userId,
              'acctFullName': acctName,
              'confirmedPurchase': false,

              // yohan 29 jul 2019
              //'confirmedDate' : DateTime.now(),
              'confirmedDate' : parseTime(DateTime.now()),

              'productId': recordTemp.productId,
              'productURL': recordTemp.productURL,
              'productPrice': recordTemp.price,
              'name': recordTemp.name,
              'qty': 1,
              'orderFulfill' : false,
              'orderFulfillQty' : 0,
              'stockQty' : 0,

            }).whenComplete(() {
          inprocess = false;
        });
        inprocess = true;
      }
    }

   getNumberOfItems();
    return isExist;
  } // end checkCartsExists

  Future getNumberOfItems() async {
   ///print ('go in');

    //int count;
    await print ('user id: ${acctName}');

    await Firestore.instance.collection('carts')
        .where('acctFullName', isEqualTo:acctName )
        .where('confirmedPurchase', isEqualTo: false)
        .getDocuments().then((data) {
          //print ("${data.documents.length}"
           // count = data.documents.length.toInt();
            //countItemStr = data.documents.length.toString();

          num cnt = 0;

          List<DocumentSnapshot> listDocSnapshot =data.documents ;
          listDocSnapshot.forEach((snap) {
            final record2 =  RecordCart.fromSnapshot(snap);

            setState(() {
              cnt = cnt + record2.qty;
              print ('countAtMyHomePage ${cnt}');
              countItemStr = cnt.toString();
            });
          });

    }
    );


       /* .snapshots().length.then((data) {
          print(data.toString());*/
    //);
   // print (countItem);
    setState(() {});
  }

  Future getCurrentUser() async {

    acctName =  await getStringDataLocally(key: acctFullName);
    acctEmail = await getStringDataLocally(key: userEmail);
    acctPhotoURL = await getStringDataLocally(key: photoURL);
    isLoggedIn = await getBoolDataLocally(key: loggedIN);
    userId = await getStringDataLocally(key:userID);

    //print(await getStringDataLocally(key: userEmail));
    acctName == null ? acctName = "Guest User" : acctName;
    acctEmail == null ? acctEmail = "guestUser@email.com" : acctEmail;
    if (acctEmail == 'yohan_i@yahoo.com') {
      isAdmin = true;
    }else {
      isAdmin = false;
    }

    setState(()
    {

    });
    await print ('user id: ${acctName}');
    await getNumberOfItems();
  }

  String _checkStr(String str)  {

      return str != null ? str : '';
  }



  Widget _buildBody(BuildContext context) {
    //return _buildList(context, dummySnapshot);



    if (_value =='Category') {
      return StreamBuilder<QuerySnapshot>(

        // Yohan try to filter using key word
        stream: Firestore.instance.collection('products').where('stockQty',isGreaterThan: 0).snapshots(),
        builder: (context, snapshot) {
         // if (!snapshot.hasData) return LinearProgressIndicator();



          if (!snapshot.hasData) {

           /* return  Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                    Icon(Icons.star, size : 50),
               ]
              );
*/
            return new Center(
              child: new Container(
                height: 300.0,
                width: 300.0,
                child: /*new CustomPaint(
                  foregroundPainter: new MyPainter(
                      lineColor: Colors.amber,
                      completeColor: Colors.blueAccent,
                      completePercent: percentage,
                      width: 8.0
                  ),
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new RaisedButton(
                        color: Colors.purple,
                        splashColor: Colors.blueAccent,
                        shape: new CircleBorder(),
                        child: new Text("Click"),
                        onPressed: (){
                          setState(() {
                            percentage += 10.0;
                            if(percentage>100.0){
                              percentage=0.0;
                            }
                          });
                        }),
                  ),
                )*/
                /* new Container(
                 child: CircularProgressIndicator(),
                 )
*/
                  new Column(
                    children: [ CircularProgressIndicator(),
                      new Text(""),
                      new Text("Data Loading, you may proceed to login"),
                      new IconButton(
                        icon: new Icon(Icons.exit_to_app),
                        onPressed: () { checkIfLoggedIn(); /* Your code */ },
                      )
                ]
              )

              ) ,
              );


            /*return Text("Data is loading, please login",
                style: new TextStyle(fontSize: 25.0),
            );*/
              //LinearProgressIndicator(semanticsLabel: 'test1245555');
          }

          return _buildList(context, snapshot.data.documents);
        },
      );
    } else {
      return StreamBuilder<QuerySnapshot>(

      // Yohan try to filter using key word
      stream: Firestore.instance.collection('products').where('category', isEqualTo: _value)
                      .where('stockQty',isGreaterThan: 0).snapshots(),
      builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
      },
      );
    }
/*
   void _showDialog2Login() {

     showDialog(
       context: context,
       builder: (BuildContext context) {
         // return object of type Dialog
         return AlertDialog(
           title: new Text("Please proceed with login during loading"),
           //content: new Text("Alert Dialog body"),
           actions: <Widget>[
             // usually buttons at the bottom of the dialog
             new FlatButton(
               child: new Text("OK"),
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



  }


  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {

    return ListView(
       //padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );

  }




  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = RecordProduct.fromSnapshot(data );
    return Card (
     // margin: const EdgeInsets.only(top: 1.0),
      child: new Column(
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
                 /* new Text(' -  ${record.category}' ,
                    style: new TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),*/

                   new IconButton(
                      icon: new Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      ),

                      onPressed: () {
                        //final cartsExists =  checkCartsExists(record.productId);
                        final cartsExists =  addUpdateCarts(record);
                        getNumberOfItems();
                      }),
                ],
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Row(
                       children:[
                         new Text( 'S\$ ${record.price.toString()}', //record.price.toString(),
                             style: new TextStyle(
                                 fontSize: 16.0, fontWeight: FontWeight.normal)),
                         new Text( '   Stock Qty : ${record.stockQty.toString()}', //record.price.toString(),
                             style: new TextStyle(
                                 fontSize: 15.0, fontWeight: FontWeight.normal)),

                       ]

                     ),
                   /* new Text( 'Price : S\$ ${record.price.toString()}', //record.price.toString(),
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),*/
                   Row (
                     children : [
                       new Text('${record.category} - ' ,
                         style: new TextStyle(fontSize: 17.0, color: Colors.grey),
                       ),
                       new Text(_checkStr(record.description),
                           style: new TextStyle(
                               fontSize: 15.0, fontWeight: FontWeight.normal)),
                       ]
                   ),

                   /*Padding (
                     padding: EdgeInsets.only(top: 8.0),//EdgeInsets.all(8.0),
                     child:

                         new Text(_checkStr(record.description),
                         style: new TextStyle(
                             fontSize: 16.0, fontWeight: FontWeight.normal)),
                   ),*/

                  ]),

             // contentPadding: const EdgeInsets.only(top: 10.0),

              onTap: () {
                {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) =>
                       new AldreyItemDetail( data: record)
                      //new GirliesMessages()
                  ));
                }
                //print('teston tap');
              },

              onLongPress: (){
               // prodDelete = false;

                if (isAdmin) {
                  _showDialogDelete(record);
                } else {
                  print ('as different user');
                }


              },
            ),
          ]
      ),
    );
  }

  // yohan - search still trying
  Icon _searchIcon = new  Icon(
   Icons.search,
   color: Colors.white,
 );

  String _searchText = "";
  Widget _appBarTitle = new Text( 'Aldrey Craft' );
  final TextEditingController _filter = new TextEditingController();

  //bool prodDelete;

// user defined function
  void _showDialogDelete(RecordProduct record) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Delete?"),
          //content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                Firestore.instance
                    .collection('products')
                    .document(record.productId)
                    .delete()
                    .catchError((e) {
                  print(e);
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


  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle =  productDropDown(
            textTitle: "Product Category",
            //selectedItem: selectedCategory,
            dropDownItems: dropDownCategories,
            //changedDropDownItems: changedDropDownCategory
          );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Aldrey Craft');
        //filteredNames = names;
        //_filter.clear();
      }
    });
  }

 /* _MyHomePageState() {
    _filter.addListener(() {
      //print (_filter.text);
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";

          //filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;

        });
      }

      //print (_searchText);
    });
  }
*/



  String _value = 'Category';
//girlies original
  @override
  Widget build(BuildContext context) {

    this.context = context;


    checkLogin() {
      if (acctEmail == "guestUser@email.com") {
        showSnackBar("Please login first", scaffoldKey);
        return;
      }
    }



    return new Scaffold(

      // yohan added 21 july
      key: scaffoldKey,

      appBar: new AppBar(
        title:


        // yohan dropdown
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new DropdownButton<String>(
              value: _value,
              items: dropDownCategories,
              onChanged: (String value) {

                setState(() => _value = value);
              },
            ),

          ],
        ),

        // yohan to show search  button - working
        //_appBarTitle,

        // Yohan to show admin page - working
        /*GestureDetector(
          onLongPress: openAdmin,
          child: new Text("Girlies"),
        ),*/
        centerTitle: false,
        actions: <Widget>[

      isAdmin ? new IconButton(
              icon: new Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {

                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new AdminHome()));

              }) : new Text(''),
/*          new Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            new GirliesMessages()));
                  }),
              new CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.red,
                child: new Text(
                  "0",
                  style: new TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              )
            ],
          )*/
        ],
      ),

      // yohan combine with listview
      body: _buildBody(context),

      floatingActionButton: new Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[


          new FloatingActionButton(
            onPressed: () async{

              if (acctEmail == "guestUser@email.com") {return; }

              final resultCount = await
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new AldreyCart(data2 : acctName, param2 : acctName )));

              countItemStr = await resultCount??'';
              print('resultcount yohan:  ${resultCount}');
            },

             child : new Icon(Icons.shopping_cart),
          ),
          new CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.red,
            child: new Text(
              //"0",
              countItemStr,
              style: new TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          )
        ],
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(acctName),
              accountEmail: new Text(acctEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                child: new Icon(Icons.person),
              ),
            ),
        /*    new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Order Notifications"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new GirliesNotifications()));
              },
            ),*/
           !isAdmin ? new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Order History"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new AldreyCartHistory()));
              },
            ): new Container(width : 0 , height : 0),
        /*    new Divider(),
            !isAdmin ? new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Profile Settings"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new GirliesProfile()));
              },
            ):  new Container(width : 0 , height : 0),*/
            !isAdmin ? new ListTile(
              leading: new CircleAvatar(
                child: new Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("Delivery Address"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Address(pAcctName : acctName, fromOrder: false,)));
              },
            ):  new Container(width : 0 , height : 0),
            !isAdmin ? new Divider(): new Container(width : 0 , height : 0),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(
                  Icons.help,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text("About Us"),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new AboutUs()));
              },
              //
            ),
            new ListTile(
              trailing: new CircleAvatar(
                child: new Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              title: new Text(isLoggedIn == true ? "Logout" : "Login"),
              onTap: checkIfLoggedIn,
            ),
          ],
        ),
      ),
    );
  }

  checkIfLoggedIn() async {
    if (isLoggedIn == false) {
      bool response = await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new GirliesLogin()));
      if (response == true) getCurrentUser();
      return;
    }
    bool response = await appMethods.logOutUser();
    if (response == true) getCurrentUser();
  }

  openAdmin() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new AdminHome()));
  }



}