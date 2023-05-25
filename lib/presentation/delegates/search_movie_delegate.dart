import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

        FadeInRight(
          animate : query.isNotEmpty,
          duration: const Duration( milliseconds: 500 ),
          child   : IconButton(
            onPressed: () => query = '',
            icon     : const Icon( Icons.clear ),
          ),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon     : const Icon( Icons.arrow_back_sharp )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text('buildSuggestions');
  }

  @override
  String get searchFieldLabel => 'Buscar película';
  
}
