import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {

  const FullScreenLoader({super.key});


  Stream<String> getLoadingMessages() {

    final messages = <String>[
      'Cargando películas',
      'Comprando palomitas',
      'Cargando pouplares',
      'Llamando a mi novia',
      'Ya casi...',
      'Esto está tardando más de lo devido :('
    ];

    return Stream.periodic( const Duration( milliseconds: 1200 ), (step) {
      return messages[step];
    }).take( messages.length );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espero por favor'),
          const SizedBox( height: 10.0 ,),
          const CircularProgressIndicator(),
          const SizedBox( height: 10.0 ,),

          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {

              if( !snapshot.hasData ) return const Text('Cargando...');

              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}