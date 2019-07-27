import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girlies_store/userScreens/_product.dart';

import 'package:photo_view/photo_view.dart';
import 'package:flutter_girlies_store/tools/recProduct.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:flutter_girlies_store/tools/app_data.dart';


class AldreyItemModify extends StatefulWidget {
  final RecordProduct data;

  //AldreyItemDetail({this.data});
  AldreyItemModify({Key key, @required this.data}) : super(key: key);

  @override
  _AldreyItemModifyState createState() => _AldreyItemModifyState(data);
}

class _AldreyItemModifyState extends State<AldreyItemModify> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    categoryList = new List.from(localCatgeories);
    dropDownCategories = buildAndGetDropDownItems(categoryList);

    selectedCategory = data.category;
    prodcutTitle.text = data.name;
    prodcutDesc.text = data.description;
    prodcutPrice.text = data.price.toString();

    print ('stock qty : ${data.stockQty}');
    _itemCount = data.stockQty;


  }

  String selectedCategory;
  List<String> categoryList = new List();

  List<DropdownMenuItem<String>> dropDownCategories;
  TextEditingController prodcutTitle = new TextEditingController();
  TextEditingController prodcutPrice = new TextEditingController();
  TextEditingController prodcutDesc = new TextEditingController();
  TextEditingController prodcutCategory = new TextEditingController();

  RecordProduct data;
  _AldreyItemModifyState (this.data);

  void changedDropDownCategory(String selectedSize) {
    setState(() {
      selectedCategory = selectedSize;

    });
  }

  num _itemCount = 0;

  _buildBody() {
    //return new SingleChildScrollView(
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        <Widget>[
          new SizedBox(
            height: 10.0,
          ),


          productTextField(
              textTitle:
              //data.name,
              "Product Title",
              textHint: data.name, //"Enter Product Title",
              controller: prodcutTitle),
          /*new SizedBox(
              height: 10.0,
            ),*/
          productTextField(
              textTitle: "Product Price",
              textHint:data.price.toString(),
              textType: TextInputType.number,
              controller: prodcutPrice),
          /* new SizedBox(
              height: 10.0,
            ),*/
          productTextField(
              textTitle: "Product Description",
              textHint: data.description,
              controller: prodcutDesc,
            //  height: 80.0
          ),

          productDropDown(
              textTitle: "Product Category",
              selectedItem: selectedCategory,
              dropDownItems: dropDownCategories,
              changedDropDownItems: changedDropDownCategory),



          // end try to add qty

          Row(
            children: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(8.0),
                child:   new Text('Stock Qty: ', style:
                new TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              _itemCount!=0? new  IconButton(icon: new Icon(Icons.remove),color: Colors.white,  onPressed: ()=>setState(()=>_itemCount--),):new Container(),
              //new IconButton(icon: new Icon(Icons.remove),onPressed: ()=>setState(()=>_itemCount--)),
              new Text(_itemCount.toString(), style:
              new TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
              //new IconButton(icon: new Icon(Icons.add),onPressed: ()=>setState(()=>_itemCount++))
              new IconButton(icon: new Icon(Icons.add),color: Colors.white,onPressed: (){ _itemCount=_itemCount+1; print (_itemCount);setState((){_itemCount;});})
            ],
          ),

          appButton(
              btnTxt: "Modify Product",
              onBtnclicked: ()  {
                print ('modify product : ${selectedCategory}');


                Firestore.instance.collection('products').document(
                    data.productId).updateData(
                  { 'name' : prodcutTitle.text,
                    'price' : double.parse( prodcutPrice.text),
                    'description': prodcutDesc.text,
                    'category': selectedCategory,
                    'stockQty' : _itemCount,
                  },
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Stock is updated"),
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


              },
              //{ uploadImage(); },
              // ys- change this, folow tutor - addNewProducts,
              btnPadding: 5.0,
              btnColor: Theme.of(context).primaryColor),
        /*  new SizedBox(
            height: 20.0,
          ),*/

           new Image.network(data.productURL,
            fit: BoxFit.contain,
            width: 100.0,
            height: 100.0,
          ),

          ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Product"),
        centerTitle: false,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body:
           _buildBody(),
          // new Text('test'),
/*      new Center(
          child :  PhotoView(
            imageProvider : NetworkImage(data.productURL,
              //fit: BoxFit.cover,
            )
            ,)

      ),*/
    );
  }
}
