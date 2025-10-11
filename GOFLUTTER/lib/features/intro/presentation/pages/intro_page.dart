import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const _FloatingElements(),
            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const _Header(),
                          const SizedBox(height: 30),
                          _buildCarousel(),
                          const SizedBox(height: 25),
                          const _FeaturesGrid(),
                          const SizedBox(height: 25),
                          const _LaunchButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800, maxHeight: 280),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                _CarouselSlide(
                  title: "🌐 Decentralized Network",
                  description:
                      "Experience true decentralization with our advanced peer-to-peer network architecture. Every node is equal, every transaction is secure.",
                  gradientColors: [Color(0xCC667EEA), Color(0xCC764BA2)],
                  svgBackground:
                      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400"><rect width="800" height="400" fill="#000"/><circle cx="200" cy="200" r="50" fill="#4299e1"/><circle cx="400" cy="150" r="30" fill="#48bb78"/><circle cx="600" cy="250" r="40" fill="#ed8936"/><path d="M100 300 L300 100 L500 300 L700 100" stroke="#fff" stroke-width="2" fill="none"/></svg>',
                ),
                _CarouselSlide(
                  title: "⚡ High Performance",
                  description:
                      "Lightning-fast transaction processing with our optimized consensus mechanism. Handle thousands of transactions per second with ease.",
                  gradientColors: [Color(0xCC48BB78), Color(0xCC38A169)],
                  svgBackground:
                      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400"><rect width="800" height="400" fill="#000"/><rect x="150" y="150" width="100" height="100" fill="#4299e1"/><rect x="300" y="200" width="80" height="80" fill="#48bb78"/><rect x="450" y="120" width="120" height="120" fill="#ed8936"/><line x1="100" y1="300" x2="700" y2="100" stroke="#fff" stroke-width="3"/></svg>',
                ),
                _CarouselSlide(
                  title: "🛡️ Enterprise Security",
                  description:
                      "Military-grade security protocols protect your assets. Advanced cryptography ensures your data remains private and secure.",
                  gradientColors: [Color(0xCCED8936), Color(0xCCDD6B20)],
                  svgBackground:
                      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400"><rect width="800" height="400" fill="#000"/><polygon points="200,100 250,200 150,200" fill="#4299e1"/><polygon points="400,150 450,250 350,250" fill="#48bb78"/><polygon points="600,120 650,220 550,220" fill="#ed8936"/><circle cx="400" cy="300" r="30" fill="#fff"/></svg>',
                ),
                _CarouselSlide(
                  title: "🔗 Smart Contracts",
                  description:
                      "Deploy and execute smart contracts with our powerful virtual machine. Build the future of decentralized applications.",
                  gradientColors: [Color(0xCC667EEA), Color(0xCC48BB78)],
                  svgBackground:
                      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 400"><rect width="800" height="400" fill="#000"/><circle cx="200" cy="200" r="60" fill="#4299e1"/><circle cx="400" cy="200" r="60" fill="#48bb78"/><circle cx="600" cy="200" r="60" fill="#ed8936"/><path d="M200 200 L400 200 L600 200" stroke="#fff" stroke-width="4"/></svg>',
                ),
              ],
            ),
            _buildCarouselNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselNav() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return GestureDetector(
            onTap: () => _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: _currentPage == index ? 16 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFF0F0F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "🔗 ATLAS B.C.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 56, // 3.5rem
              color: Colors.white, // This color is necessary for ShaderMask
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Welcome to the Future of Blockchain Technology",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21, color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 10),
        Text(
          "Decentralized • Secure • Scalable",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _CarouselSlide extends StatelessWidget {
  final String title;
  final String description;
  final List<Color> gradientColors;
  final String svgBackground;

  const _CarouselSlide({
    required this.title,
    required this.description,
    required this.gradientColors,
    required this.svgBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        SvgPicture.string(svgBackground, fit: BoxFit.cover),
        Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  const _FeaturesGrid();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: const [
          _FeatureCard(
            icon: "🔍",
            title: "Block Explorer",
            description:
                "Browse blocks, transactions, and network activity in real-time with our comprehensive explorer.",
          ),
          _FeatureCard(
            icon: "💼",
            title: "Wallet Management",
            description:
                "Manage your accounts, balances, and send transactions securely with our advanced wallet system.",
          ),
          _FeatureCard(
            icon: "🌐",
            title: "Network Monitoring",
            description:
                "Monitor node status, peers, and validator performance with detailed analytics and insights.",
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _LaunchButton extends StatelessWidget {
  const _LaunchButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to wallet setup page using GoRouter
        context.go('/wallet-setup');
      },
      style:
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Colors.transparent, // Handled by decoration
            shadowColor: const Color(0xFF48BB78).withOpacity(0.4),
            elevation: 10,
          ).copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF48BB78), Color(0xFF38A169)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF48BB78).withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          child: const Text(
            "🚀 Launch ATLAS B.C. Dashboard",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingElements extends StatefulWidget {
  const _FloatingElements();

  @override
  State<_FloatingElements> createState() => _FloatingElementsState();
}

class _FloatingElementsState extends State<_FloatingElements>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  final List<Widget> _elements = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: 6 + index * 2),
      )..repeat(reverse: true);
    });

    // Define positions for floating elements
    final List<Map<String, dynamic>> positions = [
      {'top': 0.2, 'left': 0.1, 'size': 80.0},
      {'top': 0.6, 'right': 0.15, 'size': 60.0},
      {'bottom': 0.2, 'left': 0.2, 'size': 100.0},
    ];

    for (int i = 0; i < 3; i++) {
      _elements.add(
        AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) {
            final value = _controllers[i].value; // 0.0 to 1.0
            return Positioned(
              top: positions[i]['top'] != null
                  ? MediaQuery.of(context).size.height * positions[i]['top']
                        as double
                  : null,
              left: positions[i]['left'] != null
                  ? MediaQuery.of(context).size.width * positions[i]['left']
                        as double
                  : null,
              right: positions[i]['right'] != null
                  ? MediaQuery.of(context).size.width * positions[i]['right']
                        as double
                  : null,
              bottom: positions[i]['bottom'] != null
                  ? MediaQuery.of(context).size.height * positions[i]['bottom']
                        as double
                  : null,
              child: Transform.translate(
                offset: Offset(0, math.sin(value * 2 * math.pi) * 10),
                child: Transform.rotate(
                  angle: value * 2 * math.pi,
                  child: child,
                ),
              ),
            );
          },
          child: Container(
            width: positions[i]['size'] as double,
            height: positions[i]['size'] as double,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _elements);
  }
}