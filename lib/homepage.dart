import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projecthttp/settings.dart';
import 'package:projecthttp/watchlist.dart';

import 'movie_details_page.dart';

// void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String image;
  final String genre;

  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.genre,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['movie_name'] as String,
      image: json['image_url'] as String,
      genre: json['genre'] as String,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> futureMovies;
  late List<Movie> displayedMovies;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
    displayedMovies = [];
  }

  Future<List<Movie>> fetchMovies() async {
    final response =
    await http.get(Uri.parse('https://s3-id-jkt-1.kilatstorage.id/api/movies1.json'));

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson =
      jsonDecode(response.body) as List<dynamic>;

      final List<Movie> movies =
      moviesJson.map((json) => Movie.fromJson(json)).toList();

      setState(() {
        futureMovies = Future.value(movies);
        displayedMovies = movies;
      });

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }


  void navigateToSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }
  void navigateToWatchlistPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WatchlistPage(watchlistMovies: [],)),
    );
  }
  //perlu implementasi profile
  // void navigateToProfile() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Profile()),
  //   );
  // }

  void searchMovies(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedMovies = [];
        _isSearching = false;
      });
      return;
    }

    final List<Movie> searchResults = displayedMovies.where((movie) {
      final title = movie.title.toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      displayedMovies = searchResults;
      _isSearching = true;
    });
  }

  void clearSearch() {
    _searchController.clear();
    setState(() {
      displayedMovies = [];
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search Movies',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: searchMovies,
        )
            : const Text('Movies'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          IconButton(
            icon: Icon(_isSearching ? Icons.search_off : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
              if (!_isSearching) {
                clearSearch();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('App settings'),
                    onTap: navigateToSettingsPage,
                  ),
                  ListTile(
                    title: const Text('Watchlist'),
                    onTap: navigateToWatchlistPage,
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'V1.0',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: FutureBuilder<List<Movie>>(
          future: futureMovies,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final movies = snapshot.data!;
              final displayedMovieList = _isSearching ? displayedMovies : movies;

              if (displayedMovieList.isEmpty) {
                return const Text('No movies found.');
              }

              return ListView.builder(
                itemCount: displayedMovieList.length,
                itemBuilder: (context, index) {
                  final movie = displayedMovieList[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(movie.image),
                      title: Text(movie.title),
                      subtitle: Text(movie.genre),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsPage(movie: movie),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
