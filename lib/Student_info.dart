//import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fahamni/widgets/widgets.dart';



class studentinfo extends StatefulWidget {
  const studentinfo({super.key});

  @override
  State<studentinfo> createState() => _studentinfoState();
}

class _studentinfoState extends State<studentinfo> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xfff9f9f9),

      appBar: AppBar(
        backgroundColor: const Color(0xfff9f9f9),
        leading: Container(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 24,
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        title: const Text(
          "User Registration",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xff0f172a),
            height: 23 / 18,
          ),
        ),
        centerTitle: true,
      ),


        body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8,0,0,8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bare(2,1),
            Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                "Who are you?",
                style: TextStyle(
                  letterSpacing: -0.25,
                  fontFamily: "Inter",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 30 / 18,
                ),
              ),),
           
              SizedBox(height: 20),
              Buttons(selectedIndex,(index) => setState(() => selectedIndex = index),
        ),
              SizedBox(height: 20),
              if (selectedIndex == 0) Student_widget(),
if (selectedIndex == 1) Parent_widget(),
//if (selectedIndex == 2) Tutor_widget(),
          ],
    ),),),);
  }
}


class Buttons extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectionChanged;

  const Buttons(this.selectedIndex, this.onSelectionChanged, {super.key});
 
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFFAFAFA),
        
      ),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: const EdgeInsets.fromLTRB(10, 0, 18, 0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         Container(
           child: ElevatedButton(
            onPressed: () {
             
                onSelectionChanged(selectedIndex == 0 ? -1 : 0);
              ;

            },
            
         style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        backgroundColor: selectedIndex == 0
                    ? const Color(0xFF000080)
                    : const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text("Student",
            style:  TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selectedIndex == 0
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF000080),
              height: 24 / 16,
            ),
          ),
         ),),
         SizedBox.fromSize(size: const Size(5, 0)),
         Container(
           child: ElevatedButton(
            onPressed: () {
              
                onSelectionChanged(selectedIndex == 1 ? -1 : 1);
            

            },
        
         style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        backgroundColor: selectedIndex == 1
                    ? const Color(0xFF000080)
                    : const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text("Parent",
            style:  TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selectedIndex == 1
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF000080),
              height: 24 / 16,
            ),
          ),
         ),
         
         ),
         SizedBox.fromSize(size: const Size(5, 0)),
         Container(
           child: ElevatedButton(
            onPressed: () {
              
                onSelectionChanged(selectedIndex == 2 ? -1 : 2);
              

            },
         style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        backgroundColor: selectedIndex == 2
                    ? const Color(0xFF000080)
                    : const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
         child: Text("Tutor",
            style:  TextStyle(
              fontFamily: "Inter",
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: selectedIndex == 2
                      ? const Color(0xFFFAFAFA)
                      : const Color(0xFF000080),
              height: 24 / 16,
            ),
          ),
         ),
         ),
       ],),
    );
  }
}


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




class Buttons1 extends StatefulWidget {
  const Buttons1({super.key});
 
  @override
  State<Buttons1> createState() =>  Buttons1State();
}

class  Buttons1State extends State<Buttons1> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
           child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex = selectedIndex == 1 ? -1 : 1;
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
        backgroundColor: selectedIndex == 1
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
              color: selectedIndex == 1
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
                selectedIndex = selectedIndex == 2 ? -1 : 2;
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
        backgroundColor: selectedIndex == 2
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
              color: selectedIndex == 2
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
                selectedIndex = selectedIndex == 3 ? -1 : 3;
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
        backgroundColor: selectedIndex == 3
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
              color: selectedIndex == 3
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
                selectedIndex = selectedIndex == 4 ? -1 : 4;
              });

            },
        
         style: ElevatedButton.styleFrom(
          elevation: 0,
        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
        backgroundColor: selectedIndex == 4
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
              color: selectedIndex == 4
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
    );
  }
}


