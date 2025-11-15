import 'package:ink_front/core/dio_client.dart';
import 'package:ink_front/core/token_provider.dart';
import 'package:ink_front/features/appointments/model/appointment_model.dart';
import 'package:ink_front/features/appointments/model/time_slot_model.dart';

class AppointmentRepository {
  final DioClient _client;

  AppointmentRepository(TokenProvider tokenProvider)
      : _client = DioClient(tokenProvider: tokenProvider);

  Future<List<AppointmentModel>> getAppointments() async {
    final response = await _client.get('/api/bookings');

    if (response.data == null) {
      throw Exception('getAppointments failed: No data returned');
    }

    if (response.data is! Map<String, dynamic>) {
      throw Exception('getAppointments failed: Invalid response format');
    }

    final data = response.data;

    if (data['bookings'] == null || data['bookings'] is! List) {
      return [];
    }

    final List bookings = data['bookings'];

    return bookings.map((json) => AppointmentModel.fromJson(json)).toList();
  }

  Future<List<TimeSlot>> getTimeSlots(String date) async {
    try {
      final response = await _client.get(
        '/api/slots',
        queryParameters: {
          'date': date,
        },
      );

      if (response.data == null) {
        throw Exception('getTimeSlots failed: No data returned');
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception('getTimeSlots failed: Invalid response format');
      }

      // Valida se tem os campos necessários
      if (!response.data.containsKey('date') ||
          !response.data.containsKey('slots')) {
        throw Exception('getTimeSlots failed: Missing required fields');
      }

      // Valida se slots é uma lista
      if (response.data['slots'] is! List) {
        throw Exception('getTimeSlots failed: slots is not a list');
      }

      // Parse da lista de slots
      final List<dynamic> slotsJson = response.data['slots'];
      return slotsJson
          .map(
              (slotJson) => TimeSlot.fromJson(slotJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Tratamento de erros específicos
      if (e.toString().contains('400')) {
        throw Exception('Parâmetro date é obrigatório (formato: YYYY-MM-DD)');
      } else if (e.toString().contains('500')) {
        throw Exception('Erro interno no servidor');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> bookAppointment({
    required String date,
    required String startAt,
  }) async {
    try {
      final response = await _client.post(
        '/api/book',
        data: {
          'date': date,
          'startAt': startAt,
        },
      );

      if (response.data == null) {
        throw Exception('bookAppointment failed: No data returned');
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception('bookAppointment failed: Invalid response format');
      }

      return response.data;
    } catch (e) {
      // Tratamento de erros específicos
      if (e.toString().contains('409')) {
        throw Exception('Horário já reservado');
      } else if (e.toString().contains('400')) {
        throw Exception('Dados inválidos ou horário no passado');
      } else if (e.toString().contains('500')) {
        throw Exception('Erro interno no servidor');
      }
      rethrow;
    }
  }
}
