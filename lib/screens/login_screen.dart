import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:memmerli/screens/memory_list_screen.dart';
import 'package:memmerli/services/auth_service.dart';
import 'package:memmerli/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Using a mock authentication service
      final success = await AuthService.login(
        _emailController.text, 
        _passwordController.text,
      );

      if (success) {
        // Navigate to memory list screen
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MemoryListScreen(),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent2.withOpacity(0.8),
      body: Stack(
        children: [
          // Background color
          Container(
            decoration: BoxDecoration(
              color: AppColors.accent2.withOpacity(0.8),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.accent2.withOpacity(0.9),
                  AppColors.accent2,
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    
                    // Centered logo
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: kIsWeb 
                          ? Image.network(
                              '/assets/images/LoginIcon.png',
                              width: 150,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading web image: $error');
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 100,
                                  color: AppColors.primary1,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/LoginIcon.png',
                              width: 150,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading asset image: $error');
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 100,
                                  color: AppColors.primary1,
                                );
                              },
                            ),
                      ),
                    ),
                    
                    Text(
                      'Sign in',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.primary2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: 60,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary1,
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Login form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email field
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: AppColors.primary2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Password field
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: AppColors.primary2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              // Subtle wave shape under password field
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: CustomPaint(
                                  painter: WavePainter(),
                                  size: const Size(double.infinity, 4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Remember me and Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      activeColor: AppColors.primary1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Remember Me',
                                    style: TextStyle(
                                      color: AppColors.primary2,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // Implement forgot password functionality
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary1,
                                ),
                                child: const Text('Forgot Password?'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Error message
                          if (_errorMessage != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 32),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Sign up option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an Account ? ",
                                style: TextStyle(color: AppColors.primary2),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to sign up screen
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary1,
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the subtle wave shape
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent1
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Start at the left of the text field
    path.moveTo(0, 0);
    
    // Create a subtle wave
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.5, 
      size.width * 0.5, 
      -size.height * 0.5,
      size.width,
      0
    );
    
    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}