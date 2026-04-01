class ServiceModel {
  final String serviceId;
  final String tutorId;
  final String name;
  final String area;
  final String level;
  final String subject;
  final String description;
  final double price;
  final int duration;
  final int sessionsnum;
  final int maxnum;
  final int enrollednum;
  final bool isActive;
  final String picture;

  ServiceModel({
    required this.serviceId,
    required this.tutorId,
    required this.name,
    required this.area,
    required this.level,
    required this.subject,
    required this.description,
    required this.price,
    required this.duration,
    required this.isActive,
    required this.maxnum,
    required this.enrollednum,
    required this.sessionsnum,
    required this.picture,

  });

  Map<String, dynamic> toMap() {
    return {
      'service_id': serviceId,
      'tutor_id': tutorId,
      'name': name,
      'area':area,
      'level':level,
      'subject': subject,
      'description': description,
      'price': price,
      'duration': duration,
      'is_active': isActive,
      'sessions_num' : sessionsnum,
      'enrolled_num' : enrollednum,
      'maxstudents' : maxnum,
      'picture' : picture,
    };
  }
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      serviceId: map['service_id'] ?? '',
      tutorId: map['tutor_id'] ?? '',
      name: map['name'] ?? '',
      area: map['area'] ?? '',
      level: map['level'] ?? '',
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      duration: map['duration'] ?? 0,
      maxnum: map['maxstudents'] ?? 0,
      enrollednum: map['enrolled_num'] ?? 0,
      sessionsnum: map['sessions_num'] ?? 0,
      isActive: map['is_active'] ?? false,
      picture: map['picture'] ?? '',
    );
  }
}