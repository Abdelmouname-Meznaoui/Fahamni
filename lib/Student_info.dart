//import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'iPersonal_info.dart';

class MyWidget_p2 extends StatelessWidget {
  const MyWidget_p2({super.key});

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
                "Student Academic ",
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
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                "Details",
                style: TextStyle(
                  letterSpacing: -0.25,
                  fontFamily: "Inter",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 10 / 18,
                ),
              ),),
              SizedBox(height: 20),
              Buttons(),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 29, right: 24),
                child:
              const Text(
                "Level of Study",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff1f2937),
                  height: 14 / 18,
                ),
              ),),
              SizedBox(height: 20),
              Buttons1(),
          ],
    ),),),);
  }
}


class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  int selectedIndex = -1;
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
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         Container(
           child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedIndex = selectedIndex == 0 ? -1 : 0;
              });

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
              setState(() {
                selectedIndex = selectedIndex == 1 ? -1 : 1;
              });

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
              setState(() {
                selectedIndex = selectedIndex == 2 ? -1 : 2;
              });

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



