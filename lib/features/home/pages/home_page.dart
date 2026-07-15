import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/tools_registry.dart';
import '../../../core/models/tool_model.dart';
import '../../../core/theme/theme_cubit.dart';
import '../widgets/tool_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ToolCategory _selectedCategory = ToolCategory.all;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _showSearch = false;

  List<ToolModel> get _filteredTools {
    var tools = ToolsRegistry.byCategory(_selectedCategory);
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      tools = tools
          .where(
            (t) =>
                t.name.toLowerCase().contains(q) ||
                t.description.toLowerCase().contains(q),
          )
          .toList();
    }
    return tools;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tools = _filteredTools;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar.large(
            title: _showSearch ? _buildSearchField(theme) : _buildTitle(theme),
            actions: [
              // Search toggle
              IconButton(
                icon: Icon(
                  _showSearch ? Icons.close_rounded : Icons.search_rounded,
                ),
                tooltip: _showSearch ? 'Close search' : 'Search tools',
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) {
                      _searchController.clear();
                      _searchQuery = '';
                    }
                  });
                },
              ),
              // Theme toggle
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  final cubit = context.read<ThemeCubit>();
                  return IconButton(
                    icon: Icon(cubit.icon),
                    tooltip: cubit.label,
                    onPressed: cubit.toggleTheme,
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ── Category Chips ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                ),
                itemCount: ToolCategory.values.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppConstants.spacingSm),
                itemBuilder: (context, index) {
                  final cat = ToolCategory.values[index];
                  final isSelected = cat == _selectedCategory;
                  return FilterChip(
                    label: Text(cat.label),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                    },
                    showCheckmark: false,
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.spacingMd),
          ),

          // ── Tool Grid ──
          if (tools.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      'No tools found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
              ),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final crossAxisCount = width > AppConstants.breakpointTablet
                      ? 4
                      : width > AppConstants.breakpointMobile
                      ? 3
                      : 2;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: AppConstants.spacingMd,
                      crossAxisSpacing: AppConstants.spacingMd,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final tool = tools[index];
                      return ToolCard(
                        tool: tool,
                        index: index,
                        onTap: () {
                          if (!tool.isComingSoon) {
                            context.push(tool.routePath);
                          }
                        },
                      );
                    }, childCount: tools.length),
                  );
                },
              ),
            ),

          // ── Bottom padding ──
          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.spacingXxl),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset('assets/app_icon.png', width: 36, height: 36),
        ),
        const SizedBox(width: 12),
        Text(
          AppConstants.appName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search tools...',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
        hintStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          fontWeight: FontWeight.w400,
        ),
      ),
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
      onChanged: (value) {
        setState(() => _searchQuery = value);
      },
    );
  }
}
