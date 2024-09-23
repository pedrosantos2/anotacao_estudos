import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  final List<String> categories;
  final Function(Map<String, String>) onSave;

  AddNotePage({required this.categories, required this.onSave});

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  String? selectedCategory;

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
  title: Text('Criar Anotação'),
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
              onPressed: () => _handleSaveButtonPress(),
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

   void _handleSaveButtonPress() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final summary = summaryController.text.trim();

    if (title.isEmpty) {
      _showAlertDialog('Título', 'O título da anotação não pode ser vazio.');
    } else if (content.isEmpty) {
      _showAlertDialog('Conteúdo', 'O conteúdo da anotação não pode ser vazio.');
    } else {
      final newNote = {
        'titulo': title,
        'conteudo': content,
        'resumo': summary,
        'categoria': selectedCategory ?? 'Outros',
      };
      widget.onSave(newNote);
      Navigator.pop(context);
    }
  }

  void _showAlertDialog(String campo, String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Campo obrigatório'),
        content: Text('O campo $campo deve ser preenchido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
