import 'package:flutter/material.dart';
import 'package:toplansin_cleanarch/data/datasources/remote/auth_remote_datasource.dart';
import 'package:toplansin_cleanarch/injection_container/injection_container.dart';

class AuthTestPage extends StatefulWidget {
  const AuthTestPage({super.key});

  @override
  State<AuthTestPage> createState() => _AuthTestPageState();
}

class _AuthTestPageState extends State<AuthTestPage> {
  final _emailController = TextEditingController(text: 'test@test.com');
  final _passwordController = TextEditingController(text: 'Test123!');
  String _result = 'Henüz test yapılmadı';
  bool _loading = false;

  Future<void> _testLogin() async {
    await _performAuth(isSignUp: false);
  }

  Future<void> _testSignUp() async {
    await _performAuth(isSignUp: true);
  }

  Future<void> _performAuth({required bool isSignUp}) async {
    setState(() => _loading = true);
    try {
      final authDataSource = sl<AuthRemoteDataSource>();
      final user = isSignUp
          ? await authDataSource.signUp(_emailController.text, _passwordController.text)
          : await authDataSource.signIn(_emailController.text, _passwordController.text);
      
      setState(() {
        _result = user != null
            ? '✅ ${isSignUp ? "Kayıt" : "Giriş"} Başarılı!\nEmail: ${user.email}\nUID: ${user.id}'
            : '❌ User null döndü';
      });
    } catch (e) {
      setState(() => _result = '❌ Hata: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _testLogin,
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _testSignUp,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading) Text(_result, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}