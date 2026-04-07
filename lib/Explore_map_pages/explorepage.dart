import 'package:fahamni/messaging/chat_page.dart';
import 'package:fahamni/feedback/feedback_pages.dart';
import 'package:fahamni/Courses/courses_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fahamni/widgets/customnavbar.dart';
import 'package:fahamni/models/service_model.dart';
import 'package:fahamni/models/student_model.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:fahamni/widgets/servicecard.dart';
import 'package:fahamni/StudentHomePage/Student_homepage.dart';
import 'package:fahamni/widgets/explore_service.dart';
import 'package:fahamni/widgets/servicedetails.dart';
import 'map.dart';

const String _mapLocationConsentKey = 'map_location_consent_granted';

class Explorepage extends StatefulWidget {
  final StudentModel student;
  const Explorepage({super.key, required this.student});

  @override
  State<Explorepage> createState() => _ExplorepageState();
}

class _ExplorepageState extends State<Explorepage> {
  final TextEditingController _searchController = TextEditingController();
  Position? _currentPosition;
  GoogleMapController? _controller;

  String? selectedSubject;
  String? selectedMode;
  String? selectedRating;
  String? selectedPrice;

  List<ServiceModel> filteredServices = [];
  List<ServiceModel> allServices = [];
  List<TutorModel> allTutors = [];
  List<String> op = ['Subject', 'Price', 'Rating', 'Mode'];
  List<List<String>> options = [
    ['Mathematics', 'Physics', 'English'],
    ['<1000', '<2000', '<2500'],
    ['3.5', '4', '4.5'],
    ['online', 'onSite'],
  ];

  int _selectedIndex = 1;
  int _selectedIndex2 = 0;
  int nearbyTutorsCount = 0;

  List<TutorModel>? tutors;
  List<ServiceModel>? services;
  List<TutorModel>? tutorservice;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // 1. Wait for location & tutors to load concurrently
    await Future.wait([
      _getCurrentLocation(),
      loadTutorsServices(),
    ]);

    // 2. Only calculate distances AFTER both are loaded
    await _getDistances();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    _controller?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  Future<void> _loadLocationPreview() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool locationConsentGranted =
        preferences.getBool(_mapLocationConsentKey) ?? false;
    if (!locationConsentGranted) {
      return;
    }

    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    if (!mounted) {
      return;
    }
    setState(() {
      _currentPosition = position;
    });

