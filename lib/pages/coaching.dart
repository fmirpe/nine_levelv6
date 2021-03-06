import 'package:flutter/material.dart';
import 'package:nine_levelv6/utils/constants.dart';

class CoachingPage extends StatefulWidget {
  CoachingPage({Key key}) : super(key: key);

  @override
  _CoachingPageState createState() => _CoachingPageState();
}

class _CoachingPageState extends State<CoachingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightButtom,
      appBar: AppBar(
        //scaffoldKey: widget.scaffoldKey,
        title: Text(
          'Coaching',
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
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset("assets/images/Coaching.png"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Coaching",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 2.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    "assets/images/CoachingApp.jpg",
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
                              "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno est??ndar de las industrias desde el a??o 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido us?? una galer??a de textos y los mezcl?? de tal manera que logr?? hacer un libro de textos especimen. No s??lo sobrevivi?? 500 a??os, sino que tambien ingres?? como texto de relleno en documentos electr??nicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creaci??n de las hojas 'Letraset', las cuales contenian pasajes de Lorem Ipsum, y m??s recientemente con software de autoedici??n, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum.")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
