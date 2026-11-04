class FocusSessionModel {
  final String id;
  final String modeName;
  final int durationMinutes;
  final DateTime completedAt;
  final int flowScore; // 1 - 100
  final String ambientMode;

  FocusSessionModel({
    required this.id,
    required this.modeName,
    required this.durationMinutes,
    required this.completedAt,
    required this.flowScore,
    required this.ambientMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modeName': modeName,
      'durationMinutes': durationMinutes,
      'completedAt': completedAt.toIso8601String(),
      'flowScore': flowScore,
      'ambientMode': ambientMode,
    };
  }

  factory FocusSessionModel.fromJson(Map<String, dynamic> json) {
    return FocusSessionModel(
      id: json['id'] as String,
      modeName: json['modeName'] as String,
      durationMinutes: json['durationMinutes'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      flowScore: json['flowScore'] as int,
      ambientMode: json['ambientMode'] as String,
    );
  }
}

