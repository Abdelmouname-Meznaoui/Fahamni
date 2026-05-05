import 'package:fahamni/TeacherDashboard/models/teacher_portal_models.dart';
import 'package:fahamni/TeacherDashboard/teacher_portal_service.dart';
import 'package:fahamni/TeacherDashboard/widgets/teacher_navbar.dart';
import 'package:fahamni/messaging/chat_page.dart';
import 'package:fahamni/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'teacher_dashboard.dart';
import 'teacher_services_dashboard.dart';

class TeacherCreateServicePage extends StatefulWidget {
  const TeacherCreateServicePage({super.key});

  @override
  State<TeacherCreateServicePage> createState() => _TeacherCreateServicePageState();
}

class _TeacherCreateServicePageState extends State<TeacherCreateServicePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TeacherPortalService _service = TeacherPortalService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _membersController =
      TextEditingController(text: '1');
  final TextEditingController _sessionsController =
      TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController(text: '1');

  String _selectedDomain = 'Mathematics';
  String _selectedGrade = '2nd High School';
  String _selectedMode = 'Hybrid';
  int _selectedDuration = 30;
  String _selectedImage = _imageOptions.first;
  bool _submitting = false;

  static const List<String> _domains = <String>[
    'Mathematics',
    'Physics',
    'Languages',
    'Programming',
  ];

  static const List<String> _grades = <String>[
    'Middle School',
    '1st High School',
    '2nd High School',
    '3rd High School',
  ];

  static const List<String> _modes = <String>[
    'Online',
    'Onsite',
    'Hybrid',
  ];

  static const List<int> _durations = <int>[30, 45, 60, 90];

  static const List<String> _imageOptions = <String>[
    'assets/images/default_service_img.png',
    'assets/images/Container (3).png',
    'assets/images/page3.png',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _membersController.dispose();
    _sessionsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TeacherDashboardScreen()),
      );
      return;
    }
    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TeacherServicesDashboardScreen()),
      );
      return;
    }
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.translate('teacher_profile_coming_soon'))),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    try {
      await _service.createService(
        TeacherServiceDraft(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          domain: _selectedDomain,
          grade: _selectedGrade,
          membersCount: int.parse(_membersController.text.trim()),
          mode: _selectedMode,
          sessionsCount: int.parse(_sessionsController.text.trim()),
          sessionDurationMinutes: _selectedDuration,
          price: double.parse(_priceController.text.trim()),
          imagePath: _selectedImage,
        ),
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.translate('service_created_successfully'))),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      bottomNavigationBar: TeacherNavbar(
        selectedIndex: 1,
        onTap: _handleNavigation,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Expanded(
                      child: Text(
                        localizations.translate('create_service'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 18),
                _FormFieldBlock(
                  label: localizations.translate('service_name'),
                  child: TextFormField(
                    controller: _nameController,
                    validator: _requiredValidator,
                    decoration: _inputDecoration(),
                  ),
                ),
                const SizedBox(height: 16),
                _FormFieldBlock(
                  label: localizations.translate('description'),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    maxLength: 200,
                    validator: _requiredValidator,
                    decoration: _inputDecoration(hintText: localizations.translate('in_this_service')),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _FormFieldBlock(
                        label: localizations.domain,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedDomain,
                          items: _domains
                              .map((domain) => DropdownMenuItem<String>(
                                    value: domain,
                                    child: Text(_localizedOption(context, domain)),
                                  ))
                              .toList(),
                          decoration: _inputDecoration(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedDomain = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FormFieldBlock(
                        label: localizations.grade,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedGrade,
                          items: _grades
                              .map((grade) => DropdownMenuItem<String>(
                                    value: grade,
                                    child: Text(_localizedOption(context, grade)),
                                  ))
                              .toList(),
                          decoration: _inputDecoration(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedGrade = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _FormFieldBlock(
                        label: localizations.translate('members_number'),
                        child: TextFormField(
                          controller: _membersController,
                          keyboardType: TextInputType.number,
                          validator: _numberValidator,
                          decoration: _inputDecoration(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FormFieldBlock(
                        label: localizations.mode,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedMode,
                          items: _modes
                              .map((mode) => DropdownMenuItem<String>(
                                    value: mode,
                                    child: Text(_localizedOption(context, mode)),
                                  ))
                              .toList(),
                          decoration: _inputDecoration(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedMode = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _FormFieldBlock(
                        label: localizations.translate('sessions_number'),
                        child: TextFormField(
                          controller: _sessionsController,
                          keyboardType: TextInputType.number,
                          validator: _numberValidator,
                          decoration: _inputDecoration(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FormFieldBlock(
                        label: localizations.translate('sessions_duration'),
                        child: DropdownButtonFormField<int>(
                          initialValue: _selectedDuration,
                          items: _durations
                              .map((duration) => DropdownMenuItem<int>(
                                    value: duration,
                                    child: Text('$duration ${localizations.translate('minutes_short')}'),
                                  ))
                              .toList(),
                          decoration: _inputDecoration(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedDuration = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _FormFieldBlock(
                  label: localizations.translate('service_price'),
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: _numberValidator,
                    decoration: _inputDecoration(suffixText: 'DA'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.translate('service_picture'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imageOptions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final String image = _imageOptions[index];
                      final bool selected = image == _selectedImage;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = image;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 116,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF0D138B)
                                  : const Color(0xFFE2E8F0),
                              width: selected ? 2 : 1,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF0D138B)
                                          .withValues(alpha: 0.18),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ]
                                : null,
                            image: DecorationImage(
                              image: AssetImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: selected
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0x550D138B),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.all(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF0D138B),
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          localizations.translate('selected'),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0D138B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D138B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            localizations.translate('create'),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.translate('field_required');
    }
    return null;
  }

  String? _numberValidator(String? value) {
    if (_requiredValidator(value) != null) {
      return _requiredValidator(value);
    }
    if (double.tryParse(value!.trim()) == null) {
      return AppLocalizations.of(context)!.translate('enter_valid_number');
    }
    return null;
  }

  InputDecoration _inputDecoration({
    String hintText = '',
    String? suffixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixText: suffixText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0D138B)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
    );
  }
}

String _localizedOption(BuildContext context, String value) {
  final localizations = AppLocalizations.of(context)!;
  switch (value) {
    case 'Online':
      return localizations.online;
    case 'Onsite':
      return localizations.onsite;
    case 'Hybrid':
      return localizations.translate('hybrid');
    case 'Mathematics':
      return localizations.translate('mathematics');
    case 'Physics':
      return localizations.translate('physics');
    case 'Languages':
      return localizations.translate('languages');
    case 'Programming':
      return localizations.translate('programming');
    case 'Middle School':
      return localizations.translate('middle_school');
    case '1st High School':
      return localizations.translate('first_high_school');
    case '2nd High School':
      return localizations.translate('second_high_school');
    case '3rd High School':
      return localizations.translate('third_high_school');
  }
  return value;
}

class _FormFieldBlock extends StatelessWidget {
  const _FormFieldBlock({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}


