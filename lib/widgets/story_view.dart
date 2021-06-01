import 'package:flutter/material.dart';

class StoryItems extends StatefulWidget {
  @override
  _StoryItemsState createState() => _StoryItemsState();
}

class _StoryItemsState extends State<StoryItems> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      child: ListView.builder(
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            print(index);
            return GestureDetector(
              onTap: () {
                print('Cargar story');
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Stack(
                  children: [
                    Container(
                      height: 65.0,
                      width: 75.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/cm0.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50.0,
                      right: 25.0,
                      child: Icon(
                        Icons.add_circle,
                        size: 24.0,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Stack(
              children: [
                Container(
                  height: 65.0,
                  width: 75.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/cm0.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 50.0,
                  right: 25.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage('assets/images/cm0.jpeg'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
