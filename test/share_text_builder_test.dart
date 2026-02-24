import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/models/movie.dart';
import 'package:sinopse_filmes_flutter/utils/share_text_builder.dart';

void main() {
  test('monta texto de compartilhamento com título, ano e sinopse', () {
    const movie = Movie(
      title: 'Interestelar',
      year: '2014',
      plot: 'Uma equipe viaja por um buraco de minhoca em busca de um novo lar.',
    );

    final result = buildMovieShareText(movie);

    expect(result, contains('Interestelar (2014)'));
    expect(result, contains('Sinopse:'));
    expect(
      result,
      contains('Uma equipe viaja por um buraco de minhoca em busca de um novo lar.'),
    );
  });
}
