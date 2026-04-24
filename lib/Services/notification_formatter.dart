/// Notification Formatter Service
/// Formats notification titles and content according to the Fahamni Notification System specification
/// 
/// This service provides standardized notification messages based on:
/// - Notification type
/// - Receiver role (student, teacher, admin)
/// - Context data (sender name, service name, etc.)

class NotificationFormatter {
  /// Formats notification title and content based on type and receiver role
  /// 
  /// Returns a map with 'title' and 'content' keys
  static Map<String, String> formatNotification({
    required String type,
    required String receiverRole,
    String? senderFirstName,
    String? senderLastName,
    String? serviceOrResourceName,
    String? messageContent,
    double? rating,
  }) {
    final senderName = _buildSenderName(senderFirstName, senderLastName);

    switch (type) {
      // MESSAGE NOTIFICATIONS
      case 'message':
        return _formatMessageNotification(receiverRole, senderName, messageContent ?? '');

      // QUOTE REQUEST NOTIFICATIONS
      case 'quote_request':
        return _formatQuoteRequestNotification(receiverRole, senderName, serviceOrResourceName);

      // REVIEW NOTIFICATIONS
      case 'review':
        return _formatReviewNotification(receiverRole, senderName, rating);

      // Default fallback
      default:
        return {
          'title': type,
          'content': 'You have a new notification',
        };
    }
  }

  /// Formats MESSAGE notification
  static Map<String, String> _formatMessageNotification(
    String receiverRole,
    String senderName,
    String messageContent,
  ) {
    const String title = 'New Message';

    String content;
    if (receiverRole == 'student') {
      content = 'You received a new message from a teacher.';
    } else if (receiverRole == 'teacher') {
      content = 'You received a new message.';
    } else {
      // admin or other roles
      content = 'You received a new message.';
    }

    return {
      'title': title,
      'content': content,
    };
  }

  /// Formats QUOTE REQUEST notification
  static Map<String, String> _formatQuoteRequestNotification(
    String receiverRole,
    String senderName,
    String? serviceName,
  ) {
    if (receiverRole == 'teacher') {
      const String title = 'New Quote';
      const String content = 'A student sent you a new Quote request.';
      return {
        'title': title,
        'content': content,
      };
    }

    if (receiverRole == 'student') {
      const String title = 'Booking Request Sent';
      String content = 'Your booking request has been sent to the teacher.';
      if (serviceName != null && serviceName.isNotEmpty) {
        content = 'Your booking request for $serviceName has been sent to the teacher.';
      }
      return {
        'title': title,
        'content': content,
      };
    }

    // Fallback
    return {
      'title': 'New Quote',
      'content': 'A student sent you a new Quote request.',
    };
  }

  /// Formats REVIEW notification
  static Map<String, String> _formatReviewNotification(
    String receiverRole,
    String senderName,
    double? rating,
  ) {
    if (receiverRole == 'teacher') {
      const String title = 'New Review';
      String content = 'A student left a review on your profile.';
      if (rating != null) {
        content = 'A student left a ${rating.toStringAsFixed(1)} star review on your profile.';
      }
      return {
        'title': title,
        'content': content,
      };
    }

    // Fallback
    return {
      'title': 'New Review',
      'content': 'A student left a review on your profile.',
    };
  }

  /// Builds sender name from first and last name
  static String _buildSenderName(String? firstName, String? lastName) {
    final parts = <String>[];
    if (firstName != null && firstName.isNotEmpty) {
      parts.add(firstName);
    }
    if (lastName != null && lastName.isNotEmpty) {
      parts.add(lastName);
    }
    return parts.join(' ').trim();
  }
}
