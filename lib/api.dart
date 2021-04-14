import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/video.dart';

const API_KEY = 'insert coin here';
/*
  'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10'
  'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken'
  'https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json'
 */


class Api {

  String _searchText;
  String _nextToken;

  Future<List<Video>> search(String searchText) async {

    _searchText = searchText;

    //print('Api.search($searchText)');
    //print('Api.search url = https://www.googleapis.com/youtube/v3/search?part=snippet&q=$searchText&type=video&key=$API_KEY&maxResults=10');
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

      _nextToken = decoded['nextPageToken'];

      List<Video> videosList = decoded['items'].map<Video>(
        (item) => Video.fromJson(item)
      ).toList();

      //print(videosList);

      return videosList;
    } else {
      //print('response.statusCode = ${response.statusCode}');
      //print('response.body = ${response.body}');
      throw Exception('Failed to load videos!');
    }
  }

  Future<List<Video>> nextPage() async {
    //print('Api.nextPage url = https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_searchText&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken');

    http.Response response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_searchText&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken'
      )
    );

    return decode(response);
  }

}