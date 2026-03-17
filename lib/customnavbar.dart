import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  Widget navItem(String iconpath, String label, int index) {
    bool selected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: selected ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10) : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              color: selected ? Colors.white : Color(0xFF000080),
            ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        navItem("assets/images/fi-rr-home.svg", "Home", 0),
        navItem("assets/images/explore.svg", "explore", 1),
        navItem("assets/images/course.svg", "Courses", 2),
        navItem("assets/images/chat.svg", "Chat", 3),
        navItem("assets/images/profile.svg", "Profile", 4),
      ],
    );
  }
}