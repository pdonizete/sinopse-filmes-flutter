class Movie {
  const Movie({required this.title, required this.year, required this.plot});

  final String title;
  final String year;
  final String plot;

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: (json['Title'] as String?)?.trim().isNotEmpty == true
          ? json['Title'] as String
          : 'Título indisponível',
      year: (json['Year'] as String?)?.trim().isNotEmpty == true
          ? json['Year'] as String
          : 'Ano indisponível',
      plot: (json['Plot'] as String?)?.trim().isNotEmpty == true
          ? json['Plot'] as String
          : 'Sinopse indisponível.',
    );
  }
}
