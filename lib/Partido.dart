// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unnecessary_import, avoid_print, body_might_complete_normally_nullable, file_names
/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:audioplayers/audioplayers.dart'; // Importa la biblioteca de audioplayers
import 'package:tarea8/AudioPlayer.dart';
import 'DatabaseHelper.dart';
import 'event.dart';

class Partido extends StatelessWidget {
  const Partido({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Eventos',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: const EventListPage(),
    );
  }
}

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final dbHelper = DatabaseHelper();
  late List<Event> events = [];
  late AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final loadedEvents = await dbHelper.retrieveEvents();
    setState(() {
      events = loadedEvents;
    });
  }

  // Método para reproducir audio desde una URL
  Future<void> _playAudio(String audioUrl) async {
    try {
      await audioPlayer.setSourceUrl(audioUrl);
      print('Reproducción de audio iniciada correctamente');
    } catch (e) {
      print('Error al reproducir audio: $e');
    }
  }

  Future<void> _addEvent(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final urlController = TextEditingController(); // Controller para la URL de la imagen
    final audioFileController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    String? audioFilePath = await FilePicker.platform
        .pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    )
        .then((result) {
      if (result != null) {
        return result.files.single.path;
      }
    });

    if (audioFilePath != null) {
      audioFileController.text = audioFilePath;
    }

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Nuevo Evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: audioFileController,
                  decoration:
                      const InputDecoration(labelText: 'Archivo de audio'),
                ),
                TextField(
                  controller: urlController,
                  decoration:
                      const InputDecoration(labelText: 'URL de la imagen'),
                ),
                // Widget para seleccionar la fecha
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      selectedDate = pickedDate;
                    }
                  },
                  child: const Text('Seleccionar Fecha'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final title = titleController.text;
                final description = descriptionController.text;
                final imageUrl = urlController.text; // Obtener la URL de la imagen
                final date = selectedDate.toString(); // Usar la fecha seleccionada
                final audioFile = audioFileController.text;
                final newEvent = Event(
                  id: 0,
                  title: title,
                  description: description,
                  date: date,
                  audioPath: audioFile,
                  photoPath: imageUrl, // Usar la URL de la imagen proporcionada
                );

                await dbHelper.insertEvent(newEvent);
                await _loadEvents();

                Navigator.of(dialogContext).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editEvent(Event event, BuildContext context) async {
    final titleController = TextEditingController(text: event.title);
    final descriptionController = TextEditingController(text: event.description);
    final urlController = TextEditingController(text: event.photoPath); // Controller para la URL de la imagen
    final audioFileController = TextEditingController(text: event.audioPath);

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Editar Evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Imagen'),
              ),
              TextField(
                controller: audioFileController,
                decoration: const InputDecoration(labelText: 'Audio'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final title = titleController.text;
                final description = descriptionController.text;
                final imagen = urlController.text;
                final audio = audioFileController.text;
                
                final date = DateTime.now().toString();
                final updatedEvent = Event(
                  id: event.id,
                  title: title,
                  description: description,
                  date: date,
                  audioPath: audio,
                  photoPath: imagen, // Mantener la URL existente
                );
                await dbHelper.updateEvent(updatedEvent);
                await _loadEvents();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEvent(Event event) async {
    await dbHelper.deleteEvent(event.id);
    await _loadEvents();
  }

  Future<void> _deleteAllEvents() async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Borrar Todos los Eventos'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar todos los eventos?'),
          actions: [
            TextButton(
              onPressed: () async {
                await dbHelper.deleteAllEvents();
                await _loadEvents();
                Navigator.pop(dialogContext);
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Partidos Politicos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _deleteAllEvents(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: events.map((event) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(event: event),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            event.photoPath,
                            width: 400,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 40,
                              margin: const EdgeInsets.only(
                                  right: 40), // Espacio entre botones
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 3, 245,
                                    124), // Color de fondo para el botón de reproducción de audio
                                borderRadius:
                                    BorderRadius.circular(8), // Radio de borde
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {
                                  _playAudio(
                                      event.audioPath); // Reproducir audio al hacer clic
                                },
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              margin: const EdgeInsets.only(
                                  right: 40), // Espacio entre botones
                              decoration: BoxDecoration(
                                color: Colors
                                    .blue, // Color de fondo para el botón de edición
                                borderRadius:
                                    BorderRadius.circular(8), // Radio de borde
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editEvent(event, context);
                                },
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors
                                    .red, // Color de fondo para el botón de eliminación
                                borderRadius:
                                    BorderRadius.circular(8), // Radio de borde
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Eliminar Evento'),
                                      content: const Text(
                                          '¿Estás seguro de que deseas eliminar este evento?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            _deleteEvent(event);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Event event;
  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 3, 27, 248),
        ),
        child: Column(
          children: [
            if (event.photoPath.isNotEmpty)
              Image.network(
                event.photoPath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo para el primer ListTile
                borderRadius: BorderRadius.circular(10), // Radio de borde
              ),
              child: ListTile(
                title: Text(
                  'Título: ${event.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo para el segundo ListTile
                borderRadius: BorderRadius.circular(10), // Radio de borde
              ),
              child: ListTile(
                title: Text('Descripción: ${event.description}'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo para el tercer ListTile
                borderRadius: BorderRadius.circular(10), // Radio de borde
              ),
              child: ListTile(
                title: Text('Fecha: ${event.date}'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo para el tercer ListTile
                borderRadius: BorderRadius.circular(10), // Radio de borde
              ),
              child: ListTile(
                title: PlayerWidget(player: AudioPlayer()..setSourceUrl(event.audioPath)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
