/// La persona que usa la app. La cédula es la llave común entre los sistemas.
class Usuario {
  const Usuario({required this.ci, required this.nombre});

  final String ci;
  final String nombre;

  String get primerNombre => nombre.split(' ').first;
}
