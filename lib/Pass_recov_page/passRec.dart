import 'package:flutter/material.dart';



class passRec extends StatefulWidget {
  const passRec({super.key});

  @override
  State<passRec> createState() => _passRecState();
}

class _passRecState extends State<passRec> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
      ),


        body: SafeArea(
          child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8,0,0,8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child:
            Image.asset(
                    "assets/images/Vector@2x.png",
                    height: 100,
                  ),),
            const SizedBox(height: 10),
             const Text(
                    "Fahamni",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      letterSpacing: -0.75,
                    ),
                  ),
                 
               const Text(
                "A peaceful place for growth",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff64748B),
                  height: 24 / 16,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                    "Recover your password",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      height: 35 / 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                "We will send a verification code to reset",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff64748B),
                  height: 24 / 16,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "your password.",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff64748B),
                  height: 24 / 16,
                ),
              ),
              const SizedBox(height: 40),
              Buttons(selectedIndex,(index) => setState(() => selectedIndex = index)),
              const SizedBox(height: 20),
              if (selectedIndex == 0) Email_widg(),
              if (selectedIndex == 1) Phone_widg(),
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
      margin: const EdgeInsets.fromLTRB(80, 0, 88, 0),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      child: Text("Email",
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
      child: Text("Phone",
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
      
        
       ],),
    );
  }
}

class Email_widg extends StatelessWidget {
  const Email_widg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
       Container(
                margin: const EdgeInsets.only(left: 34),
                child:
              const Text(
                "Email Address",
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
                  hintText: 'name@example.com',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    fontSize: 17,
                    fontFamily: 'Lexend',
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
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
              const SizedBox(height: 18),
               SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000080),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x33137FEC),
                            offset: const Offset(0, 8),
                            blurRadius: 10,
                            spreadRadius: -6,
                          ),
                          BoxShadow(
                            color: const Color(0x33137FEC),
                            offset: const Offset(0, 20),
                            blurRadius: 25,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {},
                          child: const Center(
                            child: Text(
                              "Send Code",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
   ], ),);
  }
}
class Phone_widg extends StatelessWidget {
  const Phone_widg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
       Container(
                margin: const EdgeInsets.only(left: 34),
                child:
              const Text(
                "Phone Number",
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
                  hintText: 'Ex:0555555555',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    fontSize: 17,
                    fontFamily: 'Lexend',
                  ),
                  prefixIcon: const Icon(
                    Icons.phone,
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
              const SizedBox(height: 18),
               SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000080),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x33137FEC),
                            offset: const Offset(0, 8),
                            blurRadius: 10,
                            spreadRadius: -6,
                          ),
                          BoxShadow(
                            color: const Color(0x33137FEC),
                            offset: const Offset(0, 20),
                            blurRadius: 25,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {},
                          child: const Center(
                            child: Text(
                              "Send Code",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
   ], ),);
  }
}
