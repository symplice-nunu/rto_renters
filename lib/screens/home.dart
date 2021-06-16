import 'package:flutter/material.dart';
import 'package:rto_renters/services/payment_service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rto_renters/widgets/app_drawer.dart';
import './existing_card.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../local_notications_helper.dart';
import '../page/payment_notification.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/user-credcard';
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  
  final notifications = FlutterLocalNotificationsPlugin();
  
  onItemPress(BuildContext context, int index) async {
    switch(index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.pushNamed(context, ExistingCardPage.routeName);
        
       
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
                  title: 'Monthly Payment', body: 'Your monthly house Payment of 350 USD to House Owner has been completed successfuly.');
                 
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
        MaterialPageRoute(builder: (context) => PaymentNotification(payload: payload)),
      );
  

  @override
  Widget build(BuildContext context) {
     
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('House Payment'),
      ),
      
      // appBar: AppBar(
      //   title: const Text('Your Credit Card'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () {
      //         // Navigator.of(context).pushNamed(EditHouseScreen.routeName);
      //       },
      //     ),
      //   ],
      // ),
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
              case 1:
                icon = Icon(Icons.credit_card, color: theme.primaryColor);
                text = Text('Pay via existing card');
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
