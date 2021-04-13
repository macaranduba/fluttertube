import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/video.dart';

const API_KEY = 'insert coin here';
/*
  testar no navegador
  https://www.googleapis.com/youtube/v3/search?part=snippet&q=eletro&type=video&key=AIzaSyAw7lSc6xJ85Welz0x74xXgQ0Cc8v2goOA&maxResults=10

  'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10'
  'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken'
  'http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json'
 */


class Api {

  Future<List<Video>> search(String searchText) async {
    http.Response response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$searchText&type=video&key=$API_KEY&maxResults=10'
      )
    );

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if(response.statusCode == 200) { // data returned OK
      var decoded = json.decode(response.body);
      List<Video> videosList = decoded['items'].map<Video>(
        (item) => Video.fromJson(item)
      ).toList();

      //print(videosList);

      return videosList;
    } else {
      throw Exception('Failed to load videos!');
    }
  }
}