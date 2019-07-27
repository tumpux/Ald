import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_girlies_store/tools/app_data.dart';
import 'package:flutter_girlies_store/tools/app_tools.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'; // additional import because adding .path
import 'package:firebase_storage/firebase_storage.dart'; // ys added
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:image/image.dart' as ImageLib;
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'dart:isolate';
import 'dart:async';


class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}


/*const String _imageUrlOne = 'https://firebasestorage.googleapis.com/v0/b/aldrey-craft.appspot.com/o/20190301_213014.jpg?alt=media&token=5f32bc38-1ced-4589-92b5-7e586ecec034';

class ImageUrl extends StatelessWidget {
  final String imageUrl;
  ImageUrl({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Image.network(im ageUrl);
  }
}*/

class Record {
  final String name;
  final DocumentReference reference;
  final String productURL;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
  //assert(map['productURL'] != null),
        name = map['name'],
        productURL = map['productURL']

  ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name;$productURL>";

}

class _AddProductsState extends State<AddProducts>  {
/*  List<DropdownMenuItem<String>> dropDownColors;
  String selectedColor;
  List<String> colorList = new List();

  List<DropdownMenuItem<String>> dropDownSizes;
  String selectedSize;
  List<String> sizeList = new List();*/

  List<DropdownMenuItem<String>> dropDownCategories;
  String selectedCategory;
  List<String> categoryList = new List();

  Map<int, File> imagesMap = new Map();

  TextEditingController prodcutTitle = new TextEditingController();
  TextEditingController prodcutPrice = new TextEditingController();
  TextEditingController prodcutDesc = new TextEditingController();


  @override
  void clearTxt() {
    // Clean up the controller when the Widget is removed from the Widget tree

    prodcutTitle.clear();
    prodcutPrice.clear();
    prodcutDesc.clear();
    imageList.clear();
    //prodcutTitle.dispose();
    //super.dispose();

    setState(() {
      imageList.clear();
      // tutor
      //filename= basename(file.path);
    });

    initState();
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _downloadURL;
  //String _downloadURL ='https://firebasestorage.googleapis.com/v0/b/aldrey-craft.appspot.com/o/20190301_213014.jpg?alt=media&token=5f32bc38-1ced-4589-92b5-7e586ecec034';
  /*Future downloadImage() async {
    const _prevURL = 'https://firebasestorage.googleapis.com/v0/b/aldrey-craft.appspot.com/o/20190301_215320.jpg?alt=media&token=88b56405-020c-4e66-8db3-9a2fdf85e9c5';
        //'https://firebasestorage.googleapis.com/v0/b/fir-demo-20870.appspot.com/o/myimage.jpg?alt=media&token=31d2f9e3-1c45-442b-855c-660cbb07bbe9';

    setState(() {
      _downloadURL = _prevURL;
    });
  }*/



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  /*  colorList = new List.from(localColors);
    sizeList = new List.from(localSizes);*/
    categoryList = new List.from(localCatgeories);
/*    dropDownColors = buildAndGetDropDownItems(colorList);
    dropDownSizes = buildAndGetDropDownItems(sizeList);*/
    dropDownCategories = buildAndGetDropDownItems(categoryList);
 /*   selectedColor = dropDownColors[0].value;
    selectedSize = dropDownSizes[0].value;*/
    selectedCategory = dropDownCategories[0].value;


  }

