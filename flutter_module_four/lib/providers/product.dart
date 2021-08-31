import "dart:convert";

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final dynamic price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavourite(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-udemy-413e4-default-rtdb.europe-west1.firebasedatabase.app/products/userFavourites/$userId/$id.json?auth=$token';

    try {
      final response = await http.put(
        url,
        body: json.encode({
          isFavourite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavourite(oldStatus);
      }
    } catch (error) {
      _setFavourite(oldStatus);
    }
  }
}
