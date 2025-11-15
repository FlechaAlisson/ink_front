class BookingModel {
  String? startAt;
  String? date;

  Map<String, dynamic> toJson() {
    return {
      'startAt': startAt,
      'date': date,
    };
  }
}