class SubjectPickerWidget extends StatefulWidget {
  final int i;
  const SubjectPickerWidget(this.i,{super.key});

  @override
  State<SubjectPickerWidget> createState() => _SubjectPickerWidgetState();
}

class _SubjectPickerWidgetState extends State<SubjectPickerWidget> {
  final List<List<String>> subjectLists = [
  // 1st Year Primary School
  [
    'Arabic Language', 'Mathematics', 'Islamic Education', 'Civic Education',
    'Art Education', 'Physical Education and Sports'
  ],
  
  // 2nd Year Primary School
  [
    'Arabic Language', 'Mathematics', 'Islamic Education', 'Civic Education',
    'Art Education', 'Physical Education and Sports'
  ],
  
  // 3rd Year Primary School
  [
    'Arabic Language', 'Mathematics', 'Science', 'History - Geography',
    'French', 'English', 'Islamic Education', 'Civic Education',
    'Art Education', 'Physical Education and Sports'
  ],
  
  // 4th Year Primary School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics', 'Science',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Art Education', 'Physical Education and Sports'
  ],
  
  // 5th Year Primary School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics', 'Science',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Art Education', 'Physical Education and Sports'
  ],
  
  // 1st Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences and Technology',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // 2nd Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // 3rd Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // 4th Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // High School - Experimental Sciences
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Mathematics', 'Life and Earth Sciences',
    'Physics Sciences', 'History - Geography', 'French', 'English',
    'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Mathematics
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Advanced Mathematics', 'Physics Sciences',
    'Life and Earth Sciences', 'History - Geography', 'French',
    'English', 'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Technical Mathematics
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Mathematics', 'Physics Sciences', 'Industrial Technology',
    'Engineering (specialty dependent)', 'Technical Drawing', 'History - Geography',
    'French', 'English', 'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Management and Economics
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Applied Mathematics', 'General Economics', 'Management and Accounting',
    'Law', 'History - Geography', 'French', 'English',
    'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Letters and Philosophy
  [
    'Advanced Arabic Language', 'Tamazight Language (region dependent)',
    'Advanced Philosophy', 'History - Geography', 'Islamic Sciences',
    'French', 'English', 'Light Mathematics', 'Physical Education and Sports'
  ],
  
  // High School - Foreign Languages
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Advanced French', 'Advanced English', 'Third Foreign Language',
    'History - Geography', 'Light Mathematics', 'Islamic Education',
    'Physical Education and Sports'
  ],
  
  // Higher Education - 1CP (Engineering 1st Year)
  [
    'Electricity', 'Office Automation and Web', 'English 1', 'Mathematical Analysis 1',
    'Algorithms and Static Data Structures', 'Computer Architecture 1',
    'Algebra 1', 'Introduction to Operating Systems 1', 'Written Expression Techniques',
    'Algorithms and Dynamic Data Structures',
    'Introduction to Operating Systems 2', 'English 1',
    'Oral Expression Techniques', 'Algebra 2', 'Mathematical Analysis 2',
    'Fundamental Electronics 1', 'Point Mechanics'
  ],
  
 
  
  // Higher Education - 2CP (Engineering 2nd Year)
  [
    'Business Economics', 'Mathematical Analysis 3',
    'Computer Architecture 2', 'Fundamental Electronics 2',
    'English 2', 'Algebra 3', 'File Structures and Data Structures',
    'Probability & Statistics 1','English 3', 'Mathematical Logic', 'Optics and Electromagnetic Waves',
    'Probability & Statistics 2', 'Object-Oriented Programming',
    'Mathematical Analysis 4', 'Information Systems', 'Project 2CPI'
  ],
  
 
  
  // Higher Education - 1CS  (Engineering 3rd Year)
  [
    'Centralized Operating Systems 1', 'Introduction to Software Engineering',
    'Operational Research', 'Programming Language Theory',
    'Organizational Analysis', 'Networks 1', 'Numerical Analysis', 'English',
    'Computer Architecture 3', 'Project Management', 'Networks 2',
    'Databases', 'IS Design Methodology',
    'Computer Security', 'Centralized Operating Systems 2',
    'Project 1CS'
  ],
  
  // Higher Education - 2CS Main Modules (Engineering 4th Year)
  [
    'High Performance Computing', 'Machine Learning', 'Data Analysis',
    'Advanced Databases', 'Signal Processing',
    'Complexity and Problem Solving', 'Information Visualization',
    'Advanced Mathematics for Data Science', 'Smart Government'
  ],
  
  // Higher Education - 3CS Master (Engineering 5th Year/Master)
  [
    'Artificial Intelligence', 'Information System Architectures',
    'Research Valorization', 'Distributed Systems', 'Agent Technology',
    'Machine Learning', 'Research Methodology', 'IT Master Plan',
    'Advanced Networks and Simulation', 'Information Visualization',
    'Information Retrieval'
  ]
];

  List<String> selectedSubjects = [];

  void _showSubjectPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => ListView(
          children: subjectLists[widget.i].map((subject) => ListTile(
            title: Text(subject),
            trailing: selectedSubjects.contains(subject)
                ? const Icon(Icons.check, color: Color(0xFF000080))
                : null,
            onTap: () {
              setState(() {
                if (selectedSubjects.contains(subject)) {
                  selectedSubjects.remove(subject);
                } else {
                  selectedSubjects.add(subject);
                }
              });
              setModalState(() {}); // updates checkmarks inside sheet
            },
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Container(
                margin: const EdgeInsets.only(left: 10),
                child:
              const Text(
                "Interests / Subjects of Focus",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 14 / 18,
                ),
              ),),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // selected chips
            ...selectedSubjects.map((subject) => Chip(
              label: Text(
                subject,
                style: const TextStyle(
                  color: Color(0xFF000080),
                  fontWeight: FontWeight.w700,
                ),
              ),
              deleteIcon: const Icon(Icons.close, size: 16, color: Color(0xFF000080)),
              onDeleted: () => setState(() => selectedSubjects.remove(subject)),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            )),

            // Add more button
            GestureDetector(
              onTap: () => _showSubjectPicker(context),
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                child:
              const Text(
                "Add more...",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF94A3B8),
                  height: 14 / 18,
                ),
              ),),
            ),
          ],
        ),
      ],
    ),);
  }
}


