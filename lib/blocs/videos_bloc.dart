import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video.dart';

class VideosBloc extends BlocBase {

  Api api;

  List<Video> _videosList;

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _seearchController = StreamController<String>();
  Sink get inSearch => _seearchController.sink;

  VideosBloc() {
    api = Api();

    _seearchController.stream.listen( _search );
  }

  void _search(String searchText) async {
    //print('[VideosBloc._search] Procurando por $searchText... encontrei:');

    if(searchText != null) { // search for something
      _videosController.sink.add([]); // reset the ListView piping an empty video list
      _videosList = await api.search(searchText);
    } else {
      _videosList += await api.nextPage(); // dart allows to add 2 different lists!!
    }
    //print('[VideosBloc._search] $_videosList');

    _videosController.sink.add(_videosList);
  }

  @override
  void dispose() {
    _videosController.close();
    _seearchController.close();
  }
}