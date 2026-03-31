import 'package:flutter/material.dart';
import '../widgets/customnavbar2.dart';
import 'package:fahamni/screens/study_info_screen.dart';
import 'package:fahamni/screens/profile_settings.dart';
import 'package:fahamni/screens/notification_screen.dart';
import 'package:fahamni/screens/help_support_screen.dart';
import 'package:fahamni/screens/personal_info_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Widget buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: const Color(0xFF000080),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),

      bottomNavigationBar: CustomBottomNavbar2(
        selectedIndex: 4,
        onTap: (index) {},
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              const Text(
                "Account",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 24),

              const CircleAvatar(
                radius: 46,
                backgroundImage: AssetImage("assets/images/alice.png"),
              ),

              //const SizedBox(height: 2),

              const Text(
                "Ahmed Mansour",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),

              //const SizedBox(height: 2),

              const Text(
                "Grade 12 - Science",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 6),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildMenuItem(
                      context,
                      Icons.person_outline,
                      "Personal Information",
                      const PersonalInfoScreen(),
                    ),
                    buildMenuItem(
                      context,
                      Icons.school_outlined,
                      "Study Information",
                      const StudyInfoScreen(),
                    ),
                    buildMenuItem(
                      context,
                      Icons.settings_outlined,
                      "Profile Settings",
                      const ProfileSettingsScreen(),
                    ),
                    buildMenuItem(
                      context,
                      Icons.notifications_none,
                      "Notifications",
                      const NotificationScreen(),
                    ),
                    buildMenuItem(
                      context,
                      Icons.help_outline,
                      "Help & Support",
                      const HelpSupportScreen(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 34),

              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Color(0xFFEF4444)),
                      SizedBox(width: 8),
                      Text(
                        "Logout from Fahamni",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}