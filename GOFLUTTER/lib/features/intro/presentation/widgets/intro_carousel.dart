import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../shared/themes/app_colors.dart';

class IntroCarousel extends StatefulWidget {
  const IntroCarousel({Key? key}) : super(key: key);

  @override
  State<IntroCarousel> createState() => _IntroCarouselState();
}

class _IntroCarouselState extends State<IntroCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    
    // Auto-advance slides every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 4;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView(
            controller: _pageController,
            children: [
              _buildSlide(
                '🌐 Decentralized Network',
                'Experience true decentralization with our advanced peer-to-peer network architecture. Every node is equal, every transaction is secure.',
                AppColors.primaryGradient,
              ),
              _buildSlide(
                '⚡ High Performance',
                'Lightning-fast transaction processing with our optimized consensus mechanism. Handle thousands of transactions per second with ease.',
                AppColors.successGradient,
              ),
              _buildSlide(
                '🛡️ Enterprise Security',
                'Military-grade security protocols protect your assets. Advanced cryptography ensures your data remains private and secure.',
                AppColors.warningGradient,
              ),
              _buildSlide(
                '🔗 Smart Contracts',
                'Deploy and execute smart contracts with our powerful virtual machine. Build the future of decentralized applications.',
                AppColors.infoGradient,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.white : Colors.white.withValues(alpha: 0.5),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  static Widget _buildSlide(String title, String description, LinearGradient gradient) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.h2.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: AppTextStyles.body1.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
