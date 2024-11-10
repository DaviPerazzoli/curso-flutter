import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var wordHistory = <WordPair>[];

  void toggleFavorite({WordPair? pair}){
    WordPair localPair;
    if (pair == null){
      localPair = current;
    }else {
      localPair = pair;
    }
    if ( favorites.contains(localPair) ){
      favorites.remove(localPair);
    } else {
      favorites.add(localPair);
    }
    notifyListeners();
  }

  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
      throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    void scrollToBottom(){
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent, 
        duration: const Duration(milliseconds: 300), 
      curve: Curves.easeOut);
    }

    void addToHistory(WordPair newPair) {
      appState.wordHistory.insert(0,newPair);
      _listKey.currentState?.insertItem(0);
      scrollToBottom();
    }

    

    Widget historyList = ClipRect(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.white, Colors.transparent],
            stops: [0.5,0.9],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: AnimatedList(
              key: _listKey,
              initialItemCount: appState.wordHistory.length,
              controller: _scrollController,
              reverse: true,
              itemBuilder: (context, index, animation) {
                var oldPair = appState.wordHistory[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(appState.favorites.contains(oldPair))
                        const Icon(Icons.favorite),
                      Text(oldPair.toString())
                    ],
                  ),
                );
              }
            )
      )
    );
    
    Widget mainWordPair = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BigCard(pair: pair),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LikeButton(pair: pair),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        addToHistory(pair);
                        appState.getNext();
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
            );
    

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: 
            historyList,
          ),

          Expanded(flex: 4,child: 
            mainWordPair,
          ),
          
        ],
      ),
    );
  }
}

// ...

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary 
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: 
          Text(
            pair.asCamelCase,
            style: style,
            semanticsLabel: '${pair.first} ${pair.second}',
           ),
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair:pair);
                },
                icon: Icon(icon),
                label: const Text('Like'),
              );
  }

}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var favoriteList = context.watch<MyAppState>().favorites;

    if (favoriteList.isEmpty){
      return const Center(child: Text("There's no favorites yet."),);
    }

    return Center(
      child: ListView(
        
        children: [
          for(var favoritePair in favoriteList)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BigCard(pair: favoritePair),
                    const SizedBox(height: 10),
                    LikeButton(pair: favoritePair),
                  ],
                ),
            )
           
        ],
      ),
    );
  }
  
}