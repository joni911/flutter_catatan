import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class Note {
  String title;
  String content;

  Note(this.title, this.content);
}

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        title: 'Catatan App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NotesList(),
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          return ListView.builder(
            itemCount: notesProvider.notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notesProvider.notes[index].title),
                subtitle: Text(notesProvider.notes[index].content),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    notesProvider.deleteNote(index);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddNoteScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final note = Note(
                titleController.text,
                contentController.text,
              );
              Provider.of<NotesProvider>(context, listen: false).addNote(note);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Isi Catatan'),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
