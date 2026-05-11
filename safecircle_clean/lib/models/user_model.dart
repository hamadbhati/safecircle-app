class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String? familyId;
  final String? fcmToken;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.familyId,
    this.fcmToken,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'child',
      familyId: map['familyId'],
      fcmToken: map['fcmToken'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'familyId': familyId,
      'fcmToken': fcmToken,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}

class LocationModel {
  final double lat;
  final double lng;
  final DateTime timestamp;
  final String address;

  LocationModel({
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.address = '',
  });

  Map<String, dynamic> toMap() => {
    'lat': lat,
    'lng': lng,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'address': address,
  };

  factory LocationModel.fromMap(Map<String, dynamic> map) => LocationModel(
    lat: (map['lat'] ?? 0).toDouble(),
    lng: (map['lng'] ?? 0).toDouble(),
    timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    address: map['address'] ?? '',
  );
}

class AppUsageModel {
  final String appName;
  final String packageName;
  final int usageMinutes;
  final DateTime date;

  AppUsageModel({
    required this.appName,
    required this.packageName,
    required this.usageMinutes,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'appName': appName,
    'packageName': packageName,
    'usageMinutes': usageMinutes,
    'date': date.millisecondsSinceEpoch,
  };

  factory AppUsageModel.fromMap(Map<String, dynamic> map) => AppUsageModel(
    appName: map['appName'] ?? '',
    packageName: map['packageName'] ?? '',
    usageMinutes: map['usageMinutes'] ?? 0,
    date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
  );
}

class AlertModel {
  final String id;
  final String type;
  final String message;
  final String? screenshotUrl;
  final DateTime timestamp;
  final bool isRead;
  final String childId;
  final String childName;

  AlertModel({
    required this.id,
    required this.type,
    required this.message,
    this.screenshotUrl,
    required this.timestamp,
    this.isRead = false,
    required this.childId,
    required this.childName,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'message': message,
    'screenshotUrl': screenshotUrl,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'isRead': isRead,
    'childId': childId,
    'childName': childName,
  };

  factory AlertModel.fromMap(Map<String, dynamic> map) => AlertModel(
    id: map['id'] ?? '',
    type: map['type'] ?? '',
    message: map['message'] ?? '',
    screenshotUrl: map['screenshotUrl'],
    timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    isRead: map['isRead'] ?? false,
    childId: map['childId'] ?? '',
    childName: map['childName'] ?? '',
  );
}
