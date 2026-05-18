import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a single developer utility tool.
class ToolModel extends Equatable {
  const ToolModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.routePath,
    this.category = ToolCategory.all,
    this.isNew = false,
    this.isComingSoon = false,
  });

  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String routePath;
  final ToolCategory category;
  final bool isNew;
  final bool isComingSoon;

  @override
  List<Object?> get props => [id];
}

/// Category for grouping tools.
enum ToolCategory {
  all('All'),
  formatters('Formatters'),
  encoders('Encoders'),
  generators('Generators'),
  converters('Converters'),
  testers('Testers');

  const ToolCategory(this.label);
  final String label;
}
