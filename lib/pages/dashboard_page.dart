import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import '../widgets/app_shell.dart';
import '../widgets/metric_card.dart';
import '../widgets/chart_card.dart';
import '../widgets/simple_progress_card.dart';
import '../widgets/simple_performers_list.dart';
import '../widgets/simple_activity_feed.dart';
import '../core/constants.dart';
import '../theme/theme_provider.dart';
import 'package:dashboard/models/chart_data_set.dart';
import 'package:dashboard/services/chart_service.dart';

/// Main dashboard layout with responsive grid system.
///
/// Coordinates the overall dashboard layout with sidebar navigation,
/// header controls, and adaptive content grid for different screen sizes.
///
/// **Layout Structure:**
/// ```
/// [Sidebar] | [Header            ]
///          | [Metrics Grid      ]
///          | [Chart Card        ]
///          | [Progress Cards    ]
///          | [Lists & Activity  ]
/// ```
///
/// **Responsive Breakpoints:**
/// - **Mobile** (< md): Drawer sidebar, 1-column metrics
/// - **Tablet** (md-lg): Collapsible sidebar, 2-column metrics
/// - **Desktop** (lg+): Fixed sidebar, 4-column metrics
///
/// **Data Sources:**
/// - All displayed data is currently mock/hardcoded sample data
/// - Chart data generated via `_generateChartDatasets()` with 3 months of sample points
/// - Metric cards use static demo values
/// - Replace these with real API calls for production use
///
/// **State Management:**
/// - Uses `ThemeProvider` for theme switching
/// - Local state for sidebar collapse animation
/// - No external data state - currently demonstration only
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, ChartDataSet> _generateChartDatasets() {
    return ChartService.generateChartDatasets();
  }


  @override
  Widget build(BuildContext context) {
    return AppShell(
      pageTitle: 'Dashboard',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metrics grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.theme.breakpoints.xl2 <=
                      MediaQuery.of(context).size.width
                  ? 4
                  : context.theme.breakpoints.xl <=
                          MediaQuery.of(context).size.width
                      ? 2
                      : context.theme.breakpoints.lg <=
                              MediaQuery.of(context).size.width
                          ? 2
                          : context.theme.breakpoints.md <=
                                  MediaQuery.of(context).size.width
                              ? 1
                              : context.theme.breakpoints.sm <=
                                      MediaQuery.of(context).size.width
                                  ? 2
                                  : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 192,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final cards = const [
                MetricCard(
                  title: 'Total Revenue',
                  value: '\$1,250.00',
                  percentage: '+12.5%',
                  trend: 'Trending up this month',
                  description: 'Visitors for the last 6 months',
                  isPositive: true,
                ),
                MetricCard(
                  title: 'Subscriptions',
                  value: '+2,350',
                  percentage: '+180.1%',
                  trend: 'Trending up this month',
                  description: 'New subscriptions this period',
                  isPositive: true,
                ),
                MetricCard(
                  title: 'Sales',
                  value: '+12,234',
                  percentage: '+19%',
                  trend: 'Trending up this month',
                  description: 'Sales from last month',
                  isPositive: true,
                ),
                MetricCard(
                  title: 'Active Now',
                  value: '+573',
                  percentage: '+201%',
                  trend: 'Trending up this month',
                  description: 'Active users right now',
                  isPositive: true,
                ),
              ];
              return cards[index];
            },
          ),

          const SizedBox(height: 24),

          // Chart section
          ChartCard(
            title: 'Total Visitors',
            subtitle: 'Total for the last 3 months',
            timePeriods: const ['Last 3 months', 'Last 30 days', 'Last 7 days'],
            datasets: _generateChartDatasets(),
          ),

          const SizedBox(height: 24),

          // Progress cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.theme.breakpoints.lg <=
                      MediaQuery.of(context).size.width
                  ? 3
                  : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 150,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              final cards = const [
                SimpleProgressCard(
                  title: 'Sales Goal',
                  value: '\$45,231 / \$60,000',
                  progress: 0.75,
                  label: '75% Complete',
                ),
                SimpleProgressCard(
                  title: 'New Users',
                  value: '1,284 / 2,000',
                  progress: 0.64,
                  label: '64% Complete',
                ),
                SimpleProgressCard(
                  title: 'Satisfaction',
                  value: '4.6 / 5.0',
                  progress: 0.92,
                  label: '92% Complete',
                ),
              ];
              return cards[index];
            },
          ),

          const SizedBox(height: 24),

          // Bottom section - responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isLargeScreen =
                  context.theme.breakpoints.lg <= MediaQuery.of(context).size.width;

              if (isLargeScreen) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: SimplePerformersList()),
                    const SizedBox(width: 16),
                    const Expanded(child: SimpleActivityFeed()),
                  ],
                );
              } else {
                return const Column(
                  children: [
                    SimplePerformersList(),
                    SizedBox(height: 16),
                    SimpleActivityFeed(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
