import 'package:fahamni/TeacherDashboard/teacher_dashboard.dart';
import 'package:fahamni/TeacherDashboard/teacher_dashboard_service.dart';
import 'package:fahamni/messaging/chat_page.dart';
import 'package:fahamni/models/teacher_schedule_model.dart';
import 'package:fahamni/widgets/customnavbar.dart';
import 'package:flutter/material.dart';

class TeacherSchedulePage extends StatefulWidget {
  const TeacherSchedulePage({super.key});

  @override
  State<TeacherSchedulePage> createState() => _TeacherSchedulePageState();
}

class _TeacherSchedulePageState extends State<TeacherSchedulePage> {
  static const Color _primaryBlue = Color(0xFF1A237E);
  static const Color _pageBackground = Color(0xFFF5F5F5);

  late Future<TeacherScheduleModel> _scheduleFuture;
  int _selectedDayIndex = 0;
  int _selectedNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _scheduleFuture = TeacherDashboardService().loadSchedule();
  }

  Future<void> _refresh() async {
    final Future<TeacherScheduleModel> future =
        TeacherDashboardService().loadSchedule();
    setState(() {
      _scheduleFuture = future;
    });
    await future;
  }

  void _handleNavigation(int index) {
    if (index == _selectedNavIndex) {
      return;
    }

    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TeacherDashboardScreen()),
        );
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher explore is coming soon.')),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChatPage()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This section is coming soon.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedNavIndex,
        onTap: _handleNavigation,
      ),
      body: SafeArea(
        child: FutureBuilder<TeacherScheduleModel>(
          future: _scheduleFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Failed to load your schedule.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: _refresh,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final TeacherScheduleModel schedule = snapshot.data!;
            final int safeIndex = _selectedDayIndex.clamp(0, schedule.days.length - 1);
            final TeacherScheduleDay selectedDay = schedule.days[safeIndex];

            return RefreshIndicator(
              color: _primaryBlue,
              onRefresh: _refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                                color: const Color(0xFF1F2937),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Text(
                                    schedule.title,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    schedule.teacherName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDEFF5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'This Week',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List<Widget>.generate(
                                      schedule.days.length,
                                      (index) {
                                        final TeacherScheduleDay day = schedule.days[index];
                                        final bool isSelected = index == safeIndex;
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            right: index == schedule.days.length - 1 ? 0 : 10,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedDayIndex = index;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 180),
                                              width: 78,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 14,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected ? _primaryBlue : Colors.white,
                                                borderRadius: BorderRadius.circular(18),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    day.shortLabel.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w800,
                                                      color: isSelected
                                                          ? Colors.white70
                                                          : const Color(0xFF94A3B8),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    day.date.day.toString(),
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.w800,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : const Color(0xFF1F2937),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            selectedDay.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            selectedDay.sessions.isEmpty
                                ? 'No sessions planned for this day.'
                                : '${selectedDay.sessions.length} session${selectedDay.sessions.length == 1 ? '' : 's'} scheduled',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 120),
                    sliver: selectedDay.sessions.isEmpty
                        ? SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.event_available_rounded,
                                    color: Color(0xFF1A237E),
                                    size: 42,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Nothing booked here yet.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Your upcoming teaching sessions will show up in this timeline.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final TeacherScheduleSession session =
                                    selectedDay.sessions[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == selectedDay.sessions.length - 1 ? 0 : 14,
                                  ),
                                  child: _ScheduleSessionCard(session: session),
                                );
                              },
                              childCount: selectedDay.sessions.length,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScheduleSessionCard extends StatelessWidget {
  const _ScheduleSessionCard({
    required this.session,
  });

  final TeacherScheduleSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF1A237E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EAF6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              session.startTimeLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              session.endTimeLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              session.subject,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ScheduleChip(
                        label: session.modalityLabel,
                        backgroundColor: const Color(0xFFE8F7EC),
                        textColor: const Color(0xFF16A34A),
                      ),
                      _ScheduleChip(
                        label: session.durationLabel,
                        backgroundColor: const Color(0xFFF1F5F9),
                        textColor: const Color(0xFF475569),
                      ),
                      _ScheduleChip(
                        label: session.statusLabel,
                        backgroundColor: const Color(0xFFE8EAF6),
                        textColor: const Color(0xFF1A237E),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.group_outlined,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          session.studentSummary,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  const _ScheduleChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
