class AppointmentModel {
  final String id;
  final String uid;
  final String date;
  final String startAt;
  final int duration;
  final String status;
  final DateTime? createdAt;
  final DateTime? cancelledAt;

  AppointmentModel({
    required this.id,
    required this.uid,
    required this.date,
    required this.startAt,
    required this.duration,
    required this.status,
    this.createdAt,
    this.cancelledAt,
  });

  // Converte JSON para AppointmentModel
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      uid: json['uid'] as String,
      date: json['date'] as String,
      startAt: json['startAt'] as String,
      duration: json['duration'] as int,
      status: json['status'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['createdAt']['_seconds'] * 1000,
            )
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['cancelledAt']['_seconds'] * 1000,
            )
          : null,
    );
  }

  // Converte AppointmentModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'date': date,
      'startAt': startAt,
      'duration': duration,
      'status': status,
      if (createdAt != null)
        'createdAt': {
          '_seconds': createdAt!.millisecondsSinceEpoch ~/ 1000,
          '_nanoseconds': 0,
        },
      if (cancelledAt != null)
        'cancelledAt': {
          '_seconds': cancelledAt!.millisecondsSinceEpoch ~/ 1000,
          '_nanoseconds': 0,
        },
    };
  }

  // Método helper para formatar a data e horário
  String getFormattedDateTime() {
    final dateTime = DateTime.parse(date);

    const weekDays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo'
    ];

    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];

    final weekDay = weekDays[dateTime.weekday - 1];
    final day = dateTime.day;
    final month = months[dateTime.month - 1];

    final startHour = int.parse(startAt.split(':')[0]);
    final endHour = startHour + (duration ~/ 60);
    final endTime = '${endHour.toString().padLeft(2, '0')}:00';

    return '$weekDay, $day de $month $startAt - $endTime';
  }

  // Método helper para obter a data do DateTime
  DateTime getDateTime() {
    return DateTime.parse(date);
  }

  // Método helper para obter o horário de término
  String getEndTime() {
    final startHour = int.parse(startAt.split(':')[0]);
    final startMinute = int.parse(startAt.split(':')[1]);
    final endHour = startHour + (duration ~/ 60);
    final endMinute = startMinute + (duration % 60);
    return '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
  }

  // Verifica se o agendamento está ativo
  bool get isActive => status == 'booked';

  // Verifica se o agendamento foi cancelado
  bool get isCancelled => status == 'cancelled';

  // CopyWith para facilitar atualizações
  AppointmentModel copyWith({
    String? id,
    String? uid,
    String? date,
    String? startAt,
    int? duration,
    String? status,
    DateTime? createdAt,
    DateTime? cancelledAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      date: date ?? this.date,
      startAt: startAt ?? this.startAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  @override
  String toString() {
    return 'AppointmentModel(id: $id, uid: $uid, date: $date, startAt: $startAt, duration: $duration, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppointmentModel &&
        other.id == id &&
        other.uid == uid &&
        other.date == date &&
        other.startAt == startAt &&
        other.duration == duration &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        date.hashCode ^
        startAt.hashCode ^
        duration.hashCode ^
        status.hashCode;
  }
}
