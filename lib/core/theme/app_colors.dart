import 'package:flutter/material.dart';

/// Brand colors and semantic design tokens for DevUtils.
class AppColors {
  AppColors._();

  // ── Brand Seed ──
  static const Color seedColor = Color(0xFF00BCD4);

  // ── Accent Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00BCD4), Color(0xFF00897B)],
    begin: .topLeft,
    end: .bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: .topCenter,
    end: .bottomCenter,
  );

  // ── Tool Accent Colors ──
  static const Color jsonFormatter = Color(0xFF26A69A);
  static const Color jwtDecoder = Color(0xFFEF5350);
  static const Color regexTester = Color(0xFFAB47BC);
  static const Color timestampConverter = Color(0xFFFFA726);
  static const Color base64Tools = Color(0xFF42A5F5);
  static const Color urlEncoder = Color(0xFF66BB6A);
  static const Color hashGenerator = Color(0xFFEC407A);
  static const Color colorTools = Color(0xFFFFCA28);
  static const Color diffChecker = Color(0xFF7E57C2);
  static const Color apiTester = Color(0xFF26C6DA);
  static const Color qrGenerator = Color(0xFF8D6E63);
  static const Color sqlFormatter = Color(0xFF78909C);
  static const Color markdownPreview = Color(0xFF5C6BC0);
  static const Color cronParser = Color(0xFFD4E157);

  // ── Glassmorphism ──
  static Color glassWhite = Colors.white.withValues(alpha: 0.08);
  static Color glassBorder = Colors.white.withValues(alpha: 0.12);

  // ── Syntax Highlighting (JSON) ──
  static const Color syntaxKey = Color(0xFF82AAFF);
  static const Color syntaxString = Color(0xFFC3E88D);
  static const Color syntaxNumber = Color(0xFFF78C6C);
  static const Color syntaxBoolean = Color(0xFFFF5370);
  static const Color syntaxNull = Color(0xFF89DDFF);
  static const Color syntaxBracket = Color(0xFFBFC7D5);
  static const Color syntaxError = Color(0xFFFF5370);

  // ── Syntax Highlighting (Light theme) ──
  static const Color syntaxKeyLight = Color(0xFF1565C0);
  static const Color syntaxStringLight = Color(0xFF2E7D32);
  static const Color syntaxNumberLight = Color(0xFFE65100);
  static const Color syntaxBooleanLight = Color(0xFFC62828);
  static const Color syntaxNullLight = Color(0xFF00838F);
  static const Color syntaxBracketLight = Color(0xFF37474F);
}
