import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key, 
    required this.movieId,
  });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();
    ref.read( movieInfoProvider.notifier  ).loadMovie(widget.movieId);
    ref.read( actorsByMovieProvider.notifier ).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch( movieInfoProvider )[widget.movieId];

    if( movie == null ) {
      return const Scaffold( body: Center( child: CircularProgressIndicator() ) );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovideDetails( movie: movie ),
              childCount: 1,
            ))
        ],
      ),
    );
  }
}

class _MovideDetails extends StatelessWidget {

  final Movie movie;

  const _MovideDetails({required this.movie});

  @override
  Widget build(BuildContext context) {

    final size        = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children          : [
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Hero(
                tag: movie,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child       : Image.network(
                    movie.posterPath,
                    width: size.width * 0.3,
                  ),
                ),
              ),

              const SizedBox( width: 10.0 ,),

              // desc
              SizedBox(
                width: ( size.width - 40 ) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children          : [
                    Text( movie.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0 ) ,),
                    const SizedBox( height: 10.0 ,),
                    Text( movie.overview ,),
                  ],
                ),
              ),

            ],
          ),
        ),

        //generos de la pelicula
        Padding(
          padding: const EdgeInsets.all(8),
          child  : Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                margin: const EdgeInsets.only( right: 10.0 ),
                child : Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular( 20.0 ) ),
                ),
              ))
            ],
          ),
        ),

        const SizedBox( height: 20.0 ),

        _ActorsByMovie( movieId: movie.id.toString() ,),
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {

  final String movieId;

  const _ActorsByMovie({
    required this.movieId
  });

  @override
  Widget build( BuildContext context , WidgetRef ref ) {

    final actorsByMovie = ref.watch( actorsByMovieProvider );

    if( actorsByMovie[movieId] == null ) {
      return const CircularProgressIndicator();
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 300.0,
      child : ListView.builder(
        itemCount       : actors.length,
        scrollDirection : Axis.horizontal,
        itemBuilder     : (context, index) {

        final actor = actors[index];

        return Container(
          padding: const EdgeInsets.all(8.0),
          width  : 135.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              FadeInRight(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network( 
                    actor.profilePath,
                    height: 180.0,
                    width : 135.0,
                    fit    : BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox( height: 5.0,),

              Text( actor.name , maxLines: 2,),
              Text( actor.character ?? '' , maxLines: 2, style: const TextStyle( fontWeight: FontWeight.bold, ) ),
            ],
          ),
        );
      },),
    );
  }
}

final isFavoriteProvider = FutureProvider.family.autoDispose( (ref, int movieId) {

  final localStorageRepository = ref.watch( localStorageRepositoryProvider );
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {

  final Movie movie;

  const _CustomSliverAppBar({
    required this.movie
  });

  @override
  Widget build( BuildContext context, WidgetRef ref ) {

    final size = MediaQuery.of(context).size;
    final isFavoriteFuture = ref.watch( isFavoriteProvider(movie.id) );

    return SliverAppBar(
      backgroundColor : Colors.black,
      expandedHeight  : size.height * 0.7,
      foregroundColor : Colors.white,
      actions         : [
        IconButton(
          onPressed: () async {
            await ref.read( favoriteMoviesProvider.notifier ).toggleFavorite(movie);
            ref.invalidate( isFavoriteProvider( movie.id ) );
          },
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(),
            data   : (data) => data ? const Icon( Icons.favorite_rounded, color: Colors.red , ) : const Icon( Icons.favorite_border ),
            error  : (_, __) => throw UnimplementedError(),
          ),
        ),
      ],
      flexibleSpace    : FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric( horizontal: 10.0, vertical: 5.0 ),
        background  : Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath, 
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if( loadingProgress != null ) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            const _CustomGradient(
              begin : Alignment.topCenter,
              end   : Alignment.bottomCenter,
              stops : [ 0.7, 1.0 ],
              colors: [
                Colors.transparent,
                Colors.black12,
              ],
            ),

            const _CustomGradient(
              begin : Alignment.topRight,
              end   : Alignment.bottomLeft,
              stops: [ 0.0, 0.2 ],
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
            ),
            const _CustomGradient(
              begin : Alignment.topLeft,
              stops: [ 0.0, 0.2 ],
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {

  final AlignmentGeometry begin;
  final AlignmentGeometry? end;
  final List<double>? stops;
  final List<Color> colors;

  const _CustomGradient({
    this.stops, 
    this.end,
    required this.begin, 
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin : begin,
            end   : end ?? Alignment.centerRight,
            stops : stops,
            colors: colors
          )
        )
      )
    );
  }
}
