import 'dart:typed_data';

import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/ownership_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/risk_category_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/security_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/user_requirements_category.dart';
import 'package:deal_insights_assistant/src/features/analytics/data/model/contract_analysis_result_model.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_provider.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_state.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/current_user_provider.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_state.dart';
import 'package:deal_insights_assistant/src/features/result/domain/service/export_service.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/result_header.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/result_summary_cards.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/page/result_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Mock classes
class MockExportService extends Mock implements ExportService {}

class FakeContractAnalysisResultModel extends Fake implements ContractAnalysisResultModel {}

class MockHomeNotifier extends StateNotifier<HomeState> implements HomeStateNotifier {
  MockHomeNotifier() : super(const HomeState());

  @override
  void clearSelection() {
    state = state.copyWith(
      fileBytes: null,
      selectedFileName: null,
      extractedText: null,
      uploadStatus: UploadStatus.idle,
    );
  }

  @override
  void setSelectedText(String? text) {
    state = state.copyWith(selectedText: text);
  }

  @override
  void updateTextInput(String text) {
    state = state.copyWith(textInput: text);
  }

  @override
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  Future<void> analyzeDocument(GoRouter router) async {}

  @override
  void setDragging(bool isDragging) {
    state = state.copyWith(isDragging: isDragging);
  }

  @override
  Future<void> pickFile() async {
    // Mock implementation
  }

  @override
  Future<void> handleDroppedFile(PlatformFile file) async {
    // Mock implementation
  }
}

class MockAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  MockAuthNotifier() : super(AuthState.initial());

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInAnonymously() async {}

  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {}

  @override
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  void clearError() {}

  @override
  Future<void> deleteAccount() async {}
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeContractAnalysisResultModel());
  });

  // Test data
  final testAnalysisResult = ContractAnalysisResultModel(
    obligations: [
      const ObligationEntity(
        text: 'Test obligation',
        party: 'Party A',
        severity: Severity.high,
        timeframe: '30 days',
        confidence: 0.9,
      ),
    ],
    risks: [
      const RiskEntity(
        text: 'Test risk',
        severity: Severity.critical,
        likelihood: Likelihood.high,
        category: RiskCategory.legal,
        confidence: 0.85,
        riskScore: 8,
      ),
    ],
    paymentTerms: [
      const PaymentTermEntity(
        text: 'Payment due in 30 days',
        amount: 1000.0,
        currency: 'USD',
        dueInDays: 30,
        severity: Severity.medium,
        confidence: 0.8,
      ),
    ],
    liabilities: [
      const LiabilityEntity(
        text: 'Liability cap',
        party: 'Vendor',
        capType: CapType.capped,
        capValue: '\$1M',
        excludedDamages: ['consequential'],
        severity: Severity.high,
        confidence: 0.75,
      ),
    ],
    serviceLevels: [
      const ServiceLevelEntity(text: '99.9% uptime', metric: 'uptime', target: '99.9%', severity: Severity.medium),
    ],
    intellectualProperty: [
      const IntellectualPropertyEntity(text: 'IP ownership', ownership: Ownership.client, severity: Severity.low),
    ],
    securityRequirements: [
      const SecurityRequirementEntity(text: 'SOC 2 compliance', type: SecurityType.compliance, severity: Severity.high),
    ],
    userRequirements: [
      const UserRequirementEntity(
        text: 'User training',
        category: UserRequirementCategory.functional,
        severity: Severity.medium,
      ),
    ],
    conflictsOrContrasts: [
      const ConflictOrContrastEntity(text: 'Conflicting terms', conflictWith: 'Section 5', severity: Severity.high),
    ],
  );

  const testExtractedText = 'This is a test extracted text from the document.';
  const testFileName = 'test_contract.pdf';

  // Setup test environment
  late MockExportService mockExportService;
  late MockHomeNotifier mockHomeNotifier;
  late MockAuthNotifier mockAuthNotifier;

  setUp(() {
    mockExportService = MockExportService();
    mockHomeNotifier = MockHomeNotifier();
    mockAuthNotifier = MockAuthNotifier();

    // Setup mock behavior
    when(
      () => mockExportService.exportToPdf(
        analysisResult: any(named: 'analysisResult'),
        fileName: any(named: 'fileName'),
        extractedText: any(named: 'extractedText'),
      ),
    ).thenAnswer((_) async {});
  });

  // Helper function to create widget with providers
  Widget createWidget({
    ContractAnalysisResultModel? analysisResult,
    String? fileName,
    bool isAuthenticated = false,
    UserEntity? user,
    double width = 1024, // Default to desktop width
  }) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 2048)),
        child: ResponsiveBreakpoints.builder(
          child: ProviderScope(
            overrides: [
              exportServiceProvider.overrideWithValue(mockExportService),
              homeStateProvider.overrideWith((ref) => mockHomeNotifier),
              authStateProvider.overrideWith((ref) => mockAuthNotifier),
              if (isAuthenticated && user != null) currentUserProvider.overrideWithValue(user),
            ],
            child: ResultPage(
              contractAnalysisResult: analysisResult ?? testAnalysisResult,
              extractedText: testExtractedText,
              fileName: fileName,
            ),
          ),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          ],
        ),
      ),
    );
  }

  testWidgets('should display all main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer

    // Check app bar
    expect(find.text('${AppConstants.appName}: Analysis Results'), findsOneWidget);

    // Check main content sections
    expect(find.byType(ResultHeader), findsOneWidget);
    expect(find.byType(ResultSummaryCards), findsOneWidget);

    // Check analysis sections
    expect(find.text('Obligations'), findsOneWidget);
    expect(find.text('Risks'), findsOneWidget);
    expect(find.text('Payment Terms'), findsOneWidget);
    expect(find.text('Liabilities'), findsOneWidget);
    expect(find.text('Service Levels'), findsOneWidget);
    expect(find.text('Intellectual Property'), findsOneWidget);
    expect(find.text('Security Requirements'), findsOneWidget);
    expect(find.text('Conflicts & Contrasts'), findsOneWidget);

    // Check action buttons
    expect(find.byIcon(PhosphorIcons.filePdf(PhosphorIconsStyle.regular)), findsOneWidget);
    expect(find.byIcon(PhosphorIcons.house(PhosphorIconsStyle.regular)), findsOneWidget);
  });

  testWidgets('should display file name when provided', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget(fileName: testFileName));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer
    expect(find.text(testFileName), findsOneWidget);
  });

  testWidgets('should render when authenticated', (WidgetTester tester) async {
    final mockUser = UserEntity(
      id: 'test-user-123',
      email: 'test@example.com',
      displayName: 'Test User',
      isAnonymous: false,
    );

    await tester.pumpWidget(createWidget(isAuthenticated: true, user: mockUser));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer

    // Verify the page renders without errors
    expect(find.byType(ResultPage), findsOneWidget);
  });

  testWidgets('should render when not authenticated', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget(isAuthenticated: false));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer
    expect(find.byType(ResultPage), findsOneWidget);
  });

  testWidgets('should call exportToPdf when export button is tapped', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget(fileName: testFileName));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer

    // Tap the export button
    await tester.tap(find.byIcon(PhosphorIcons.filePdf(PhosphorIconsStyle.regular)));
    await tester.pumpAndSettle();

    // Verify export was called with correct parameters
    verify(
      () => mockExportService.exportToPdf(
        analysisResult: testAnalysisResult,
        fileName: testFileName,
        extractedText: testExtractedText,
      ),
    ).called(1);
  });

  testWidgets('should handle empty analysis result gracefully', (WidgetTester tester) async {
    final emptyResult = ContractAnalysisResultModel();
    await tester.pumpWidget(createWidget(analysisResult: emptyResult));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer
    expect(tester.takeException(), isNull);
  });

  testWidgets('should show desktop layout when width > 768', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget(width: 1024));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer
    expect(find.text('Export PDF'), findsOneWidget);
    expect(find.text('New Analysis'), findsOneWidget);
  });

  testWidgets('should render mobile layout when width <= 768', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget(width: 375));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer
    expect(find.byType(ResultPage), findsOneWidget);
  });

  testWidgets('should verify initial state', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer

    // Verify page renders successfully
    expect(find.byType(ResultPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('should show only non-empty sections', (WidgetTester tester) async {
    final minimalResult = ContractAnalysisResultModel(
      obligations: [
        const ObligationEntity(
          text: 'Test obligation',
          party: 'Party A',
          severity: Severity.high,
          timeframe: '30 days',
          confidence: 0.9,
        ),
      ],
    );

    await tester.pumpWidget(createWidget(analysisResult: minimalResult));
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer

    // Only obligations section should be visible
    expect(find.text('Obligations'), findsOneWidget);
    expect(find.text('Risks'), findsNothing);
    expect(find.text('Payment Terms'), findsNothing);
    expect(find.text('Liabilities'), findsNothing);
  });

  testWidgets('should handle navigation interactions', (WidgetTester tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pump(const Duration(milliseconds: 100)); // Wait for timer

    // Verify page renders and navigation elements are present
    expect(find.byType(ResultPage), findsOneWidget);
    expect(find.byIcon(PhosphorIcons.house(PhosphorIconsStyle.regular)), findsOneWidget);
  });
}
