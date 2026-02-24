import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/main.dart';

void main() {
  testWidgets('renderiza tela inicial com campo de filme', (tester) async {
    await tester.pumpWidget(const SinopseFilmesApp());

    expect(find.text('Sinopse de Filmes'), findsOneWidget);
    expect(find.text('Buscar sinopse'), findsOneWidget);
    expect(find.text('Nome do filme'), findsOneWidget);
  });
}
