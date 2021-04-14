import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FavoriteBloc _favBloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: _favBloc.outFav,
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.hasData ?
              snapshot.data.values.map( (video) {
                return InkWell( // touch visual effect
                  onTap: () {
                    FlutterYoutube.playYoutubeVideoById(
                      apiKey: API_KEY,
                      videoId: video.id
                    );
                  },
                  onLongPress: () => _favBloc.toggleFavorite(video),
                  child: Row(
                    children: [
                      Container(
                        child: Image.network(video.thumb),
                        height: 50,
                        width: 100,
                      ),
                      Expanded(
                        child: Text(video.title,
                          style: TextStyle(color: Colors.white70),
                          maxLines: 2
                        )
                      ),
                    ],
                  ),
                );
              }).toList()
            :
              [ CircularProgressIndicator() ],
          );
        },
      ),
    );
  }
}
