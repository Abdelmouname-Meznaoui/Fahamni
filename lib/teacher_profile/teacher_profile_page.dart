import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'teacher_profile_buttons.dart';

class TeacherProfilePage extends StatelessWidget {
  final TutorModel tutor;


  const TeacherProfilePage({
    super.key,
    required this.tutor,
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        centerTitle: true,
        title: Text(
          'Teacher',
          style: GoogleFonts.inter(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 1.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border_sharp, color: Color(0xFFEF4444)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.share_outlined, color: Color(0xFF1F2937)),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16.0),
          CircleAvatar(
            backgroundImage: AssetImage(
              tutor.picture,
              ),
            radius: 55.0,
          ),
          SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Title(
                color: Color(0xFF1F2937),
                child: Text(
                  '${tutor.lastName} ${tutor.firstName}',
                  style: GoogleFonts.inter(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (tutor.Certified == true) ...[
                const SizedBox(width: 8.0),
                const Icon(Icons.verified_outlined, color: Color(0xFF000080)),
              ],
            ],
          ),
          Text(
            tutor.expertiseDomain,
            style: GoogleFonts.nunito(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000080),
            ),
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_border_outlined, color: Color(0xFFEAB308), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${tutor.averageRating} Rating',
                      style: GoogleFonts.nunito(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const Text('•', style: TextStyle(color: Color(0xFF64748B),fontWeight: FontWeight.bold,fontSize: 16)),

                Text(
                  '${tutor.yearsOfExperience} Years Experience',
                  style: GoogleFonts.nunito(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),

                const Text('•', style: TextStyle(color: Color(0xFF64748B),fontWeight: FontWeight.bold,fontSize: 16)),

                Text(
                  tutor.isAvailable ? 'Available' : 'Away',
                  style: GoogleFonts.nunito(
                    color: tutor.isAvailable ? const Color(0xFF16A34A) : const Color(0xFFDD0D0D),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: TeacherProfileButtons(tutor: tutor)),
        
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: FloatingActionButton.extended(
                heroTag: "Message",
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 194, 194, 209),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(56/2),
                ),
                icon: const Icon(Icons.chat_outlined, color: Color(0xFF1F2937)),
                label: Text(
                  "Message",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: SizedBox(
              height: 56,
              child: FloatingActionButton.extended(
                heroTag: "Quote Request",
                onPressed: () {},
                backgroundColor: const Color(0xFF000080),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(56/2),
                ),
                icon: const Icon(Icons.edit_calendar_outlined, color: Colors.white),
                label: Text(
                  "Quote Request",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
