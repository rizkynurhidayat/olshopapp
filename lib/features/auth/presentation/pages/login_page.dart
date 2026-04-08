import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olshopapp/core/themes/theme.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:olshopapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:olshopapp/features/auth/presentation/pages/register_page.dart';
import 'package:olshopapp/main_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 28),
        onPressed: () {
          // TODO: Implementasi logika Social Login
        },
      ),
    );
  }

    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
       child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Placeholder untuk Ilustrasi
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 32.0, top: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    // child: Text(
                    //   'Gambar Ilustrasi Login',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: Colors.grey),
                    // ),
                    child: Image.network("https://img.freepik.com/free-vector/user-verification-unauthorized-access-prevention-private-account-authentication-cyber-security-people-entering-login-password-safety-measures_335657-3530.jpg",),
                  ),
                ),
              ),

              // 2. Judul Login
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D2E), // Menyesuaikan warna gelap dari desain
                ),
              ),
              const SizedBox(height: 32),

              // 3. Input Email
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.alternate_email, color: Colors.grey),
                  hintText: 'Email ID',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryPink),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Input Password
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: TextButton(
                    onPressed: () {
                      // TODO: Implementasi logika Forgot Password
                    },
                    child: const Text(
                      'Forgot?',
                      style: TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.w600),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryPink),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 5. Tombol Login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) return Center(child: const CircularProgressIndicator(color: AppColors.primaryPink,));
                    return ElevatedButton(
                      onPressed: () {
                        // context.read<AuthBloc>().add(LoginRequested(emailController.text, passwordController.text));
                        context.read<AuthBloc>().add(LoginRequested("user@example.com", "password"));
                      },style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink, // Warna biru dari desain
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // 6. Separator
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Or, login with...',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),

              // 7. Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(Icons.g_mobiledata, Colors.red), // Ganti dengan aset logo Google asli
                  _buildSocialButton(Icons.facebook, Colors.blue),    // Ganti dengan aset logo FB asli
                  _buildSocialButton(Icons.apple, Colors.black),      // Ganti dengan aset logo Apple asli
                ],
              ),
              const SizedBox(height: 48),

              // 8. Teks Registrasi
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
                  child: RichText(
                    text: const TextSpan(
                      text: 'New to iThickLogistics? ',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            color: AppColors.primaryPink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

/*
 child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              const SizedBox(height: 20),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) return const CircularProgressIndicator();
                  return ElevatedButton(
                    onPressed: () {
                      // context.read<AuthBloc>().add(LoginRequested(emailController.text, passwordController.text));
                      context.read<AuthBloc>().add(LoginRequested("user@example.com", "password"));
                    },style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6DF9), // Warna biru dari desain
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  );
                },
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage())),
                child: const Text('Register here'),
              ),
              // const Text('Mock Login: user@example.com / password', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
*/
