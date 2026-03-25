import 'package:flutter/material.dart';
import '../models/tutor_model.dart';
import '../models/service_model.dart';

class TeacherServiceSection extends StatelessWidget {
  final TutorModel tutor;
  final List<ServiceModel> services;

  const TeacherServiceSection({
    super.key,
    required this.tutor,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
     return ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
        //shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16,8,16,64),
        itemCount: services.length,
        itemBuilder: (context, index){
           return Padding(
              padding: const EdgeInsets.all(0),
              child: Card(
                      elevation: 6,
                      shadowColor: Color(0xFF000080).withOpacity(0.3),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/indian-male-teacher_981168-3023.avif",
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(16,16,0,16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 23,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Color(0x19000080),
                                        borderRadius: BorderRadius.circular(999)
                                      ),
                                      child: Center(
                                        child: Text(
                                          services[index].subject,
                                          style: TextStyle(
                                            color: const Color(0xFF000080),
                                            fontSize: 13,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w700,
                                            height: 1.50,
                                            letterSpacing: 0.50,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                      services[index].name,
                                      style: TextStyle(
                                        color: const Color(0xFF1F2937),
                                        fontSize: 18,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        height: 1.38,
                                      ),
                                    ),
                                
                                    SizedBox(height: 8,),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded, color: Color(0xFF64748B),),
                                        SizedBox(width: 5,),
                                        Text(
                                          services[index].duration.toString()+"min session",
                                          style: TextStyle(
                                            color: const Color(0xFF64748B),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color: Color(0xFF64748B),),
                                        SizedBox(width: 5,),
                                        Text(
                                          services[index].type.toString(),
                                          style: TextStyle(
                                            color: const Color(0xFF64748B),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    if(services[index].maxnum - services[index].enrollednum <= 10)
                                    Row(
                                      children: [
                                        Icon(Icons.error_outline_rounded, color: Color(0xFFDD0D0D),),
                                        SizedBox(width: 5,),
                                        Text(
                                          (services[index].maxnum - services[index].enrollednum).toString()+' places left',
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
                                    SizedBox(height: 8,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          services[index].price.toInt().toString()+"DA",
                                          style: TextStyle(
                                            color: const Color(0xFF000080),
                                            fontSize: 20,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w700,
                                            height: 1.56,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: ElevatedButton(
                                            onPressed:(){},
                                            style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF000080),
                                              foregroundColor: Colors.white,
                                              minimumSize: Size(100, 40),
                                              shape: RoundedRectangleBorder(
                                                 borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Book Now',
                                                style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 15
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Positioned(
                              top: 15,
                              left: 280,
                              child: Container(
                                height: 25,
                                width: 50,
                                decoration: ShapeDecoration(
                                  color: Colors.white.withValues(alpha: 0.90),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star_border_outlined, color: Color(0xFFEAB308), size: 12.0,),
                                      SizedBox(width: 2,),
                                      Text(
                                        tutor.averageRating.toString(),
                                        style: TextStyle(
                                          color: const Color(0xFF1E293B),
                                          fontSize: 14,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w700,
                                          height: 1.33,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
               );
         }
       ),
     );
  }
}