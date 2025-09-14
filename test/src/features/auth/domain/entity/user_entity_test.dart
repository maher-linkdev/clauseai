import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';

void main() {
  group('UserEntity', () {
    late UserEntity userEntity;
    late DateTime testCreatedAt;
    late DateTime testLastSignInAt;

    setUp(() {
      testCreatedAt = DateTime(2023, 1, 1, 12, 0, 0);
      testLastSignInAt = DateTime(2023, 1, 2, 14, 30, 0);
      
      userEntity = const UserEntity(
        id: 'test-user-id',
        email: 'test@example.com',
        displayName: 'Test User',
        photoURL: 'https://example.com/photo.jpg',
        isAnonymous: false,
      );
    });

    group('Constructor', () {
      test('should create UserEntity with required fields', () {
        const user = UserEntity(
          id: 'test-id',
          isAnonymous: false,
        );

        expect(user.id, equals('test-id'));
        expect(user.isAnonymous, equals(false));
        expect(user.email, isNull);
        expect(user.displayName, isNull);
        expect(user.photoURL, isNull);
        expect(user.createdAt, isNull);
        expect(user.lastSignInAt, isNull);
      });

      test('should create UserEntity with all fields', () {
        final user = UserEntity(
          id: 'test-id',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          isAnonymous: false,
          createdAt: testCreatedAt,
          lastSignInAt: testLastSignInAt,
        );

        expect(user.id, equals('test-id'));
        expect(user.email, equals('test@example.com'));
        expect(user.displayName, equals('Test User'));
        expect(user.photoURL, equals('https://example.com/photo.jpg'));
        expect(user.isAnonymous, equals(false));
        expect(user.createdAt, equals(testCreatedAt));
        expect(user.lastSignInAt, equals(testLastSignInAt));
      });

      test('should create anonymous user', () {
        const user = UserEntity(
          id: 'anonymous-id',
          isAnonymous: true,
        );

        expect(user.id, equals('anonymous-id'));
        expect(user.isAnonymous, equals(true));
        expect(user.email, isNull);
        expect(user.displayName, isNull);
      });
    });

    group('copyWith', () {
      test('should return same instance when no parameters provided', () {
        final copiedUser = userEntity.copyWith();

        expect(copiedUser.id, equals(userEntity.id));
        expect(copiedUser.email, equals(userEntity.email));
        expect(copiedUser.displayName, equals(userEntity.displayName));
        expect(copiedUser.photoURL, equals(userEntity.photoURL));
        expect(copiedUser.isAnonymous, equals(userEntity.isAnonymous));
        expect(copiedUser.createdAt, equals(userEntity.createdAt));
        expect(copiedUser.lastSignInAt, equals(userEntity.lastSignInAt));
      });

      test('should update only specified fields', () {
        final copiedUser = userEntity.copyWith(
          displayName: 'Updated Name',
          isAnonymous: true,
        );

        expect(copiedUser.id, equals(userEntity.id));
        expect(copiedUser.email, equals(userEntity.email));
        expect(copiedUser.displayName, equals('Updated Name'));
        expect(copiedUser.photoURL, equals(userEntity.photoURL));
        expect(copiedUser.isAnonymous, equals(true));
        expect(copiedUser.createdAt, equals(userEntity.createdAt));
        expect(copiedUser.lastSignInAt, equals(userEntity.lastSignInAt));
      });

      test('should update all fields', () {
        final newCreatedAt = DateTime(2023, 6, 15);
        final newLastSignInAt = DateTime(2023, 6, 16);

        final copiedUser = userEntity.copyWith(
          id: 'new-id',
          email: 'new@example.com',
          displayName: 'New Name',
          photoURL: 'https://example.com/new-photo.jpg',
          isAnonymous: true,
          createdAt: newCreatedAt,
          lastSignInAt: newLastSignInAt,
        );

        expect(copiedUser.id, equals('new-id'));
        expect(copiedUser.email, equals('new@example.com'));
        expect(copiedUser.displayName, equals('New Name'));
        expect(copiedUser.photoURL, equals('https://example.com/new-photo.jpg'));
        expect(copiedUser.isAnonymous, equals(true));
        expect(copiedUser.createdAt, equals(newCreatedAt));
        expect(copiedUser.lastSignInAt, equals(newLastSignInAt));
      });

      test('should preserve existing values when null is passed', () {
        // Note: The copyWith method uses ?? operator, so passing null
        // will preserve the existing value, not set it to null
        final userWithNulls = userEntity.copyWith(
          email: null,
          displayName: null,
          photoURL: null,
        );

        expect(userWithNulls.id, equals(userEntity.id));
        expect(userWithNulls.email, equals(userEntity.email)); // Preserves existing value
        expect(userWithNulls.displayName, equals(userEntity.displayName)); // Preserves existing value
        expect(userWithNulls.photoURL, equals(userEntity.photoURL)); // Preserves existing value
        expect(userWithNulls.isAnonymous, equals(userEntity.isAnonymous));
      });
    });

    group('Equality', () {
      test('should be equal when all fields are the same', () {
        final user1 = UserEntity(
          id: 'test-id',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          isAnonymous: false,
          createdAt: testCreatedAt,
          lastSignInAt: testLastSignInAt,
        );

        final user2 = UserEntity(
          id: 'test-id',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          isAnonymous: false,
          createdAt: testCreatedAt,
          lastSignInAt: testLastSignInAt,
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when id differs', () {
        final user1 = const UserEntity(
          id: 'test-id-1',
          isAnonymous: false,
        );

        final user2 = const UserEntity(
          id: 'test-id-2',
          isAnonymous: false,
        );

        expect(user1, isNot(equals(user2)));
        expect(user1.hashCode, isNot(equals(user2.hashCode)));
      });

      test('should not be equal when email differs', () {
        final user1 = const UserEntity(
          id: 'test-id',
          email: 'test1@example.com',
          isAnonymous: false,
        );

        final user2 = const UserEntity(
          id: 'test-id',
          email: 'test2@example.com',
          isAnonymous: false,
        );

        expect(user1, isNot(equals(user2)));
      });

      test('should not be equal when isAnonymous differs', () {
        final user1 = const UserEntity(
          id: 'test-id',
          isAnonymous: false,
        );

        final user2 = const UserEntity(
          id: 'test-id',
          isAnonymous: true,
        );

        expect(user1, isNot(equals(user2)));
      });

      test('should not be equal when compared to different type', () {
        final user = const UserEntity(
          id: 'test-id',
          isAnonymous: false,
        );

        expect(user, isNot(equals('not a user')));
        expect(user, isNot(equals(42)));
        expect(user, isNot(equals(null)));
      });

      test('should be equal to itself', () {
        expect(userEntity, equals(userEntity));
      });
    });

    group('toString', () {
      test('should return formatted string representation', () {
        final user = UserEntity(
          id: 'test-id',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          isAnonymous: false,
          createdAt: testCreatedAt,
          lastSignInAt: testLastSignInAt,
        );

        final result = user.toString();

        expect(result, contains('UserEntity'));
        expect(result, contains('id: test-id'));
        expect(result, contains('email: test@example.com'));
        expect(result, contains('displayName: Test User'));
        expect(result, contains('photoURL: https://example.com/photo.jpg'));
        expect(result, contains('isAnonymous: false'));
        expect(result, contains('createdAt: $testCreatedAt'));
        expect(result, contains('lastSignInAt: $testLastSignInAt'));
      });

      test('should handle null values in toString', () {
        const user = UserEntity(
          id: 'test-id',
          isAnonymous: false,
        );

        final result = user.toString();

        expect(result, contains('email: null'));
        expect(result, contains('displayName: null'));
        expect(result, contains('photoURL: null'));
        expect(result, contains('createdAt: null'));
        expect(result, contains('lastSignInAt: null'));
      });
    });

    group('Immutability', () {
      test('should be immutable', () {
        // UserEntity is marked with @immutable, so this test verifies
        // that the class follows immutability principles
        final user = const UserEntity(
          id: 'test-id',
          email: 'test@example.com',
          isAnonymous: false,
        );

        // All fields should be final (verified by compilation)
        expect(user.id, equals('test-id'));
        expect(user.email, equals('test@example.com'));
        expect(user.isAnonymous, equals(false));
      });
    });

    group('Edge cases', () {
      test('should handle empty strings', () {
        const user = UserEntity(
          id: '',
          email: '',
          displayName: '',
          photoURL: '',
          isAnonymous: false,
        );

        expect(user.id, equals(''));
        expect(user.email, equals(''));
        expect(user.displayName, equals(''));
        expect(user.photoURL, equals(''));
      });

      test('should handle very long strings', () {
        final longString = 'a' * 1000;
        final user = UserEntity(
          id: longString,
          email: '$longString@example.com',
          displayName: longString,
          photoURL: 'https://example.com/$longString.jpg',
          isAnonymous: false,
        );

        expect(user.id, equals(longString));
        expect(user.email, equals('$longString@example.com'));
        expect(user.displayName, equals(longString));
        expect(user.photoURL, equals('https://example.com/$longString.jpg'));
      });

      test('should handle special characters', () {
        const user = UserEntity(
          id: 'test-id-with-special-chars-!@#\$%^&*()',
          email: 'test+special@example.com',
          displayName: 'Test User 测试用户 🚀',
          photoURL: 'https://example.com/photo-with-query?param=value&other=123',
          isAnonymous: false,
        );

        expect(user.id, equals('test-id-with-special-chars-!@#\$%^&*()'));
        expect(user.email, equals('test+special@example.com'));
        expect(user.displayName, equals('Test User 测试用户 🚀'));
        expect(user.photoURL, equals('https://example.com/photo-with-query?param=value&other=123'));
      });
    });
  });
}
