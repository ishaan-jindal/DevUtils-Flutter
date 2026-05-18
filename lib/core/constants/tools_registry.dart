import 'package:flutter/material.dart';

import '../models/tool_model.dart';
import '../theme/app_colors.dart';

/// Central registry of all available developer tools.
class ToolsRegistry {
  ToolsRegistry._();

  static const List<ToolModel> tools = [
    ToolModel(
      id: 'json_formatter',
      name: 'JSON Formatter',
      description: 'Prettify, minify & validate JSON',
      icon: Icons.data_object_rounded,
      accentColor: AppColors.jsonFormatter,
      routePath: '/json-formatter',
      category: ToolCategory.formatters,
      isNew: true,
    ),
    ToolModel(
      id: 'jwt_decoder',
      name: 'JWT Decoder',
      description: 'Decode payload & check expiry',
      icon: Icons.token_rounded,
      accentColor: AppColors.jwtDecoder,
      routePath: '/jwt-decoder',
      category: ToolCategory.encoders,
      isComingSoon: true,
    ),
    ToolModel(
      id: 'regex_tester',
      name: 'Regex Tester',
      description: 'Live matching & explanations',
      icon: Icons.manage_search_rounded,
      accentColor: AppColors.regexTester,
      routePath: '/regex-tester',
      category: ToolCategory.testers,
      isComingSoon: true,
    ),
    ToolModel(
      id: 'timestamp_converter',
      name: 'Timestamp Converter',
      description: 'Unix ↔ human readable time',
      icon: Icons.access_time_rounded,
      accentColor: AppColors.timestampConverter,
      routePath: '/timestamp-converter',
      category: ToolCategory.converters,
      isComingSoon: true,
    ),
    ToolModel(
      id: 'base64_tools',
      name: 'Base64 Tools',
      description: 'Encode & decode Base64',
      icon: Icons.swap_horiz_rounded,
      accentColor: AppColors.base64Tools,
      routePath: '/base64-tools',
      category: ToolCategory.encoders,
      isComingSoon: true,
    ),
    ToolModel(
      id: 'url_encoder',
      name: 'URL Encoder',
      description: 'Encode & decode URLs',
      icon: Icons.link_rounded,
      accentColor: AppColors.urlEncoder,
      routePath: '/url-encoder',
      category: ToolCategory.encoders,
      isComingSoon: true,
    ),
    ToolModel(
      id: 'hash_generator',
      name: 'Hash Generator',
      description: 'SHA256, MD5 & more',
      icon: Icons.fingerprint_rounded,
      accentColor: AppColors.hashGenerator,
      routePath: '/hash-generator',
      category: ToolCategory.generators,
      isComingSoon: true,
    ),
    ToolModel(
      id: 'color_tools',
      name: 'Color Tools',
      description: 'HEX ↔ RGB ↔ HSL converter',
      icon: Icons.palette_rounded,
      accentColor: AppColors.colorTools,
      routePath: '/color-tools',
      category: ToolCategory.converters,
      isComingSoon: true,
    ),
  ];

  /// Get tools filtered by category.
  static List<ToolModel> byCategory(ToolCategory category) {
    if (category == ToolCategory.all) return tools;
    return tools.where((t) => t.category == category).toList();
  }

  /// Search tools by name or description.
  static List<ToolModel> search(String query) {
    if (query.isEmpty) return tools;
    final q = query.toLowerCase();
    return tools
        .where(
          (t) =>
              t.name.toLowerCase().contains(q) ||
              t.description.toLowerCase().contains(q),
        )
        .toList();
  }
}
