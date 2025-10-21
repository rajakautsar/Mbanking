import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _backgroundController;
  
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _formController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // Initialize animations
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _formAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutBack,
    ));
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _formController.forward();
    });
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    _backgroundController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      if (result['success']) {
        // Haptic feedback
        HapticFeedback.lightImpact();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(result['message']),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        
        // Navigate to dashboard with username
        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
          arguments: {
            'username': usernameController.text.trim(),
          },
        );
      } else {
        // Haptic feedback for error
        HapticFeedback.heavyImpact();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text(result['message']),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white),
              const SizedBox(width: 8),
              Text('Koneksi gagal: $e'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk testing koneksi server
  Future<void> _testServerConnection() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Test koneksi
      final result = await ApiService.checkServerHealth();
      
      // Close loading
      Navigator.pop(context);
      
      // Show result
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            result['success'] ? '✅ Koneksi Berhasil' : '❌ Koneksi Gagal',
            style: TextStyle(
              color: result['success'] ? Colors.green : Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('URL: ${result['url']}'),
              if (result['success']) ...[
                Text('Status Code: ${result['statusCode']}'),
                Text('Response: ${result['body']}'),
              ] else ...[
                Text('Error: ${result['error']}'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            if (!result['success'])
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ApiService.testConnections();
                },
                child: const Text('Test URLs Lain'),
              ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error testing connection: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
            ],
            stops: [
              0.0,
              0.5,
              1.0,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundPainter(_backgroundAnimation.value),
                  size: size,
                );
              },
            ),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      
                      // Logo section with animation
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/Logo_Nusantara.png',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Title with glow effect
                      AnimatedBuilder(
                        animation: _logoAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _logoAnimation.value)),
                            child: Opacity(
                              opacity: _logoAnimation.value,
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [Colors.white, Colors.white.withOpacity(0.8)],
                                ).createShader(bounds),
                                child: const Text(
                                  "NUSANTARA BANK",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Login form with glassmorphism
                      AnimatedBuilder(
                        animation: _formAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - _formAnimation.value)),
                            child: Opacity(
                              opacity: _formAnimation.value,
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Username field
                                      _buildGlassmorphicField(
                                        controller: usernameController,
                                        label: "Username",
                                        icon: Icons.person_outline,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Username harus diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Password field
                                      _buildGlassmorphicField(
                                        controller: passwordController,
                                        label: "Password",
                                        icon: Icons.lock_outline,
                                        obscureText: _obscurePassword,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.white.withOpacity(0.7),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                            HapticFeedback.lightImpact();
                                          },
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Password harus diisi';
                                          }
                                          if (value.length < 6) {
                                            return 'Password minimal 6 karakter';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Remember me checkbox
                                      Row(
                                        children: [
                                          Transform.scale(
                                            scale: 0.9,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: (value) {
                                                setState(() {
                                                  _rememberMe = value ?? false;
                                                });
                                                HapticFeedback.lightImpact();
                                              },
                                              activeColor: Colors.white,
                                              checkColor: const Color(0xFF667eea),
                                              side: BorderSide(
                                                color: Colors.white.withOpacity(0.5),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Remember me",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 30),
                                      
                                      // Login button with gradient
                                      Container(
                                        width: double.infinity,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.9),
                                              Colors.white.withOpacity(0.7),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF667eea),
                                                    ),
                                                  ),
                                                )
                                              : const Text(
                                                  "Sign In",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF667eea),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      // Register link
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Belum punya akun? ",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              Navigator.pushNamed(context, '/register');
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.white.withOpacity(0.8),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                "Register",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Debug button untuk testing koneksi
                                      GestureDetector(
                                        onTap: () async {
                                          HapticFeedback.lightImpact();
                                          await _testServerConnection();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Text(
                                            "🔍 Test Server Connection",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassmorphicField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.7),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// Custom painter for animated background
class BackgroundPainter extends CustomPainter {
  final double animationValue;
  
  BackgroundPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    
    // Create floating circles
    final circles = [
      {'x': size.width * 0.1, 'y': size.height * 0.2, 'radius': 80, 'opacity': 0.1},
      {'x': size.width * 0.8, 'y': size.height * 0.1, 'radius': 60, 'opacity': 0.15},
      {'x': size.width * 0.2, 'y': size.height * 0.7, 'radius': 100, 'opacity': 0.08},
      {'x': size.width * 0.9, 'y': size.height * 0.8, 'radius': 70, 'opacity': 0.12},
      {'x': size.width * 0.5, 'y': size.height * 0.3, 'radius': 50, 'opacity': 0.1},
    ];
    
    for (final circle in circles) {
      final animatedY = (circle['y']! as double) + (20 * animationValue);
      paint.color = Colors.white.withOpacity(circle['opacity']! as double);
      
      canvas.drawCircle(
        Offset(circle['x']! as double, animatedY),
        circle['radius']! as double,
        paint,
      );
    }
    
    // Create gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1 * animationValue),
          Colors.transparent,
          Colors.white.withOpacity(0.05 * animationValue),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
