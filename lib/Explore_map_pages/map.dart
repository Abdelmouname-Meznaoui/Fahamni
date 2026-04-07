import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:fahamni/widgets/explore_service.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const String _googleMapsApiKey = 'AIzaSyAsdCXmRcjXMYaLrytaPoO7oLACGdzj65E';
const LatLng _defaultMapCenter = LatLng(36.7538, 3.0588);

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  GoogleMapController? _controller;
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<TutorModel> teachers = [];
  List<List<Location>> positions = [];
  TutorModel? _selectedTutor;
  int? _selectedIndex;
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadTutorMarkers();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() => _currentPosition = null);
      }
      return;
    }
    final position = await Geolocator.getCurrentPosition();
    if (!mounted) {
      return;
    }
    setState(() => _currentPosition = position);
    _controller?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  Future<BitmapDescriptor> _buildCircularMarker(String url) async {
    const int size = 120;
    const double radius = 50;
    const double borderWidth = 5;
    const Color borderColor = Colors.white;

    final response = await http.get(Uri.parse(url));
    final Uint8List imageBytes = response.bodyBytes;

    final ui.Codec codec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: (radius * 2).toInt(),
      targetHeight: (radius * 2).toInt(),
    );
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image avatarImage = frame.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final double center = size / 2;
    final Offset centerOffset = Offset(center, center);

    canvas.drawCircle(
      centerOffset,
      radius + borderWidth,
      Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(centerOffset, radius + borderWidth, Paint()..color = borderColor);
    final Path clipPath = Path()
      ..addOval(Rect.fromCircle(center: centerOffset, radius: radius));
    canvas.clipPath(clipPath);
    canvas.drawImageRect(
      avatarImage,
      Rect.fromLTWH(0, 0, avatarImage.width.toDouble(), avatarImage.height.toDouble()),
      Rect.fromCircle(center: centerOffset, radius: radius),
      Paint(),
    );

    final ui.Image markerImage = await recorder.endRecording().toImage(size, size);
    final ByteData? byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  Future<void> _loadTutorMarkers() async {
    final tutors = await Explore_service().getAllTutors();
    for (TutorModel tutor in tutors) {
      if (tutor.location.isEmpty) continue;
      try {
        List<Location> locations = await locationFromAddress(tutor.location);
        if (locations.isEmpty) continue;
        final BitmapDescriptor icon = await _buildCircularMarker(tutor.picture);
        final marker = Marker(
          markerId: MarkerId(tutor.uid),
          position: LatLng(locations[0].latitude, locations[0].longitude),
          icon: icon,
          onTap: () {
            final index = teachers.indexWhere((t) => t.uid == tutor.uid);
            setState(() {
              _selectedTutor = tutor;
              _selectedIndex = index;
            });
            _sheetController.animateTo(
              0.45,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
            _controller!.animateCamera(
              CameraUpdate.newLatLng(LatLng(locations[0].latitude, locations[0].longitude)),
            );
          },
        );
        setState(() {
          _markers.add(marker);
          teachers = tutors;
          positions.add(locations);
        });
      } catch (e) {
        print('Could not geocode: $e');
      }
    }
  }

  String _getDistance(int index) {
    if (_currentPosition == null) return '';
    final distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      positions[index][0].latitude,
      positions[index][0].longitude,
    );
    final km = distanceInMeters / 1000;
    return km < 1 ? '${distanceInMeters.toInt()} m away' : '${km.toStringAsFixed(1)} km away';
  }
  Future<void> _drawPolyline(int index) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: _googleMapsApiKey,
      request: PolylineRequest(
        origin: PointLatLng(
          _currentPosition?.latitude ?? _defaultMapCenter.latitude,
          _currentPosition?.longitude ?? _defaultMapCenter.longitude,
        ),
        destination: PointLatLng(positions[index][0].latitude, positions[index][0].longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _polylines = {
          Polyline(
            polylineId: PolylineId('route'),
            points: result.points
                .map((p) => LatLng(p.latitude, p.longitude))
                .toList(),
            color: Color(0xFF000080),
            width: 5,
          ),
        };
        print('polyline points: ${result.points.length}');
        print('status: ${result.status}');
        print('error: ${result.errorMessage}');
      });
    }
  }

  void _openGoogleMapsDirections(int index) async {
    final lat = positions[index][0].latitude;
    final lng = positions[index][0].longitude;
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving'
    );
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialTarget = _currentPosition == null
        ? _defaultMapCenter
        : LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff9f9f9),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text(
          "Tutors Map",
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff0f172a),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: 15,
            ),
            myLocationEnabled: _currentPosition != null,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) async {
              _controller = controller;
              _controller!.setMapStyle(
                await DefaultAssetBundle.of(context).loadString('assets/map_style.json'),
              );
              _customInfoWindowController.googleMapController = controller;
              _controller!.animateCamera(
                CameraUpdate.newLatLng(
                  initialTarget,
                ),
              );
            },
            onCameraMove: (_) => _customInfoWindowController.onCameraMove!(),
            onTap: (_) {
              _customInfoWindowController.hideInfoWindow!();
              setState(() {
                _selectedTutor = null;
                _selectedIndex = null;
                _polylines = {};
              });
              _sheetController.animateTo(
                0.18,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 180,
            width: MediaQuery.of(context).size.width * 0.89,
            offset: 50,
          ),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.18,
            minChildSize: 0.18,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 12, bottom: 8),
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),

                      // Teacher avatars row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Center(
                          child: Text(
                            'select your favorite tutor',
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 85,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: teachers.length,
                          itemBuilder: (context, index) {
                            final isSelected = _selectedIndex == index;
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  _selectedTutor = teachers[index];
                                  _selectedIndex = index;
                                });
                                _controller!.animateCamera(
                                  CameraUpdate.newLatLng(
                                    LatLng(positions[index][0].latitude, positions[index][0].longitude),
                                  ),
                                );
                                _sheetController.animateTo(
                                  0.45,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(teachers[index].picture),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                          color: isSelected ? Color(0xFF000080) : Colors.grey[300]!,
                                          width: isSelected ? 3 : 1.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      teachers[index].firstName,
                                      style: TextStyle(
                                        fontFamily: "Lexend",
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                        fontSize: 11,
                                        color: isSelected ? Color(0xFF000080) : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Selected tutor details
                      if (_selectedTutor != null && _selectedIndex != null) ...[
                        Divider(height: 24, color: Colors.grey[200]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 5),
                                decoration: BoxDecoration(
                                    color: Color(0xFF000080).withOpacity(0.1),
                                    borderRadius: BorderRadiusGeometry.circular(5),
                                    border: Border(
                                        left: BorderSide(
                                          color: Color(0xFF000080),
                                          width: 4,
                                        )
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(_selectedTutor!.picture),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                          style: BorderStyle.none
                                        )
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_selectedTutor!.firstName} ${_selectedTutor!.lastName}',
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                          Text(
                                            _selectedTutor!.expertiseDomain,
                                            style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF000080).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset("assets/images/star.svg", height: 12, width: 12),
                                          SizedBox(width: 4),
                                          Text(
                                            _selectedTutor!.averageRating.toString(),
                                            style: TextStyle(
                                              fontFamily: "Lexend",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              // Info rows
                              _infoRow(Icons.location_on_rounded, _selectedTutor!.location),
                              SizedBox(height: 8),
                              Container(
                                margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
                                padding: EdgeInsets.fromLTRB(6, 3, 0, 3) ,
                                width: 130,
                                isAntiAlias: true,
                                decoration: BoxDecoration(
                                  color: Color(0xFF000080).withOpacity(0.1),
                                  borderRadius: BorderRadiusGeometry.circular(99),
                                ),
                                child: _infoRow(
                                  Icons.directions_walk_rounded,
                                  _currentPosition == null
                                      ? 'Enable location for distance'
                                      : _getDistance(_selectedIndex!),
                                ),
                                
                              ),
                              SizedBox(height: 8),
                              _infoRow(Icons.devices, _selectedTutor!.teachingMode),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed:()=> _openGoogleMapsDirections(_selectedIndex!),
                                        icon: Icon(
                                            Icons.message_outlined
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsetsGeometry.fromLTRB(20,15,20,15),
                                            backgroundColor: Color(0xFFD2D2D2),
                                            iconColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadiusGeometry.circular(30),
                                            )
                                        ),
                                        label: Center(
                                          child: Text(
                                            'Directions',
                                            style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )

                                    ),
                                    SizedBox(width: 10,),
                                    ElevatedButton.icon(onPressed:(){},
                                        icon: Icon(
                                          Icons.person_2_outlined,
                                          color: Colors.white,
                                          size: 23,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsetsGeometry.fromLTRB(20,15,20,15),
                                            backgroundColor: Color(0xFF000080),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadiusGeometry.circular(30),
                                            )
                                        ),
                                        label: Center(
                                          child: Text(
                                            'View Profile',
                                            style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )

                                    )
                                  ],
                                )
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                      if (_currentPosition == null)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Text(
                            'Location permission is off. The map still works, but your current position and distance are unavailable.',
                            style: TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Container(
      padding: icon == Icons.directions_walk_rounded ? EdgeInsets.symmetric(horizontal: 0) : EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Color(0xFF000080)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "Lexend",
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color:  icon == Icons.directions_walk_rounded ?  Color(0xFF000080)  :  Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
