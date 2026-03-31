import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/tutor_model.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final TutorModel tutor;
  final ServiceModel service;

  const ServiceCard({
    super.key,
    required this.tutor,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
     return Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
                elevation: 6,
                shadowColor: Color(0xFF000080).withOpacity(0.45),
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/slide1.png",
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.fromLTRB(15,15,0,0),
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
                                    service.subject,
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
                              SizedBox(height: 10,),
                              Text(
                              service.name,
                              style: TextStyle(
                              color: const Color(0xFF1F2937),
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.38,
                              ),
                              ),
                              SizedBox(height: 10 ,),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(tutor.picture),
                                    radius: 20,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    tutor.firstName,
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 14,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/time.svg",
                                    height: 20,
                                    width: 20,
                                    color: Color(0xFF475569),
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    "${service.duration}min session",
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
                              SizedBox(height: 10,),
                              if(service.maxnum - service.enrollednum <= 10)
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
                                    '${service.maxnum - service.enrollednum} places left',
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
                                    "${service.price.toInt()}DA",
                                    style: TextStyle(
                                      color: const Color(0xFF000080),
                                      fontSize: 20,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w700,
                                      height: 1.56,
                                    ),
                                  ),
                                  SizedBox(width: 80,),
                                  ElevatedButton(
                                    onPressed:(){},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF000080),
                                        foregroundColor: Colors.white,
                                        minimumSize: Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        )
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
                        left: 250,
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
                              SvgPicture.asset(
                                "assets/images/star.svg",
                                height:12 ,
                                width: 12,
                              ),
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
}