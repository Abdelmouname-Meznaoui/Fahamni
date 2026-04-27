import 'package:fahamni/Services/report_service.dart';
import 'package:fahamni/Services/review_service.dart';
import 'package:fahamni/Services/student_tutor_action_service.dart';
import 'package:fahamni/messaging/conversation_page.dart';
import 'package:fahamni/models/review_model.dart';
import 'package:fahamni/models/service_model.dart';
import 'package:fahamni/models/student_model.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:fahamni/models/tutor_review_bundle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late final TabController _tabController;
  late Future<TutorReviewBundle> _bundleFuture;

  double _selectedRating = 0;
  bool _isSubmitting = false;
  bool _isFavorite = false;
  bool _isFavoriteLoading = true;
  bool _isActionLoading = false;
  String _viewerRole = 'student';
  List<StudentModel> _linkedChildren = <StudentModel>[];

  bool get _isParentViewer => _viewerRole == 'parent';
  bool get _canReportTeacher =>
      _viewerRole == 'student' || _viewerRole == 'parent';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bundleFuture = _reviewService.loadTutorReviewBundle(widget.tutorId);
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
      final bool favorite = await _studentTutorActionService.isFavoriteTutor(
        widget.tutorId,
      );
      if (!mounted) return;
      setState(() {
        _isFavorite = favorite;
        _isFavoriteLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isFavoriteLoading = false;
      });
    }
  }

  Future<void> _loadViewerRole() async {
    try {
      final String role = await _studentTutorActionService.getCurrentUserRole();
      List<StudentModel> linkedChildren = <StudentModel>[];
      if (role == 'parent') {
        linkedChildren = await _studentTutorActionService
            .getLinkedChildrenForCurrentParent();
      }
      if (!mounted) return;
      setState(() {
        _viewerRole = role;
        _linkedChildren = linkedChildren;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _viewerRole = 'student';
        _linkedChildren = <StudentModel>[];
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isFavoriteLoading = true;
    });

    try {
      final bool favorite = await _studentTutorActionService
          .toggleFavoriteTutor(widget.tutorId);
      if (!mounted) return;
      setState(() {
        _isFavorite = favorite;
      });
    } catch (error) {
      if (!mounted) return;
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

  Future<void> _shareTutorProfile(String tutorName) async {
    final String link = 'https://fahamni.app/teacher/${widget.tutorId}';
    try {
      await Clipboard.setData(ClipboardData(text: '$tutorName\n$link'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile link copied to clipboard')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to copy link: $error')));
    }
  }

  Future<void> _openConversation(TutorModel tutor) async {
    setState(() {
      _isActionLoading = true;
    });

    try {
      final conversation = await _studentTutorActionService
          .createOrGetConversation(tutor: tutor);
      if (!mounted) return;
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
      if (!mounted) return;
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

  Future<void> _submitFeedback(TutorModel tutor) async {
    final String comment = _feedbackController.text.trim();
    if (comment.isEmpty || _selectedRating <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pick a rating and write a short comment.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _reviewService.submitReview(
        tutorId: tutor.uid,
        rating: _selectedRating,
        comment: comment,
      );
      _feedbackController.clear();
      setState(() {
        _selectedRating = 0;
      });
      await _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback sent successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
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

  Future<void> _openQuoteRequestSheet({
    required TutorModel tutor,
    required List<ServiceModel> services,
    ServiceModel? service,
  }) async {
    final List<String> subjects = <String>{
      if (service != null && service.subject.trim().isNotEmpty)
        service.subject.trim(),
      ...services
          .map((item) => item.subject.trim())
          .where((subject) => subject.isNotEmpty),
      if (tutor.expertiseDomain.trim().isNotEmpty) tutor.expertiseDomain.trim(),
    }.toList();

    final _QuoteRequestDraft? draft =
        await showModalBottomSheet<_QuoteRequestDraft>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          builder: (context) => _QuoteRequestSheet(
            showChildSelector: _isParentViewer,
            children: _linkedChildren,
            subjects: subjects,
            initialSubject: service?.subject,
          ),
        );

    if (draft == null) return;

    try {
      await _studentTutorActionService.submitQuoteRequest(
        tutor: tutor,
        subject: draft.subject,
        description: draft.description,
        teachingMode: draft.mode,
        sessionsCount: draft.sessionsCount,
        sessionDurationMinutes: draft.sessionDurationMinutes,
        service: service,
        childStudentId: draft.childId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote request submitted successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openProfileActions(TutorModel tutor) async {
    if (!_canReportTeacher) return;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share profile'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _shareTutorProfile(
                    '${tutor.firstName} ${tutor.lastName}'.trim(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report teacher'),
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
    final String? description = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => const _ReportTeacherSheet(),
    );

    if (description == null || description.trim().isEmpty) return;

    try {
      await _reportService.submitTeacherReport(
        teacherId: tutor.uid,
        teacherName: '${tutor.firstName} ${tutor.lastName}'.trim(),
        description: description,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
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
      body: SafeArea(
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
                    tutorName: '${tutor.firstName} ${tutor.lastName}'.trim(),
                    isFavorite: _isFavorite,
                    isFavoriteLoading: _isFavoriteLoading,
                    onFavoriteTap: _toggleFavorite,
                    onShareTap: () => _shareTutorProfile(
                      '${tutor.firstName} ${tutor.lastName}'.trim(),
                    ),
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
                    labelStyle: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: const [
                      Tab(text: 'About'),
                      Tab(text: 'Services'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _AboutTutorTab(tutor: tutor),
                        _TutorServicesTab(
                          tutor: tutor,
                          services: bundle.services,
                          reviewService: _reviewService,
                          onBookNow: (service) => _openQuoteRequestSheet(
                            tutor: tutor,
                            services: bundle.services,
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
                              onSubmit: () => _submitFeedback(tutor),
                              isSubmitting: _isSubmitting,
                            ),
                          ],
                        ),
                      ],
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
                                : () => _openQuoteRequestSheet(
                                    tutor: tutor,
                                    services: bundle.services,
                                  ),
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
        title: Text(
          widget.tutorName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: _reviewService.getTutorReviews(widget.tutorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _FeedbackErrorState(
              message: snapshot.error.toString(),
              onRetry: () async {},
            );
          }

          final List<ReviewModel> reviews = snapshot.data ?? <ReviewModel>[];
          return FutureBuilder<Map<String, StudentModel>>(
            future: _reviewService.getReviewers(
              reviews.map((review) => review.reviewerId).toList(),
            ),
            builder: (context, reviewerSnapshot) {
              if (reviewerSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
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
    required this.onShareTap,
    required this.showMoreAction,
    this.onMoreTap,
  });

  final String tutorName;
  final bool isFavorite;
  final bool isFavoriteLoading;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;
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
        ),
        const SizedBox(width: 8),
        _CircleIconButton(icon: Icons.share_outlined, onTap: onShareTap),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000080).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: tutor.picture.trim().isNotEmpty
                    ? NetworkImage(tutor.picture)
                    : null,
                child: tutor.picture.trim().isEmpty
                    ? const Icon(Icons.person, size: 30)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${tutor.firstName} ${tutor.lastName}'.trim(),
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tutor.expertiseDomain.isNotEmpty
                          ? tutor.expertiseDomain
                          : 'Tutor profile',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MetaChip(
                label: reviewService.availabilityLabel(tutor.isAvailable),
                icon: tutor.isAvailable
                    ? Icons.check_circle_outline
                    : Icons.schedule,
              ),
              _MetaChip(
                label: reviewService.experienceLabel(tutor.yearsOfExperience),
                icon: Icons.school_outlined,
              ),
              _MetaChip(
                label: averageRating > 0
                    ? averageRating.toStringAsFixed(1)
                    : 'New',
                icon: Icons.star_outline,
              ),
            ],
          ),
        ],
      ),
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
      children: [
        _InfoCard(
          title: 'Expertise',
          child: Text(
            tutor.expertiseDomain.isNotEmpty
                ? tutor.expertiseDomain
                : 'Not specified',
          ),
        ),
        const SizedBox(height: 12),
        _InfoCard(title: 'Levels Taught', child: Text(levelsTaught)),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'Teaching Mode',
          child: Text(
            tutor.teachingMode.isNotEmpty
                ? tutor.teachingMode
                : 'Not specified',
          ),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'About',
          child: Text(
            tutor.pedagogicalDescription.isNotEmpty
                ? tutor.pedagogicalDescription
                : 'No bio available yet.',
          ),
        ),
      ],
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
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final ServiceModel service = services[index];
        return _InfoCard(
          title: service.name.isNotEmpty ? service.name : service.subject,
          trailing: Text(
            reviewService.priceLabel(service),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF000080),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.description.isNotEmpty
                    ? service.description
                    : 'No description available.',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(label: service.subject, icon: Icons.book_outlined),
                  _MetaChip(label: service.level, icon: Icons.layers_outlined),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onBookNow(service),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000080),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Quote Request'),
                ),
              ),
            ],
          ),
        );
      },
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
            averageRating > 0 ? averageRating.toStringAsFixed(1) : 'New',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF000080),
            ),
          ),
          const SizedBox(width: 6),
          _StarsRow(rating: averageRating, size: 18),
        ],
      ),
      child: Column(
        children: [
          if (reviews.isEmpty)
            const Text('No recent reviews yet.')
          else
            ...reviews.map(
              (review) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReviewCard(
                  review: review,
                  reviewer: reviewers[review.reviewerId],
                  reviewService: reviewService,
                ),
              ),
            ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onViewAll,
            child: Text('See all $totalReviewsCount reviews'),
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
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your review here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: isSubmitting ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF000080),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(isSubmitting ? 'Sending...' : 'Submit Feedback'),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: reviewer?.picture.trim().isNotEmpty == true
                    ? NetworkImage(reviewer!.picture)
                    : null,
                child: reviewer?.picture.trim().isEmpty == true
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewer != null
                          ? '${reviewer!.firstName} ${reviewer!.lastName}'
                                .trim()
                          : 'Anonymous',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      reviewService.formatShortDate(review.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              _StarsRow(rating: review.rating, size: 16),
            ],
          ),
          if (review.comment.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(review.comment),
          ],
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
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
            Text(
              'Something went wrong',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
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
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF000080)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow({required this.rating, required this.size});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final int filled = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        return Icon(
          index < filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: const Color(0xFFF4B400),
          size: size,
        );
      }),
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
        return IconButton(
          onPressed: () => onChanged(starValue),
          icon: Icon(
            starValue <= selectedRating
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            color: const Color(0xFFF4B400),
            size: 34,
          ),
        );
      }),
    );
  }
}

