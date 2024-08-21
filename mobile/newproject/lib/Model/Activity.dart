class Activity {
  final String activity;
  final String type;
  final int participants;
  final double price;
  final String link;
  final String key;
  final double accessibility;

  Activity({
    required this.activity,
    required this.type,
    required this.participants,
    required this.price,
    required this.link,
    required this.key,
    required this.accessibility,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activity: json['activity'] as String,
      type: json['type'] as String,
      participants: json['participants'] as int,
      price: (json['price'] as num).toDouble(),
      link: json['link'] as String,
      key: json['key'] as String,
      accessibility: (json['accessibility'] as num).toDouble(),
    );
  }
}
