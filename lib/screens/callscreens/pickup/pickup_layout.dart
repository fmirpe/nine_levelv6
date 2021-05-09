import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nine_levelv6/models/call.dart';
import 'package:nine_levelv6/resources/call_methods.dart';
import 'package:nine_levelv6/screens/callscreens/pickup/pickup_screen.dart';
import 'package:nine_levelv6/view_models/user/user_view_model.dart';
import 'package:provider/provider.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final UserViewModel userProvider =
        Provider.of<UserViewModel>(context, listen: false);

    userProvider.setUser();
    return (userProvider != null && userProvider.user != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.exists) {
                  Call call = Call.fromMap(snapshot.data.data());

                  if (!call.hasDialled) {
                    return PickupScreen(call: call);
                  }
                } else {
                  return scaffold;
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
