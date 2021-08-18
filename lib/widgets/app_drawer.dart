import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rto_renters/screens/homee.dart';
import '../screens/application_screen.dart';
import '../screens/monthly_payment_screen.dart';
import '../screens/bail_payment_screen.dart';
import '../screens/edit_person_screen.dart';
import '../screens/user_houses_screen.dart';
import '../screens/person_details_screen.dart';
import '../screens/user_cancels_screen.dart';
import '../screens/home.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('R.T.O Menu'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.house_outlined),
            title: Text('Houses'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.request_quote),
            title: Text('Your Application'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ApplicationScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Request to cancel rent'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserCancelsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.view_column),
            title: Text('View Bail Payment'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(BailPaymentScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.view_column),
            title: Text('View Monthly Payments'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(MonthlyPaymentScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pay Bail'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeePage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pay House'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text('Set Person Details'),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(PersonDetailsScreen.routeName);
          //   },
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