class _QuoteRequestDraft {
  const _QuoteRequestDraft({
    required this.childId,
    required this.subject,
    required this.description,
    required this.mode,
    required this.sessionsCount,
    required this.sessionDurationMinutes,
  });

  final String? childId;
  final String subject;
  final String description;
  final String mode;
  final int sessionsCount;
  final int sessionDurationMinutes;
}

class _QuoteRequestSheet extends StatefulWidget {
  const _QuoteRequestSheet({
    required this.showChildSelector,
    required this.children,
    required this.subjects,
    this.initialSubject,
  });

  final bool showChildSelector;
  final List<StudentModel> children;
  final List<String> subjects;
  final String? initialSubject;

  @override
  State<_QuoteRequestSheet> createState() => _QuoteRequestSheetState();
}

class _QuoteRequestSheetState extends State<_QuoteRequestSheet> {
  static const List<String> _modes = <String>['Online', 'Onsite', 'Hybrid'];
  static const List<int> _durations = <int>[30, 45, 60, 90, 120];

  final TextEditingController _descriptionController = TextEditingController();
  late final List<String> _subjects;
  String? _selectedChildId;
  String? _selectedSubject;
  late String _selectedMode;
  late int _sessionsCount;
  late int _sessionDuration;

  @override
  void initState() {
    super.initState();
    _subjects = widget.subjects
        .where((item) => item.trim().isNotEmpty)
        .toSet()
        .toList();
    if (_subjects.isEmpty) {
      _subjects.add('General');
    }

    _selectedChildId = widget.showChildSelector && widget.children.isNotEmpty
        ? widget.children.first.uid
        : null;
    _selectedSubject =
        widget.initialSubject != null &&
            _subjects.contains(widget.initialSubject)
        ? widget.initialSubject
        : _subjects.first;
    _selectedMode = _modes.first;
    _sessionsCount = 1;
    _sessionDuration = _durations.first;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (widget.showChildSelector &&
        widget.children.isNotEmpty &&
        (_selectedChildId ?? '').isEmpty) {
      return false;
    }
    return (_selectedSubject ?? '').isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
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
        borderSide: const BorderSide(color: Color(0xFF000080), width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  void _submit() {
    if (!_canSubmit) return;
    Navigator.pop(
      context,
      _QuoteRequestDraft(
        childId: _selectedChildId,
        subject: _selectedSubject ?? '',
        description: _descriptionController.text.trim(),
        mode: _selectedMode,
        sessionsCount: _sessionsCount,
        sessionDurationMinutes: _sessionDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Quote Request',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              if (widget.showChildSelector) ...[
                const SizedBox(height: 12),
                const Text(
                  'Select Child',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedChildId,
                  isExpanded: true,
                  items: widget.children
                      .map(
                        (child) => DropdownMenuItem<String>(
                          value: child.uid,
                          child: Text(
                            '${child.firstName} ${child.lastName}'.trim(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: widget.children.isEmpty
                      ? null
                      : (value) {
                          setState(() {
                            _selectedChildId = value;
                          });
                        },
                  decoration: _inputDecoration(
                    widget.children.isEmpty
                        ? 'No linked children'
                        : 'Select Child',
                  ),
                ),
                if (widget.children.isEmpty) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'No linked child account found.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
                const SizedBox(height: 12),
              ],
              const Text(
                'Subject',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                isExpanded: true,
                items: _subjects
                    .map(
                      (subject) => DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                decoration: _inputDecoration('Choose Subject'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 4,
                maxLength: 200,
                onChanged: (_) => setState(() {}),
                decoration: _inputDecoration('Describe your request'),
              ),
              const SizedBox(height: 12),
              const Text('Mode', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMode,
                isExpanded: true,
                items: _modes
                    .map(
                      (mode) => DropdownMenuItem<String>(
                        value: mode,
                        child: Text(mode),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedMode = value;
                  });
                },
                decoration: _inputDecoration('Choose Mode'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sessions Number',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _sessionsCount,
                          isExpanded: true,
                          items: List<DropdownMenuItem<int>>.generate(
                            12,
                            (index) => DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _sessionsCount = value;
                            });
                          },
                          decoration: _inputDecoration('1'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Session Duration',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _sessionDuration,
                          isExpanded: true,
                          items: _durations
                              .map(
                                (duration) => DropdownMenuItem<int>(
                                  value: duration,
                                  child: Text('$duration min'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _sessionDuration = value;
                            });
                          },
                          decoration: _inputDecoration('30 min'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submit : null,
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
      ),
    );
  }
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
    if (description.isEmpty) return;
    Navigator.pop(context, description);
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets viewInsets = MediaQuery.of(context).viewInsets;
    final bool canSubmit = _descriptionController.text.trim().isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Report Teacher',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              minLines: 4,
              maxLines: 6,
              maxLength: 400,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tell us what happened',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000080),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Submit Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
