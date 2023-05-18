import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body               : _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {

  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read( popularMoviesProvider.notifier ).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final moviesSlideShow = ref.watch( moviesSlideShowProvider );
    final popularMovies = ref.watch( popularMoviesProvider );

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
                    movies      : nowPlayingMovies,
                    title       : 'Próximamente',
                    subTitle    : 'En este mes',
                    loadNextPage: () {
                      ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
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
                    movies      : nowPlayingMovies,
                    title       : 'Mejor calificadas',
                    subTitle    : 'De todos los tiempos',
                    loadNextPage: () {
                      ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
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