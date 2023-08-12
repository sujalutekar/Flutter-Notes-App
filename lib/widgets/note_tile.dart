import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteTile extends StatelessWidget {
  final String id;
  final String text;
  final Color color;

  const NoteTile({
    super.key,
    required this.id,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 50,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
