import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Subject_picker.dart';


class Student_widget extends StatefulWidget {
  const Student_widget({super.key});
  
  @override
  State<Student_widget> createState() => _Student_widgetState();
}

class _Student_widgetState extends State<Student_widget> {
  String? selectedGrade;
  int selectedIndex = 0;
  String? selectedSpeciality;
  int selectedLevelIndex = -1;
  
  final List<String> yourOptionsList = ['Option 1', 'Option 2', 'Option 3'];
  final List<String> levels = ['Primary', 'Middle', 'High', 'University'];
  final List<List<String>> gradeLists = [
    ['1st year', '2nd year', '3rd year', '4th year', '5th year'],
    ['1st year', '2nd year', '3rd year', '4th year'],
    ['1st year', '2nd year', '3rd year'],
    ['1CP', '2CP', '1CS', '2CS', '3CS','Master']];
    final List<int> levelOffsets = [0, 5, 9, 15];

    static const Map<String, List<String>> SpecialityMapESI = {
    '2CS':    ['Information Systems (SIT)','Computer Systems (SIQ)','Software Engineering (SIL)','AI & Data Science (SID)'],
    '3CS':     ['Information Systems (SIT)','Computer Systems (SIQ)','Software Engineering (SIL)','AI & Data Science (SID)'],
    'Master':       ['AI & Data Science','Cyber Security','Intelligent Systems','Mobile & Embedded Intelligent Systems'],
  };

  static const Map<String, List<String>> SpecialityMap = {
    '1st year':    ['Letters and Social Studies','Sciences and Technology'],
    '2nd year':     ['Experimental Sciences', 'Mathematics', 'Technical Mathematics(Mechanical Engineering)', 'Technical Mathematics(Electrical Engineering)','Technical Mathematics(Civil Engineering)','Technical Mathematics(Methods (Chemistry))','Management and Economics','Philosophy','Foreign Languages','Arts'],
    '3rd year':       ['Experimental Sciences', 'Mathematics', 'Technical Mathematics(Mechanical Engineering)', 'Technical Mathematics(Electrical Engineering)','Technical Mathematics(Civil Engineering)','Technical Mathematics(Methods (Chemistry))','Management and Economics','Philosophy','Foreign Languages','Arts'],
  };

int getRealIndex(String grade) {
  int offset = levelOffsets[selectedIndex];
  int gradePosition = gradeLists[selectedIndex].indexOf(grade);
  return offset + gradePosition;
}
  @override
  
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                "Student Academic Details",
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
            margin: const EdgeInsets.only(left: 29, right: 24),
            child: const Text(
              "Level of Study",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff1f2937),
                height: 14 / 18,
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
           child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex = 0 ;selectedGrade = null;selectedLevelIndex = -1;selectedSpeciality = null;
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
        backgroundColor: selectedIndex == 0
                    ? const Color(0xFF000080)
                    : const Color(0xfff9f9f9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text("Primary",
            style:  TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selectedIndex == 0
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF94A3B8),
              height: 24 / 16,
            ),
          ),
         ),
         
         ),
          SizedBox.fromSize(size: const Size(20, 0)),
         Container(
           child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex =1;selectedGrade = null;selectedLevelIndex = -1;selectedSpeciality = null;  
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(55, 15, 55, 15),
        backgroundColor: selectedIndex == 1
                    ? const Color(0xFF000080)
                    : const Color(0xfff9f9f9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text("Middle",
            style:  TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selectedIndex == 1
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF94A3B8),
              height: 24 / 16,
            ),
          ),
         ),
         
         ),
        ]),
          SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
           child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex = 2; selectedGrade = null;selectedLevelIndex = -1;selectedSpeciality = null;
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
        backgroundColor: selectedIndex == 2
                    ? const Color(0xFF000080)
                    : const Color(0xfff9f9f9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text("High School",
            style:  TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selectedIndex == 2
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF94A3B8),
              height: 24 / 16,
            ),
          ),
         ),
         
         ),
          SizedBox.fromSize(size: const Size(20, 0)),
         Container(
           child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex = 3;selectedGrade = null;selectedLevelIndex = -1;selectedSpeciality = null;
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
        backgroundColor: selectedIndex == 3
                    ? const Color(0xFF000080)
                    : const Color(0xfff9f9f9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text("University",
            style:  TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selectedIndex == 3
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF94A3B8),
              height: 24 / 16,
            ),
          ),
         ),
         
         ),
        ]),
        ],
      ),
          SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 34, right: 24),
            child: const Text(
              "Select Grade",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff1f2937),
                height: 14 / 18,
              ),
            ),
          ),
          
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child:
              DropdownButtonFormField<String>(
                value: selectedGrade,
                isExpanded: true, 
                borderRadius: BorderRadius.circular(16),
                dropdownColor: Colors.white,
                elevation: 8,
                
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
                hint: const Text(
                  'Select Grade',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontFamily: 'Lexend'),
                ),
                items: gradeLists[selectedIndex]
                    .map((grade) => DropdownMenuItem(
                          value: grade,
                          child: Text(
                            grade,
                            style: const TextStyle(
                              color: Color(0xFF1f2937),
                              fontSize: 14,
                              fontFamily: 'Lexend',
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGrade = value;
                    selectedLevelIndex = getRealIndex(value!);
                    selectedSpeciality = null;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.school_outlined, color: Color(0xFF94A3B8)),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
          ),],
          ),
          // Show for High School
