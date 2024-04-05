// ignore_for_file: file_names
/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'package:flutter/material.dart';

class ContratarmeView extends StatelessWidget {
  const ContratarmeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Información'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 72, 40, 216),
                  Color.fromARGB(255, 30, 220, 52),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/img/photo_3.jpg'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nombre: Jose Andres Trinidad Almeyda',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Desarrollador de Software',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sobre Mí: Me gusta la tecnologia, programacion y los video juegos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  '¡Hola! Soy un apasionado desarrollador de software con experiencia unos años.',
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Información de Contacto:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildContactInfo(
                  'Correo Electrónico',
                  'Joseandres.0017@gmail.com',
                ),
                _buildContactInfo('Teléfono', '+849-452-7415'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(value),
        const SizedBox(height: 10),
      ],
    );
  }
}
