import 'package:flutter/material.dart';
import 'package:nine_levelv6/utils/constants.dart';

class MarketPlacePage extends StatefulWidget {
  MarketPlacePage({Key key}) : super(key: key);

  @override
  _MarketPlacePageState createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightButtom,
      appBar: AppBar(
        //scaffoldKey: widget.scaffoldKey,
        title: Text(
          'Marketplace',
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(
                      1.0), // Add 1.0 point padding to create border
                  height: 40.0, // ProfileImageSize = 50.0;
                  width: 40.0, // ProfileImageSize = 50.0;
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset("assets/images/Market.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Marketplace",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 2.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    "assets/images/marketplace.jpeg",
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                          style: TextStyle(color: Colors.white),
                          text:
                              "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas 'Letraset', las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum.")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
