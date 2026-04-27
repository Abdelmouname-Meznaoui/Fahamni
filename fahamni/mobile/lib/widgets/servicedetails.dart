import 'package:fahamni/messaging/chat_page.dart';
import 'package:fahamni/messaging/conversation_page.dart';
import 'package:fahamni/Services/student_tutor_action_service.dart';
import 'package:fahamni/Courses/courses_page.dart';
import 'package:fahamni/feedback/feedback_pages.dart';
import 'package:fahamni/widgets/customnavbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/student_model.dart';
import '../StudentHomePage/Student_homepage.dart';
import 'package:fahamni/Account_Settings_Student/account_screen.dart';
import '../models/service_model.dart';
import '../models/tutor_model.dart';

class Servicedetails extends StatefulWidget {
  final TutorModel tutor;
  final ServiceModel service;
  const Servicedetails({super.key, required this.service, required this.tutor});

  @override
  State<Servicedetails> createState() => _ServicedetailsState();
}

class _ServicedetailsState extends State<Servicedetails> {
  int _selectedIndex = 1;
  final StudentTutorActionService _studentTutorActionService =
      StudentTutorActionService();
  bool _isActionLoading = false;
  bool _isParentViewer = false;
  String? _currentUserId;
  List<StudentModel> _linkedChildren = <StudentModel>[];
  StudentModel? _selectedChild;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _loadViewerContext();
  }

  Future<void> _loadViewerContext() async {
    final String? uid = _currentUserId;
    if (uid == null) {
      return;
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final String role = ((userDoc.data()?['role'] as String?) ?? 'student')
          .toLowerCase();

      List<StudentModel> children = <StudentModel>[];
      if (role == 'parent') {
        children = await _studentTutorActionService.getCurrentParentChildren();
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isParentViewer = role == 'parent';
        _linkedChildren = children;
        if (_linkedChildren.isNotEmpty) {
          _selectedChild = _linkedChildren.first;
        }
      });
    } catch (_) {
      // Keep defaults when role cannot be resolved.
    }
  }

  Future<void> _openConversation() async {
    setState(() {
      _isActionLoading = true;
    });

    try {
      final conversation = await _studentTutorActionService
          .createOrGetConversation(tutor: widget.tutor);
      if (!mounted) {
        return;
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConversationPage(
            conversation: conversation,
            imageUrl: conversation.participantAvatarUrl.isNotEmpty
                ? conversation.participantAvatarUrl
                : widget.tutor.picture,
            currentUserId: conversation.participants.firstWhere(
              (participant) => participant != widget.tutor.uid,
              orElse: () => '',
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isActionLoading = false;
        });
      }
    }
  }

  Future<void> _sendJoinRequest({String? studentId, String? childName}) async {
    setState(() {
      _isActionLoading = true;
    });

    try {
      await _studentTutorActionService.createBookingRequest(
        tutor: widget.tutor,
        service: widget.service,
        studentId: studentId,
      );
      if (!mounted) {
        return;
      }

      // Update local UI state for immediate feedback
      setState(() {
        final String? targetStudentId = studentId ?? _currentUserId;
        if (targetStudentId != null &&
            !widget.service.pendingIds.contains(targetStudentId)) {
          widget.service.pendingIds.add(targetStudentId);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Join request sent for ${widget.service.name}${childName == null ? '' : ' ($childName)'}.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isActionLoading = false;
        });
      }
    }
  }

  Future<void> _openJoinRequestSheetForParent() async {
    final StudentModel? selected = await showModalBottomSheet<StudentModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (BuildContext context) => _ParentJoinRequestSheet(
        children: _linkedChildren,
        initialChild: _selectedChild,
      ),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _selectedChild = selected;
    });

    await _sendJoinRequest(
      studentId: selected.uid,
      childName: '${selected.firstName} ${selected.lastName}'.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = 'Join Request';
    bool isActionDisabled = _isActionLoading;

    if (!_isParentViewer && _currentUserId != null) {
      if (widget.service.studentIds.contains(_currentUserId)) {
        buttonText = 'Joined';
        isActionDisabled = true;
      } else if (widget.service.pendingIds.contains(_currentUserId)) {
        buttonText = 'Pending';
        isActionDisabled = true;
      }
    }

    Widget infoRow({
      required Widget icon,
      required String title,
      required String value,
      Widget? trailing,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF000080).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff9f9f9),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          iconSize: 24,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text(
          "Service",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff0f172a),
            height: 23 / 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              if (widget.service.picture != "")
                Image.network(
                  widget.service.picture,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              else
                Image.asset(
                  "assets/images/default_service_img.png",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.service.subject,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double cardWidth =
                            (constraints.maxWidth - 146) / 2;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatCard(
                              'STUDENTS',
                              widget.service.enrollednum.toString(),
                              cardWidth,
                            ),
                            _buildStatCard(
                              'SESSIONS',
                              widget.service.sessionsnum.toString(),
                              cardWidth,
                            ),
                            _buildStatCard(
                              'PRICE',
                              '${widget.service.price.toInt()}DA',
                              cardWidth,
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    if (widget.service.maxnum - widget.service.enrollednum <=
                        10)
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/circle-alert.svg',
                            height: 20,
                            width: 20,
                            color: const Color(0xFFDD0D0D),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${widget.service.maxnum - widget.service.enrollednum} places left',
                            style: TextStyle(
                              color: const Color(0xFFDD0D0D),
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000080).withOpacity(0.2),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF000080),
                                size: 30,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Service Details',
                                style: TextStyle(
                                  color: Color(0xFF1F2937),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          infoRow(
                            icon: SvgPicture.asset(
                              'assets/images/course.svg',
                              height: 20,
                              width: 20,
                            ),
                            title: 'DOMAIN',
                            value: widget.service.subject,
                          ),
                          SizedBox(height: 10),
                          infoRow(
                            icon: Icon(
                              Icons.school_outlined,
                              color: Color(0xFF000080),
                            ),
                            title: 'GRADE',
                            value: widget.service.level,
                          ),
                          SizedBox(height: 13),
                          infoRow(
                            icon: Icon(
                              Icons.access_time,
                              color: Color(0xFF000080),
                            ),
                            title: 'DURATION',
                            value: '${widget.service.duration}min/session',
                          ),
                          SizedBox(height: 13),
                          infoRow(
                            icon: Icon(
                              Icons.devices_rounded,
                              color: Color(0xFF000080),
                            ),
                            title: 'COURSE TYPE',
                            value: widget.tutor.teachingMode,
                          ),
                          SizedBox(height: 13),
                          infoRow(
                            icon: Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF000080),
                            ),
                            title: 'LOCATION',
                            value: widget.tutor.location,
                            trailing: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                backgroundColor: Color(0xFF000080),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'See on map',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000080).withOpacity(0.2),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About this Service',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.service.description,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000080).withOpacity(0.2),
                            spreadRadius: 0.5,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instructor',
                            style: TextStyle(
                              color: Color(0xFF1F2937),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  widget.tutor.picture,
                                ),
                                radius: 30,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.tutor.firstName,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      widget.tutor.expertiseDomain,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Color(0xFF464653),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 50,
                                          decoration: ShapeDecoration(
                                            color: Color(
                                              0xFF000080,
                                            ).withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/star.svg',
                                                  height: 12,
                                                  width: 12,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  widget.tutor.averageRating
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF1E293B,
                                                    ),
                                                    fontSize: 14,
                                                    fontFamily: 'Lexend',
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.33,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    TutorProfilePage(
                                                      tutorId: widget.tutor.uid,
                                                    ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              color: Color(
                                                0xFF000080,
                                              ).withOpacity(0.2),
                                            ),
                                            padding: EdgeInsets.all(10),
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'View profile',
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Color(0xFF000080),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000080).withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isActionLoading ? null : _openConversation,
                    icon: const Icon(Icons.message_outlined),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      backgroundColor: const Color(0xFFD2D2D2),
                      iconColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    label: const Center(
                      child: Text(
                        'Message',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isActionDisabled
                        ? null
                        : () {
                            if (_isParentViewer) {
                              _openJoinRequestSheetForParent();
                              return;
                            }
                            _sendJoinRequest();
                          },
                    icon: const ImageIcon(
                      AssetImage('assets/images/schedule.png'),
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      backgroundColor: const Color(0xFF000080),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    label: Center(
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Studenthomepage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CoursesPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}

class _ParentJoinRequestSheet extends StatefulWidget {
  const _ParentJoinRequestSheet({required this.children, this.initialChild});

  final List<StudentModel> children;
  final StudentModel? initialChild;

  @override
  State<_ParentJoinRequestSheet> createState() =>
      _ParentJoinRequestSheetState();
}

class _ParentJoinRequestSheetState extends State<_ParentJoinRequestSheet> {
  StudentModel? _selectedChild;

  @override
  void initState() {
    super.initState();
    _selectedChild = widget.initialChild;
    if (_selectedChild == null && widget.children.isNotEmpty) {
      _selectedChild = widget.children.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasChildren = widget.children.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Join Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<StudentModel>(
              value: hasChildren ? _selectedChild : null,
              isExpanded: true,
              hint: Text(
                hasChildren ? 'Select a Child' : 'No child linked yet',
              ),
              items: widget.children
                  .map(
                    (child) => DropdownMenuItem<StudentModel>(
                      value: child,
                      child: Text(
                        '${child.firstName} ${child.lastName}'.trim(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: hasChildren
                  ? (StudentModel? child) {
                      setState(() {
                        _selectedChild = child;
                      });
                    }
                  : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF000080),
                    width: 1.2,
                  ),
                ),
              ),
            ),
            if (!hasChildren) ...[
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No linked child account found. Link a child first.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: 180,
              height: 56,
              child: ElevatedButton(
                onPressed: hasChildren && _selectedChild != null
                    ? () => Navigator.pop(context, _selectedChild)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000080),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatCard(String title, String value, double width) {
  return Container(
    height: 80,
    width: width,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF000080).withOpacity(0.2),
          spreadRadius: 0.5,
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF64748B),
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF000080),
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ],
    ),
  );
}
