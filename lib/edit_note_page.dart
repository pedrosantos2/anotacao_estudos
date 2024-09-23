import 'package:flutter/material.dart';

class EditNotePage extends StatefulWidget {
  final Map<String, String> note;
  final List<String> categories;
  final Function(Map<String, String>) onSave;

  EditNotePage({required this.note, required this.categories, required this.onSave});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController summaryController;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note['titulo']);
    contentController = TextEditingController(text: widget.note['conteudo']);
    summaryController = TextEditingController(text: widget.note['resumo']);
    selectedCategory = widget.note['categoria'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xffe3b8b2), Color(0xffa18093)],
          stops: [0.25, 0.75],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      
      
    ),
  ),
  backgroundColor: Colors.transparent, // Set background color to transparent
  title: Text('Editar Anotação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Conteúdo'),
            ),
            SizedBox(height: 35),
            TextField(
              controller: summaryController,
              decoration: InputDecoration(labelText: 'Resumo',floatingLabelBehavior: FloatingLabelBehavior.always),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedCategory,
              hint: Text('Selecione a Categoria'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: widget.categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffa18093),
                foregroundColor: Colors.black,
                minimumSize: Size(200,50)
              ),
              onPressed: () {
                final newNote = {
                  'titulo': titleController.text,
                  'conteudo': contentController.text,
                  'resumo': summaryController.text,
                  'categoria': selectedCategory ?? 'Outros',
                };
                widget.onSave(newNote);
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
