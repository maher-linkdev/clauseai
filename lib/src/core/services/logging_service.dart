import 'dart:developer' as developer;

import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Log levels enum for categorizing log messages
enum LogLevel {
  debug(0, 'DEBUG'),
  info(1, 'INFO'),
  warning(2, 'WARNING'),
  error(3, 'ERROR'),
  critical(4, 'CRITICAL');

  const LogLevel(this.value, this.name);

  final int value;
  final String name;
}

final loggingServiceProvider = Provider<LoggingService>((ref) => LoggingService());

/// Centralized logging service with different log levels
/// Provides structured logging with proper formatting and filtering
/// Uses only built-in Dart functionality without external packages
class LoggingService {
  static final LoggingService _instance = LoggingService._internal();

  factory LoggingService() => _instance;

  LoggingService._internal();

  /// Current minimum log level (configurable)
  LogLevel _minLogLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  /// Initialize the logging service
  /// Should be called once at app startup
  void initialize({LogLevel? minLogLevel}) {
    if (minLogLevel != null) {
      _minLogLevel = minLogLevel;
    }
    info('Logging service initialized with minimum level: ${_minLogLevel.name}');
  }

  /// Set the minimum log level
  void setMinLogLevel(LogLevel level) {
    _minLogLevel = level;
    info('Log level changed to: ${level.name}');
  }

  /// Internal method to log messages
  void _log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    // Skip if below minimum log level
    if (level.value < _minLogLevel.value) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelName = level.name.padRight(8);

    // Format: [TIMESTAMP] [LEVEL] [APP] MESSAGE
    final formattedMessage = '[$timestamp] [$levelName] [${AppConstants.appName}] $message';

    // Include error and stack trace if present
    String fullMessage = formattedMessage;
    if (error != null) {
      fullMessage += '\n  Error: $error';
    }
    if (stackTrace != null) {
      fullMessage += '\n  Stack trace:\n${_formatStackTrace(stackTrace)}';
    }

    // Output to console in debug mode, use developer.log in release
    if (kDebugMode) {
      print(fullMessage);
    } else {
      developer.log(
        message,
        time: DateTime.now(),
        level: level.value * 100,
        // Convert to developer.log level scale
        name: AppConstants.appName,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Format stack trace for better readability
  String _formatStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    final relevantLines = lines
        .where((line) => line.contains('package:deal_insights_assistant'))
        .take(5) // Limit to 5 most relevant lines
        .map((line) => '    $line')
        .join('\n');

    return relevantLines.isNotEmpty ? relevantLines : '    ${lines.first}';
  }

  /// Log debug messages (only in debug mode)
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  /// Log informational messages
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  /// Log warning messages
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  /// Log error messages
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  /// Log critical/fatal errors
  void critical(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.critical, message, error, stackTrace);
  }

  /// Log method entry (debug level)
  void methodEntry(String className, String methodName, [Map<String, dynamic>? parameters]) {
    if (_minLogLevel.value <= LogLevel.debug.value) {
      String message = '$className.$methodName() - Entry';
      if (parameters != null && parameters.isNotEmpty) {
        final paramStr = parameters.entries.map((e) => '${e.key}: ${_truncateValue(e.value)}').join(', ');
        message += ' with parameters: {$paramStr}';
      }
      debug(message);
    }
  }

  /// Log method exit (debug level)
  void methodExit(String className, String methodName, [dynamic result]) {
    if (_minLogLevel.value <= LogLevel.debug.value) {
      String message = '$className.$methodName() - Exit';
      if (result != null) {
        message += ' with result: ${_truncateValue(result)}';
      }
      debug(message);
    }
  }

  /// Log performance metrics
  void performance(String operation, Duration duration, [Map<String, dynamic>? metrics]) {
    String message = 'Performance: $operation took ${duration.inMilliseconds}ms';
    if (metrics != null && metrics.isNotEmpty) {
      final metricsStr = metrics.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      message += ' - Metrics: {$metricsStr}';
    }
    info(message);
  }

  /// Log API calls
  void apiCall(String method, String endpoint, [Map<String, dynamic>? data]) {
    String message = 'API Call: $method $endpoint';
    if (data != null && data.isNotEmpty) {
      message += ' with data: ${_truncateValue(data)}';
    }
    info(message);
  }

  /// Log API responses
  void apiResponse(String endpoint, int statusCode, [String? responseBody]) {
    String message = 'API Response: $endpoint - Status: $statusCode';
    if (responseBody != null && responseBody.isNotEmpty) {
      // Truncate long responses for readability
      final truncatedBody = responseBody.length > 500
          ? '${responseBody.substring(0, 500)}...[truncated]'
          : responseBody;
      message += ' - Body: $truncatedBody';
    }
    info(message);
  }

  /// Log file operations
  void fileOperation(String operation, String fileName, [String? details]) {
    String message = 'File Operation: $operation - $fileName';
    if (details != null) {
      message += ' - $details';
    }
    info(message);
  }

  /// Log validation errors
  void validationError(String field, String value, String reason) {
    error('Validation Error: Field "$field" with value "${_truncateValue(value)}" failed validation - $reason');
  }

  /// Log business logic errors
  void businessError(String operation, String reason, [Object? error, StackTrace? stackTrace]) {
    this.error('Business Error: $operation failed - $reason', error, stackTrace);
  }

  /// Log security events
  void security(String event, [Map<String, dynamic>? context]) {
    String message = 'Security Event: $event';
    if (context != null && context.isNotEmpty) {
      final contextStr = context.entries.map((e) => '${e.key}: ${_truncateValue(e.value)}').join(', ');
      message += ' - Context: {$contextStr}';
    }
    warning(message);
  }

  /// Truncate values for logging to prevent extremely long log messages
  String _truncateValue(dynamic value) {
    final str = value.toString();
    return str.length > 200 ? '${str.substring(0, 200)}...[truncated]' : str;
  }

  /// Get current log level
  LogLevel get currentLogLevel => _minLogLevel;

  /// Check if a log level is enabled
  bool isLevelEnabled(LogLevel level) => level.value >= _minLogLevel.value;
}

/// Global logging service instance
final loggingService = LoggingService();

/// Extension to add logging capabilities to any class
extension LoggingExtension on Object {
  /// Get a logger instance for this object's class
  void logDebug(String message, [Object? error, StackTrace? stackTrace]) {
    loggingService.debug('[$runtimeType] $message', error, stackTrace);
  }

  void logInfo(String message, [Object? error, StackTrace? stackTrace]) {
    loggingService.info('[$runtimeType] $message', error, stackTrace);
  }

  void logWarning(String message, [Object? error, StackTrace? stackTrace]) {
    loggingService.warning('[$runtimeType] $message', error, stackTrace);
  }

  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    loggingService.error('[$runtimeType] $message', error, stackTrace);
  }

  void logCritical(String message, [Object? error, StackTrace? stackTrace]) {
    loggingService.critical('[$runtimeType] $message', error, stackTrace);
  }
}
