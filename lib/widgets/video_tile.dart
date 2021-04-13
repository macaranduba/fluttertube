import 'package:flutter/material.dart';
import 'package:fluttertube/models/video.dart';

class VideoTile extends StatelessWidget {

  final Video _video;

  VideoTile(this._video) ;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              IconButton(
                icon: Icon(Icons.star_border, color: Colors.orange, size: 30,),
                onPressed: () {}
              )
            ],
          ),
        ],
      ),
    );
  }
}
