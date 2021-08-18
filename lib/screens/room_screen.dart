import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../providers/approom.dart' show Room;
import '../widgets/room_item.dart';
import '../providers/houseapplication.dart';
import '../local_notications_helper.dart';
import '../page/application_notification.dart';

class RoomScreen extends StatefulWidget {
  static const routeName = '/room';
@override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<RoomScreen> {
  
 
  @override
  Widget build(BuildContext context) {
    final room = Provider.of<Room>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your application room'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Text(
                  //   'Total',
                  //   style: TextStyle(fontSize: 20),
                  // ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${room.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(room: room)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: room.items.length,
              itemBuilder: (ctx, i) => RoomItem(
                    room.items.values.toList()[i].id,
                    room.items.keys.toList()[i],
                    room.items.values.toList()[i].price,
                    room.items.values.toList()[i].quantity,
                    room.items.values.toList()[i].houseno,
                  ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.room,
  }) : super(key: key);

  final Room room;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

   final notifications = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
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
        MaterialPageRoute(builder: (context) => ApplicationNotification(payload: payload)),
      );

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('APPLY'),
      onPressed: (widget.room.totalAmount <= 0 || _isLoading)
          ? null
          
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Application>(context, listen: false).addApplication(
                widget.room.items.values.toList(),
                widget.room.totalAmount,
                
              );
              showOngoingNotification(notifications,
                  title: 'House Application', body: 'Your application to rent house  was sent successfuly.');
              setState(() {
                _isLoading = false;
              });
              widget.room.clear();
            },
      textColor: Theme.of(context).primaryColor,
      
    );
  }
}
