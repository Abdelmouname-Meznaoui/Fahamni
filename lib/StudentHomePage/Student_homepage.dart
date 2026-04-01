import 'package:carousel_slider/carousel_slider.dart';
import 'package:fahamni/StudentHomePage/studenthome_service.dart';
import 'package:fahamni/Explore_map_pages/explorepage.dart';
import 'package:fahamni/messaging/chat_page.dart';
import 'package:fahamni/models/session_model.dart';
import 'package:fahamni/models/student_model.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:fahamni/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fahamni/widgets/customnavbar.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

class Studentpage extends StatelessWidget {
  const Studentpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      home: const Studenthomepage(),
    );
  }
}

class Studenthomepage extends StatefulWidget {
  const  Studenthomepage({super.key});
  @override
  State<Studenthomepage> createState() => _StudenthomepageState();
}

class _StudenthomepageState extends State<Studenthomepage> {
  List<String> images = [
    'assets/images/slide2.png',
    'assets/images/slide0.png',
    'assets/images/slide1.png',
  ];
  final List<Map<String, dynamic>> teachers = [
    {
      'name': 'Sami',
      'image': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'name': 'Sami',
      'image': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'name': 'Sami',
      'image': 'https://randomuser.me/api/portraits/women/68.jpg',
    },
    {
      'name': 'Sami',
      'image': 'https://randomuser.me/api/portraits/men/75.jpg',
    },
    {
      'name': 'Sami',
      'image': 'https://randomuser.me/api/portraits/women/17.jpg',
    },
    {
      'name': 'Sami',
      'image': 'https://randomuser.me/api/portraits/men/52.jpg',
    },
  ];
  int currentindex=0;
  int counter = 0;
  int minutes = 0;
  String ? mode ;
  StudentModel ? student ;
  int _selectedIndex = 0;
  TutorModel ? sessiontutor;
  List<TutorModel> ? favoriteTutors = [];
  List<SessionModel> ? courses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStudent();
  }
  Future<void> loadStudent() async {
  try {
    final data = await studenthomepage_service().getStudentData();
    final tutors = await studenthomepage_service().getFavoriteTeachers(data.favoriteTeachers);
    final sessions = await studenthomepage_service().getCourses(data.Courses);
    sessions.sort((a,b) => a.date.compareTo(b.date));
    final tutor = sessions.isNotEmpty ? await studenthomepage_service().getTutorData(sessions[0].tutorId) : null;
    if (!mounted) return;
    setState(() {
      student = data;
      favoriteTutors = tutors;
      courses = sessions;
      sessiontutor = tutor;
    });
    if (sessions.isNotEmpty) {
      minutes = courses![0].endTime.difference(courses![0].startTime).inMinutes;
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      student = StudentModel(  // set a fallback so spinner stops
        uid: '', firstName: 'Error', lastName: '',
        email: '', phone: '', location: '',
        gender: Gender.male, birthday: DateTime.now(),
        accountStatus: AccountStatus.validated,
        picture: '', schoolLevel: '', learningObjectives: '',
        preferredSubjects: [], favoriteTeachers: [], Courses: [],
      );
    });
    debugPrint('loadStudent error: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    if (student == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 5, 16, 0), // Added right margin
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align to start
            children: [
              // First row with avatar and icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(student!.picture != "")
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(student!.picture),
                  )
                  else
                    if (student!.gender == Gender.male)
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/studentmale.png'),
                     )
                    else
                     CircleAvatar(
                       radius: 25,
                       backgroundImage: AssetImage('assets/images/studentfemale.png'),
                       backgroundColor: Colors.white,
                     ),
                  SizedBox(width: 5),
                  Expanded( // Wrap with Expanded to take available space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 300),
                          child: Text(
                            '${student?.firstName} ${student?.lastName} ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF1F2937),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          '${student?.role.name}',
                          style: TextStyle(
                            color: const Color(0xFF000080),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: ImageIcon(
                      AssetImage('assets/images/bell.png'),
                      color: Colors.black,
        ),
                    iconSize: 35,
                  ),
                ],
              ),
              SizedBox(height: 5),

              // Search row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded( // Expanded makes TextField take full width
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                        boxShadow: [ BoxShadow(
                          color: Color(0xFF000080).withOpacity(0.61),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(0,0),
                          blurStyle: BlurStyle.normal,

                        )
                        ],
                      ),
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Search for Teacher/module...',
                          hintStyle: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                            fontSize: 14 ,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(80),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),

                      ),
                    ),
                  ),
                  SizedBox(width: 2,),
                  Container(
                    height: 70,
                    width: 50,
                    child: Center(
                      child: IconButton(
                          onPressed: (){},
                          icon: ImageIcon(
                              AssetImage('assets/images/search.png'),
                            color: Colors.black,
                          ),
                          iconSize: 40,
                      ),
                    ),
                  )
                ],
              ),


              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(-0, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                    
                    
                    child:CarouselSlider(items: images.map((item) =>
                    Stack(
                      children: [
                        Container(
                        margin: EdgeInsets.all(5),
                        width: 398,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage(item),fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF000080).withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              )
                            ]
                        ),
                        ),
                        Positioned(
                            top: 140 ,
                            left: 23,
                            child: Container(
                             height: 35,
                             width: 100,
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(8),
                             ),
                              child: Center(
                                child: Text(
                                    'En Profiter',
                                   style: TextStyle(
                                     color: Color(0xFF000080),
                                     fontFamily: "Nunito",
                                     fontWeight: FontWeight.w700,
                                   ),
                                ),
                              ),
                            )
                        )
                      ],
                    )).toList(),
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        enlargeCenterPage: true,
                        aspectRatio: 16/9,
                        viewportFraction: 0.95,
                        enlargeFactor: 0.2,
                        enableInfiniteScroll: true,
                        clipBehavior: Clip.none,
                        padEnds: true,
                        onPageChanged: (index,reason){
                          setState(() {
                            currentindex  = index ;
                          });
                        }
                      )
                  ),),),
                  SizedBox(
                    height: 5,
                  ),
                  //dots slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((item) => Container(
                      height: 12,
                      width: 12,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentindex == item.key ? Color(0xFF000080) : Colors.grey,
                      ),
                    )).toList(),
                  )
                ],
              ),

              // Online teachers
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                        'Favorite Teachers',
                         style: TextStyle(
                           color: Colors.black,
                           fontFamily: "Inter",
                           fontSize: 20,
                           fontWeight: FontWeight.w600,
                         ),

                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      'See All',
                       style: TextStyle(
                         fontFamily: "Nunito",
                         fontSize: 17,
                         fontWeight: FontWeight.w600,
                         color: Color(0xFF000080),
                       ),
                    ),

                  )
                ],
              ),
             SizedBox(
               height: 100,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 shrinkWrap: true,
                 itemCount: favoriteTutors?.length,
                 itemBuilder: (context, index) {
                   if(favoriteTutors?.length == 0){
                     return Container(
                       height: 500,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           SizedBox(width: 80 ,),
                           Text(
                               'NO Favorite Teachers :(',
                               style: TextStyle(
                                 fontFamily: 'Nunito',
                                 fontWeight: FontWeight.w700,
                                 fontSize: 20,
                                 color: Colors.grey,
                               ),
                           ),
                         ],
                       ),

                     );
                   }
                   return Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: GestureDetector(
                             onTap: (){},
                             child: Stack(
                               children: [
                                 Container(
                                   height:60,
                                   width:60,
                                   decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   image: DecorationImage(
                                       image: NetworkImage((favoriteTutors?[index].picture).toString()),
                                       fit : BoxFit.cover ),
                                   ),
                                 ),
                                 Positioned(
                                   left: 40 ,
                                   top:45 ,
                                   child: Container(
                                     height:14,
                                     width:14,
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Colors.white,
                                     ),
                                     child: Center(
                                       child: SvgPicture.asset(
                                        "assets/images/heart.svg",
                                  
                                        
                                       ),
                                     ),
                                   ),

                                   ),
                               ],
                             ),
                           )
                         ),
                         Text(
                           (favoriteTutors?[index].firstName).toString(),
                             style: TextStyle(
                              color: Colors.black,
                             fontFamily: "Nunito",
                             fontWeight: FontWeight.w500,
                             fontSize: 16,
                             ),
                         )
                       ],
                   );
                 },
               ),
             ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Course Schedule',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Inter",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),

                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Color(0xFF000080),
                      ),
                    ),

                  )
                ],
              ),
              if(courses?.length==0)
                Row(
                  children: [
                    SizedBox(width: 100 ,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50,),
                        Text(
                            "Start your Journey",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                            onPressed:(){},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF000080),
                                foregroundColor: Colors.white,
                                minimumSize: Size(100, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                 )
                            ),
                              child: Text(
                                  'Book a Session',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 18

                                ),
                              ),
                        )
                      ],
                    ),
                  ],
                )
              else if(sessiontutor != null)
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  height: 230,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        left: BorderSide(
                          color: Color(0xFF000080), // Your custom color
                          width: 5, // Border width
                          style: BorderStyle.solid, // solid is default
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000080).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(2, 3),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Color(0xFF6324EB).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  'NEXT COURSE',
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF000080),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 150,),
                            Container(
                              height: 25,
                              width:70,
                              decoration: BoxDecoration(
                                color: courses![0].type == "online" ? Color(0xFFDCFCE7) : Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                                child: Center(
                                  child: Text(
                                    courses![0].type,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: courses![0].type == "online" ? Color(0xFF16A34A) : Colors.white,
                                      height: 1.25,
                                    ),

                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          width: 200,
                          height: 28,
                          child: Text(
                            sessiontutor!.expertiseDomain,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/person.svg",
                              height: 20,
                              width: 20,
                              color: Color(0xFF475569),
                            ),

                            SizedBox(width: 10,),
                            Text(
                              sessiontutor!.firstName,
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/time.svg",
                              height: 20,
                              width: 20,
                              color: Color(0xFF475569),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              DateFormat('HH:mm').format(courses![0].startTime)+ "-"+
                              DateFormat('HH:mm').format(courses![0].endTime)+" ("+
                              '$minutes min)',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 28,),
                        Container(
                          height: 48,
                          width: 370,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: ImageIcon(
                              AssetImage('assets/images/Icon.png'),

                            ),

                            label: Text(
                              'Join the course',
                              style: TextStyle(
                                  fontFamily: "Lexend",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF000080), // Your dark color
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              //  minimumSize: Size(324, 48), // Minimum width and height
                            ),
                          ),
                        )
                      ],

                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
          selectedIndex: _selectedIndex,
          onTap: (index){
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Explorepage(student: student!) ),
              );
            }
            else if (index == 3) {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatPage() ),
              );
            }
            else{
              setState(() {
                _selectedIndex = index ;
              });
            }
          })
    );
  }
}