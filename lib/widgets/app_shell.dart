import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../theme/theme_provider.dart';
import 'sidebar.dart';
import 'dashboard_header.dart';

/// Shared page shell with sidebar, header, and content container.
class AppShell extends StatefulWidget {
  final String pageTitle;
  final Widget child;

  const AppShell({
    super.key,
    required this.pageTitle,
    required this.child,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  bool _isSidebarCollapsed = false;
  late AnimationController _sidebarAnimationController;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    _sidebarAnimationController = AnimationController(
      duration: DashboardConstants.sidebarAnimationDuration,
      vsync: this,
    );
    _sidebarAnimation = CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOut,
    );
    _sidebarAnimationController.forward();
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
    if (_isSidebarCollapsed) {
      _sidebarAnimationController.reverse();
    } else {
      _sidebarAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        context.theme.breakpoints.md > MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: context.theme.colors.primaryForeground,
      drawer: isMobile
          ? Container(
              color: context.theme.colors.background,
              child: const Sidebar(),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            AnimatedBuilder(
              animation: _sidebarAnimation,
              builder: (context, child) {
                return ClipRect(
                  child: SizeTransition(
                    sizeFactor: _sidebarAnimation,
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    child: const Sidebar(),
                  ),
                );
              },
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.theme.colors.background,
                          borderRadius: BorderRadius.circular(
                            DashboardConstants.containerBorderRadius,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.colors.primary
                                  .withValues(alpha: 0.13),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            DashboardHeader(
                              pageTitle: widget.pageTitle,
                              onSidebarToggle: isMobile ? null : _toggleSidebar,
                              sidebarAnimation: isMobile ? null : _sidebarAnimation,
                              onThemeToggle: () => context
                                  .read<ThemeProvider>()
                                  .toggleThemeMode(),
                              themeMode: context.watch<ThemeProvider>().themeMode,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                DashboardConstants.contentPadding,
                              ),
                              child: widget.child,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
