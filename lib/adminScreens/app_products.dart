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
import 'package:flutter_girlies_store/userScreens/cart.dart';
import 'package:flutter_girlies_store/userScreens/notifications.dart';
import 'package:flutter_girlies_store/userScreens/history.dart';
import 'package:flutter_girlies_store/userScreens/profile.dart';
import 'package:flutter_girlies_store/userScreens/delivery.dart';
import 'package:flutter_girlies_store/userScreens/aboutUs.dart';
import 'package:flutter_girlies_store/userScreens/login.dart';
import 'package:flutter_girlies_store/tools/recCart.dart';
import 'package:flutter_girlies_store/adminScreens/itemModify.dart';
import 'package:flutter_girlies_store/userScreens/address.dart';

class AppProducts extends StatefulWidget {
  // yohan added for 2nd page cart to return value
  //AppProducts(this.indx) ;
  //final String indx;
  AppProducts() ;

  @override
  _AppProductsState createState() => _AppProductsState();
  //_AppProductsState createState() => _AppProductsState(indx);
}
class _AppProductsState extends State<AppProducts> {

  // yohan added for 2nd page cart to return value
  /*String indx;
  _AppProductsState(this.indx);*/

  _AppProductsState();

  BuildContext context;
  String acctName = "";
  String acctEmail = "";
  String acctPhotoURL = "";
  String userId = "";
  int countItem = 0;
  String countItemStr = "";
  bool isLoggedIn;

  AppMethods appMethods = new FirebaseMethods();

  // yohan added for drop down list
  List<DropdownMenuItem<String>> dropDownCategories;
  List<String> categoryList = new List();

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

  Future getNumberOfItems() async {

    await print ('user id: ${acctName}');

    await Firestore.instance.collection('carts')
        .where('acctFullName', isEqualTo:acctName )
        .where('confirmedPurchase', isEqualTo: false)
        .getDocuments().then((data) {
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
        stream: Firestore.instance.collection('products')
            //.where('stockQty',isGreaterThan: 0)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

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

                ],
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        children:[
                          new Text( 'Price : S\$ ${record.price.toString()}', //record.price.toString(),
                              style: new TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.normal)),
                          new Text( '   Stock Qty : ${record.stockQty.toString()}', //record.price.toString(),
                              style: new TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.normal)),

                        ]

                    ),

                    Row (
                        children : [
                          new Text('${record.category} - ' ,
                            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
                          ),
                          new Text(_checkStr(record.description),
                              style: new TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.normal)),
                        ]
                    ),

                  ]),

              onTap: () {
                {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) =>

                      new AldreyItemModify( data: record)
                    //new GirliesMessages()
                  ));
                }

              },

              onLongPress: (){
                // prodDelete = false;
                if (acctEmail == 'yohan_i@yahoo.com' ) {
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

  String _value = 'Category';
//girlies original
  @override
  Widget build(BuildContext context) {

    this.context = context;
    return new Scaffold(
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


        centerTitle: false,
     /*   actions: <Widget>[

          new IconButton(
              icon: new Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {

                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new AdminHome()));

              }),

        ],*/
      ),

      // yohan combine with listview
      body: //new Text ('test'),
      _buildBody(context),

      floatingActionButton: new Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
        ],
      ),
/*      drawer: new Drawer(
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

            new Divider(),
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
                    builder: (BuildContext context) => new GirliesAboutUs()));
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
      ),*/
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