class Parent_widget extends StatefulWidget {
  const Parent_widget({super.key});

  @override
  State<Parent_widget> createState() => _Parent_widgetState();
}

class _Parent_widgetState extends State<Parent_widget> {
  // Each item in this list = one child card on screen
  List<Map<String, dynamic>> children = [
    {"id": UniqueKey().toString(),"name": "", "level": null, "grade": null}];
  void addChild() {
    setState(() {
      children.add({"id": UniqueKey().toString(),"name": "", "level": null, "grade": null});
    });
  }
  void removeChild(int index) {
    setState(() {
      children.removeAt(index);});
  }
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
        ...List.generate(
          children.length,
          (index) => ChildCard(
            key: ValueKey(children[index]['id']),
            index: index,
            data: children[index],
            onRemove: children.length > 1 ? () => removeChild(index) : null,
            onChanged: (updatedData) {
              setState(() {
              children[index] = updatedData;
              });
            },
          ),
        ),

        const SizedBox(height: 12),

        // Add Another Child button
        Center(
          child: TextButton.icon(
            onPressed: addChild,
            icon: const Icon(
              size: 20,
              Icons.add_circle_outline,
              color: Color(0xFF000080),
            ),
            label: const Text(
              "Add Another Child",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF000080),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class ChildCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;
  final VoidCallback? onRemove;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const ChildCard({
    super.key,
    required this.index,
    required this.data,
    required this.onRemove,
    required this.onChanged,
  });

  // Level → its available grades
  static const Map<String, List<String>> gradeMap = {
    'Primary':    ['1st year', '2nd year', '3rd year', '4th year', '5th year'],
    'Middle':     ['1st year', '2nd year', '3rd year', '4th year'],
    'High':       ['1st year', '2nd year', '3rd year'],
    
  };

  static const Map<String, List<String>> SpecialityMap = {
    '1st year':    ['Letters and Social Studies','Sciences and Technology'],
    '2nd year':     ['Experimental Sciences', 'Mathematics', 'Technical Mathematics(Mechanical Engineering)', 'Technical Mathematics(Electrical Engineering)','Technical Mathematics(Civil Engineering)','Technical Mathematics(Methods (Chemistry))','Management and Economics','Philosophy','Foreign Languages','Arts'],
    '3rd year':       ['Experimental Sciences', 'Mathematics', 'Technical Mathematics(Mechanical Engineering)', 'Technical Mathematics(Electrical Engineering)','Technical Mathematics(Civil Engineering)','Technical Mathematics(Methods (Chemistry))','Management and Economics','Philosophy','Foreign Languages','Arts'],
  };

  static const List<int> levelOffsets = [0, 5, 9];
  static const List<String> levelOrder = ['Primary', 'Middle', 'High'];
  

  int getRealIndex() {
  if (!levelOrder.contains(data['level'])) return 0;
  int offset = levelOffsets[levelOrder.indexOf(data['level'])];
  int gradePosition = gradeMap[data['level']]!.indexOf(data['grade']);
  return offset + gradePosition;
}
  static const List<List<String>> subjectLists = [
  // 1st Year Primary School
  [
    'Arabic Language', 'Mathematics', 'Islamic Education', 'Civic Education',
    'Art Education', 'Physical Education and Sports'
  ],
  
  // 2nd Year Primary School
  [
    'Arabic Language', 'Mathematics', 'Islamic Education', 'Civic Education',
    'Art Education', 'Physical Education and Sports'
  ],
  
  // 3rd Year Primary School
  [
    'Arabic Language', 'Mathematics', 'Science', 'History - Geography',
    'French', 'English', 'Islamic Education', 'Civic Education',
    'Art Education', 'Physical Education and Sports'
  ],
  
  // 4th Year Primary School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics', 'Science',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Art Education', 'Physical Education and Sports'
  ],
  
  // 5th Year Primary School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics', 'Science',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Art Education', 'Physical Education and Sports'
  ],
  
  // 1st Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences and Technology',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // 2nd Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // 3rd Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // 4th Year Middle School
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Mathematics',
    'Life and Earth Sciences', 'Physics Sciences',
    'History - Geography', 'French', 'English', 'Islamic Education',
    'Civic Education', 'Computer Science', 'Art Education',
    'Physical Education and Sports'
  ],
  
