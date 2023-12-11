import 'dart:convert';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/models/actor.dart';
import 'package:movies_app/models/actordesc.dart';
import 'package:movies_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/review.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
          await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

    /*PILLAMOS ACTORES POPULARES, SOLO SUS NOMBRES, IMG Y ID
    static Future<List<Actor>?> getActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(5).forEach(
            (a) => actors.add(
              Actor.fromMap(a),
            ),
      );
      return actors;
    } catch (e) {
      return null;
    }
  }*/

  static Future<List<Actor>?> getActors() async {
  List<Actor> actors = [];
  try {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
    var res = jsonDecode(response.body);

    for (var actorData in res['results'].take(5)) {
      List<dynamic> knownFor = actorData['known_for'];
      List<Movie> movies = [];

      for (var movieData in knownFor) {
        Movie movie = Movie.fromMap(movieData);
        movies.add(movie);
      }

      Actor actor = Actor(
        name: actorData['name'] ?? '',
        profilepath: actorData['profile_path'] ?? '',
        id: actorData['id'] ?? '',
        peliculas: movies,
        popularity: actorData['popularity']?? 0.0,
      );

      actors.add(actor);
    }

    return actors;
  } catch (e) {
    return null;
  }
}


//MISMA FUNCION PARA BUSCAR A ACTORES PERO EMPIEZA DESPUES DE 6 PARA QUE NO SE REPITAN
  static Future<List<Actor>?> getActorsExtra(int numero) async {
  List<Actor> actors = [];
  try {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
    var res = jsonDecode(response.body);

    for (var actorData in res['results'].skip(numero).take(5)) {
      List<dynamic> knownFor = actorData['known_for'];
      List<Movie> movies = [];

      for (var movieData in knownFor) {
        Movie movie = Movie.fromMap(movieData);
        movies.add(movie);
      }

      Actor actor = Actor(
        name: actorData['name'] ?? '',
        profilepath: actorData['profile_path'] ?? '',
        id: actorData['id'] ?? '',
        peliculas: movies,
        popularity: actorData['popularity']?? 0.0,
      );

      actors.add(actor);
    }

    return actors;
  } catch (e) {
    return null;
  }
}




  /*PILLAMOS LOS DATOS DE LA PELICULA
    static Future<List<Movie>?> getMovieInformation(String namemovie) async {
    List<Movie> movie = [];
    try {
      http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=${Api.apiKey}&language=en-US&query=$namemovie&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
            (a) => movie.add(
              Movie.fromMap(a),
            ),
      );
      return movie;
    } catch (e) {
      return null;
    }
  }*/

  //PILLAMOS LA DESCRIPCION DE LOS ACTORES
  static Future<ActorDesc?> getActorsDesc(int idact) async {
  try {
    http.Response response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$idact?api_key=${Api.apiKey}&language=en-US&page=1'));
    var res = jsonDecode(response.body);

      return ActorDesc(
        id: res['id'],
        biography: res['biography']);
  } catch (e) {
    return null;
  }
}



}