if (selectedIndex == 2 && selectedGrade != null)
   Column(
     crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Container(
                margin: const EdgeInsets.only(left: 34),
                child:
              const Text(
                "Speciality",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 14 / 18,
                ),
              ),),
              const SizedBox(height: 8),
  Container(
    margin: const EdgeInsets.only(left: 24, right: 24),
    child: DropdownButtonFormField<String>(
      value: selectedSpeciality,
      isExpanded: true,
      borderRadius: BorderRadius.circular(16),
      dropdownColor: Colors.white,
      elevation: 8,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
      hint: const Text(
        'Select Speciality',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontFamily: 'Lexend'),
      ),
      items: (SpecialityMap[selectedGrade] ?? [])
          .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s, style: const TextStyle(color: Color(0xFF1f2937), fontSize: 14, fontFamily: 'Lexend')),
              ))
          .toList(),
      onChanged: (value) => setState(() => selectedSpeciality = value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.school_outlined, color: Color(0xFF94A3B8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    ),
  ),],),

// Show for University 2CS, 3CS, Master
if (selectedIndex == 3 && (selectedGrade == '2CS' || selectedGrade == '3CS' || selectedGrade == 'Master'))
     Column(
     crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Container(
                margin: const EdgeInsets.only(left: 34),
                child:
              const Text(
                "Speciality",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 14 / 18,
                ),
              ),),
              const SizedBox(height: 8),
  Container(

    margin: const EdgeInsets.only(left: 24, right: 24),
    child: DropdownButtonFormField<String>(
      value: selectedSpeciality,
      isExpanded: true,
      borderRadius: BorderRadius.circular(16),
      dropdownColor: Colors.white,
      elevation: 8,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF94A3B8)),
      hint: const Text(
        'Select Speciality',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, fontFamily: 'Lexend'),
      ),
      items: (SpecialityMapESI[selectedGrade] ?? [])
          .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s, style: const TextStyle(color: Color(0xFF1f2937), fontSize: 14, fontFamily: 'Lexend')),
              ))
          .toList(),
      onChanged: (value) => setState(() => selectedSpeciality = value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.school_outlined, color: Color(0xFF94A3B8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    ),
  ),
     ],),
          const SizedBox(height: 8),
          Container(
                margin: const EdgeInsets.only(left: 34),
                child:
              const Text(
                "Current Institution/School Name",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 14 / 18,
                ),
              ),),


              const SizedBox(height: 8),

              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: 
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g. St. James Academy',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 17,
                    fontFamily: 'Lexend',
                  ),
                  prefixIcon: const Icon(
                    Icons.apartment_outlined,
                    size: 22,
                    color: Color(0xFF94A3B8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFFFFFF),
                ),
              ),),
              const SizedBox(height: 12),
              if (selectedLevelIndex != -1)
            SubjectPickerWidget(
              key: ValueKey(selectedLevelIndex),
              selectedLevelIndex,
            ),

            
        ],
      ),
    );
  }
}