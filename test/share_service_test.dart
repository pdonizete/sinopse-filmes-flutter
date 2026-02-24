import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/models/movie.dart';
import 'package:sinopse_filmes_flutter/services/share_service.dart';

void main() {
  test('buildMovieShareMessage gera payload com título, ano e sinopse', () {
    const movie = Movie(
      title: 'Interestelar',
      year: '2014',
      plot: 'Uma equipe viaja por um buraco de minhoca.',
    );

    final payload = buildMovieShareMessage(movie);

    expect(
      payload,
      'Título: Interestelar\nAno: 2014\nSinopse: Uma equipe viaja por um buraco de minhoca.',
    );
  });
}