  File file;
  Future getImage(String sourceimage) async {

    if (sourceimage == 'Camera') {
      file = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 480, maxWidth: 640);
    } else {
      file = await ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    }
    if (file != null) {
      //imagesMap[imagesMap.length] = file;

      //yohan2 added compress
      //file =  await compressImage(file) ;

      List<File> imageFile = new List();

      //imageFile.add(CompressAndGetFile(file,file.absolute.path));
      imageFile.add(file);


      imageList = new List.from(imageFile);
      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {
        // tutor
        filename= basename(file.path);
      });
    }

  }

  num _itemCount = 1 ;

  @override
  Widget build(BuildContext context) {

    File file;




    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new AppBar(
        title: new Text("Add Products"),
        centerTitle: false,
        elevation: 0.0,
    /*    actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
              new RaisedButton.icon(
                color: Colors.green,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(15.0))),
                onPressed: ()
                  //=> pickImage(),

                    => getImage(),

                icon: Icon(
                  Icons.add,
                  color: Colors.white,),
                label: new Text(
                  "Add Images",
                  style: new TextStyle(color: Colors.white),
                )),

          )
        ],*/
      ),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
            <Widget>[
            new SizedBox(
              height: 10.0,
            ),
            MultiImagePickerList(
                imageList: imageList,
                removeNewImage: (index) {
                  removeImage(index);
                }),
            //new ImageUrl(imageUrl: _imageUrlOne,),
          /*  new SizedBox(
              height: 10.0,
            ),*/
            productTextField(
                textTitle: "Product Title",
                textHint: "Enter Product Title",
                controller: prodcutTitle),
            /*new SizedBox(
              height: 10.0,
            ),*/
            productTextField(
                textTitle: "Product Price",
                textHint: "Enter Product Price",
                textType: TextInputType.number,
                controller: prodcutPrice),
           /* new SizedBox(
              height: 10.0,
            ),*/
            productTextField(
                textTitle: "Product Description",
                textHint: "Enter Description",
                controller: prodcutDesc,
                height: 80.0),
           /* new SizedBox(
              height: 10.0,
            ),*/

            // try to add qty
            Row(
              children: <Widget>[
/*new SizedBox(
  width:40,
               child: FlatButton.icon(
                  color: Colors.red,
                  icon: Icon(Icons.remove), //`Icon` to display
                  label: Text('-'), //`Text` to display
                  onPressed: () =>setState(()=>_itemCount--),
                ),

),*/             new Padding(
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
            // end try to add qty

            productDropDown(
                textTitle: "Product Category",
                selectedItem: selectedCategory,
                dropDownItems: dropDownCategories,
                changedDropDownItems: changedDropDownCategory),
          /*  new SizedBox(
              height: 10.0,
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                /*productDropDown(
                    textTitle: "Color",
                    selectedItem: selectedColor,
                    dropDownItems: dropDownColors,
                    changedDropDownItems: changedDropDownColor),
                productDropDown(
                    textTitle: "Size",
                    selectedItem: selectedSize,
                    dropDownItems: dropDownSizes,
                    changedDropDownItems: changedDropDownSize), */
              ],
            ),
           /* new SizedBox(
              height: 20.0,
            ),
*/

            appButton(
                btnTxt: "Add Product",
                onBtnclicked:
                    // ys - adduploadImage
                    ()  {
                      //file = await compressImage(file);

                      if (imageList == null || imageList.isEmpty) {
                        showSnackBar("Product Images cannot be empty", scaffoldKey);
                        return;
                      }
                      addNewProducts();
                      uploadProduct();
                      },
                //{ uploadImage(); },
                // ys- change this, folow tutor - addNewProducts,
                btnPadding: 20.0,
                btnColor: Theme.of(context).primaryColor),
            new SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

        new RaisedButton.icon(
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                borderRadius:
                new BorderRadius.all(new Radius.circular(15.0))),
            onPressed: ()
            //=> pickImage(),

            => getImage('Gallery'),

            icon: Icon(
              Icons.photo_camera,
              color: Colors.black,),
            label: new Text(
              "Images (Camera)",
              style: new TextStyle(color: Colors.black),
            )),

            new RaisedButton.icon(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(15.0))),
                onPressed: ()
                //=> pickImage(),

                => getImage('Camera'),

                icon: Icon(
                  Icons.photo_library,
                  color: Colors.black,),
                label: new Text(
                  "Images (Gallery)",
                  style: new TextStyle(color: Colors.black),
                )),
          ],
        ),

            /*RaisedButton (
              child : Text('Download Image'),
              onPressed: () {
                downloadImage();
              },
            ),*/

            // yohan remark this first
            //_downloadURL==null? Container() : Image.network(_downloadURL),

            // ys added
            /*MultiImagePickerList(
                imageList: imageList2,
                removeNewImage: (index) {
                  removeImage(index);
                }),*/


          ],
        ),
      ),
    );
  }
/*
  void changedDropDownColor(String selectedSize) {
    setState(() {
      selectedColor = selectedSize;
    });
  }*/

  void changedDropDownCategory(String selectedSize) {
    setState(() {
      selectedCategory = selectedSize;
    });
  }

 /* void changedDropDownSize(String selected) {
    setState(() {
      selectedSize = selected;
    });
  }*/

  List<File> imageList;
  String filename;
  //File file;

  /*Future <File> CompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
      rotate: 180,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }*/


  //Yohan2 try compress
  /*Future<void> getCompressedImage(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);
    List msg = (await receivePort.first) as List;

    String srcPath = msg[0];
    String name = msg[1];
    String destDirPath = msg[2];
    SendPort replyPort = msg[3];

    ImageLib.Image image =
    ImageLib.decodeImage(await new File(srcPath).readAsBytes());

    if (image.width > 500 || image.height > 500) {
      image = ImageLib.copyResize(image, 500);
    }

    File destFile = new File(destDirPath + '/' + name);
    await destFile.writeAsBytes(ImageLib.encodeJpg(image, quality: 60));

    replyPort.send(destFile.path);
  }

  Future<File> compressImage(File f) async {
    ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(getCompressedImage, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;

    ReceivePort receivePort2 = ReceivePort();

    sendPort.send([
      f.path,
      f.uri.pathSegments.last,
      (await getTemporaryDirectory()).path,
      receivePort2.sendPort,
    ]);

    var msg = await receivePort2.first;

    return new File(msg);
  }*/
  //Yohan2 end try compress