    _controller?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  Future<void> _openFullMap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Mappage()),
    );

    if (!mounted) {
      return;
    }

    await _loadLocationPreview();
  }

  Future<void> _getDistances() async {
    // 1. Get User Location first

    // 2. Fetch Tutors
    List<TutorModel> allTutors = await Explore_service().getAllTutors();
    int count = 0;

    for (var tutor in tutors!) {
      if (tutor.location.isNotEmpty) {
        try {
          // 3. Geocode the tutor's address string
          List<Location> locations = await locationFromAddress(tutor.location);

          if (locations.isNotEmpty) {
            // 4. Calculate distance in KM
            double distance = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              locations[0].latitude,
              locations[0].longitude,
            ) / 1000;

            // 5. Check if less than 20km
            if (distance < 20.0) {
              count++;
            }

            // Optional: Store distance in the tutor object if you updated your model
            // tutor.distance = distance;
          }
        } catch (e) {
          print("Geocoding failed for ${tutor.firstName}: $e");
        }
      }
    }
    setState(() {
      nearbyTutorsCount = count;
    });
  }

  Future<void> loadTutorsServices() async {
    final teachers = await Explore_service().getAllTutors();
    final fetchedServices = await Explore_service().getAllServices();
    final teacherservice = await Explore_service().getTutorsFromServices(
      fetchedServices,
    );
    setState(() {
      tutors = teachers;
      allTutors = teachers;
      services = fetchedServices;
      allServices = fetchedServices;
      tutorservice = teacherservice;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (services == null || tutors == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
          "Explore",
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
          margin: const EdgeInsets.fromLTRB(16, 5, 16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search TextField
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF94A3B8),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    applyFilters();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search subjects or teachers',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: "Lexend",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Filter dropdowns
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: SizedBox(
                        width: 115,
                        child: DropdownButtonFormField<String>(
                          initialValue: [
                            selectedSubject,
                            selectedPrice,
                            selectedRating,
                            selectedMode,
                          ][index],
                          icon: const Icon(Icons.keyboard_arrow_down_sharp),
                          iconEnabledColor: _selectedIndex2 == index
                              ? Colors.white
                              : Colors.black,
                          iconSize: 20,
                          isExpanded: true,
                          selectedItemBuilder: (context) {
                            return options[index]
                                .map(
                                  (e) => Center(
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: _selectedIndex2 == index
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                                .toList();
                          },
                          hint: Center(
                            child: Text(
                              op[index],
                              style: TextStyle(
                                color: _selectedIndex2 == index
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _selectedIndex2 == index
                                ? const Color(0xFF000080)
                                : Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(99),
                              borderSide: _selectedIndex2 == index
                                  ? BorderSide.none
                                  : const BorderSide(color: Colors.grey),
                            ),
                          ),
                          items: options[index]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (value) {
                            _selectedIndex2 = index;
                            if (index == 0) {
                              selectedSubject = value;
                            } else if (index == 1) {
                              selectedPrice = value;
                            } else if (index == 2) {
                              selectedRating = value;
                            } else if (index == 3) {
                              selectedMode = value;
                            }
                            applyFilters();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Map
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (_currentPosition != null)
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: GoogleMap(
                          onMapCreated: (controller) async {
                            _controller = controller;
                            // Custom map style if needed
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            zoom: 14,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                      )
                    else
                      Image.asset(
                        "assets/images/map.png",
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Positioned(
                      top: 150,
                      left: 25,
                      child: Container(
                        height: 40,
                        width: 330,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/position.svg",
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 5),
                            nearbyTutorsCount == 0 ?
                             Text(
                              '$nearbyTutorsCount Tutors found near you',
                              style: TextStyle(
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF0F172A),
                              ),
                            ) : Text(
                              'Discover Tutors found near you',
                              style: TextStyle(
                                fontFamily: "Lexend",
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                _openFullMap();
                              },
                              child: const Text(
                                'VIEW FULL MAP',
                                style: TextStyle(
                                  fontFamily: "Lexend",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Color(0xFF000080),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Recommended Teachers
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Text(
                      'Recommended Teachers',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000080),
                      ),
                    ),
                  ),
                ],
              ),
              if (tutors!.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No results found :(',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tutors!.length,
                  itemBuilder: (context, index) {
                    final TutorModel tutor = tutors![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TutorProfilePage(tutorId: tutor.uid),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF000000,
                                ).withValues(alpha: 0.05),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.network(
                                  tutor.picture,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                        'assets/images/tutormale.png',
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${tutor.firstName} ${tutor.lastName}',
                                      style: const TextStyle(
                                        fontFamily: "Lexend",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      tutor.expertiseDomain,
                                      style: const TextStyle(
                                        fontFamily: "Lexend",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/position.svg",
                                              height: 12,
                                              width: 12,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    Color(0xFF64748B),
                                                    BlendMode.srcIn,
                                                  ),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              tutor.location,
                                              style: const TextStyle(
                                                fontFamily: "Lexend",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          tutor.isAvailable
                                              ? 'Available'
                                              : 'Busy',
                                          style: TextStyle(
                                            fontFamily: "Lexend",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                            color: tutor.isAvailable
                                                ? const Color(0xFF16A34A)
                                                : const Color(0xFFDC2626),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(
                                    0xFF000080,
                                  ).withValues(alpha: 0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/star.svg",
                                      height: 12,
                                      width: 12,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      tutor.averageRating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontSize: 12,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 5),
              // Recommended Services
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Text(
                      'Recommended Services',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000080),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 410,
                width: double.infinity,
                child: services!.isEmpty
                    ? const Center(
                        child: Text(
                          'No results found :(',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: services!.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 430,
                            width: 350,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Servicedetails(
                                      tutor: tutorservice![index],
                                      service: services![index],
                                    ),
                                  ),
                                );
                              },
                              child: ServiceCard(
                                tutor: tutorservice![index],
                                service: services![index],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
        selectedIndex: _selectedIndex,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Studenthomepage()),
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
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  void applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      services = allServices.where((s) {
        final matchSubject =
            selectedSubject == null || s.subject == selectedSubject;
        final matchPrice =
            selectedPrice == null ||
            s.price <= double.parse(selectedPrice!.replaceAll('<', ''));
        final matchSearch =
            query.isEmpty ||
            s.subject.toLowerCase().contains(query) ||
            s.price.toString().toLowerCase().contains(query);

        final tutor = tutorservice?.firstWhere(
          (t) => t.uid == s.tutorId,
          orElse: () => tutorservice![0],
        );
        final matchMode =
            selectedMode == null || tutor?.teachingMode == selectedMode;
        final matchRating =
            selectedRating == null ||
            (tutor?.averageRating ?? 0) >=
                double.parse(selectedRating!.replaceAll(',', '.'));

        return matchSubject &&
            matchPrice &&
            matchMode &&
            matchRating &&
            matchSearch;
      }).toList();

      tutors = allTutors.where((t) {
        final matchMode =
            selectedMode == null || t.teachingMode == selectedMode;
        final matchSubject =
            selectedSubject == null || t.expertiseDomain == selectedSubject;
        final matchRating =
            selectedRating == null ||
            t.averageRating >=
                double.parse(selectedRating!.replaceAll(',', '.'));
        final matchSearch =
            query.isEmpty ||
            t.firstName.toLowerCase().contains(query) ||
            t.lastName.toLowerCase().contains(query) ||
            t.expertiseDomain.toLowerCase().contains(query) ||
            t.averageRating.toString().toLowerCase().contains(query);
        return matchMode && matchRating && matchSubject && matchSearch;
      }).toList();
    });
  }
}
