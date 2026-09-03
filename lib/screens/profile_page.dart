import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '/theme/app_theme.dart';
import '/services/storage_service.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '/models/recycling_activity.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfilePage extends StatefulWidget{
  final int weeklyGoal;
  final Function(bool) onDarkModeChanged;
  const ProfilePage({super.key, required this.weeklyGoal, required this.onDarkModeChanged});

  @override
  State<ProfilePage> createState()=> _profilePageState();
}

// ignore: camel_case_types
class _profilePageState extends State<ProfilePage>{
  int selectedMonth=DateTime.now().month;
  int selectedYear=DateTime.now().year;

  List<double> getWeeklyData(){
    final box =Hive.box<RecyclingActivity>('activities');
    final now=DateTime.now();

    //find monday of the current week
    final monday=now.subtract(Duration(days: now.weekday-1),);

    final weeklyData=List<double>.filled(7, 0);

    for (final activity in box.values){
      final activityDate=activity.dateTime;

      final difference=DateTime(
        activityDate.year,
        activityDate.month,
        activityDate.day,
      ).difference(
        DateTime(monday.year, monday.month, monday.day,),
      ).inDays;

      if (difference>=0 && difference<7){
        weeklyData[difference]+=activity.quantity;
      }
    }
    return weeklyData;
  }

  List<double> getMonthlyData(){
    final box=Hive.box<RecyclingActivity>('activities');

    final daysInMonth=DateTime(selectedYear, selectedMonth+1, 0).day;

    final monthlyData=List<double>.filled(daysInMonth, 0);

    for (final activity in box.values){
      final activityDate=activity.dateTime;

      if (activityDate.year == selectedYear && activityDate.month == selectedMonth){
        final index = activityDate.day - 1;

        monthlyData[index] += activity.quantity;
      }
    }
    return monthlyData;
  }

  void previousMonth(){
    setState((){
      if (selectedMonth==1){
        selectedMonth=12;
        selectedYear--;
      } else{
        selectedMonth--;
      }
    });
  }

  void nextMonth(){
    setState((){
      if (selectedMonth==12){
        selectedMonth=1;
        selectedYear++;
      } else{
        selectedMonth++;
      }
    });
  }

  String getSelectedMonthName(){
    const months=[
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return months[selectedMonth-1];
  }

  double _getMaxY(List<double> data){
    final maxValue=data.isEmpty
      ?0
      :data.reduce((a, b)=> a>b? a:b);

    if(maxValue <= 5){
      return 5;
    }
    return (maxValue + 2).ceilToDouble();
  }

  @override
  Widget build(BuildContext context){
    Widget _weeklyChart(){
      final weeklyData=getWeeklyData();

      return Container(
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
              '📈 Weekly Recycling',
              style: GoogleFonts.fredoka(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,

              child: BarChart(
                BarChartData(
                  maxY: _getMaxY(weeklyData),

                  borderData: FlBorderData(
                    show: false,
                  ),

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                  ),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta){
                          return Text(
                            value.toInt().toString(),
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta){
                          const days=['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt()< 0 || value.toInt()>=days.length){
                            return const SizedBox();
                          }
                          return Text(
                            days[value.toInt()],
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(7, (index){
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weeklyData[index],
                          width: 18,
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.softGreen,
                        ),
                      ],
                    );
                  },),
                 ),
                ),
              ),
          ],
        ),
      );
    }
    
    Widget _monthlyChart(){
      final monthlyData=getMonthlyData();

      return Container(width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📈 Monthly Recycling',
            style: GoogleFonts.fredoka(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: previousMonth,
                icon: const Icon(Icons.chevron_left),
              ),

              Text(
                '${getSelectedMonthName()} $selectedYear',
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface
                ),
              ),

              IconButton(
                onPressed: nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: _getMaxY(monthlyData),

                borderData: FlBorderData(
                  show: false,
                ),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                ),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta){
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 5,
                      getTitlesWidget: (value, meta){
                        final day = value.toInt() + 1;

                        if (day < 1 || day > monthlyData.length){
                          return const SizedBox();
                        }

                         if (day != 1 && day % 5 !=0){
                          return const SizedBox();
                        }
                        return Text(
                          day.toString(),
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                barGroups: List.generate(monthlyData.length, (index){
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: monthlyData[index],
                        width: 10,
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.softGreen,
                      ),
                    ],
                  );
                },),
              ),
            ),
          ),
        ],
      ),
      );
    }
    
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

            //weekly chart 
            ValueListenableBuilder(
              valueListenable: Hive.box<RecyclingActivity>('activities').listenable(),
              builder: (context, box, _){
                return _weeklyChart();
              },
            ),
            const SizedBox(height: 20),
            
            //monthly chart
            ValueListenableBuilder(
              valueListenable: Hive.box<RecyclingActivity>('activities').listenable(),
              builder: (context, box, _){
                return _monthlyChart();
              },
            ),

            //your goal section
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

            const SizedBox(height: 10),

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

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}