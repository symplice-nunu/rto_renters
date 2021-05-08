import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rto_renters/screens/homee.dart';
import '../screens/orders_screen.dart';
import '../screens/user_houses_screen.dart';
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
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              
            },
          ),
           Divider(),
         
          ListTile(
            leading: Icon(Icons.money_off),
            title: Text('Request to cancel rent'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserHousesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pay Bail'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(HomeePage.routeName);
            },
          ),
          Divider(),
           ListTile(
            leading: Icon(Icons.payments),
            title: Text('Pay House'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(HomePage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
