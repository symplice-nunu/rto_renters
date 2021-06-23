import 'package:flutter/material.dart';
import 'package:rto_renters/services/payment_service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rto_renters/widgets/app_drawer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../local_notications_helper.dart';
import '../page/Bail_payment_notification.dart';

class HomeePage extends StatefulWidget {
  static const routeName = '/user-creditcard';
  HomeePage({Key key}) : super(key: key);

  @override
  HomeePageState createState() => HomeePageState();
}

class HomeePageState extends State<HomeePage> {
  final notifications = FlutterLocalNotificationsPlugin();
  onItemPress(BuildContext context, int index) async {
    switch(index) {
      case 0:
        payViaNewCard(context);
        break;
      
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
      message: 'Please wait...'
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
      amount: '350',
      currency: 'USD'
    );
    await dialog.hide();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
      )
    );
    showOngoingNotification(notifications,
                  title: 'Bail Payment', body: 'Your Bail Payment of 350 USD to House Owner has been completed successfuly.');
      
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
      final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BailPaymentNotification(payload: payload)),
      );
  @override
  Widget build(BuildContext context) {
     
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bail Payment'),
      ),
     
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            Icon icon;
            Text text;

            switch(index) {
              case 0:
                icon = Icon(Icons.add_circle, color: theme.primaryColor);
                text = Text('Pay via new card');
                break;
             
            }

            return InkWell(
              onTap: () {
                onItemPress(context, index);
              },
              child: ListTile(
                title: text,
                leading: icon,
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: theme.primaryColor,
          ),
          itemCount: 2
        ),
      ),
      
    );
  }
}
