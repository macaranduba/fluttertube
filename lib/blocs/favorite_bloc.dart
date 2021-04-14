import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteBloc extends BlocBase {

  Map<String, Video> _favoritesMap = {};

  final StreamController<Map<String, Video>> _favController = BehaviorSubject<Map<String, Video>>();
  Stream<Map<String, Video>> get outFav => _favController.stream.asBroadcastStream();

  FavoriteBloc() {
    _favController.sink.add({}); // avoid
  }

  void toggleFavorite(Video video) {
    if(_favoritesMap.containsKey(video.id)) {
      _favoritesMap.remove(video.id);
    } else {
      _favoritesMap[video.id] = video;
    }

    _favController.sink.add(_favoritesMap);
  }

  @override
  void dispose() {
    super.dispose();
    _favController.close();
  }
}