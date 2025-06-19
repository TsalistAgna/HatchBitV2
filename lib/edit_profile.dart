import 'package:flutter/material.dart';
import 'package:project_mobile/user_auth/firebase_auth/firebase_auth_services.dart';
import 'package:project_mobile/global/toast.dart';
import 'package:project_mobile/verify_new_email_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();
  bool _isLoading = false;
  bool _isGoogleUser = false;

  String _initialUsername = '';
  String _initialEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Ini buat ambil data user dan kasi liat
  void _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Kepake pas update email sih ini, sync data
    await _authService.synchronizeUserData();

    final results = await Future.wait([
      _authService.getUserData(),
      _authService.isGoogleSignIn(),
    ]);

    final userData = results[0] as Map<String, dynamic>?;
    final isGoogle = results[1] as bool;
    if (userData != null && mounted) {
      setState(() {
        _initialUsername = userData['username'] ?? '';
        _initialEmail = userData['email'] ?? '';
        _usernameController.text = userData['username'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _isGoogleUser = isGoogle;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Ini buat save
  void _saveProfile() async {
    setState(() {
      _isLoading = true;
    });
    bool otherChangesMade = false;

    try{
      // Password
      if (!_isGoogleUser &&
          (_passwordController.text.isNotEmpty ||
              _confirmPasswordController.text.isNotEmpty)) {
        if (_passwordController.text != _confirmPasswordController.text) {
          showToasts(message: "Password ga cocok!");
          setState(() {
            _isLoading = false;
          });
          return;
        }
        await _authService.updateUserPassword(_passwordController.text);
        otherChangesMade = true;
      }

      // Username
      if (_usernameController.text != _initialUsername) {
        await _authService.updateUsername(_usernameController.text);
        otherChangesMade = true;
      }

      // Email
      if (!_isGoogleUser && _emailController.text != _initialEmail) {
        await _authService.updateUserEmail(_emailController.text);
        showToasts(message: "Link verifikasi telah dikirim ke email baru Anda.");

        setState(() { _isLoading = false; });
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VerifyNewEmailScreen(
              newEmail: _emailController.text,
            ),
          ));
        }
        return;
      }

      setState(() {
        _isLoading = false;
      });

      if (otherChangesMade) {
        showToasts(message: "Profile berhasil diupdate!");
        Navigator.pop(context);
      } else {
        showToasts(message: "Tidak ada perubahan....");
      }
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showToasts(
            message: "Aksi ini butuh keamanan ekstra. Silakan login kembali dan coba lagi.",);
      } else {
        showToasts(message: "Error: ${e.message}");
      }
    } catch (e) {
      showToasts(message: e.toString());
    } finally {
      if(mounted) {
        setState(() { _isLoading = false; });
      }
    }

  }

  // Biar hemat resoucrce
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: _isLoading
              ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple))
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                      icon: Image.asset(
                        'assets/icons/back.png',
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }
                  ),
                const SizedBox(height: 8),

                const Text(
                  'Edit Profile Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 24),

                // Username
                const Text(
                  'Username',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration(),
                ),

                const SizedBox(height: 16),

                // Warning kalo pake google
                if (_isGoogleUser)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.deepPurple),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.deepPurple, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Anda login dengan google! Password dan email tidak bisa diganti dari app ini...",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Email
                const Text('Email',
                    style: TextStyle(color: Colors.deepPurple)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  readOnly: _isGoogleUser,
                  decoration: _inputDecoration(),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Password
                const Text(
                  'Password',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  readOnly: _isGoogleUser,
                  decoration: _inputDecoration(
                    hint:
                    'New password (optional)',
                  ),
                ),

                const SizedBox(height: 16),

                // Confirm Password
                const Text(
                  'Confirm Password',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller:
                  _confirmPasswordController,
                  readOnly: _isGoogleUser,
                  obscureText: true,
                  decoration: _inputDecoration(
                    hint:
                    'Confirm new password (optional)',
                  ),
                ),

                const SizedBox(height: 28),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
