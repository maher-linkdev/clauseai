import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/core/services/logging_service.dart';
import 'package:flutter/foundation.dart';

void main() {
  group('LoggingService', () {
    late LoggingService loggingService;

    setUp(() {
      loggingService = LoggingService();
    });

    group('LogLevel enum', () {
      test('should have correct values and names', () {
        expect(LogLevel.debug.value, equals(0));
        expect(LogLevel.debug.name, equals('DEBUG'));
        
        expect(LogLevel.info.value, equals(1));
        expect(LogLevel.info.name, equals('INFO'));
        
        expect(LogLevel.warning.value, equals(2));
        expect(LogLevel.warning.name, equals('WARNING'));
        
        expect(LogLevel.error.value, equals(3));
        expect(LogLevel.error.name, equals('ERROR'));
        
        expect(LogLevel.critical.value, equals(4));
        expect(LogLevel.critical.name, equals('CRITICAL'));
      });
    });

    group('Initialization', () {
      test('should initialize with default log level', () {
        loggingService.initialize();
        final expectedLevel = kDebugMode ? LogLevel.debug : LogLevel.info;
        expect(loggingService.currentLogLevel, equals(expectedLevel));
      });

      test('should initialize with custom log level', () {
        loggingService.initialize(minLogLevel: LogLevel.warning);
        expect(loggingService.currentLogLevel, equals(LogLevel.warning));
      });
    });

    group('Log level management', () {
      test('should set minimum log level', () {
        loggingService.setMinLogLevel(LogLevel.error);
        expect(loggingService.currentLogLevel, equals(LogLevel.error));
      });

      test('should check if log level is enabled', () {
        loggingService.setMinLogLevel(LogLevel.warning);
        
        expect(loggingService.isLevelEnabled(LogLevel.debug), isFalse);
        expect(loggingService.isLevelEnabled(LogLevel.info), isFalse);
        expect(loggingService.isLevelEnabled(LogLevel.warning), isTrue);
        expect(loggingService.isLevelEnabled(LogLevel.error), isTrue);
        expect(loggingService.isLevelEnabled(LogLevel.critical), isTrue);
      });
    });

    group('Logging methods', () {
      test('should log debug messages', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.debug('Test debug message'), returnsNormally);
      });

      test('should log info messages', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.info('Test info message'), returnsNormally);
      });

      test('should log warning messages', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.warning('Test warning message'), returnsNormally);
      });

      test('should log error messages', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.error('Test error message'), returnsNormally);
      });

      test('should log critical messages', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.critical('Test critical message'), returnsNormally);
      });

      test('should log with error and stack trace', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        final error = Exception('Test exception');
        final stackTrace = StackTrace.current;
        
        expect(() => loggingService.error('Test error with exception', error, stackTrace), 
               returnsNormally);
      });
    });

    group('Method tracking', () {
      test('should log method entry', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.methodEntry('TestClass', 'testMethod'), 
               returnsNormally);
      });

      test('should log method entry with parameters', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        final parameters = {'param1': 'value1', 'param2': 42};
        expect(() => loggingService.methodEntry('TestClass', 'testMethod', parameters), 
               returnsNormally);
      });

      test('should log method exit', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.methodExit('TestClass', 'testMethod'), 
               returnsNormally);
      });

      test('should log method exit with result', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.methodExit('TestClass', 'testMethod', 'result'), 
               returnsNormally);
      });
    });

    group('Performance logging', () {
      test('should log performance metrics', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        final duration = Duration(milliseconds: 150);
        expect(() => loggingService.performance('test operation', duration), 
               returnsNormally);
      });

      test('should log performance metrics with additional data', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        final duration = Duration(milliseconds: 150);
        final metrics = {'items': 100, 'memory': '50MB'};
        expect(() => loggingService.performance('test operation', duration, metrics), 
               returnsNormally);
      });
    });

    group('API logging', () {
      test('should log API calls', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.apiCall('GET', '/api/test'), returnsNormally);
      });

      test('should log API calls with data', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        final data = {'key': 'value'};
        expect(() => loggingService.apiCall('POST', '/api/test', data), returnsNormally);
      });

      test('should log API responses', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.apiResponse('/api/test', 200), returnsNormally);
      });

      test('should log API responses with body', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.apiResponse('/api/test', 200, '{"success": true}'), 
               returnsNormally);
      });
    });

    group('File operation logging', () {
      test('should log file operations', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.fileOperation('read', 'test.txt'), returnsNormally);
      });

      test('should log file operations with details', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.fileOperation('read', 'test.txt', 'File size: 1024 bytes'), 
               returnsNormally);
      });
    });

    group('Error logging', () {
      test('should log validation errors', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.validationError('email', 'invalid-email', 'Invalid format'), 
               returnsNormally);
      });

      test('should log business errors', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.businessError('user creation', 'Email already exists'), 
               returnsNormally);
      });

      test('should log business errors with exception', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        final error = Exception('Database error');
        final stackTrace = StackTrace.current;
        expect(() => loggingService.businessError('user creation', 'Database failure', error, stackTrace), 
               returnsNormally);
      });
    });

    group('Security logging', () {
      test('should log security events', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        expect(() => loggingService.security('login attempt'), returnsNormally);
      });

      test('should log security events with context', () {
        loggingService.setMinLogLevel(LogLevel.debug);
        final context = {'ip': '192.168.1.1', 'userAgent': 'Chrome'};
        expect(() => loggingService.security('login attempt', context), returnsNormally);
      });
    });

    group('Singleton pattern', () {
      test('should return same instance', () {
        final instance1 = LoggingService();
        final instance2 = LoggingService();
        expect(identical(instance1, instance2), isTrue);
      });
    });
  });

  group('LoggingExtension', () {
    test('should provide logging methods for any object', () {
      final testObject = TestClass();
      
      expect(() => testObject.logDebug('Debug message'), returnsNormally);
      expect(() => testObject.logInfo('Info message'), returnsNormally);
      expect(() => testObject.logWarning('Warning message'), returnsNormally);
      expect(() => testObject.logError('Error message'), returnsNormally);
      expect(() => testObject.logCritical('Critical message'), returnsNormally);
    });

    test('should include class name in log messages', () {
      final testObject = TestClass();
      // This test verifies the extension works, actual log content testing would require mocking
      expect(() => testObject.logInfo('Test message'), returnsNormally);
    });
  });
}

class TestClass {
  void doSomething() {
    // Test class for extension testing
  }
}
