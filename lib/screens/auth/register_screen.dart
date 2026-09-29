import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _sekolahController = TextEditingController();
  final _jurusanController = TextEditingController();
  String _selectedRole = 'siswa';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _sekolahController.dispose();
    _jurusanController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    // TODO: Panggil register ke AuthService / AuthProvider
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pendaftaran akun sedang diproses...')),
    );

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun TALENTA'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Buat Akun Baru',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.navy),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih peranmu (Siswa atau Alumni) dan lengkapi data diri.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Pilihan Role
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'siswa', label: Text('Siswa')),
                  ButtonSegment(value: 'alumni', label: Text('Alumni')),
                ],
                selected: {_selectedRole},
                onSelectionChanged: (val) {
                  setState(() => _selectedRole = val.first);
                },
              ),
              const SizedBox(height: 16),
              AppTextField(label: 'Nama Lengkap', controller: _nameController, hint: 'Contoh: Ahmad Fachri'),
              const SizedBox(height: 16),
              AppTextField(label: 'E-mail', controller: _emailController, hint: 'nama@email.com'),
              const SizedBox(height: 16),
              AppTextField(label: 'Kata Sandi', controller: _passwordController, hint: 'Minimal 8 karakter', obscureText: true),
              const SizedBox(height: 16),
              AppTextField(label: 'Sekolah / Asal Sekolah', controller: _sekolahController, hint: 'Contoh: SMKN 1'),
              const SizedBox(height: 16),
              AppTextField(label: 'Jurusan', controller: _jurusanController, hint: 'Contoh: Rekayasa Perangkat Lunak'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Daftar Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
