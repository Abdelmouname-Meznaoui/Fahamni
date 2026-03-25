import 'package:fahamni/models/tutor_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'teacher_about_section.dart';
import 'package:fahamni/models/service_model.dart';
import 'teacher_service_section.dart';

class TeacherProfileButtons extends StatefulWidget {
  final TutorModel tutor;
  final List<ServiceModel> services;
  const TeacherProfileButtons({
    super.key,
    required this.tutor,
    required this.services,
  });

  @override
  State<TeacherProfileButtons> createState() =>
      _InsideConversationButtonsState();
}

class _InsideConversationButtonsState extends State<TeacherProfileButtons>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFAFA),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: const Color(0xFF000080),
            indicatorWeight: 3.0,
            labelColor: const Color(0xFF000080),
            unselectedLabelColor: const Color(0xFF767C8C),
            labelStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [const Text("About")],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [const Text("Services")],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [const Text("Reviews")],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFECEFF1)),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TeacherAboutSection(tutor: widget.tutor),
                TeacherServiceSection(tutor: widget.tutor, services: widget.services),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