  // High School - Experimental Sciences
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Mathematics', 'Life and Earth Sciences',
    'Physics Sciences', 'History - Geography', 'French', 'English',
    'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Mathematics
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Advanced Mathematics', 'Physics Sciences',
    'Life and Earth Sciences', 'History - Geography', 'French',
    'English', 'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Technical Mathematics
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Mathematics', 'Physics Sciences', 'Industrial Technology',
    'Engineering (specialty dependent)', 'Technical Drawing', 'History - Geography',
    'French', 'English', 'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Management and Economics
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Applied Mathematics', 'General Economics', 'Management and Accounting',
    'Law', 'History - Geography', 'French', 'English',
    'Islamic Education', 'Physical Education and Sports'
  ],
  
  // High School - Letters and Philosophy
  [
    'Advanced Arabic Language', 'Tamazight Language (region dependent)',
    'Advanced Philosophy', 'History - Geography', 'Islamic Sciences',
    'French', 'English', 'Light Mathematics', 'Physical Education and Sports'
  ],
  
  // High School - Foreign Languages
  [
    'Arabic Language', 'Tamazight Language (region dependent)', 'Philosophy',
    'Advanced French', 'Advanced English', 'Third Foreign Language',
    'History - Geography', 'Light Mathematics', 'Islamic Education',
    'Physical Education and Sports'
  ],
  
];

  @override
  Widget build(BuildContext context) {
    final List<String> grades =
        data['level'] != null ? gradeMap[data['level']] ?? [] : [];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "CHILD ${index + 1}",
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.6,
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFEF4444), 
                        size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            const Text(
              "Child Name",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: data['name'],
              onChanged: (value) {
                onChanged({...data, 'name': value});
              },
              decoration: InputDecoration(
                hintText: 'Mimoun Mahieddine',
                hintStyle: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(Icons.person_outline,
                    color: Color(0xFF94A3B8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFE0E0E0), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Level of Study",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: data['level'],
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF94A3B8)),
              hint: const Text(
                'Select level',
                style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontFamily: 'Inter'),
              ),
              items: gradeMap.keys
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level,
                            style: const TextStyle(
                                color: Color(0xFF1f2937),
                                fontSize: 14,
                                fontFamily: 'Inter')),
                      ))
                  .toList(),
              onChanged: (value) {
                // Reset grade when level changes
                onChanged({...data, 'level': value, 'grade': null});
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.school_outlined,
                    color: Color(0xFF94A3B8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFE0E0E0), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFFF9F9F9),
              ),
            ),

            if (data['level'] != null) ...[ //to show grade only after select level
              const SizedBox(height: 16),
              const Text(
                "Grade",
                style: TextStyle(
                  fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
              // Horizontally scrollable chip row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: grades
                      .map(
                        (grade) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(grade),
                            checkmarkColor: Colors.white,
                            selected: data['grade'] == grade,
                            onSelected: (_) {
                              onChanged({...data, 'grade': grade});
                            },
                            selectedColor: const Color(0xFF000080),
                            backgroundColor: const Color(0xFFF9F9F9),
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            labelStyle: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: data['grade'] == grade? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],

            if (data['level'] == 'High' && data['grade'] != null) ...[ //to show grade only after select level
              const SizedBox(height: 16),
              const Text(
                "Speciality",
                style: TextStyle(
                  fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
              // Horizontally scrollable chip row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (SpecialityMap[data['grade']] ?? []).map((speciality) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(speciality),
                            checkmarkColor: Colors.white,
                            selected: data['speciality'] == speciality,
                            onSelected: (_) {
                              onChanged({...data, 'speciality': speciality});
                            },
                            selectedColor: const Color(0xFF000080),
                            backgroundColor: const Color(0xFFF9F9F9),
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            labelStyle: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: data['speciality'] == speciality? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          
             if (data['grade'] != null) ...[ //to show grade only after select level
              const SizedBox(height: 16),
              const Text(
                "Interests / Subjects of Focus",
                style: TextStyle(
                  fontFamily: "Inter",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
               SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
    children: subjectLists[getRealIndex()].map((subject) {
      final List<String> selected = List<String>.from(data['subjects'] ?? []);
      final bool isSelected = selected.contains(subject);
      return FilterChip(
        label: Text(subject),
        selected: isSelected,
        checkmarkColor: Colors.white,
        selectedColor: const Color(0xFF000080),
        backgroundColor: const Color(0xFFF9F9F9),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
        labelStyle: TextStyle(
          fontFamily: "Inter",
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : const Color(0xFF475569),
        ),
        onSelected: (_) {
          final List<String> updated = List<String>.from(data['subjects'] ?? []);
          if (isSelected) {
            updated.remove(subject);  // deselect
          } else {
            updated.add(subject);     // select
          }
          onChanged({...data, 'subjects': updated});
        },
      );
    }).toList(),
  ),
        ),],
          ],
        ),
      ),
    );
  }
}