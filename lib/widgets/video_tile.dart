import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';

import '../api.dart';

class VideoTile extends StatelessWidget {

  final Video _video;

  final FavoriteBloc _favBloc = BlocProvider.getBloc<FavoriteBloc>();

  VideoTile(this._video) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FlutterYoutube.playYoutubeVideoById(
            apiKey: API_KEY,
            videoId: _video.id
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4), // top and bottom
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.,
          children: [
            AspectRatio(
              aspectRatio: 16.0/9.0,
              child: Image.network(_video.thumb, fit: BoxFit.cover),
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(_video.title,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(_video.channel,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    )
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: _favBloc.outFav,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return IconButton(
                          icon: Icon(
                              snapshot.data.containsKey(_video.id) ?
                              Icons.star
                                  :
                              Icons.star_border,
                              color: Colors.orange,
                              size: 30
                          ),
                          onPressed: () {
                            _favBloc.toggleFavorite(_video);
                          }
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
