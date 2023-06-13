import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projecthttp/movie_details_page.dart';
import 'package:projecthttp/homepage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  Future<List<Movie>> searchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://s3-id-jkt-1.kilatstorage.id/api/movies1.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonBody = jsonDecode(response.body) as List<dynamic>;
      final List<Movie> movies = jsonBody.map((json) => Movie.fromJson(json)).toList();

      final List<Movie> filteredMovies = movies.where((movie) {
        final title = movie.title.toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();

      setState(() {
        _isLoading = false;
        _searchResults = filteredMovies;
      });
    } else {
      throw Exception('Failed to search movies');
    }

    return _searchResults;
  }

  void navigateToMovieDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie)),
    );
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
        title: Text('Search Movies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final query = _searchController.text;
                    await searchMovies(query);
                  },
                ),
              ),
            ),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else if (_searchResults.isEmpty)
            Text('No movies found.')
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final movie = _searchResults[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.genre),
                    onTap: () {
                      navigateToMovieDetails(movie);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
