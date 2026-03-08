import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file_uploader.dart';


class TeacherDetailsWidget extends StatelessWidget {  //Alicia's work
  const TeacherDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                "Children Information ",
                style: TextStyle(
                  letterSpacing: -0.25,
                  fontFamily: "Inter",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 30 / 18,
                ),
              ),),
        Container(
          margin: const EdgeInsets.only(left: 34),
          child: const Text(
            "Highest Degree Earned",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff1f2937),
              height: 14 / 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "e.g. Master's in Education",
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 17, fontFamily: 'Lexend'),
              prefixIcon: const Icon(Icons.school_outlined, size: 22, color: Color(0xFF94A3B8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          margin: const EdgeInsets.only(left: 34),
          child: const Text(
            "Graduation University",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff1f2937),
              height: 14 / 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Enter university name",
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 17, fontFamily: 'Lexend'),
              prefixIcon: const Icon(Icons.account_balance_outlined, size: 22, color: Color(0xFF94A3B8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),
       
Container(
          margin: const EdgeInsets.only(left: 34),
          child: const Text(
            "Exp. (Years)",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff1f2937),
              height: 14 / 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Enter a number",
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 17, fontFamily: 'Lexend'),
              prefixIcon: const Icon(Icons.work, size: 22, color: Color(0xFF94A3B8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        

        const SizedBox(height: 12),

        Container(
          margin: const EdgeInsets.only(left: 34),
          child: const Text(
            "Specialization & Bio",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff1f2937),
              height: 14 / 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24),
          child: TextFormField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Describe your teaching style and subjects...",
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15, fontFamily: 'Lexend'),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          margin: const EdgeInsets.only(left: 34),
          child: const Text(
            "Certifications (PDF/JPG)",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff1f2937),
              height: 14 / 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const FileUploadWidget(),
        const SizedBox(height: 30),
      ],
    );
  }
}