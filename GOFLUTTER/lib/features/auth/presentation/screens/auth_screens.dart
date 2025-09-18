import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Import the AuthProvider from the correct location
import '../../../../shared/widgets/web_scaffold.dart'; // Use WebScaffold instead of AppScaffold
import '../../../../shared/themes/web_parity_theme.dart'; // Import web parity theme
import '../../../../shared/themes/web_colors.dart'; // Import web colors
import '../../../../shared/themes/web_typography.dart'; // Import web typography
import '../../../../shared/themes/web_gradients.dart'; // Import web gradients
import '../../../../shared/themes/web_shadows.dart'; // Import web shadows

/// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        await authProvider.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (mounted) {
          // Navigate to dashboard
          context.go('/dashboard');
        }
      } catch (e) {
        // Handle error - could show a snackbar or dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Login',
      showBackButton: false,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(WebParityTheme.containerPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo or app name
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: WebColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ATLAS Wallet',
                    textAlign: TextAlign.center,
                    style: WebTypography.h2,
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                        borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                        borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                        borderSide: const BorderSide(color: WebColors.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: WebColors.surface,
                      contentPadding: const EdgeInsets.all(WebParityTheme.spacingMd),
                      prefixIcon: const Icon(Icons.email, color: WebColors.textSecondary),
                      labelStyle: WebTypography.formLabel,
                    ),
                    style: WebTypography.formInput,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                        borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                        borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                        borderSide: const BorderSide(color: WebColors.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: WebColors.surface,
                      contentPadding: const EdgeInsets.all(WebParityTheme.spacingMd),
                      prefixIcon: const Icon(Icons.lock, color: WebColors.textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: WebColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      labelStyle: WebTypography.formLabel,
                    ),
                    style: WebTypography.formInput,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  Container(
                    decoration: BoxDecoration(
                      gradient: WebGradients.buttonPrimary,
                      borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
                      boxShadow: WebShadows.button,
                    ),
                    child: ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: WebParityTheme.spacingMd),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
                        ),
                      ),
                      child: Text(
                        'LOGIN',
                        style: WebTypography.button.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Register link
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: WebTypography.body2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Registration Screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        await authProvider.register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
        if (mounted) {
          // Navigate to dashboard
          context.go('/dashboard');
        }
      } catch (e) {
        // Handle error - could show a snackbar or dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Register',
      showBackButton: false,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(WebParityTheme.containerPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo or app name
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: WebColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: WebTypography.h2,
                    ),
                    const SizedBox(height: 32),

                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: WebColors.surface,
                        contentPadding: const EdgeInsets.all(WebParityTheme.spacingMd),
                        prefixIcon: const Icon(Icons.person, color: WebColors.textSecondary),
                        labelStyle: WebTypography.formLabel,
                      ),
                      style: WebTypography.formInput,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: WebColors.surface,
                        contentPadding: const EdgeInsets.all(WebParityTheme.spacingMd),
                        prefixIcon: const Icon(Icons.email, color: WebColors.textSecondary),
                        labelStyle: WebTypography.formLabel,
                      ),
                      style: WebTypography.formInput,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: WebColors.surface,
                        contentPadding: const EdgeInsets.all(WebParityTheme.spacingMd),
                        prefixIcon: const Icon(Icons.lock, color: WebColors.textSecondary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: WebColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        labelStyle: WebTypography.formLabel,
                      ),
                      style: WebTypography.formInput,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.formBorder, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(WebParityTheme.radiusSm),
                          borderSide: const BorderSide(color: WebColors.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: WebColors.surface,
                        contentPadding: const EdgeInsets.all(WebParityTheme.spacingMd),
                        prefixIcon: const Icon(Icons.lock, color: WebColors.textSecondary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: WebColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        labelStyle: WebTypography.formLabel,
                      ),
                      style: WebTypography.formInput,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    Container(
                      decoration: BoxDecoration(
                        gradient: WebGradients.buttonPrimary,
                        borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
                        boxShadow: WebShadows.button,
                      ),
                      child: ElevatedButton(
                        onPressed: () => _register(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: WebParityTheme.spacingMd),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(WebParityTheme.radiusMd),
                          ),
                        ),
                        child: Text(
                          'REGISTER',
                          style: WebTypography.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Login link
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: WebTypography.body2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}