import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsMapNotifier, Map<String, List<Actor>>>((ref) {
  
  final actorRepository = ref.watch( actorsRepositoryProvider ).getActorsByMovie;

  return ActorsMapNotifier( getActors: actorRepository );
});

typedef GetActorsCallBack = Future<List<Actor>>Function( String movieId );

class ActorsMapNotifier extends StateNotifier<Map<String, List<Actor>>> {

  GetActorsCallBack getActors;

  ActorsMapNotifier({
    required this.getActors
  }):super({});

  Future<void> loadActors( String movieId ) async {

    if( state[movieId] != null ) return;

    final actors = await getActors( movieId );

    state = { ...state, movieId: actors };
  }
}
