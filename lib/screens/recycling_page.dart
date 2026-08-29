import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecylingPage extends StatefulWidget {
  const RecylingPage({super.key});

  @override
  State<RecylingPage> createState() => _RecylingPageState();
}

class _RecylingPageState extends State<RecylingPage> {
  final ImagePicker picker = ImagePicker(); 
  XFile? selectedImage;
  String? selectedItem;

  int calculatePoints(){
    int pointsPerItem = 0;

  if (selectedItem == 'Plastic'){
    pointsPerItem = 5;
  }else if (selectedItem == 'Paper'){
    pointsPerItem = 2;
  }else if (selectedItem == 'Glass'){
    pointsPerItem = 4;
  }else if (selectedItem == 'Metal'){
    pointsPerItem = 8;
  }

  int quantity = int.tryParse(quantityController.text) ?? 0;
  return pointsPerItem * quantity;
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Something'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What are you recycling today?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Select an item',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Recycling Item',
              ),
              items: const [
                DropdownMenuItem(value: 'Plastic', child: Text('Plastic'),),
                DropdownMenuItem(value: 'Paper', child: Text('Paper'),),
                DropdownMenuItem(value: 'Glass', child: Text('Glass'),),
                DropdownMenuItem(value: 'Metal', child: Text('Metal'),),
              ],
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
              },
            ),
             const SizedBox(height: 20),

             const Text(
              'How many?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
             ),

             const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity',
                hintText: 'e.g. 2',),
              controller: quantityController,
            ),

              const SizedBox(height: 30),

              const Text(
                'Photo',
                style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              ),

              const SizedBox(height: 10),

              OutlinedButton.icon(
                onPressed: () => pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo'),
              ),//take photo by camera
              OutlinedButton.icon(
                onPressed: () => pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo),
                label: const Text('Choose from Gallery'),
              ),//take photo from gallery


              if (selectedImage != null) ...[
                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                Image.file(
                  File(selectedImage!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ),
              ],

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedItem == null || quantityController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an item and enter a quantity.')),
                      );
                      return;
                    }
                    int points=calculatePoints();

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('♻️ Recycling Submitted!'),
                          content: Text('You have recycled ${quantityController.text} ${selectedItem!.toLowerCase()} item(s).\n\n'
                          '🎉 You earned $points points!',),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context, {
                                  'points': points,
                                  'items': int.tryParse(quantityController.text) ?? 0,
                                  'item': selectedItem,
                                  'photoPath': selectedImage?.path,
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                    );
                  },
                  child: const Text('Submit Recycling'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}