// below I remove first this is the original work without compress
  /*pickImage() async {
      file = await ImagePicker.pickImage(source: ImageSource.gallery);

    /* yohan compress working but slow
     if (file != null ) {


       final tempDir = await getTemporaryDirectory();
       final path = tempDir.path;
       int rand = new Math.Random().nextInt(10000);

       Im.Image image = Im.decodeImage(file.readAsBytesSync());
       Im.Image smallerImage = Im.copyResize(image, 500); // choose the size here, it will maintain aspect ratio

       var compressedImage = new File('$path/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

       List<File> imageFile = new List();

       //imageFile.add(CompressAndGetFile(file,file.absolute.path));
       imageFile.add(compressedImage);


       imageList = new List.from(imageFile);
       if (imageList == null) {
         imageList = new List.from(imageFile, growable: true);
         for (int s = 0; s < imageFile.length; s++) {
           imageList.add(compressedImage);
         }
       }
       setState(() {
         // tutor
         filename= basename(file.path);
       });
     } */

     // backup original file upload without compress
    if (file != null) {
      //imagesMap[imagesMap.length] = file;

      //yohan2 added compress
      file = await compressImage(file);

      List<File> imageFile = new List();

      //imageFile.add(CompressAndGetFile(file,file.absolute.path));
      imageFile.add(file);


      imageList = new List.from(imageFile);
      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {
        // tutor
        filename= basename(file.path);
      });
    }
  }

*/ //end pickimage

  removeImage(int index) async {
    //imagesMap.remove(index);
    imageList.removeAt(index);
    setState(() {});
  }

  // yohan try - still wrong
  /*final FirebaseApp app = await FirebaseApp.configure(
  name: 'yourappname',
  options: const FirebaseOptions(
  googleAppID: 'yourgoogleid',
  gcmSenderID: 'yourgmssenderid',
  apiKey: 'yourapikey',
  projectID: 'yourprojectid',
  ),
  );
  final Firestore firestore = Firestore(app: app);
  final Firestore firestore;
  CollectionReference get messages => firestore.collection('products');*/

  Future<String> uploadProduct() async {
  //void uploadProduct(String url)  {

    // yohan comment below first as want to save field first
    print ('test upload produc');


    StorageReference ref = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask= ref.putFile(file);
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    //var url = await ref.getDownloadURL() as String;




    print ("Download URL : $url");

    Firestore.instance.collection('products').document().setData(
        {'name': prodcutTitle.text, //'Test123',
          'description' : prodcutDesc.text,
          'price' : double.parse(prodcutPrice.text),
          'category' : selectedCategory,
          'stockQty' : _itemCount,
          'productURL' : url,
          'timeAdded' : new DateTime.now(),
          //'category' :
        });


    clearTxt();
    //return 'test';

    //return url;

    // yohan added to save data -- still wrong
   /* final DocumentReference postRef = firestore.document('posts/123');
    firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{'name': new Text('TEst123')});
      }
    });

    final productColl = FirebaseDatabase.instance.reference().child('products');

    productColl.push().set({
    'name': 'test123',
    //'description': 'Programming Tutorials'
    }).then((_) {
    // ...
    });
*/


  }


  addNewProducts() {

    /*if (imageList == null || imageList.isEmpty) {
      showSnackBar("Product Images cannot be empty", scaffoldKey);
      return;
    }*/

    if (prodcutTitle.text == "") {
      showSnackBar("Product Title cannot be empty", scaffoldKey);
      return;
    }

    if (prodcutPrice.text == "") {
      showSnackBar("Product Price cannot be empty", scaffoldKey);
      return;
    }

   /* if (prodcutDesc.text == "") {
      showSnackBar("Product Description cannot be empty", scaffoldKey);
      return;
    } */

    if (selectedCategory == "Select Product category") {
      showSnackBar("Please select a category", scaffoldKey);
      return;
    }

   /*if (selectedColor == "Select a color") {
      showSnackBar("Please select a color", scaffoldKey);
      return;
    }

    if (selectedSize == "Select a size") {
      showSnackBar("Please select a size", scaffoldKey);
      return;
    }*/

    Map newProduct = {};



  }


  // yohan added to try save to database
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      // padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
  }
  // end yohan

}
