import 'package:flutter/material.dart';
import '../../widgets/onboarding_page.dart';
import 'package:fahamni/StudentHomePage/Student_homepage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/Image (1).png",
      "title": "Learn Smarter, Faster",
      "desc":
          "Explore qualified teachers and discover experts in different subjects near you or online."
    },
    {
      "image": "assets/images/Placeholder for educational scheduling illustration.png",
      "title": "Support Your Child’s Success",
      "desc":
          "Monitor progress, connect with trusted teachers, and ensure your child gets the guidance they need."
    },
    {
      "image": "assets/images/page3.png",
      "title": "Share Your Knowledge",
      "desc":
          "Offer your services, manage your sessions, and connect with students who need your expertise."
    },
  ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const Studentpage(),
    ),
  );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
           
            SizedBox(
              height: screenHeight * 0.68, 
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    image: pages[index]["image"]!,
                    title: pages[index]["title"]!,
                    description: pages[index]["desc"]!,
                  );
                },
              ),
            ),

            // spacing (description → dots)
            const SizedBox(height: 12),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => buildDot(index == currentIndex),
              ),
            ),

            
            const SizedBox(height: 28),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF000080),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentIndex == pages.length - 1
                                ? "Get Started"
                                : "Next",
                            style: const TextStyle(
                              fontFamily: "Inter",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ///  Skip 
                  if (currentIndex == 0)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF000080),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Skip",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000080),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Dot
  Widget buildDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF000080)
            : const Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}