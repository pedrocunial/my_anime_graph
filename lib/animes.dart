import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class Animes extends StatefulWidget {
  @override
  _AnimesState createState() => _AnimesState();
}

class _AnimesState extends State<Animes> {
  final _suggestions = <WordPair>[];
  final _favorites = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _toggleFavorite(WordPair anime, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        _favorites.remove(anime);
      } else {
        _favorites.add(anime);
      }
    });
  }

  Widget _buildRow(WordPair anime) {
    final favorite = _favorites.contains(anime);

    return ListTile(
      title: Text(
        anime.asPascalCase,
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          color: favorite ? Colors.red : null,
        ),
        onPressed: () {
          _toggleFavorite(anime, favorite);
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider();
          }

          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext buildContext) {
        final tiles = _favorites.map((WordPair favorite) {
          return ListTile(
            title: Text(
              favorite.asPascalCase,
              style: _biggerFont,
            ),
          );
        });

        final divided = ListTile.divideTiles(
          context: buildContext,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(title: Text('Favorites')),
          body: ListView(children: divided),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animes'), actions: [
        IconButton(
          icon: Icon(Icons.list),
          onPressed: _pushSaved,
        )
      ]),
      body: _buildSuggestions(),
    );
  }
}
