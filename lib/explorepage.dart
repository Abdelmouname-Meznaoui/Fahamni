import 'package:fahamni/map.dart';
import 'package:fahamni/models/student_model.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:fahamni/widgets/explore_service.dart';
import 'package:fahamni/widgets/servicedetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fahamni/customnavbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'StudentHomePage/Student_homepage.dart';
import 'models/service_model.dart';
import 'package:fahamni/widgets/servicecard.dart';
class Explorepage extends StatefulWidget {
  final StudentModel student ;
  const Explorepage({
    super.key,
    required this.student,
    });

  @override
  State<Explorepage> createState() => _ExplorepageState();
}

class _ExplorepageState extends State<Explorepage> {

  final TextEditingController _searchController = TextEditingController();
  Position? _currentPosition ;
  GoogleMapController? _controller;


  String? selectedSubject;
  String? selectedMode;
  String? selectedRating;
  String? selectedPrice;
  List<ServiceModel> filteredServices = [];
  List<ServiceModel> allServices = [];
  List<TutorModel> allTutors = [];
  List<String> op = ['Subject','Price','Rating','Mode'];
  List<List<String>> options = [
    ['Mathematics', 'Physics', 'English',],
    ['<1000', '<2000', '<2500',],
    ['3,5','4','4,5',],
    ['online', 'onSite',],
    ];
  @override
  int _selectedIndex = 1;
  int _selectedIndex2 = 0 ;
  late List<Widget> _pages;
  List<TutorModel> ? tutors ;
  List<ServiceModel> ? services ;
  List<TutorModel> ? tutorservice ;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void initState(){
     super.initState();
     loadTutorsServices();
     _getCurrentLocation();
    _pages = [
      const Studenthomepage(),
      const Placeholder(),
      const Placeholder(),
      const Placeholder(),
    ];
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
  Future<void> loadTutorsServices()async{
    final teachers = await Explore_service().getAllTutors();
    final Services = await Explore_service().getAllServices();
    print('serviceId: ${Services[0].serviceId}');
    print('tutorId: ${Services[0].tutorId}');
    final teacherservice = await Explore_service().getTutorsFromServices(Services);
    setState(() {
      tutors = teachers ;
      allTutors = teachers;
      services = Services ;
      allServices = Services;
      tutorservice = teacherservice ;
    });
  }
  Widget build(BuildContext context) {
    if (services == null || tutors == null || _currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar:AppBar(
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
          margin: EdgeInsets.fromLTRB(16, 5, 16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [ BoxShadow(
                            color: Color(0xFF94A3B8),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: const Offset(0,0),
                            blurStyle: BlurStyle.normal,
                          )
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onTap: (){
                            setState(() {
                              _selectedIndex2 = 0 ;
                            });
                          },
                          onChanged: (value) {
                            applyFilters();
                          },
                                decoration: InputDecoration(
                                hintText: 'Search subjects or teachers',
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Lexend",
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  prefixIcon: GestureDetector(
                                    onTap: () {},
                                    child: Icon(
                                        Icons.search,
                                        color: Color(0xFF94A3B8),
                                        size: 30,
                                        fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                      ))
                ],
              ),
              SizedBox(height: 15,),
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: SizedBox(
                            height: 20,
                            width: 115,
                            child: DropdownButtonFormField<String>(
                              value: [selectedSubject, selectedPrice, selectedRating, selectedMode][index],
                              icon: Icon(Icons.keyboard_arrow_down_sharp),
                              iconEnabledColor: _selectedIndex2 == index ? Colors.white : Colors.black,
                              iconSize: 20,
                              isExpanded: true,
                              selectedItemBuilder: (context) {
                                return options[index].map((e) => Center(
                                  child:  Text(
                                    e,
                                    style: TextStyle(
                                      color: _selectedIndex2 == index ? Colors.white : Colors.black,
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )).toList();
                              },
                              hint: Center(
                                child: Text(
                                  op[index],
                                  style: TextStyle(
                                      color: _selectedIndex2 == index ? Colors.white : Colors.black,
                                      fontFamily: "Nunito",
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              autofocus: true,
                              dropdownColor: Colors.white,
                              focusColor: Color(0xFF000080) ,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: _selectedIndex2 == index ? Color(0xFF000080) : Colors.white,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(99),
                                      borderSide: _selectedIndex2 == index ? BorderSide.none : const BorderSide(color: Colors.red , style: BorderStyle.none),
                                  ),
                              ),
                              items: options[index]
                                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                _selectedIndex2 = index ;
                                if (index == 0) selectedSubject = value;
                                else if (index == 1) selectedPrice = value;
                                else if (index == 2) selectedRating = value;
                                else if (index == 3) selectedMode = value;
                                applyFilters();
                              },
                            ),
                          ),
                      );
                    }
                ),
              ),
              SizedBox(height: 16,),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(2, 0),
                  )
                  ],
                ),
                child: Stack(
                  children: [
                      if (_currentPosition != null)
                        Image.asset(
                          "assets/images/map.png",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      Container(
                        height: 200,
                        child: GoogleMap(
                          onMapCreated: (controller) async{
                            _controller = controller;
                            _controller!.setMapStyle(
                                await DefaultAssetBundle.of(context).loadString('assets/map_style.json')
                            );
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
                      ),
                    Positioned(
                      top: 150,
                      left: 25,
                        child: Container(
                          height: 40,
                          width: 330,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/position.svg",
                                height: 25,
                                width: 25,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                  'Discover Tutor near you',
                                style: TextStyle(
                                  fontFamily: "Lexend",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              SizedBox(width: 20,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push( context,
                                    MaterialPageRoute(builder: (context) => Mappage()),
                                  );
                                },
                                child: Text(
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
                        )
                    )

                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Recommanded Teachers',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000080),
                      ),
                    ),

                  )
                ],
              ),
              SizedBox(
                height: 250,
                width: 500,
                child: tutors!.isEmpty ? Center(
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
                :ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: tutors!.length,
                    itemBuilder: (contex,index){
                      return GestureDetector(
                        onTap: (){},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Container(
                            height: 80,
                            width: 500,
                            padding: EdgeInsetsGeometry.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                color: Color(0xFF000000).withOpacity(0.05),
                                blurRadius:2,
                              )]
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height : 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                          tutors![index].picture,
                                           fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                         tutors![index].firstName,
                                         style: TextStyle(
                                           fontFamily: "Lexend",
                                           fontWeight: FontWeight.w700,
                                           fontSize: 14,
                                         ),
                                        ),
                                        Text(
                                          tutors![index].expertiseDomain,
                                          style: TextStyle(
                                              fontFamily: "Lexend",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                        SizedBox(height: 3,),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/position.svg",
                                              height: 12,
                                              width: 12,
                                              color: Color(0xFF64748B),
                                            ),
                                            SizedBox(width: 2,),
                                            Text(
                                              tutors![index].location,
                                              style: TextStyle(
                                                  fontFamily: "Lexend",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Positioned(
                                    top: 0,
                                    left: 310,
                                    child: Container(
                                      height: 23,
                                      width: 50,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFF000080).withOpacity(0.1),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/star.svg",
                                              height:12 ,
                                              width: 12,
                                            ),
                                            SizedBox(width: 2,),
                                            Text(
                                              tutors![index].averageRating.toString(),
                                              style: TextStyle(
                                                color: const Color(0xFF1E293B),
                                                fontSize: 12,
                                                fontFamily: 'Lexend',
                                                fontWeight: FontWeight.w700,
                                                height: 1.33,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }  ),
              ),
              SizedBox(height: 5,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Recommanded Services',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000080),
                      ),
                    ),

                  )
                ],
              ),
              SizedBox(
                height: 410,
                width: double.infinity,
                child: services!.isEmpty ? Center(
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
                :ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: services!.length,
                    itemBuilder: (context,index){
                      return SizedBox(
                          height: 430,
                          width: 350,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Servicedetails(tutor: tutorservice![index], service: services![index])),
                                );
                              },
                              child: ServiceCard(tutor: tutorservice![index], service: services![index])));
                    } ),
              )
            ],
          ),
        
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(selectedIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push( context,
              MaterialPageRoute(builder: (context) => Studenthomepage()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },),
    );
  }
  void applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      services = allServices.where((s) {
        final matchSubject = selectedSubject == null || s.subject == selectedSubject;
        final matchPrice = selectedPrice == null || s.price <= double.parse(selectedPrice!.replaceAll('<', ''));
        final matchSearch = query.isEmpty || s.subject.toLowerCase().contains(query) ||
            s.price.toString().toLowerCase().contains(query)  ;

        final tutor = tutorservice?.firstWhere(
              (t) => t.uid == s.tutorId,
          orElse: () => tutorservice![0],
        );
        final matchMode = selectedMode == null || tutor?.teachingMode == selectedMode;
        final matchRating = selectedRating == null || (tutor?.averageRating ?? 0) >= double.parse(selectedRating!.replaceAll(',', '.'));

        return matchSubject && matchPrice && matchMode && matchRating && matchSearch;
      }).toList();

      tutors = allTutors.where((t) {
        final matchMode = selectedMode == null || t.teachingMode == selectedMode;
        final matchSubject = selectedSubject == null || t.expertiseDomain == selectedSubject;
        final matchRating = selectedRating == null || t.averageRating >= double.parse(selectedRating!.replaceAll(',', '.'));
        final matchSearch = query.isEmpty ||
            t.firstName.toLowerCase().contains(query) ||
            t.lastName.toLowerCase().contains(query) ||
            t.expertiseDomain.toLowerCase().contains(query)||
            t.averageRating.toString().toLowerCase().contains(query);
        return matchMode && matchRating && matchSubject && matchSearch;
      }).toList();
    });
  }
}
