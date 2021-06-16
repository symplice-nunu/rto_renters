import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rto_renters/providers/payments.dart';

import '../models/http_exception.dart';
import './house.dart';
import './cancel.dart';
import './payments.dart';

class Houses with ChangeNotifier {
  List<House> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Cancel> _itemss = [

  ];
  List<Payments> _itemsss = [

  ];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Houses(this.authToken, this.userId, this._items, this._itemss, this._itemsss);

  List<House> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }
  List<Cancel> get itemss {

    return [..._itemss];
  }
  List<Payments> get itemsss {

    return [..._itemsss];
  }

  List<House> get favoriteItems {
    return _items.where((housItem) => housItem.isFavorite).toList();
  }
   List<Cancel> get favoriteItemss {
    return _itemss.where((housItem) => housItem.isFavorite).toList();
  }

  House findById(String id) {
    return _items.firstWhere((hous) => hous.id == id);
  }
  Cancel findByIdd(String id) {
    return _itemss.firstWhere((hous) => hous.id == id);
  }
  Payments findByIda(String id) {
    return _itemsss.firstWhere((hous) => hous.id == id);
  }

  

  Future<void> fetchAndSetHouses([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/house.json?auth=$authToken&$filterString';
        // 'https://rent-to-own-6688f-default-rtdb.firebaseio.com/houses.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://rtotest-891ba-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
          // 'https://rent-to-own-6688f-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<House> loadedHouses = [];
      extractedData.forEach((housId, housData) {
        loadedHouses.add(House(
          id: housId,
          villagename: housData['villagename'],
          houseno: housData['houseno'],
          roomno: housData['roomno'],
          saloonno: housData['saloonno'],
          tbno: housData['tbno'],
          kitchenno: housData['kitchenno'],
          ehouseno: housData['ehouseno'],
          houselocation: housData['houselocation'],
          housedescription: housData['housedescription'],
          price: housData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[housId] ?? false,
          imageUrl: housData['imageUrl'],
        ));
      });
      _items = loadedHouses;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetCancels([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/cancelrents.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://rtotest-891ba-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Cancel> loadedCancels = [];
      extractedData.forEach((prodId, prodData) {
        loadedCancels.add(Cancel(
          id: prodId,
          name: prodData['name'],
          houseno: prodData['houseno'],
          status: prodData['status'],
          reasons: prodData['reasons'],
          date: prodData['date'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _itemss = loadedCancels;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addHouse(House house) async {
    final url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/house.json?auth=$authToken';
        //  'https://rent-to-own-6688f-default-rtdb.firebaseio.com/houses.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'villagename': house.villagename,
          'houseno': house.houseno,
          'roomno': house.roomno,
          'saloonno': house.saloonno,
          'tbno': house.tbno,
          'kitchenno': house.kitchenno,
          'ehouseno': house.ehouseno,
          'houselocation': house.houselocation,
          'housedescription': house.housedescription,
          'imageUrl': house.imageUrl,
          'price': "350 USD",
          'creatorId': userId,
        }),
      );
      final newHouse = House(
        villagename: house.villagename,
        houseno: house.houseno,
        roomno: house.roomno,
        saloonno: house.saloonno,
        tbno: house.tbno,
        kitchenno: house.kitchenno,
        ehouseno: house.ehouseno,
        houselocation: house.houselocation,
        housedescription: house.housedescription,
        price: house.price,
        imageUrl: house.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newHouse);
      // _items.insert(0, newHouse); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addCancel(Cancel cancel) async {
    final url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/cancelrents.json?auth=$authToken';
        final dateTime = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name': cancel.name,
          'houseno': cancel.houseno,
          'status' : "Pending....",
          'reasons': cancel.reasons,
          'date': dateTime.toIso8601String(),
          'creatorId': userId,
        }),
      );
      final newProduct = Cancel(
        name: cancel.name,
        houseno: cancel.houseno,
        status: cancel.status,
        reasons: cancel.reasons,
        date: cancel.date,
        id: json.decode(response.body)['name'],
      );
      _itemss.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
Future<void> payMoney(Payments payment) async {
    final url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/payments.json?auth=$authToken';
        final dateStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'cardNumber': "4242424242424242",
          'cardHolderName': "04/24",
          'expiryDate' : "INTWARI",
          'cvvCode': "424",
          'amount': "350 USD",
          'date': dateStamp.toIso8601String(),
          'creatorId': userId,
        }),
      );
      final newProduct = Payments(
        cardNumber: payment.cardNumber,
        cardHolderName: payment.cardHolderName,
        expiryDate: payment.expiryDate,
        cvvCode: payment.cvvCode,
        amount: payment.amount,
        date: payment.date,
        id: json.decode(response.body)['name'],
      );
      _itemsss.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }


  Future<void> updateHouse(String id, House newHouse) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://rtotest-891ba-default-rtdb.firebaseio.com/house/$id.json?auth=$authToken';
          // 'https://rent-to-own-6688f-default-rtdb.firebaseio.com/houses/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'villagename': newHouse.villagename,
            'houseno': newHouse.houseno,
            'roomno': newHouse.roomno,
            'saloonno': newHouse.saloonno,
            'tbno': newHouse.tbno,
            'kitchenno': newHouse.kitchenno,
            'ehouseno': newHouse.ehouseno,
            'houselocation': newHouse.houselocation,
            'housedescription': newHouse.housedescription,
            'imageUrl': newHouse.imageUrl,
            'price': newHouse.price
          }));
      _items[prodIndex] = newHouse;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> updateCancel(String id, Cancel newCancel) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://rtotest-891ba-default-rtdb.firebaseio.com/cancelrents/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'name': newCancel.name,
            'houseno': newCancel.houseno,
            'reasons': newCancel.reasons
          }));
      _itemss[prodIndex] = newCancel;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteHouse(String id) async {
    final url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/house/$id.json?auth=$authToken';
        // 'https://rent-to-own-6688f-default-rtdb.firebaseio.com/houses/$id.json?auth=$authToken';
    final existingHouseIndex = _items.indexWhere((prod) => prod.id == id);
    var existingHouse = _items[existingHouseIndex];
    _items.removeAt(existingHouseIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingHouseIndex, existingHouse);
      notifyListeners();
      throw HttpException('Could not delete house.');
    }
    existingHouse = null;
  }

  Future<void> deleteCancel(String id) async {
    final url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/cancelrents/$id.json?auth=$authToken';
    final existingCancelIndex = _itemss.indexWhere((prod) => prod.id == id);
    var existingCancel = _itemss[existingCancelIndex];
    _items.removeAt(existingCancelIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _itemss.insert(existingCancelIndex, existingCancel);
      notifyListeners();
      throw HttpException('Could not cancel rent agreement.');
    }
    existingCancel = null;
  }
}
