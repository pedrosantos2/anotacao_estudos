import 'package:flutter/material.dart';
import 'add_note_page.dart'; // Importando a página de adicionar nota
import 'edit_note_page.dart'; // Importando a página de editar nota

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Anotações',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfffffbd4),
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Uma anotação já postada
  List<Map<String, String>> notes = [
    {
      'titulo': 'Matemática',
      'conteudo': 'Estudo sobre Derivadas',
      'resumo': 'Resumo sobre cálculo diferencial',
      'categoria': 'Matemática'
    }
  ];

  String selectedCategory = 'Todas';
  final List<String> categories = ['Todas', 'Matemática', 'Física', 'Programação'];

  // Estado que controla a visibilidade do resumo de cada anotação
  List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    // Inicializa _isExpanded com o mesmo tamanho de notes
    _isExpanded = List.generate(notes.length, (index) => false);
  }

  // Função para excluir uma anotação
  void _deleteNoteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir a anotação "${notes[index]['titulo']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  notes.removeAt(index); // Remove a anotação
                  _isExpanded.removeAt(index); // Remove o estado de expansão associado
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Anotação excluída com sucesso!')),
                );
              },
              child: Text('Excluir'),
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffccded2), Color(0xfff5ddbb)],
              stops: [0.25, 0.75],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text('Minhas Anotações'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotePage(
                    categories: categories,
                    onSave: (note) {
                      setState(() {
                        notes.add(note);
                        _isExpanded.add(false); // Adiciona estado de expansão para nova anotação
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                if (_isExpanded.length != notes.length) {
                  _isExpanded = List.generate(notes.length, (i) => false);
                }

                if (selectedCategory == 'Todas' || notes[index]['categoria'] == selectedCategory) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    color: Color(0xfff5ddbb),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(notes[index]['titulo'] ?? ''),
                          // Exibe o conteúdo abaixo do título
                          subtitle: Text(notes[index]['conteudo'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Seta para expandir ou colapsar o resumo
                              IconButton(
                                icon: Icon(
                                  _isExpanded[index]
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[index] = !_isExpanded[index]; // Toggle expansão
                                  });
                                },
                              ),
                              // Ícone de exclusão
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteNoteDialog(index); // Chama a função para confirmar e excluir
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditNotePage(
                                  note: notes[index],
                                  categories: categories,
                                  onSave: (updatedNote) {
                                    setState(() {
                                      notes[index] = updatedNote;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        // Exibe o resumo quando expandido
                        if (_isExpanded[index])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              notes[index]['resumo'] ?? 'Sem resumo',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffccded2),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotePage(
                      categories: categories,
                      onSave: (note) {
                        setState(() {
                          notes.add(note);
                          _isExpanded.add(false); // Adiciona estado de expansão para nova anotação
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Criar Nova Anotação'),
            ),
          ),
        ],
      ),
    );
  }
}
