/*
Nombre: Jose Andres Trinidad Almeyda
Matricula: 2022-0575
Materia: Introduccion del desarrollo de aplicaciones moviles
Facilitador Amadiz Suarez Genao
*/

class Event {
  late int id; 
  late String title;
  late String description;
  late String date;
  late String photoPath;
  late String audioPath;

  Event({
    this.id  = 0,
    required this.title,
    required this.description,
    required this.date,
    this.photoPath  = '',
    required this.audioPath,
  });

  Event.fromMap(Map<String, dynamic> res)
    : id = res["id"] ?? 0, 
      title = res["title"] ?? '', 
      description = res["description"] ?? '', 
      date = res["date"] ?? '', 
      audioPath = res["audioPath"] ?? '',
      photoPath = res["photoPath"] ?? ''; 
     

  // Método para convertir un evento en un mapa de datos, excluyendo el ID
  Map<String, dynamic> toMapExceptId() {
    return {
      'title': title, // Título del evento
      'description': description, // Descripción del evento
      'date': date, // Fecha del evento
      'audioPath': audioPath,
      'photoPath': photoPath, // URL de la foto del evento
    };
  }
}
