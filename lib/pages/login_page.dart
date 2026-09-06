import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState(){
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen((data){
      final session = data.session;
      final event = data.event;

      debugPrint('Auth event: $event');
      debugPrint('Session: ${session != null}');

      if (session != null && mounted){
        Navigator.pop(context);
      }
    });
  }

  bool _isLoading=false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.softGreen,
              child: const Text(
                '🌳',
                style: TextStyle(fontSize: 50),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Welcome to RecycleGo!',
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Sign in to save your recycling progress',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () async{
                  setState((){
                    _isLoading=true;
                  });

                  try{
                    await Supabase.instance.client.auth.signInWithOAuth(
                      OAuthProvider.google,
                      redirectTo: 'com.example.recyclego://login-callback/',
                  );
                } catch (error){
                  if (mounted){
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: $error'),),
                    );
                  }
                }finally{
                  if(mounted){
                    setState((){
                      _isLoading=false;
                    });
                  }
                }
              },
                icon: const Icon(Icons.login),
                label: Text(
                  _isLoading ? 'Signing in...' : 'Continue with Google',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}