import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    return MaterialApp(
      //title: 'Welcome to Flutter',
      //home: Scaffold(
      title:'Startup Name Generator',
      theme: ThemeData( 
        primaryColor:  Colors.lightBlue[100],
      ),
      home:RandomWords(),
        //appBar: AppBar(
          //title: Text('Welcome to Flutter'),
        //),
        //body: Center(
          //child: Text('Hello World'),
          //child: Text(wordPair.asPascalCase),
          //child: RandomWords(),
        //),
      //),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row
      // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对
      itemBuilder: (context,i) {
        // 在每一列之前，添加一个1像素高的分割线widget
        if (i.isOdd) return Divider();

        //语法‘i ~/ 2’表示i除以2，但返回值是整形（向下取整），比如i为1，2，3，4，5
        //时，结果为0，1，1，2，3， 这可以计算出ListView钟减去分割线后的实际单词对数量
        final index = i ~/ 2;
        //如果是建议列表钟最后一个单词
        if (index >= _suggestions.length) {
          //。。。接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap:(){
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile( 
                title: Text( 
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
          .divideTiles(
            context:  context,
            tiles: tiles,
          )
          .toList();
        return Scaffold(
          appBar: AppBar(
            title: new Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
        },
      ),
    );
  }
  

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
  }

