import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc extends BlocBase {

  static const SHARED_PREFERENCES_KEY = 'favorites';

  Map<String, Video> _favoritesMap = {};


  final StreamController<Map<String, Video>> _favController = BehaviorSubject<Map<String, Video>>();
  Stream<Map<String, Video>> get outFav => _favController.stream.asBroadcastStream();

  FavoriteBloc() {
    SharedPreferences.getInstance().then((preferences) {
      if(preferences.getKeys().contains(SHARED_PREFERENCES_KEY)) {
        _favoritesMap = json.decode(preferences.getString(SHARED_PREFERENCES_KEY)).map(
          (k, v) {
            return MapEntry(k, Video.fromJson(v));
          }
        ).cast<String, Video>();
        _favController.sink.add(_favoritesMap);
      }
    });
  }

  void toggleFavorite(Video video) {
    if(_favoritesMap.containsKey(video.id)) {
      _favoritesMap.remove(video.id);
    } else {
      _favoritesMap[video.id] = video;
    }

    _favController.sink.add(_favoritesMap);

    _saveFavorites();
  }

  void _saveFavorites() {
    SharedPreferences.getInstance().then(
      (preferences) => preferences.setString(SHARED_PREFERENCES_KEY, json.encode(_favoritesMap))
    );
  }

  @override
  void dispose() {
    super.dispose();
    _favController.close();
  }
}