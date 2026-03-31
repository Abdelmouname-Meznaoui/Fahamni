import 'package:fahamni/widgets/customnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../StudentHomePage/Student_homepage.dart';
import '../models/service_model.dart';
import '../models/tutor_model.dart';



class Servicedetails extends StatefulWidget {
  final TutorModel tutor;
  final ServiceModel service;
  const Servicedetails({
    super.key,
    required this.service,
    required this.tutor,
  });

  @override
  State<Servicedetails> createState() => _ServicedetailsState();
}

class _ServicedetailsState extends State<Servicedetails> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: const Color(0xfff9f9f9),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          iconSize: 24,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text(
          "Service",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff0f172a),
            height: 23 / 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Image.asset(
                "assets/images/slide1.png",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsetsGeometry.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                          widget.service.subject,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 115,
                              padding: EdgeInsetsGeometry.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                  color: Color(0xFF000080).withOpacity(0.2),
                                  spreadRadius: 0.5,
                                  blurRadius:4,
                                  offset: Offset(0, 1),
                                )]
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'STUDENTS',
                                    style: TextStyle(
                                        color: Color(0xFF64748B),
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    widget.service.enrollednum.toString(),
                                    style: TextStyle(
                                        color: Color(0xFF000080),
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                    ),
                                  )
                                ],
                              ) ,
                            ),
                            SizedBox(width: 16,),
                            Container(
                              height: 80,
                              width: 115,
                              padding: EdgeInsetsGeometry.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: Color(0xFF000080).withOpacity(0.2),
                                    spreadRadius: 0.5,
                                    blurRadius:4,
                                    offset: Offset(0, 1),
                                  )]
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'SESSIONS',
                                    style: TextStyle(
                                        color: Color(0xFF64748B),
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    widget.service.sessionsnum.toString(),
                                    style: TextStyle(
                                        color: Color(0xFF000080),
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17
                                    ),
                                  )
                                ],
                              ) ,
                            ),
                            SizedBox(width: 16,),
                            Container(
                              height: 80,
                              width: 115,
                              padding: EdgeInsetsGeometry.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(
                                    color: Color(0xFF000080).withOpacity(0.2),
                                    spreadRadius: 0.5,
                                    blurRadius:4,
                                    offset: Offset(0, 1),
                                  )]
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'PRICE',
                                    style: TextStyle(
                                        color: Color(0xFF64748B),
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "${widget.service.price.toInt()}DA",
                                    style: TextStyle(
                                        color: Color(0xFF000080),
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17
                                    ),
                                  )
                                ],
                              ) ,
                            )
                          ],
                        ),
                    ),
                    SizedBox(height: 15,),
                    if(widget.service.maxnum - widget.service.enrollednum <= 10)
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/circle-alert.svg",
                            height: 20,
                            width: 20,
                            color: const Color(0xFFDD0D0D),
                          ),
                          SizedBox(width: 5,),
                          Text(
                              "${widget.service.maxnum - widget.service.enrollednum} places left",
                            style: TextStyle(
                              color: const Color(0xFFDD0D0D),
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsetsGeometry.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000080).withOpacity(0.2),
                            spreadRadius: 0.5,
                            blurRadius:4,
                            offset: Offset(0, 1),
                          )
                        ]
                      ),
                      child: Column(
                        children: [

                          // Column fro the Services details

                         Row(
                           children: [
                             Icon(
                               Icons.info_outline_rounded,
                               color: Color(0xFF000080),
                               size: 30,
                             ),
                             SizedBox(width: 5,),
                             Text(
                               'Service Details',
                               style: TextStyle(
                                 color: Color(0xFF1F2937),
                                 fontFamily: "Inter",
                                 fontWeight: FontWeight.w700,
                                 fontSize: 18,
                               ),
                             ),
                           ],
                         ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsetsGeometry.all(8),
                                decoration : BoxDecoration(
                                  color: Color(0xFF000080).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SvgPicture.asset(
                                    'assets/images/course.svg',
                                    height: 20,
                                    width:20 ,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('DOMAIN',
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(widget.service.subject,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsetsGeometry.all(8),
                                decoration : BoxDecoration(
                                  color: Color(0xFF000080).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                    Icons.school_outlined,
                                  color: Color(0xFF000080),
                                )
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('GRADE',
                                    style: TextStyle(
                                      fontFamily: "Nuntio",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(widget.service.level,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 13,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsetsGeometry.all(8),
                                decoration : BoxDecoration(
                                  color: Color(0xFF000080).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                    Icons.access_time,
                                  color: Color(0xFF000080),
                                )
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Duration',
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("${widget.service.duration}min/session",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 13,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsetsGeometry.all(8),
                                decoration : BoxDecoration(
                                  color: Color(0xFF000080).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                    Icons.devices_rounded,
                                    color: Color(0xFF000080),
                                )
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('COURSE TYPE',
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(widget.tutor.teachingMode,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  SizedBox(height: 13,),

                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsetsGeometry.all(8),
                                decoration : BoxDecoration(
                                  color: Color(0xFF000080).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                    Icons.location_on_outlined,
                                  color: Color(0xFF000080),
                                )
                              ),
                              SizedBox(width: 10,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('LOCATION',
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(widget.tutor.location,
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 115 ,),
                              ElevatedButton(onPressed:(){},
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsetsGeometry.fromLTRB(15,10,15,10),
                                    backgroundColor: Color(0xFF000080),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(15),
                                    )
                                  ),
                              child: Center(
                                child: Text(
                                    'See on map',
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsetsGeometry.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000080).withOpacity(0.2),
                              spreadRadius: 0.5,
                              blurRadius:4,
                              offset: Offset(0, 1),
                            )
                          ]
                      ),
                      child: Column(

                        // Column for the About this Service


                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About this Service',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            widget.service.description,
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),

                              )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsetsGeometry.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000080).withOpacity(0.2),
                              spreadRadius: 0.5,
                              blurRadius:4,
                              offset: Offset(0, 1),
                            )
                          ]
                      ),
                      child: Column(


                        // Column fro the Tutor

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instructor',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(widget.tutor.picture),
                                radius: 30,
                              ),
                              SizedBox(width: 15,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.tutor.firstName,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(widget.tutor.expertiseDomain,
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Color(0xFF464653),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 50,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFF000080).withOpacity(0.1),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/images/star.svg",
                                                height:12 ,
                                                width: 12,
                                              ),
                                              SizedBox(width: 2,),
                                              Text(
                                                widget.tutor.averageRating.toString(),
                                                style: TextStyle(
                                                  color: const Color(0xFF1E293B),
                                                  fontSize: 14,
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.33,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 90 ,),
                                      ElevatedButton(onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                              color: Color(0xFF000080).withOpacity(0.2)
                                          ),
                                          padding: EdgeInsetsGeometry.all(10),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadiusGeometry.circular(30),
                                          ),
                                        ),
                                          child: Center(
                                            child: Text(
                                                'View profile',
                                              style: TextStyle(
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Color(0xFF000080),
                                              ),
                                            ),
                                          ),
                                      )
                                      
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ) ,
                    ),
                    SizedBox(height: 20,),
                    Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(onPressed:(){},
                            icon: Icon(
                              Icons.message_outlined
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsetsGeometry.fromLTRB(20,15,20,15),
                                backgroundColor: Color(0xFFD2D2D2),
                                iconColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(30),
                                )
                            ),
                            label: Center(
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            )

                        ),
                        SizedBox(width: 10,),
                        ElevatedButton.icon(onPressed:(){},
                            icon: ImageIcon(
                              AssetImage("assets/images/schedule.png"),
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsetsGeometry.fromLTRB(20,15,20,15),
                                backgroundColor: Color(0xFF000080),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(30),
                                )
                            ),
                            label: Center(
                              child: Text(
                                'Join Request',
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            )

                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  CustomBottomNavbar(selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push( context,
              MaterialPageRoute(builder: (context) => Studenthomepage()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },),
    );

  }
}
