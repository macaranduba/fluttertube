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
    print('[VideosBloc._search] Procurando por $searchText... encontrei:');
    _videosList = await api.search(searchText);
    print('[VideosBloc._search] $_videosList');
    _videosController.sink.add(_videosList);
  }

  @override
  void dispose() {
    _videosController.close();
    _seearchController.close();
  }
}