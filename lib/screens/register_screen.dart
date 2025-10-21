import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  final _formKey = GlobalKey<FormState>();
  
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
    usernameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  // Fungsi untuk handle register
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.register(
        username: usernameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        password: passCtrl.text,
      );

      if (result['success']) {
        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        
        // Kembali ke login screen
        Navigator.pop(context);
      } else {
        // Tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
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
                  painter: RegisterBackgroundPainter(_backgroundAnimation.value),
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
                      const Spacer(flex: 1),
                      
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
                "Create Your Account",
                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Register form with glassmorphism
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
                controller: usernameCtrl,
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
                                      
                                      // Email field
                                      _buildGlassmorphicField(
                controller: emailCtrl,
                label: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                                        validator: _validateEmail,
              ),
                                      
                                      const SizedBox(height: 20),

                                      // Phone field
                                      _buildGlassmorphicField(
                controller: phoneCtrl,
                label: "Nomor HP",
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Nomor HP harus diisi';
                                          }
                                          return null;
                                        },
                                      ),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Password field
                                      _buildGlassmorphicField(
                controller: passCtrl,
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
                                        validator: _validatePassword,
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      // Terms and conditions checkbox
                                      Row(
                                        children: [
                                          Transform.scale(
                                            scale: 0.9,
                                            child: Checkbox(
                                              value: _agreeToTerms,
                                              onChanged: (value) {
                                                setState(() {
                                                  _agreeToTerms = value ?? false;
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
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.8),
                                                  fontSize: 14,
                                                ),
                                                children: [
                                                  const TextSpan(text: "Saya menyetujui "),
                                                  TextSpan(
                                                    text: "Syarat & Ketentuan",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                  const TextSpan(text: " dan "),
                                                  TextSpan(
                                                    text: "Kebijakan Privasi",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 30),
                                      
                                      // Register button with gradient
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
                                          onPressed: isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: isLoading
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
                    "Create Account",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF667eea),
                                                  ),
                  ),
                ),
              ),

                                      const SizedBox(height: 24),

                                      // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                                          Text(
                                            "Sudah punya akun? ",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                  GestureDetector(
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              Navigator.pop(context);
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
                      "Login",
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
            ],
          ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const Spacer(flex: 1),
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
    TextInputType keyboardType = TextInputType.text,
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
      keyboardType: keyboardType,
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

// Custom painter for register background
class RegisterBackgroundPainter extends CustomPainter {
  final double animationValue;
  
  RegisterBackgroundPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    
    // Create floating organic shapes
    final shapes = [
      {'x': size.width * 0.1, 'y': size.height * 0.2, 'radius': 80, 'opacity': 0.1},
      {'x': size.width * 0.8, 'y': size.height * 0.1, 'radius': 60, 'opacity': 0.15},
      {'x': size.width * 0.2, 'y': size.height * 0.7, 'radius': 100, 'opacity': 0.08},
      {'x': size.width * 0.9, 'y': size.height * 0.8, 'radius': 70, 'opacity': 0.12},
      {'x': size.width * 0.5, 'y': size.height * 0.3, 'radius': 50, 'opacity': 0.1},
      {'x': size.width * 0.3, 'y': size.height * 0.5, 'radius': 40, 'opacity': 0.08},
    ];
    
    for (final shape in shapes) {
      final animatedY = (shape['y']! as double) + (20 * animationValue);
      paint.color = Colors.white.withOpacity(shape['opacity']! as double);
      
      canvas.drawCircle(
        Offset(shape['x']! as double, animatedY),
        shape['radius']! as double,
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
