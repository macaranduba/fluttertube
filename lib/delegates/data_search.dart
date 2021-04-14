import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {

  @override
  String get searchFieldLabel => 'Procure aqui...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () { // clean search
          query = ''; // query holds the text of the search box
        }
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      //icon: Icon(Icons.arrow_back_ios),
      onPressed: () { // exit screen
        close(context, null);
      }
    );
  }

  // show results of user's search
  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration(seconds: 0)).then((_) => close(context, query));
    return Container();
  }

  // show suggestions while user is typing
  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty) { // we always must return a widget, even when there is nothing to show
      return Container();
    } else {
      return FutureBuilder(
        future: suggestions(query),
        builder: (context, snapshot) {
          print(snapshot);
          if( ! snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data[index]),
                  leading: Icon(Icons.play_arrow),
                  onTap: () {
                    print('[DataSearch.buildSuggestions.ListTitle.ontap] ${snapshot.data[index]} clicado!');
                    close(context, snapshot.data[index]);
                  },
                );
              }
            );
          }
        },
      );
    }

  }

  Future<List> suggestions(String search) async {
    //print('getting https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json');
    http.Response response = await http.get(
        Uri.parse(
            'https://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json'
        )
    );
    //print('[DataSearch.suggestions] Got ${response.body}');

    if(response.statusCode == 200) {
      return json.decode(response.body)[1].map(
        (item) => item[0]
      ).toList();
    } else {
      print('response.statusCode ${response.statusCode}');
      throw Exception('Failed to load suggestions');
    }
  }
}