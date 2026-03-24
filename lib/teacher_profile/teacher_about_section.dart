import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'dart:math';

class TeacherAboutSection extends StatelessWidget {
  final TutorModel tutor;
  const TeacherAboutSection({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Students', '120+'),
                _buildStatCard('Hours', '1.5k'),
                _buildStatCard('Courses', '12'),
              ],
            ),
            SizedBox(height: 16.0,),
            Container(  //icons container
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000080).withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Transform.rotate(
                        angle: pi,
                        child: Icon(
                          Icons.error_outline_rounded, 
                          color: Color(0xFF000080),
                        ),
                      ),
                      SizedBox(width:4.0),
                      Text(
                        'Details & Expertise',
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0,),
                  _buildInfoCard(Icons.menu_book, 'Expertise Domain', tutor.expertiseDomain),
                  _buildInfoCard(Icons.school_outlined, 'Levels Taught', 'Middle, High School'),
                  _buildInfoCard(Icons.location_on_outlined, 'Location', tutor.location),
                  _buildInfoCard(Icons.devices_rounded, 'Teaching Mode', tutor.teachingMode),
                ],
              ),
            ),
            SizedBox(height: 16.0,),
            _buildTextCard('Academic Background', tutor.academicDescription),
            SizedBox(height: 16.0,),
            _buildTextCard('Teaching Approach', tutor.pedagogicalDescription),
          ],
      ),
    );
  }
}

Widget _buildStatCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.fromLTRB(8.0, 16, 8, 16),
    width: 110,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: const Color(0xFFF1F5F9)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF000080).withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.nunito(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000080),
          ),
        ),
      ],
    ),
  );
}



Widget _buildInfoCard(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF000080).withOpacity(0.15),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Icon(
            icon, 
            color: Color(0xFF000080),
          ),
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.nunito(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildTextCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: const Color(0xFFF1F5F9)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF000080).withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF475569),
          ),
        ),
      ],
    ),
  );
}