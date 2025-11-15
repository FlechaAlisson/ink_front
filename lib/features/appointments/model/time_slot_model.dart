import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final String startAt;
  final bool available;

  TimeSlot({
    required this.startAt,
    required this.available,
  });

  // Construtor para criar a partir de JSON
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startAt: json['startAt'] as String,
      available: json['available'] as bool,
    );
  }

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'startAt': startAt,
      'available': available,
    };
  }

  // CopyWith para facilitar alterações
  TimeSlot copyWith({
    String? startAt,
    bool? available,
  }) {
    return TimeSlot(
      startAt: startAt ?? this.startAt,
      available: available ?? this.available,
    );
  }

  @override
  String toString() {
    return startAt;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.startAt == startAt &&
        other.available == available;
  }

  @override
  List<Object?> get props => [
        startAt,
      ];

  @override
  int get hashCode => startAt.hashCode ^ available.hashCode;
}
