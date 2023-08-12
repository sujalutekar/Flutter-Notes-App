import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../widgets/note_tile.dart';
import '../pages/add_new_note_page.dart';
import '../pages/note_detail_page.dart';
import '../models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> noteList = [];
  Note currentDeletedNote = Note(
    id: '',
    text: '',
    description: '',
    color: Colors.transparent,
  );

  // adding a new note to noteList
  void onNewNoteCreated(Note note) {
    setState(() {
      noteList.add(note);
    });
  }

  // deleting note
  void deleteNote(Note note) {
    Note deletedNote = Note(
        id: note.id,
        text: note.text,
        description: note.description,
        color: note.color);

    setState(() {
      currentDeletedNote = deletedNote;
      noteList.remove(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: appBarBackgroundColor,
        title: Text(
          'Notes',
          style: GoogleFonts.nunito(
            fontSize: 43,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0,
        actions: [
          // Search Button
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: iconBackgroundColor,
              ),
              child: const Icon(Icons.search),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddNewNotePage(onNewNoteCreated: onNewNoteCreated),
          ),
        ),
        backgroundColor: iconBackgroundColor,
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
      body: noteList.isEmpty
          ? Center(
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/empty-note.png'),
                  ),
                  Text(
                    'Create Your First Note',
                    style:
                        GoogleFonts.nunito(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: noteList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NoteDetailPage(
                                headingText: noteList[index].text,
                                description: noteList[index].description,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            backgroundWidget(noteList[index].text),
                            Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                deleteNote(noteList[index]);
                              },
                              confirmDismiss: (direction) {
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text('Are your sure?'),
                                      content: const Text(
                                          'Do you want to delete this Note?'),
                                      actions: [
                                        // NO
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('NO'),
                                        ),

                                        // YES
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            deleteNote(noteList[index]);
                                            int currentNoteIndex = index;

                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Undo the action',
                                                  style: GoogleFonts.nunito(),
                                                ),
                                                action: SnackBarAction(
                                                  label: 'UNDO',
                                                  textColor: Colors.white,
                                                  onPressed: () {
                                                    setState(() {
                                                      noteList.insert(
                                                        currentNoteIndex,
                                                        currentDeletedNote,
                                                      );
                                                    });
                                                    print(
                                                        'title ${currentDeletedNote.text}');
                                                    print(
                                                        'index $currentNoteIndex');
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('YES'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              direction: DismissDirection.endToStart,
                              child: NoteTile(
                                id: noteList[index].id,
                                text: noteList[index].text,
                                color: noteList[index].color,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

Widget backgroundWidget(String text) {
  return Stack(
    alignment: Alignment.center,
    children: [
      // Background
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 50,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w400,
              fontSize: 25,
              color: Colors.red,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),

      // Foreground
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: const Icon(
              Icons.delete,
              size: 40,
            ),
          ),
        ],
      ),
    ],
  );
}
