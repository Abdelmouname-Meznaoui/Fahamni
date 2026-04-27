import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fahamni/Services/report_service.dart';
import 'package:fahamni/Services/review_service.dart';
import 'package:fahamni/Services/student_tutor_action_service.dart';
import 'package:fahamni/models/review_model.dart';
import 'package:fahamni/models/service_model.dart';
import 'package:fahamni/models/student_model.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:fahamni/models/tutor_review_bundle.dart';
import 'package:fahamni/messaging/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TutorProfilePage extends StatefulWidget {
  const TutorProfilePage({super.key, required this.tutorId});

  final String tutorId;

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage>
    with SingleTickerProviderStateMixin {
  final ReviewService _reviewService = ReviewService();
  final ReportService _reportService = ReportService();
  final StudentTutorActionService _studentTutorActionService =
      StudentTutorActionService();
  final TextEditingController _feedbackController = TextEditingController();
  late Future<TutorReviewBundle> _bundleFuture;
  late TabController _tabController;
  double _selectedRating = 0;
  bool _isSubmitting = false;
  bool _isFavorite = false;
  bool _isFavoriteLoading = true;
  bool _isActionLoading = false;
  String _viewerRole = 'student';

  bool get _isParentViewer => _viewerRole == 'parent';

  bool get _canReportTeacher =>
      _viewerRole == 'parent' || _viewerRole == 'student';

  @override
  void initState() {
    super.initState();
    _bundleFuture = _reviewService.loadTutorReviewBundle(widget.tutorId);
    _tabController = TabController(length: 3, vsync: this);
    _loadViewerRole();
    _loadFavoriteState();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final Future<TutorReviewBundle> future = _reviewService
        .loadTutorReviewBundle(widget.tutorId);
    setState(() {
      _bundleFuture = future;
    });
    await future;
  }

  Future<void> _loadFavoriteState() async {
    try {
      final bool isFavorite = await _studentTutorActionService.isFavoriteTutor(
        widget.tutorId,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavorite = isFavorite;
        _isFavoriteLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavoriteLoading = false;
      });
    }
  }

  Future<void> _loadViewerRole() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (!mounted) {
        return;
      }

      final String role = ((userDoc.data()?['role'] as String?) ?? 'student')
          .toLowerCase();
      setState(() {
        _viewerRole = role;
      });
    } catch (_) {
      // Keep default false if role resolution fails.
    }
  }

  Future<void> _submitFeedback() async {
    FocusScope.of(context).unfocus();
    final String comment = _feedbackController.text.trim();
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating first.')),
      );
      return;
    }
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your feedback first.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _reviewService.submitReview(
        tutorId: widget.tutorId,
        rating: _selectedRating,
        comment: comment,
      );
      _feedbackController.clear();
      setState(() {
        _selectedRating = 0;
      });
      await _refresh();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback sent successfully.')),
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
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isFavoriteLoading = true;
    });

    try {
      final bool favorite = await _studentTutorActionService
          .toggleFavoriteTutor(widget.tutorId);
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavorite = favorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            favorite
                ? 'Tutor added to favorites.'
                : 'Tutor removed from favorites.',
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
          _isFavoriteLoading = false;
        });
      }
    }
  }

  Future<void> _openConversation(TutorModel tutor) async {
    setState(() {
      _isActionLoading = true;
    });

    try {
      final conversation = await _studentTutorActionService
          .createOrGetConversation(tutor: tutor);
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ConversationPage(
            conversation: conversation,
            imageUrl: conversation.participantAvatarUrl.isNotEmpty
                ? conversation.participantAvatarUrl
                : tutor.picture,
            currentUserId: conversation.participants.firstWhere(
              (participant) => participant != tutor.uid,
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

  Future<void> _bookSession(
    TutorModel tutor,
    List<ServiceModel> services,
  ) async {
    final ServiceModel? selectedService = services.isEmpty
        ? null
        : services.first;
    if (!_isParentViewer) {
      await _bookSpecificService(tutor: tutor, service: selectedService);
      return;
    }

    final StudentModel? selectedChild = await _showParentChildSelectorSheet(
      title: 'Quote Request',
      submitLabel: 'Submit',
    );
    if (selectedChild == null) {
      return;
    }

    await _bookSpecificService(
      tutor: tutor,
      service: selectedService,
      studentId: selectedChild.uid,
      childName: '${selectedChild.firstName} ${selectedChild.lastName}'.trim(),
    );
  }

  Future<StudentModel?> _showParentChildSelectorSheet({
    required String title,
    required String submitLabel,
  }) async {
    final List<StudentModel> children = await _studentTutorActionService
        .getCurrentParentChildren();
    if (!mounted) {
      return null;
    }

    return showModalBottomSheet<StudentModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (BuildContext context) => _ParentChildSelectionSheet(
        title: title,
        submitLabel: submitLabel,
        children: children,
      ),
    );
  }

  Future<void> _bookSpecificService({
    required TutorModel tutor,
    required ServiceModel? service,
    String? studentId,
    String? childName,
  }) async {
    setState(() {
      _isActionLoading = true;
    });

    try {
      await _studentTutorActionService.createBookingRequest(
        tutor: tutor,
        service: service,
        studentId: studentId,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            service == null
                ? 'Quote request sent to ${tutor.firstName}${childName == null ? '' : ' for $childName'}.'
                : 'Quote request sent for ${service.name}${childName == null ? '' : ' ($childName)'}.',
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

  Future<void> _openProfileActions(TutorModel tutor) async {
    if (!_canReportTeacher) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.flag_outlined,
                  color: Color(0xFFDC2626),
                ),
                title: const Text(
                  'Report Teacher',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _openReportTeacherSheet(tutor);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openReportTeacherSheet(TutorModel tutor) async {
    final _TeacherReportDraft? reportDraft =
        await showModalBottomSheet<_TeacherReportDraft>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          builder: (BuildContext context) => const _ReportTeacherSheet(),
        );

    if (reportDraft == null) {
      return;
    }

    try {
      await _reportService.submitTeacherReport(
        teacherId: tutor.uid,
        teacherName: '${tutor.firstName} ${tutor.lastName}'.trim(),
        description: reportDraft.description,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher report submitted successfully.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: FutureBuilder<TutorReviewBundle>(
            future: _bundleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return _FeedbackErrorState(
                  message: snapshot.error.toString(),
                  onRetry: _refresh,
                );
              }

              final TutorReviewBundle bundle = snapshot.data!;
              final TutorModel tutor = bundle.tutor;
              final List<ReviewModel> previewReviews = bundle.reviews
                  .take(2)
                  .toList();

              return AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  20 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileTopBar(
                      tutorName: 'Teacher',
                      isFavorite: _isFavorite,
                      isFavoriteLoading: _isFavoriteLoading,
                      onFavoriteTap: _toggleFavorite,
                      showMoreAction: _canReportTeacher,
                      onMoreTap: () => _openProfileActions(tutor),
                    ),
                    const SizedBox(height: 18),
                    _TutorHero(
                      tutor: tutor,
                      averageRating: bundle.averageRating,
                      reviewService: _reviewService,
                    ),
                    const SizedBox(height: 18),
                    TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF000080),
                      unselectedLabelColor: const Color(0xFF64748B),
                      indicatorColor: const Color(0xFF000080),
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Services'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _AboutTutorTab(tutor: tutor),
                            _TutorServicesTab(
                              tutor: tutor,
                              services: bundle.services,
                              reviewService: _reviewService,
                              onBookNow: (service) => _bookSpecificService(
                                tutor: tutor,
                                service: service,
                              ),
                            ),
                            ListView(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              padding: const EdgeInsets.only(bottom: 16),
                              children: [
                                _RatingsSummaryCard(
                                  tutor: tutor,
                                  reviews: previewReviews,
                                  reviewers: bundle.reviewers,
                                  averageRating: bundle.averageRating,
                                  reviewService: _reviewService,
                                  totalReviewsCount: bundle.reviews.length,
                                  onViewAll: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => FeedbacksPage(
                                          tutorId: widget.tutorId,
                                          tutorName:
                                              '${tutor.firstName} ${tutor.lastName}'
                                                  .trim(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                _FeedbackComposerCard(
                                  controller: _feedbackController,
                                  selectedRating: _selectedRating,
                                  onRatingChanged: (value) {
                                    setState(() {
                                      _selectedRating = value;
                                    });
                                  },
                                  onSubmit: _submitFeedback,
                                  isSubmitting: _isSubmitting,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!keyboardVisible) ...[
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isActionLoading
                                  ? null
                                  : () => _openConversation(tutor),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD9D9D9),
                                foregroundColor: const Color(0xFF1F2937),
                                minimumSize: const Size(0, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              icon: const Icon(Icons.message_outlined),
                              label: const Text(
                                'Message',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isActionLoading
                                  ? null
                                  : () => _bookSession(tutor, bundle.services),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF000080),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              icon: const Icon(Icons.calendar_today_outlined),
                              label: const Text(
                                'Quote Request',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FeedbacksPage extends StatefulWidget {
  const FeedbacksPage({
    super.key,
    required this.tutorId,
    required this.tutorName,
  });

  final String tutorId;
  final String tutorName;

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  final ReviewService _reviewService = ReviewService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Feedbacks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: _reviewService.getTutorReviews(widget.tutorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<ReviewModel> reviews = snapshot.data ?? <ReviewModel>[];
          return FutureBuilder<Map<String, StudentModel>>(
            future: _reviewService.getReviewers(
              reviews.map((review) => review.reviewerId).toList(),
            ),
            builder: (context, reviewerSnapshot) {
              final Map<String, StudentModel> reviewers =
                  reviewerSnapshot.data ?? <String, StudentModel>{};

              if (reviews.isEmpty) {
                return const Center(
                  child: Text(
                    'No feedback yet.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: reviews.length,
                separatorBuilder: (_, separatorIndex) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final ReviewModel review = reviews[index];
                  return _ReviewCard(
                    review: review,
                    reviewer: reviewers[review.reviewerId],
                    reviewService: _reviewService,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({
    required this.tutorName,
    required this.isFavorite,
    required this.isFavoriteLoading,
    required this.onFavoriteTap,
    required this.showMoreAction,
    this.onMoreTap,
  });

  final String tutorName;
  final bool isFavorite;
  final bool isFavoriteLoading;
  final VoidCallback onFavoriteTap;
  final bool showMoreAction;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        ),
        Expanded(
          child: Text(
            tutorName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        _CircleIconButton(
          icon: isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          iconColor: isFavorite
              ? const Color(0xFFEF4444)
              : const Color(0xFF64748B),
          onTap: isFavoriteLoading ? null : onFavoriteTap,
          child: isFavoriteLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
        ),
        const SizedBox(width: 8),
        const _CircleIconButton(icon: Icons.share_outlined),
        if (showMoreAction) ...[
          const SizedBox(width: 8),
          _CircleIconButton(icon: Icons.more_horiz, onTap: onMoreTap),
        ],
      ],
    );
  }
}

class _TutorHero extends StatelessWidget {
  const _TutorHero({
    required this.tutor,
    required this.averageRating,
    required this.reviewService,
  });

  final TutorModel tutor;
  final double averageRating;
  final ReviewService reviewService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 62,
          backgroundColor: const Color(0xFFE2E8F0),
          backgroundImage: _resolveImageProvider(tutor.picture),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                '${tutor.firstName} ${tutor.lastName}'.trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.verified_outlined,
              color: Color(0xFF000080),
              size: 22,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${tutor.expertiseDomain} Specialist',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000080),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            _MetaText(
              text: '${averageRating.toStringAsFixed(1)} Rating',
              color: const Color(0xFF64748B),
              leading: const Icon(
                Icons.star_rounded,
                size: 16,
                color: Color(0xFFF4B400),
              ),
            ),
            _MetaText(
              text: reviewService.experienceLabel(tutor.yearsOfExperience),
              color: const Color(0xFF64748B),
            ),
            _MetaText(
              text: reviewService.availabilityLabel(tutor.isAvailable),
              color: tutor.isAvailable
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFDC2626),
            ),
          ],
        ),
      ],
    );
  }
}

class _AboutTutorTab extends StatelessWidget {
  const _AboutTutorTab({required this.tutor});

  final TutorModel tutor;

  @override
  Widget build(BuildContext context) {
    final String levelsTaught = tutor.levelsTaught.isEmpty
        ? 'Not specified'
        : tutor.levelsTaught.join(', ');

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Rating', tutor.averageRating.toStringAsFixed(1)),
              _buildStatCard('Years', '${tutor.yearsOfExperience}+'),
              _buildStatCard('Courses', '${tutor.levelsTaught.length}'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: _profileCardDecoration(),
            child: Column(
              children: [
                Row(
                  children: [
                    Transform.rotate(
                      angle: math.pi,
                      child: const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFF000080),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Details & Expertise',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoCard(
                  Icons.menu_book,
                  'Expertise Domain',
                  tutor.expertiseDomain,
                ),
                _buildInfoCard(
                  Icons.school_outlined,
                  'Levels Taught',
                  levelsTaught,
                ),
                _buildInfoCard(
                  Icons.location_on_outlined,
                  'Location',
                  tutor.location,
                ),
                _buildInfoCard(
                  Icons.devices_rounded,
                  'Teaching Mode',
                  tutor.teachingMode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildTextCard(
            'Academic Background',
            tutor.academicDescription.isNotEmpty
                ? tutor.academicDescription
                : 'No academic background provided yet.',
          ),
          const SizedBox(height: 16),
          _buildTextCard(
            'Teaching Approach',
            tutor.pedagogicalDescription.isNotEmpty
                ? tutor.pedagogicalDescription
                : 'No teaching approach provided yet.',
          ),
        ],
      ),
    );
  }
}

class _TutorServicesTab extends StatelessWidget {
  const _TutorServicesTab({
    required this.tutor,
    required this.services,
    required this.reviewService,
    required this.onBookNow,
  });

  final TutorModel tutor;
  final List<ServiceModel> services;
  final ReviewService reviewService;
  final ValueChanged<ServiceModel> onBookNow;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(
        child: Text(
          'No services yet.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 64),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final ServiceModel service = services[index];
          final String serviceMode = service.area.isNotEmpty
              ? service.area
              : tutor.teachingMode;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Card(
              elevation: 6,
              shadowColor: const Color(0xFF000080).withValues(alpha: 0.3),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ServiceHeaderImage(imagePath: service.picture),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 23,
                              width: 100,
                              decoration: BoxDecoration(
                                color: const Color(0x19000080),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Center(
                                child: Text(
                                  service.subject,
                                  style: const TextStyle(
                                    color: Color(0xFF000080),
                                    fontSize: 13,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                    height: 1.50,
                                    letterSpacing: 0.50,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service.name,
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.38,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${service.duration}min session',
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF64748B),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  serviceMode,
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (service.maxnum - service.enrollednum <= 10)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFDD0D0D),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${service.maxnum - service.enrollednum} places left',
                                    style: const TextStyle(
                                      color: Color(0xFFDD0D0D),
                                      fontSize: 14,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${service.price.toInt()}DA',
                                  style: const TextStyle(
                                    color: Color(0xFF000080),
                                    fontSize: 20,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                    height: 1.56,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: ElevatedButton(
                                    onPressed: () => onBookNow(service),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF000080),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(100, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Book Now',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
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
                  Positioned(
                    top: 15,
                    right: 16,
                    child: Container(
                      height: 25,
                      width: 50,
                      decoration: ShapeDecoration(
                        color: Colors.white.withValues(alpha: 0.90),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_border_outlined,
                              color: Color(0xFFEAB308),
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              tutor.averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

BoxDecoration _profileCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFF1F5F9)),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF000080).withValues(alpha: 0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

Widget _buildStatCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
    width: 110,
    decoration: _profileCardDecoration(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000080),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoCard(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF000080).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: const Color(0xFF000080)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildTextCard(String title, String value) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
    decoration: _profileCardDecoration(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF475569),
          ),
        ),
      ],
    ),
  );
}

class _ServiceHeaderImage extends StatelessWidget {
  const _ServiceHeaderImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath.trim().startsWith('http://') ||
        imagePath.trim().startsWith('https://')) {
      return Image.network(
        imagePath,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          "assets/images/default_service_img.png",
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    if (imagePath.trim().startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image.asset(
      "assets/images/default_service_img.png",
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class _RatingsSummaryCard extends StatelessWidget {
  const _RatingsSummaryCard({
    required this.tutor,
    required this.reviews,
    required this.reviewers,
    required this.averageRating,
    required this.reviewService,
    required this.totalReviewsCount,
    required this.onViewAll,
  });

  final TutorModel tutor;
  final List<ReviewModel> reviews;
  final Map<String, StudentModel> reviewers;
  final double averageRating;
  final ReviewService reviewService;
  final int totalReviewsCount;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Ratings & Reviews',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            averageRating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(width: 6),
          _StarsRow(rating: averageRating, size: 18),
        ],
      ),
      child: Column(
        children: [
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'No reviews yet.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            )
          else
            ...List<Widget>.generate(reviews.length, (index) {
              final ReviewModel review = reviews[index];
              final StudentModel? reviewer = reviewers[review.reviewerId];
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewer == null
                                    ? 'Student'
                                    : '${reviewer.firstName} ${reviewer.lastName[0]}.',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (review.isHidden)
                                const Text(
                                  'Comment hidden by admin.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF94A3B8),
                                  ),
                                )
                              else
                                Text(
                                  '"${review.comment}"',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.45,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          reviewService.formatShortDate(review.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != reviews.length - 1) ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            }),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'View all $totalReviewsCount reviews',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF000080),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackComposerCard extends StatelessWidget {
  const _FeedbackComposerCard({
    required this.controller,
    required this.selectedRating,
    required this.onRatingChanged,
    required this.onSubmit,
    required this.isSubmitting,
  });

  final TextEditingController controller;
  final double selectedRating;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Your Feedback',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: _StarSelector(
              selectedRating: selectedRating,
              onChanged: onRatingChanged,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EAFB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextField(
              controller: controller,
              maxLength: 200,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                hintText: 'Write something...',
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                return Text(
                  '${value.text.characters.length}/200',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000080),
                foregroundColor: Colors.white,
                minimumSize: const Size(160, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.review,
    required this.reviewer,
    required this.reviewService,
  });

  final ReviewModel review;
  final StudentModel? reviewer;
  final ReviewService reviewService;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE2E8F0),
                backgroundImage: reviewer == null
                    ? null
                    : _resolveImageProvider(reviewer!.picture),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewer == null
                          ? 'Student'
                          : '${reviewer!.firstName} ${reviewer!.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StarsRow(rating: review.rating, size: 16),
                  ],
                ),
              ),
              Text(
                reviewService.formatShortDate(review.createdAt),
                style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (review.isHidden)
            const Text(
              'Comment hidden by admin.',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Color(0xFF94A3B8),
              ),
            )
          else
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF475569),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (trailing case final Widget trailingWidget) trailingWidget,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _FeedbackErrorState extends StatelessWidget {
  const _FeedbackErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: Color(0xFF000080),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000080),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.text, required this.color, this.leading});

  final String text;
  final Color color;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 4)],
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StarSelector extends StatelessWidget {
  const _StarSelector({required this.selectedRating, required this.onChanged});

  final double selectedRating;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        final double starValue = index + 1;
        final bool isSelected = starValue <= selectedRating;
        return IconButton(
          onPressed: () => onChanged(starValue),
          icon: Icon(
            isSelected ? Icons.star_rounded : Icons.star_border_rounded,
            color: const Color(0xFFF4B400),
            size: 34,
          ),
        );
      }),
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow({required this.rating, required this.size});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final int fullStars = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        return Icon(
          index < fullStars ? Icons.star_rounded : Icons.star_border_rounded,
          color: const Color(0xFFF4B400),
          size: size,
        );
      }),
    );
  }
}

class _TeacherReportDraft {
  const _TeacherReportDraft({required this.description});

  final String description;
}

class _ReportTeacherSheet extends StatefulWidget {
  const _ReportTeacherSheet();

  @override
  State<_ReportTeacherSheet> createState() => _ReportTeacherSheetState();
}

class _ReportTeacherSheetState extends State<_ReportTeacherSheet> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final String description = _descriptionController.text.trim();
    if (description.isEmpty) {
      return;
    }

    Navigator.pop(context, _TeacherReportDraft(description: description));
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report Teacher',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Describe your report',
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _descriptionController.text.trim().isEmpty
                    ? null
                    : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000080),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentChildSelectionSheet extends StatefulWidget {
  const _ParentChildSelectionSheet({
    required this.title,
    required this.submitLabel,
    required this.children,
  });

  final String title;
  final String submitLabel;
  final List<StudentModel> children;

  @override
  State<_ParentChildSelectionSheet> createState() =>
      _ParentChildSelectionSheetState();
}

class _ParentChildSelectionSheetState
    extends State<_ParentChildSelectionSheet> {
  StudentModel? _selectedChild;

  @override
  void initState() {
    super.initState();
    if (widget.children.isNotEmpty) {
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
          16,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<StudentModel>(
              value: hasChildren ? _selectedChild : null,
              isExpanded: true,
              hint: Text(hasChildren ? 'Select Child' : 'No child linked yet'),
              items: widget.children
                  .map(
                    (StudentModel child) => DropdownMenuItem<StudentModel>(
                      value: child,
                      child: Text(
                        '${child.firstName} ${child.lastName}'.trim(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: hasChildren
                  ? (StudentModel? value) {
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
              const Text(
                'No linked child account found. Please link a child first.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: hasChildren && _selectedChild != null
                    ? () => Navigator.pop(context, _selectedChild)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000080),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.submitLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    this.iconColor = const Color(0xFF64748B),
    this.onTap,
    this.child,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          color: Colors.white,
        ),
        child: child ?? Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

ImageProvider<Object>? _resolveImageProvider(String path) {
  final String normalized = path.trim();
  if (normalized.isEmpty) {
    return null;
  }
  if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
    return NetworkImage(normalized);
  }
  if (normalized.startsWith('assets/')) {
    return AssetImage(normalized);
  }
  return null;
}
