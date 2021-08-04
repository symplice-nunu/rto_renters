import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/houseapplication.dart' show Application;
import '../widgets/application_item.dart';
import '../widgets/app_drawer.dart';

class BailPaymentScreen extends StatelessWidget {
  static const routeName = '/bailpayments';

  @override
  Widget build(BuildContext context) {
    print('building application');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bail Payment'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Application>(context, listen: false).fetchAndSetBail(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Application>(
                builder: (ctx, orderData, child) => ListView.builder(
                      itemCount: orderData.application.length,
                      itemBuilder: (ctx, i) => ApplicationItem(orderData.application[i]),
                    ),
              );
            }
          }
        },
      ),
    );
  }
}