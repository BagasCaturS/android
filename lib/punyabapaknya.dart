import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Movies>> fetchMovies() async {
  final response =
  await http.get(Uri.parse('https://s3-id-jkt-1.kilatstorage.id/d3si-telu/bagas/movies.json'));

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
    final records = jsonBody['records'] as List<dynamic>?;

    if (records != null) {
      return records.map((record) => Movies.fromJson(record)).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load movies');
  }
}

class Movies {
  final int idmovies;
  final String genre;
  final String title;
  final String plot;

  const Movies({
    required this.idmovies,
    required this.genre,
    required this.title,
    required this.plot,
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>;
    return Movies(
      idmovies: fields['id'] as int,
      genre: fields['genre'] as String,
      title: fields['movie_name'] as String,
      plot: fields['plot'] as String,
    );
  }
}

void main() => runApp(const homepage());

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _MyAppState();
}

class _MyAppState extends State<homepage> {
  late Future<List<Movies>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Movies>>(
            future: futureMovies,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                      child: Text(
                                        items[index].title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                      child: Text(items[index].genre),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 8),
                                      child: Text(items[index].plot),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
