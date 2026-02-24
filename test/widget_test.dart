import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sinopse_filmes_flutter/main.dart';

void main() {
  testWidgets('renderiza tela inicial com campo de filme', (tester) async {
    await tester.pumpWidget(const SinopseFilmesApp());

    expect(find.text('Sinopse de Filmes'), findsOneWidget);
    expect(find.text('Buscar sinopse'), findsOneWidget);
    expect(find.text('Nome do filme'), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });

  testWidgets('exibe aviso ao tentar compartilhar sem resultado', (
    tester,
  ) async {
    await tester.pumpWidget(const SinopseFilmesApp());

    await tester.tap(find.byIcon(Icons.share));
    await tester.pump();

    expect(
      find.text('Busque um filme para habilitar o compartilhamento.'),
      findsOneWidget,
    );
  });

  testWidgets('abre modal Sobre com nome, versão e autor', (tester) async {
    await tester.pumpWidget(const SinopseFilmesApp());

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.text('Sobre'), findsOneWidget);
    expect(find.text('Sinopse de Filmes'), findsAtLeastNWidgets(1));
    expect(find.text('Versão: 1.0.0+1'), findsOneWidget);
    expect(find.text('Autor: Paulo Filho'), findsOneWidget);
  });
}
