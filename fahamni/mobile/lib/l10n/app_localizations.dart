import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/locale_service.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;
  late final Map<String, String> _localizedStrings;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  static const List<Locale> supportedLocales = LocaleService.supportedLocales;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<bool> load() async {
    final String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String get language => translate('language');
  String get selectLanguageLabel => translate('select_language');
  String get confirm => translate('confirm');
  String get english => translate('english');
  String get french => translate('french');
  String get arabic => translate('arabic');
  String get languageSaved => translate('language_saved');
  String get profileSettings => translate('profile_settings');
  String get changePassword => translate('change_password');
  String get updateEmail => translate('update_email');
  String get updatePhoneNumber => translate('update_phone_number');
  String get deleteAccount => translate('delete_account');
  String get personalInformation => translate('personal_information');
  String get linkedChildren => translate('linked_children');
  String get notifications => translate('notifications');
  String get helpSupport => translate('help_support');
  String get logoutFromFahamni => translate('logout_from_fahamni');
  String get account => translate('account');
  String get parent => translate('parent');
  String get academicInformation => translate('academic_information');
  String get studyInformation => translate('study_information');
  String get home => translate('home');
  String get explore => translate('explore');
  String get courses => translate('courses');
  String get chat => translate('chat');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get retry => translate('retry');
  String get feedbacks => translate('feedbacks');
  String get quoteRequests => translate('quote_requests');
  String get messages => translate('messages');
  String get aiStudyHelp => translate('ai_study_help');
  String get recommendedTeachers => translate('recommended_teachers');
  String get recommendedServices => translate('recommended_services');
  String get services => translate('services');
  String get available => translate('available');
  String get busy => translate('busy');
  String get searchSubjectsTeachers => translate('search_subjects_teachers');
  String get subject => translate('subject');
  String get price => translate('price');
  String get rating => translate('rating');
  String get mode => translate('mode');
  String get viewFullMap => translate('view_full_map');
  String get seeAll => translate('see_all');
  String get serviceDetails => translate('service_details');
  String get students => translate('students');
  String get sessions => translate('sessions');
  String get domain => translate('domain');
  String get grade => translate('grade');
  String get duration => translate('duration');
  String get courseType => translate('course_type');
  String get location => translate('location');
  String get seeOnMap => translate('see_on_map');
  String get aboutService => translate('about_service');
  String get instructor => translate('instructor');
  String get noMembersYet => translate('no_members_yet');
  String get student => translate('student');
  String get searchTeachersModules => translate('search_teachers_modules');
  String get takeOffer => translate('take_offer');
  String get favoriteTeachers => translate('favorite_teachers');
  String get noFavoriteTeachers => translate('no_favorite_teachers');
  String get courseSchedule => translate('course_schedule');
  String get startJourney => translate('start_journey');
  String get bookSessionToSeeItHere => translate('book_session_to_see_it_here');
  String get exploreTutors => translate('explore_tutors');
  String get nextCourse => translate('next_course');
  String get viewMySessions => translate('view_my_sessions');
  String get noCoursesYet => translate('no_courses_yet');
  String get enrolledSessionsAppear => translate('enrolled_sessions_appear');
  String get failedLoadCourses => translate('failed_load_courses');
  String get all => translate('all');
  String get inProgress => translate('in_progress');
  String get done => translate('done');
  String get noCoursesMatchFilter => translate('no_courses_match_filter');
  String get course => translate('course');
  String get session => translate('session');
  String get minSession => translate('min_session');
  String get noResourcesYet => translate('no_resources_yet');
  String get online => translate('online');
  String get onsite => translate('onsite');
  String get reportMember => translate('report_member');
  String get pleaseSignInToChatMembers => translate('please_sign_in_to_chat_members');
  String get childContactedParent => translate('child_contacted_parent');
  String get describeIssueBelow => translate('describe_issue_below');
  String get writeReportHere => translate('write_report_here');
  String get cancel => translate('cancel');
  String get send => translate('send');
  String get reportRequired => translate('report_required');
  String get reportSent => translate('report_sent');
  String get notification => translate('notification');
  String get signInToViewNotifications => translate('sign_in_to_view_notifications');
  String get noNotifications => translate('no_notifications');
  String get noNewNotifications => translate('no_new_notifications');
  String get markAsRead => translate('mark_as_read');
  String get unread => translate('unread');
  String get comingSoon => translate('coming_soon');
  String get searchConversations => translate('search_conversations');
  String get failedLoadConversations => translate('failed_load_conversations');
  String get noConversationsYet => translate('no_conversations_yet');
  String get teachers => translate('teachers');
  String get groups => translate('groups');

  String get performanceOverview => translate('performance_overview');
  String get todaySessions => translate('today_sessions');
  String get myServices => translate('my_services');
  String get emptySessions => translate('empty_sessions');
  String get emptyServices => translate('empty_services');
  String get emptyQuotes => translate('empty_quotes');
  String get ratingLabel => translate('rating_label');
  String get studentsLabel => translate('students_label');
  String get coursesLabel => translate('courses_label');
  String get nextCourseLabel => translate('next_course_label');
  String get waiting => translate('waiting');
  String get accepted => translate('accepted');
  String get rejected => translate('rejected');
  String get noRequestsFound => translate('no_requests_found');
  String get seeDetails => translate('see_details');
  String get expertiseDomain => translate('expertise_domain');
  String get levelsTaught => translate('levels_taught');
  String get detailsExpertise => translate('details_expertise');
  String get academicBackground => translate('academic_background');
  String get teachingApproach => translate('teaching_approach');
  String get yourFeedback => translate('your_feedback');
  String get ratingsReviews => translate('ratings_reviews');
  String get viewAllReviews => translate('view_all_reviews');
  String get writeSomething => translate('write_something');
  String get placesLeft => translate('places_left');
  String get joined => translate('joined');
  String get mathematics => translate('mathematics');
  String get physics => translate('physics');
  String get languages => translate('languages');
  String get pending => translate('pending');
  String get bookNow => translate('book_now');
  String get active => translate('active');
  String get inactive => translate('inactive');
  String get about => translate('about');
  String get expertise => translate('expertise');
  String get teacher => translate('teacher');
  String get experience => translate('experience');
  String get status => translate('status');
  String get expertiseSpecialist => translate('expertise_specialist');
  String get quoteRequest => translate('quote_request');
  String get quotes => translate('quotes');
  String get report => translate('report');
  String get yourReport => translate('your_report');
  String get reportSubmittedSuccessfully => translate('report_submitted_successfully');
  String get message => translate('message');
  String get placesLeftLower => translate('places_left_lower');
  String get minutesShort => translate('minutes_short');

  String get checkFullSchedule => translate('check full schedule');
  String get noLinkedChildren => translate('no linked children');
  String get tutorsFoundNearYou => translate('tutors found near you');
  String get discoverTutorsNearYou => translate('Discover tutors near you');
  String get noResultsFound => translate('no_results_found');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
