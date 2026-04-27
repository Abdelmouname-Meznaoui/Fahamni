import 'package:fahamni/Account_Settings_Student/account_screen.dart';
import 'package:fahamni/Courses/courses_page.dart';
import 'package:fahamni/Services/student_tutor_action_service.dart';
import 'package:fahamni/StudentHomePage/Student_homepage.dart';
import 'package:fahamni/feedback/feedback_pages.dart';
import 'package:fahamni/messaging/chat_page.dart';
import 'package:fahamni/messaging/conversation_page.dart';
import 'package:fahamni/models/service_model.dart';
import 'package:fahamni/models/student_model.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:fahamni/widgets/customnavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Servicedetails extends StatefulWidget {
  const Servicedetails({super.key, required this.service, required this.tutor});

  final TutorModel tutor;
  final ServiceModel service;

  @override
  State<Servicedetails> createState() => _ServicedetailsState();
}

class _ServicedetailsState extends State<Servicedetails> {
  int _selectedIndex = 1;
  final StudentTutorActionService _studentTutorActionService =
      StudentTutorActionService();

  bool _isActionLoading = false;
  String? _currentUserId;
  String _viewerRole = 'student';
  List<StudentModel> _linkedChildren = <StudentModel>[];

  bool get _isParentViewer => _viewerRole == 'parent';

  @override
  void initState() {
    super.initState();
    _initializeViewerContext();
  }

  Future<void> _initializeViewerContext() async {
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      final String role = await _studentTutorActionService.getCurrentUserRole();
      List<StudentModel> children = <StudentModel>[];
      if (role == 'parent') {
        children = await _studentTutorActionService
            .getLinkedChildrenForCurrentParent();
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _viewerRole = role;
        _linkedChildren = children;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _viewerRole = 'student';
        _linkedChildren = <StudentModel>[];
      });
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
            currentUserId: _currentUserId ?? '',
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

  Future<void> _sendJoinRequest({String? childStudentId}) async {
    setState(() {
      _isActionLoading = true;
    });

    try {
      await _studentTutorActionService.createBookingRequest(
        tutor: widget.tutor,
        service: widget.service,
        childStudentId: childStudentId,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        final String pendingId = childStudentId ?? _currentUserId ?? '';
        if (pendingId.isNotEmpty &&
            !widget.service.pendingIds.contains(pendingId)) {
          widget.service.pendingIds.add(pendingId);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Join request sent for ${widget.service.name}.'),
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

  Future<void> _openParentJoinRequestSheet() async {
    final StudentModel? selectedChild =
        await showModalBottomSheet<StudentModel>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          builder: (context) => _ParentJoinRequestSheet(
            children: _linkedChildren,
            initialChild: _linkedChildren.isNotEmpty
                ? _linkedChildren.first
                : null,
          ),
        );

    if (selectedChild == null) {
      return;
    }

    await _sendJoinRequest(childStudentId: selectedChild.uid);
  }

  Widget _buildFloatingActionButtons({
    required String buttonText,
    required bool isActionDisabled,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
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
              onPressed: _isParentViewer
                  ? (_isActionLoading || _linkedChildren.isEmpty
                        ? null
                        : _openParentJoinRequestSheet)
                  : (isActionDisabled ? null : () => _sendJoinRequest()),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text(
          'Service',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.service.picture.trim().isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.service.picture,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/default_service_img.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  widget.service.subject,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double cardWidth = (constraints.maxWidth - 24) / 3;
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
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000080).withOpacity(0.15),
                      spreadRadius: 0.5,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow(
                      icon: SvgPicture.asset(
                        'assets/images/course.svg',
                        height: 18,
                        width: 18,
                      ),
                      title: 'DOMAIN',
                      value: widget.service.subject,
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: const Icon(
                        Icons.school_outlined,
                        color: Color(0xFF000080),
                      ),
                      title: 'GRADE',
                      value: widget.service.level,
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: const Icon(
                        Icons.access_time,
                        color: Color(0xFF000080),
                      ),
                      title: 'DURATION',
                      value: '${widget.service.duration}min/session',
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: const Icon(
                        Icons.devices_rounded,
                        color: Color(0xFF000080),
                      ),
                      title: 'COURSE TYPE',
                      value: widget.tutor.teachingMode,
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF000080),
                      ),
                      title: 'LOCATION',
                      value: widget.tutor.location,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000080).withOpacity(0.15),
                      spreadRadius: 0.5,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About this Service',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.service.description,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000080).withOpacity(0.15),
                      spreadRadius: 0.5,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.tutor.picture),
                      radius: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.tutor.firstName} ${widget.tutor.lastName}'
                                .trim(),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.tutor.expertiseDomain,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TutorProfilePage(tutorId: widget.tutor.uid),
                          ),
                        );
                      },
                      child: const Text('View profile'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _isParentViewer ? 120 : 170),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingActionButtons(
        buttonText: buttonText,
        isActionDisabled: isActionDisabled,
      ),
      bottomNavigationBar: _isParentViewer
          ? null
          : CustomBottomNavbar(
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
                    MaterialPageRoute(
                      builder: (context) => const CoursesPage(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage()),
                  );
                } else if (index == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountScreen(),
                    ),
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
            const SizedBox(height: 8),
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
                  ? (value) {
                      setState(() {
                        _selectedChild = value;
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
            const SizedBox(height: 18),
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
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF000080).withOpacity(0.2),
          spreadRadius: 0.5,
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF000080),
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ],
    ),
  );
}

Widget _infoRow({
  required Widget icon,
  required String title,
  required String value,
  Widget? trailing,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF000080).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: icon,
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 16,
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
