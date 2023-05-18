import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListView extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;
  
  const MovieHorizontalListView({
    super.key,
    required this.movies, 
    this.loadNextPage,
    this.title, 
    this.subTitle, 
  });

  @override
  State<MovieHorizontalListView> createState() => _MovieHorizontalListViewState();
}

class _MovieHorizontalListViewState extends State<MovieHorizontalListView> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      
      if( widget.loadNextPage == null ) return;

      if( (scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent ) {
        widget.loadNextPage!();
      }

    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350.0,
      child : Column(
        children: [

          if( widget.title != null || widget.subTitle != null )
            _Title( title: widget.title, subTitle: widget.subTitle ),

          Expanded(
            child: ListView.builder(
              controller     : scrollController,
              itemCount      : widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics        : const BouncingScrollPhysics(),
              itemBuilder    : (context, index) {
                return _Slide( movie: widget.movies[index] );
              },
            )
          ),
          
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({ required this.movie });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 8.0 ),
      child : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children          : [

          SizedBox(
            width : 150.0,
            height: 225.0,
            child : ClipRRect(
              borderRadius: BorderRadius.circular( 20.0 ),
              child: Image.network( 
                movie.posterPath,
                width         : 150.0,
                fit            : BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  
                  if( loadingProgress != null ) {
                    return const Padding(
                      padding : EdgeInsets.all(8.0),
                      child   : Center(child: CircularProgressIndicator()),
                    );
                  }

                  return FadeIn(child: child);
                },
              ),
            ),
          ),

          const SizedBox( height: 5.0 ),

          //Title
          SizedBox(
            width: 150.0,
            child: Text( 
              movie.title,
              maxLines: 1,
              style   : textStyle.titleSmall,
            ),
          ),

          //Rating
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon( Icons.star_half_outlined, color: Colors.yellow.shade800 ,),
                const SizedBox( width: 3.0,),
                Text('${movie.voteAverage}', style: textStyle.bodyMedium?.copyWith( color: Colors.yellow.shade800),),
                const SizedBox( width: 10.0,),
                const Spacer(),
                // Text('${movie.popularity}', style: textStyle.bodySmall,),
                Text( HumanFormats.number( movie.popularity ), style: textStyle.bodySmall,),
              ],
            ),
          )

        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;

  const _Title({ this.title, this.subTitle });

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;
    
    return Container(
      padding : const EdgeInsets.only( top: 10.0 ),
      margin  : const EdgeInsets.symmetric( horizontal: 10.0 ),
      child   : Row(
        children: [

          if( title != null )
            Text( title!, style: titleStyle ,),

          const Spacer(),

          if( subTitle != null )
            FilledButton.tonal(
              onPressed: (){},
              style    : const ButtonStyle( visualDensity: VisualDensity.compact ),
              child    : Text( subTitle! ),   
            )

        ],
      ),
    );
  }
}
