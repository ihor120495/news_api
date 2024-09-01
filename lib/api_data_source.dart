import 'dart:convert';

import 'news_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiDataSource {
  Future<List<NewsModel>> fetchNews(int page, int limit) async {
    final Response response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=apple&from=2024-08-21&to=2024-08-21&sortBy=popularity&apiKey=2d409596502d4d21912b9b77c8a2da8d&_page=$page&_limit=$limit'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<NewsModel> listNews = [];
      for (var item in data['articles']) {
        listNews.add(NewsModel.fromJson(item));
      }
      return listNews;
    } else {
      throw Exception('Failed');
    }
  }
}
