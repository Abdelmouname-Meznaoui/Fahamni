import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_svg/flutter_svg.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color navyBlue = Color(0xFF1D263B);


    return Column(
      children: [
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black12,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Container(
                margin: const EdgeInsets.only(top: 6.0),
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,

                  borderRadius: BorderRadius.circular(4),
                ),
                child: SvgPicture.asset(
                  'assets/images/book_text.svg',
                  width: 35,
                  height: 35,
                  colorFilter: const ColorFilter.mode(navyBlue, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: navyBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.content,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!notification.isRead)
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFF000080),
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      const SizedBox(height: 9),
                    const SizedBox(height: 12),
                    Text(
                      DateFormat('hh:mm a').format(notification.dateTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.8,
          indent: 75,
          endIndent: 16,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}