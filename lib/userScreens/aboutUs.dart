import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_girlies_store/presentation/my_flutter_app_icons.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_girlies_store/tools/recAboutUs.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}


//List <String> imagesURL = [];

/*class BodyLayout extends StatelessWidget {

  Widget _myListView(BuildContext context) {




    return ListView.builder(
      itemCount: imagesURL.length,
      itemBuilder: (context, index) {



        return ListTile(
          title: //Text(imagesURL[index]), 
                Image.network(imagesURL[index])
        );

      },
    );




  }


  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

// replace this function with the code in the examples
Widget _myListView(BuildContext context) {
  return ListView();
}*/





class _AboutUsState extends State<AboutUs> {

  void initState() {
  /*  imagesURL = [];
    getAboutUsImg();*/

  }

  @override
  Widget build(BuildContext context) {
/*    return new Scaffold(
      appBar: new AppBar(
        title: new Text("About Us"),
        centerTitle: false,
      ),
      body: new Center(
        child: new Text(
          "About Girlies",
          style: new TextStyle(fontSize: 25.0),
        ),
      ),
    );*/

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Aldrey Craft Creation',
                    style: TextStyle(
                      fontSize : 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Reseller of Kay and Me Stories Indonesia',
                  style: TextStyle(
                    fontSize : 18.0,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
        /*  Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),*/
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         // _buildButtonColumn(color, Icons.call, 'CALL'),
        new  IconButton(icon: new Icon(MyFlutterApp.facebook_circled),color: color,
            onPressed: () {

              launch("https://www.facebook.com/pages/category/Home-Decor/Aldrey-Craft-Shop-885815921567931/");
              //print('test');
              //Share.share('check out my website https://www.facebook.com/pages/category/Home-Decor/Aldrey-Craft-Shop-885815921567931/');
            }),

          //_buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          //_buildButtonColumn(color, Icons.share, 'SHARE'),

      new  IconButton(icon: new Icon(Icons.share),color: color,
        onPressed: () {

          //print('test');
          Share.share('check out my website https://www.facebook.com/pages/category/Home-Decor/Aldrey-Craft-Shop-885815921567931/');
      }),

      new  IconButton(icon: new Icon(Icons.message),color: color,
          onPressed: () {

            //print('test');
            //Share.share('check out my website https://www.facebook.com/pages/category/Home-Decor/Aldrey-Craft-Shop-885815921567931/');

            whatsAppOpen();
      })




        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        'At Aldrey Craft, we believe that everyone is able to master in Art and Craft. '
            'Aldrey Craft Online Shop is where creative people shop. Founded in 2016 and based in Singapore. '
            'We are on the frontlines of the crafting industry, bringing you deals on the '
            'latest products for decoupage, papers, model clay, home decor and so much more!',

        softWrap: true,
        style: TextStyle(
          fontSize : 17.0,

        ),
      ),
    );



    return new Scaffold(
      appBar: new AppBar(
        title: new Text("About Us"),
        centerTitle: false,
      ),
      body:

      ListView(
        children: [
          SizedBox(
            height: 240.0,
            width: 600.0,
            child: Carousel(
              images:
              [

                Image.asset(
                  'images/mozaik.jpg',
                ),
                Image.asset(
                  'images/board.jpg',

                ),
                Image.asset(
                  'images/bear.jpg',

                ),
              ],
            ),
          ),


          titleSection,
          buttonSection,
          textSection,
        ],
      ),

    );


  }


  Image getimage1()  {
     Firestore.instance.collection('aboutUs')
    //.where('confirmedPurchase', isEqualTo: true)
     .where('picNo', isEqualTo: 1)
    //.where('orderFulfill', isEqualTo: false)
    //.orderBy('acctFullName')
        .getDocuments().then((data) {
      List<DocumentSnapshot> listDocSnapshot = data.documents;
      listDocSnapshot.forEach((snap) {

        final record = RecordAboutUs.fromSnapshot(snap );
        //listImageURL.add( record.URL);

        print (record.URL);
        return Image.network(record.URL);

      });
    });
  }

  /* void getAboutUsImg () async {

    await Firestore.instance.collection('aboutUs')

        .getDocuments().then((data) {
      List<DocumentSnapshot> listDocSnapshot = data.documents;
      listDocSnapshot.forEach((snap) {

        final record = RecordAboutUs.fromSnapshot(snap );

        imagesURL.add(record.URL);

      });
    });

    print ('length : ${imagesURL.length} ');

    ListView.builder(itemCount: imagesURL.length,
      itemBuilder: (context, int index){
        print (index);
        //print (imagesURL[index]);
      },
    );



  }

*/


  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(phone: "6583680409", message: "To AldreyCraft");
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
