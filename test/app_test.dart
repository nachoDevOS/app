import 'package:beni_digital/app.dart';
import 'package:beni_digital/nucleo/sesion/sesion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sin sesión abre el login; al ingresar llega al inicio con los datos de Jichi', (t) async {
    await t.pumpWidget(BeniDigital(sesion: Sesion()));
    await t.pumpAndSettle();
    expect(find.text('Ingresar'), findsOneWidget);

    // El login pide contraseña aunque acepte cualquiera.
    await t.tap(find.text('Ingresar'));
    await t.pump();
    expect(find.text('Escriba su contraseña.'), findsOneWidget);

    await t.enterText(find.byType(TextFormField).last, 'cualquiera');
    await t.tap(find.text('Ingresar'));
    await t.pumpAndSettle();

    // SliverAppBar.large dibuja el título dos veces: expandido y colapsado.
    expect(find.text('Hola, Ignacio'), findsWidgets);
    expect(find.text('Pago pendiente: Bs 50,00'), findsOneWidget);
  });

  testWidgets('cerrar sesión vuelve al login', (t) async {
    final sesion = Sesion();
    // La demora simulada del login es un Timer real: fuera de pump() solo avanza con runAsync.
    await t.runAsync(() => sesion.ingresar(ci: '7633685'));
    await t.pumpWidget(BeniDigital(sesion: sesion));
    await t.pumpAndSettle();

    await t.tap(find.byIcon(Icons.person_outline));
    await t.pumpAndSettle();
    await t.tap(find.text('Cerrar sesión'));
    await t.pumpAndSettle();

    expect(find.text('Ingresar'), findsOneWidget);
  });
}
