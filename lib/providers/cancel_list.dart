import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './approom.dart';

class CancelList {
  final String id;
  final double amount;
  final List<AppRoom> houses;
  final DateTime dateTime;

  CancelList({
    @required this.id,
    @required this.amount,
    @required this.houses,
    @required this.dateTime,
  });
}

class Application with ChangeNotifier {
  List<CancelList> _orders = [];
  final String authToken;
  final String userId;

  Application(this.authToken, this.userId, this._orders);

  List<CancelList> get application {
    return [..._orders];
  }

  Future<void> fetchAndSetApplication() async {
    final url = 'https://rtotest-891ba-default-rtdb.firebaseio.com/application/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<CancelList> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        CancelList(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          houses: (orderData['houses'] as List<dynamic>)
              .map(
                (item) => AppRoom(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      houseno: item['houseno'],
                      status: item['status'],
                    ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

 
}
