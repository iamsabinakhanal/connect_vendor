import 'package:flutter/material.dart';
import 'dart:async';
import '../app/theme/app_theme.dart';
import '../auth/session_storage.dart';
import '../view/home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../view/admin/admin_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for 3 seconds
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    Timer(Duration(seconds: 3), () {
      if (!mounted) return;
      _routeNext();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _routeNext() async {
    final bool isLoggedIn = await SessionStorage.isLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      final String role = await SessionStorage.getSessionRole();
      final String vendorName =
          (await SessionStorage.getSessionVendorName()) ?? 'Vendor';

      if (role.toUpperCase() == 'ADMIN') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminDashboardScreen(adminName: vendorName),
          ),
        );
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(vendorName: vendorName),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.background, AppTheme.primary],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // App Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'PG',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primarySoft,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // App Name
                      Text(
                        'CConnect Vendor',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Tagline
                      Text(
                        'Share • Network • Grow',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60),
              // Loading indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
