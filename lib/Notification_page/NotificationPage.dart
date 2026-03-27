import 'package:fahamni/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/notification_model.dart';
import '../widgets/notification_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedTab = 0;
  int _navIndex = 0;
  

  final NotificatinService _notificationService = NotificatinService();
  

  final String currentUserId = "no_one";

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF000080);
    const Color accentBlue = Color(0xFF000080);

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,size: 35,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w800,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          _buildToggle(accentBlue),

          Expanded(
            // Retrieve the notification from database in real time
            child: StreamBuilder<List<NotificationModel>>(
              stream: _notificationService.streamNotifications(currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final allNotifications = snapshot.data ?? [];

                if (allNotifications.isEmpty) {
                  return const Center(child: Text('No notifications'));
                }

                // Display depends on which tab is selected
                final visibleNotifications = _selectedTab == 0
                    ? allNotifications.where((n) => !n.isRead).toList()
                    : allNotifications;

                if (visibleNotifications.isEmpty) {
                  return const Center(child: Text('No new notifications'));
                }

                return ListView.builder(
                  itemCount: visibleNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = visibleNotifications[index];
                    return NotificationItem(
                      notification: notification,
                      onTap: () => _notificationService.markAsRead(notification.notificationId),
                    );
                  },
                );
              },
            ),
          ),

          // Mark as Read Button logic
          StreamBuilder<List<NotificationModel>>(
            stream: _notificationService.streamNotifications(currentUserId),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data?.where((n) => !n.isRead).length ?? 0;
              
              if (_selectedTab == 0 && unreadCount > 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 110.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //here we call mark as read from notificaition model
                      for (var n in snapshot.data!.where((n) => !n.isRead)) {
                        _notificationService.markAsRead(n.notificationId);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Mark as read', 
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
        child:
        ClipRRect(

          borderRadius: BorderRadius.circular(40), // Rounded edges for the "floating" look
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // The magic blur
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF000080).withOpacity(0.15), // Ultra-low opacity white
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2), // Light border to catch highlights
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color : Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset : const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBottomNavBar('assets/images/home.svg', "Home", 0),
                  _buildBottomNavBar('assets/images/compass.svg', "Discover", 1),
                  _buildBottomNavBar('assets/images/course.svg', "Courses", 2),
                  _buildBottomNavBar('assets/images/message.svg', "Chat", 3),
                  _buildBottomNavBar('assets/images/profile.svg', "Profile", 4),
                ],
              ),
            ),
          ),
        ),
      ),


    );
  }


  Widget _buildToggle(Color accentBlue) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 80),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF94A3B8),
        borderRadius: BorderRadius.circular(30),

      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            _buildToggleTab(label: 'Unread', index: 0, accentBlue: accentBlue),
            _buildToggleTab(label: 'All',    index: 1, accentBlue: accentBlue),
          ],
          spacing: 7,

        ),
      ),
    );
  }

  Widget _buildToggleTab({
    required String label,
    required int index,
    required Color accentBlue,
  }) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? accentBlue : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.nunito(
              color: isSelected ? Colors.white : const Color(0xFF000080),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),

            ),
          ),
        ),
      );
  }



  Widget _buildBottomNavBar(String assetPath, String page_name, int index) {

    final isSelected = _navIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _navIndex = index);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF000080) : Colors.white,

          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetPath,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : const Color(0xFF000080),
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),


            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                page_name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }




}