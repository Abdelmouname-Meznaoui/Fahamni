import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavbar2 extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavbar2({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavbar2> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar2> {
  Widget navItem(String iconpath, String label, int index) {
    bool selected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: selected
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF000080) : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconpath,
              height: 24,
              width: 24,
              color: selected ? Colors.white : const Color(0xFF000080),
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF94A3B8).withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    navItem("assets/images/fi-rr-home.svg", "Home", 0),
                    navItem("assets/images/explore.svg", "Explore", 1),
                    navItem("assets/images/course.svg", "Courses", 2),
                    navItem("assets/images/chat.svg", "Chat", 3),
                    navItem("assets/images/profile.svg", "Profile", 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}