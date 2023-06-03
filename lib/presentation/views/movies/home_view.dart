import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

class HomeView extends ConsumerStatefulWidget {

  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier    ).loadNextPage();
    ref.read( upcomingMoviesProvider.notifier   ).loadNextPage();
    ref.read( topRateMoviesProvider.notifier    ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading    = ref.watch( initialLoadingProvider  );
    if(initialLoading) return const FullScreenLoader();

    final moviesSlideShow   = ref.watch( moviesSlideShowProvider  );

    final nowPlayingMovies  = ref.watch( nowPlayingMoviesProvider );
    final popularMovies     = ref.watch( popularMoviesProvider    );
    final upcomingMovies    = ref.watch( upcomingMoviesProvider   );
    final topRatedMovies    = ref.watch( topRateMoviesProvider    );

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating     : true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppBar(),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {

              return Column(
                children: [
            
                  MoviesslideShow( movies: moviesSlideShow ),
            
                  MovieHorizontalListView(
                    movies      : nowPlayingMovies,
                    title       : 'En cines',
                    subTitle    : 'Lunes 20',
                    loadNextPage: () {
                      ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
                    },
                  ),
            
                  MovieHorizontalListView(
                    movies      : upcomingMovies,
                    title       : 'Próximamente',
                    subTitle    : 'En este mes',
                    loadNextPage: () {
                      ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
                    },
                  ),
            
                  MovieHorizontalListView(
                    movies      : popularMovies,
                    title       : 'Populares',
                    // subTitle    : 'En este mes',
                    loadNextPage: () {
                      ref.read( popularMoviesProvider.notifier ).loadNextPage();
                    },
                  ),
            
                  MovieHorizontalListView(
                    movies      : topRatedMovies,
                    title       : 'Mejor calificadas',
                    subTitle    : 'De todos los tiempos',
                    loadNextPage: () {
                      ref.read( topRateMoviesProvider.notifier ).loadNextPage();
                    },
                  ),

                  const SizedBox( height: 20.0 ,),
                ],
              );
    
            },
            childCount: 1,
          ),
        ),

      ]
    );

  }
}
