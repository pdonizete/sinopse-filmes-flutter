import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class MovieService {
  Future<Movie> searchMovie({required String title, required String apiKey}) async {
    final uri = Uri.http('www.omdbapi.com', '/', {
      't': title,
      'plot': 'full',
      'apikey': apiKey,
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw const MovieServiceException('Falha ao consultar API de filmes.');
      }

      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonBody['Response'] == 'False') {
        final error = (jsonBody['Error'] as String?) ?? 'Filme não encontrado.';
        if (error.toLowerCase().contains('api key')) {
          throw const MovieServiceException('Chave de API inválida ou não autorizada.');
        }
        throw MovieServiceException(error);
      }

      return Movie.fromJson(jsonBody);
    } on MovieServiceException {
      rethrow;
    } on Exception {
      throw const MovieServiceException(
        'Erro de rede. Verifique sua internet e tente novamente.',
      );
    }
  }
}

class MovieServiceException implements Exception {
  const MovieServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
