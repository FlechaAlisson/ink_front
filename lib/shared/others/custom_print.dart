import 'dart:developer' as dev;

enum LogLevel { info, warning, error }

class CustomPrint {
  static void call(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    LogLevel level = LogLevel.info,
  }) {
    final trace = stackTrace ?? StackTrace.current;
    final caller = _getCaller(trace);

    String prefix = level == LogLevel.info
        ? 'ℹ️ '
        : level == LogLevel.warning
            ? '⚠️ '
            : '❌ ';

    dev.log(
      '$prefix$message',
      time: DateTime.now(),
      name: caller,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String _getCaller(StackTrace stackTrace) {
    final frames = stackTrace.toString().split('\n');

    if (frames.length > 1) {
      final frame = frames[1].trim();

      // Remove #número e (file:line:column)
      final match = RegExp(r'#\d+\s+(.+?)\s+\(').firstMatch(frame);
      if (match != null) {
        final fullPath = match.group(1) ?? 'Unknown';

        // Simplifica: remove prefixos de pacote
        final parts = fullPath.split('.');
        if (parts.length >= 2) {
          // Retorna ClassName.methodName
          return '${parts[parts.length - 2]}.${parts[parts.length - 1]}';
        }
        return fullPath;
      }
    }

    return 'Unknown';
  }
}
