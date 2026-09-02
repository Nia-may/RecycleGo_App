import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '/theme/app_theme.dart';
import '/services/storage_service.dart';

class ProfilePage extends StatefulWidget{
  final int weeklyGoal;
  final Function(bool) onDarkModeChanged;
  const ProfilePage({super.key, required this.weeklyGoal, required this.onDarkModeChanged});

  @override
  State<ProfilePage> createState()=> _profilePageState();
}

// ignore: camel_case_types
class _profilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.softGreen,
              child: const Text(
                '👤',
                style: TextStyle(fontSize: 45),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              'Nin',
              style: GoogleFonts.fredoka(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '📊 Your Recycling',
                style: GoogleFonts.fredoka(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 12),


            Row(
              children: [
                Expanded(child: _profileStat(
                  '⭐',
                  '0',
                  'Points',
                ),),

                const SizedBox(width: 10),

                Expanded(child: _profileStat(
                  '♻️',
                  '0',
                  'Items',
                ),),

                const SizedBox(width: 10),

                Expanded(child: _profileStat(
                  '🔥',
                  '0',
                  'Streak',
                ),),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    '🎯 Your Goal',
                    style: GoogleFonts.fredoka(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${widget.weeklyGoal} items per week',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        final controller =TextEditingController(
                          text: widget.weeklyGoal.toString(),
                        );

                        final result =await showDialog<int>(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: const Text('Change Weekly Goal'),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Items per week',
                                  hintText: 'e.g. 10',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),

                                ElevatedButton(
                                  onPressed: (){
                                    final goal =int.tryParse(controller.text);

                                    if(goal==null||goal<=0){
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Please enter a valid goal.'),
                                      ),);
                                      return;
                                    }

                                    Navigator.pop(context, goal);
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );

                       

                        if (result !=null && mounted){
                          await StorageService.saveWeeklyGoal(result);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, result);
                        }
                      },
                      child: const Text('Change Goal'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Dark Mode',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: widget.onDarkModeChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileStat(
    String icon,
    String value, 
    String label, 
  ){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        children: [
          Text(
            icon, 
            style: const TextStyle(fontSize: 24),
          ),

          const SizedBox(height: 5),

          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          Text(
            label, 
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}