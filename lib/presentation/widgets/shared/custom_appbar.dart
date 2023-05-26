import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric( horizontal: 10.0 ),
        child  : SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon( Icons.movie_outlined, color: colors.primary,),
              const SizedBox( width: 5.0,),
              Text('Cinemapedia', style: titleStyle),
              const Spacer(),
              IconButton(
                onPressed: () {

                  final movieRepository = ref.read( movieRepositoryProvider );

                  showSearch<Movie?>(
                    context : context,
                    delegate: SearchMovieDelegate( searchMovies: movieRepository.searchMovies ),
                  ).then( (movie) {
                    if(movie == null ) return;
                    context.push('/movie/${movie.id}');
                  });

                },
                icon     : const Icon( Icons.search )
              ),
            ],
          ),
        ),
      )
    );
  }
}