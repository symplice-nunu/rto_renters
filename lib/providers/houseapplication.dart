import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './approom.dart';

class HouseApplication {
  final String id;
  final double amount;
  final List<AppRoom> houses;
  final DateTime dateTime;

  HouseApplication({
    @required this.id,
    @required this.amount,
    @required this.houses,
    @required this.dateTime,
  });
}

class Application with ChangeNotifier {
  List<HouseApplication> _orders = [];
  final String authToken;
  final String userId;

  Application(this.authToken, this.userId, this._orders);

  List<HouseApplication> get application {
    return [..._orders];
  }

  Future<void> fetchAndSetApplication() async {
    final url = 'https://house-6dc86-default-rtdb.firebaseio.com/houseapplication/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<HouseApplication> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        HouseApplication(
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
                      pai: item['pai'],
                      pai1: item['pai1'],
                      pai2: item['pai2'],
                      at: item['at'],
                      at1: item['at1'],
                      name: item['name'],
                      co: item['co'],
                      jobTtitle: item['jobTtitle'],
                      company: item['company'],
                    ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> fetchAndSetPayments() async {
    final url = 'https://house-6dc86-default-rtdb.firebaseio.com/monthlypayment/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<HouseApplication> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        HouseApplication(
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
                      pai: item['pai'],
                      pai1: item['pai1'],
                      pai2: item['pai2'],
                      at: item['at'],
                      at1: item['at1'],
                      name: item['name'],
                      co: item['co'],
                      jobTtitle: item['jobTtitle'],
                      company: item['company'],
                    ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

Future<void> fetchAndSetBail() async {
    final url = 'https://house-6dc86-default-rtdb.firebaseio.com/bailpayment/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<HouseApplication> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        HouseApplication(
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
                      pai: item['pai'],
                      pai1: item['pai1'],
                      pai2: item['pai2'],
                      at: item['at'],
                      at1: item['at1'],
                      name: item['name'],
                      co: item['co'],
                      jobTtitle: item['jobTtitle'],
                      company: item['company'],
                      
                    ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }


  // Future<void> addApplication(List<AppRoom> roomHouses, double total) async {
  //   final url = 'https://house-6dc86-default-rtdb.firebaseio.com/houseapplication/$userId.json?auth=$authToken';
  //   final timestamp = DateTime.now();
  //   final response = await http.post(
  //     url,
  //     body: json.encode({
  //       'amount': total,
  //       'dateTime': timestamp.toIso8601String(),
  //       'houses': roomHouses
  //           .map((cp) => {
  //                 'id': cp.id,
  //                 'houseno': cp.houseno,
  //                 'status': "Applied",
  //                 'pai': "We have to make an Agreement on",
  //                 'pai1': "Tuesday or Thursday, we will be",
  //                 'pai2': "available on our office.",
  //                 'co': "Contract",
  //                 'at': "Address:  KK 36 st",
  //                 'at1': "08:00 am to 04:30 pm",
  //                 'quantity': cp.quantity,
  //                 'price': cp.price,
  //                 'name': "Anne Marie",
  //                 'jobTtitle': "Coach, Salary: 900 000 Frw.",
  //                 'company': "RWANDA Team",
                  
  //               })
  //           .toList(),
  //     }),
  //   );
  //   _orders.insert(
  //     0,
  //     HouseApplication(
  //       id: json.decode(response.body)['name'],
  //       amount: total,
  //       dateTime: timestamp,
  //       houses: roomHouses,
  //     ),
  //   );
  //   notifyListeners();
  // }
  Future<void> addApplication(List<AppRoom> roomHouses, double total) async {
    final url = 'https://house-6dc86-default-rtdb.firebaseio.com/monthlypayment/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'houses': roomHouses
            .map((cp) => {
                  'id': cp.id,
                  'houseno': cp.houseno,
                  'status': "Paid",
                  'pai': "Thank you, You have been paid bail",
                  'pai1': "for the first month.",
                  'pai2': " ",
                  'co': "Payment made",
                  'at': "Rent to own",
                  'at1': "KK 36 St",
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'name': "MUTESI Aline",
                  'jobTtitle': "4242********4242",
                  // 'name': "INTWARI Symplice",
                  // 'jobTtitle': "5555********4444",
                  'company': "EN",
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      HouseApplication(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        houses: roomHouses,
      ),
    );
    notifyListeners();
  }
}
