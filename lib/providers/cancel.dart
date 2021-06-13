import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Cancel with ChangeNotifier {
  final String id;
  final String name;
  final String houseno;
  final String status;
  final String reasons;
  bool isFavorite;

  Cancel({
    @required this.id,
    @required this.name,
    @required this.houseno,
    @required this.status,
    @required this.reasons,
    this.isFavorite = false,
  });

  

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://rtotest-891ba-default-rtdb.firebaseio.com/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
