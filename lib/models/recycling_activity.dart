class RecyclingActivity {
  final String item;
  final int quantity;
  final int points;
  final DateTime dateTime;
  final String? photoPath;

  RecyclingActivity({
    required this.item,
    required this.quantity,
    required this.points,
    required this.dateTime,
    this.photoPath,
  });
}