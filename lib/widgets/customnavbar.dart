import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;
  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  Widget navItem(String iconpath, String label, int index) {
    bool selected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        widget.onTap(index); // ← add this
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: selected ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10) : const EdgeInsets.symmetric(horizontal: 10, vertical: 10) ,
        decoration: BoxDecoration(
          color: selected ? Color(0xFF000080) : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
                iconpath,
                height: 24,
                width: 24,
                color: selected ? Colors.white : Color(0xFF000080)),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: selected
                  ? Row(
                children: [
                  SizedBox(width: 8),
                  AnimatedOpacity(
                    opacity: selected ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 20),
      height: 70,
      width: 400,
      decoration: BoxDecoration(
        color: Color(0xFF94A3B8).withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child:ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // the glass blur
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), // grey glass tint
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15 , vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  navItem("assets/images/fi-rr-home.svg", "Home", 0),
                  navItem("assets/images/explore.svg", "explore", 1),
                  navItem("assets/images/course.svg", "Courses", 2),
                  navItem("assets/images/chat.svg", "Chat", 3),
                  navItem("assets/images/profile.svg", "Profile", 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}