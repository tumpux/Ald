import 'dart:io';

import 'package:flutter_girlies_store/tools/firebaseCarts_api.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class AddCartDialog extends StatefulWidget {
  final String acctFullName;
  final bool confirmedPurchase;

  AddCartDialog({this.acctFullName, this.confirmedPurchase});

  @override
  _AddCartDialogState createState() => _AddCartDialogState();
}

class _AddCartDialogState extends State<AddCartDialog> {
  final _formAddCartKey = GlobalKey<FormState>();
  String _acctFullName;
//  Future<File> _imageFile;

  String validateAcctFullName(String value) {
    if (value.isEmpty) {
      return "Please Login ";
    } else {
      return null;
    }
  }

//  Widget _previewImage() {
//    return FutureBuilder<File>(
//        future: _imageFile,
//        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//          if (snapshot.connectionState == ConnectionState.done &&
//              snapshot.data != null) {
//            return Image.file(snapshot.data);
//          } else if (snapshot.error != null) {
//            return const Text(
//              'Error picking image.',
//              textAlign: TextAlign.center,
//            );
//          } else {
//            return const Text(
//              'You have not yet picked an image.',
//              textAlign: TextAlign.center,
//            );
//          }
//        });
//  }

//  getImage(){
//    _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              final form = _formAddCartKey.currentState;
              if (form.validate()) {
                form.save();
               /* if (widget.name != null && widget.name.isNotEmpty) {
                  FireBaseCartAPI.updateCart(widget.docId, _acctFullName);
                } else {*/
                  FireBaseCartAPI.addCart(_acctFullName);
              //  }
                Navigator.pop(context);
              }
            },
            child: /*Text(
              widget.name != null && widget.name.isNotEmpty ? "UPDATE" : 'SAVE',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),*/
            Text('test first'),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: _formAddCartKey,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Login name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            keyboardType: TextInputType.text,
          /*  initialValue: widget.name != null && widget.name.isNotEmpty
                ? widget.name
                : "",*/
            validator: (value) {
              return validateAcctFullName(value);
            },
            onSaved: (value) => _acctFullName = value,
          ),
        ),
      ),
    );
  }
}
