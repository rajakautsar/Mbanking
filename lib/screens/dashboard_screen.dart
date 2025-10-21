import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardController;
  late AnimationController _contentController;
  late AnimationController _floatingController;
  
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _contentAnimation;
  late Animation<double> _floatingAnimation;
  
  int _selectedQuickAction = -1;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // Initialize animations
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutBack,
    ));
    
    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));
    
    _contentAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _cardController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _contentController.forward();
    });
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardController.dispose();
    _contentController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final username = (args != null && args['username'] is String && (args['username'] as String).isNotEmpty)
        ? args['username'] as String
        : 'User';
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
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            AnimatedBuilder(
              animation: _floatingAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: DashboardBackgroundPainter(_floatingAnimation.value),
                  size: size,
                );
              },
            ),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header section with glassmorphism
                    AnimatedBuilder(
                      animation: _headerAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                          child: Opacity(
                            opacity: _headerAnimation.value,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(24),
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
                              child: Row(
                                children: [
                                  // Profile section
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                    child: const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.person,
                                        color: Color(0xFF667eea),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Greeting text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Selamat Datang",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          username,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Notification icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Balance card with glassmorphism
                    AnimatedBuilder(
                      animation: _cardAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _cardAnimation.value,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(24),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Balance",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "\$76.87",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.account_balance_wallet_outlined,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "**** **** **** 7218",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Silver",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Quick actions section
                    AnimatedBuilder(
                      animation: _contentAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - _contentAnimation.value)),
                          child: Opacity(
                            opacity: _contentAnimation.value,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(24),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Quick Actions",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildQuickAction(
                                        icon: Icons.send,
                                        label: "Transfer",
                                        color: Colors.blue,
                                        index: 0,
                                      ),
                                      _buildQuickAction(
                                        icon: Icons.add_circle_outline,
                                        label: "Top Up",
                                        color: Colors.green,
                                        index: 1,
                                      ),
                                      _buildQuickAction(
                                        icon: Icons.receipt_long,
                                        label: "History",
                                        color: Colors.orange,
                                        index: 2,
                                      ),
                                      _buildQuickAction(
                                        icon: Icons.settings,
                                        label: "Settings",
                                        color: Colors.purple,
                                        index: 3,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Recent transactions
                    AnimatedBuilder(
                      animation: _contentAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - _contentAnimation.value)),
                          child: Opacity(
                            opacity: _contentAnimation.value,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(24),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Recent Transactions",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                        },
                                        child: Text(
                                          "View All",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTransactionItem(
                                    title: "Coffee Shop",
                                    subtitle: "Today, 08:05 AM",
                                    amount: "-\$12.00",
                                    icon: Icons.coffee,
                                    color: Colors.brown,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTransactionItem(
                                    title: "Grocery Store",
                                    subtitle: "Yesterday, 15:30 PM",
                                    amount: "-\$45.50",
                                    icon: Icons.shopping_cart,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTransactionItem(
                                    title: "Salary",
                                    subtitle: "Dec 1, 09:00 AM",
                                    amount: "+\$2,500.00",
                                    icon: Icons.account_balance,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required int index,
  }) {
    final isSelected = _selectedQuickAction == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedQuickAction = index;
        });
        HapticFeedback.lightImpact();
        
        // Reset selection after animation
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _selectedQuickAction = -1;
          });
        });

        // Navigate based on index
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/transfer');
            break;
          case 1:
            Navigator.pushNamed(context, '/topup');
            break;
          case 2:
            Navigator.pushNamed(context, '/history');
            break;
          case 3:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? Colors.white.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    final isPositive = amount.startsWith('+');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dashboard background
class DashboardBackgroundPainter extends CustomPainter {
  final double animationValue;
  
  DashboardBackgroundPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    
    // Create floating geometric shapes
    final shapes = [
      {'x': size.width * 0.1, 'y': size.height * 0.15, 'radius': 60, 'opacity': 0.08},
      {'x': size.width * 0.85, 'y': size.height * 0.2, 'radius': 40, 'opacity': 0.12},
      {'x': size.width * 0.2, 'y': size.height * 0.6, 'radius': 80, 'opacity': 0.06},
      {'x': size.width * 0.9, 'y': size.height * 0.7, 'radius': 50, 'opacity': 0.10},
      {'x': size.width * 0.6, 'y': size.height * 0.3, 'radius': 30, 'opacity': 0.08},
    ];
    
    for (final shape in shapes) {
      final animatedY = (shape['y']! as double) + (15 * animationValue);
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
          Colors.white.withOpacity(0.05 * animationValue),
          Colors.transparent,
          Colors.white.withOpacity(0.03 * animationValue),
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
