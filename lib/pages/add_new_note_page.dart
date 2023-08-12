import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../models/note.dart';

class AddNewNotePage extends StatefulWidget {
  final Function(Note) onNewNoteCreated;

  const AddNewNotePage({
    super.key,
    required this.onNewNoteCreated,
  });

  @override
  State<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void saveForm() {
    try {
      if (_titleController.text.isNotEmpty) {
        final note = Note(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _titleController.text,
          description: _descriptionController.text.isEmpty
              ? 'No Description!'
              : _descriptionController.text,
          color: dummyColors[currentIndex],
        );

        widget.onNewNoteCreated(note);

        // Showing Snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Note added to your list',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        // Delay by 0.8 seconds
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              title: const Text(
                'Title is empty',
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_titleController.text.isNotEmpty ||
            _descriptionController.text.isNotEmpty) {
          return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Do you want to discard?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('NO'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      Navigator.pop(context);
                    },
                    child: const Text('YES'),
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Buttton
                    GestureDetector(
                      onTap: () {
                        if (_titleController.text.isNotEmpty ||
                            _descriptionController.text.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text('Do you want to discard?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('NO'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('YES'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 24, top: 20),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: iconBackgroundColor,
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_left_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Save Button
                    GestureDetector(
                      onTap: () {
                        saveForm();

                        if (_titleController.text.isNotEmpty) {
                          setState(() {
                            currentIndex =
                                (currentIndex + 1) % dummyColors.length;
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20, right: 24),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: iconBackgroundColor,
                        ),
                        child: const Icon(
                          Icons.save_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Title
                      TextField(
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: GoogleFonts.nunito(
                            color: const Color(0xff9A9A9A),
                            fontSize: 48,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.nunito(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.text,
                      ),

                      // Description
                      TextField(
                        controller: _descriptionController,
                        maxLines: 14,
                        decoration: InputDecoration(
                          hintText: 'Type something...',
                          hintStyle: GoogleFonts.nunito(
                            color: const Color(0xff9A9A9A),
                            fontSize: 23,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.nunito(
                          fontSize: 23,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
