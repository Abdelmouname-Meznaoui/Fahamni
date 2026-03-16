import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'media_grid.dart';

class InsideConversationButtons extends StatefulWidget {
  const InsideConversationButtons({super.key});

  @override
  State<InsideConversationButtons> createState() => _MyMessagesWidgetState();
}


class _MyMessagesWidgetState extends State<InsideConversationButtons>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;

  final List<String> mediaFiles = [
    'https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg',
    'https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg',
    'https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg',
    'https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg',
    'https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg',
  ];

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {});
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
      color: Color(0xFFFAFAFA),
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
              fontWeight: FontWeight.bold,
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
                    children: [
                      SvgPicture.asset(
                        'assets/images/Vector.svg',
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          _tabController.index == 0 
                         ? const Color(0xFF000080) 
                          : const Color(0xFF767C8C),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text("Media"),
                    ],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file_outlined),
                    const SizedBox(width: 6),
                    const Text("Attach"),
                  ], 
                ),
               ),
              ),
              Tab(
                child:FittedBox(
                  fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group_outlined,
                    ),
                    SizedBox(width: 6),
                    const Text("Members"),
                  ],
                ),
                ), 
              ),
            ],
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFECEFF1)),

          SizedBox(
          height: 400, 
          child: TabBarView(
            controller: _tabController,
            children: [

              MediaGrid(images: mediaFiles),

              const Center(
                child: Text(
                  "Attachment Content",
                  ),
                ),
              const Center(
                child: Text(
                  "Groups Content",
                  ),
                ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
