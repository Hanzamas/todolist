import 'package:flutter/material.dart';

/// A reusable widget that displays todo statistics
/// This widget follows the Single Responsibility Principle by only handling statistics display
class TodoStatsWidget extends StatelessWidget {
  final int totalTodos;
  final int completedTodos;
  final int pendingTodos;

  const TodoStatsWidget({
    super.key,
    required this.totalTodos,
    required this.completedTodos,
    required this.pendingTodos,
  });

  @override
  Widget build(BuildContext context) {
    if (totalTodos == 0) {
      return const SizedBox.shrink();
    }

    final completionPercentage = 
        totalTodos > 0 ? (completedTodos / totalTodos * 100).round() : 0;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Progress',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12.0),
          
          // Progress bar
          LinearProgressIndicator(
            value: totalTodos > 0 ? completedTodos / totalTodos : 0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              completionPercentage == 100 ? Colors.green : Colors.blue,
            ),
            minHeight: 8.0,
          ),
          
          const SizedBox(height: 8.0),
          
          Text(
            '$completionPercentage% Complete',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: completionPercentage == 100 ? Colors.green : Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 16.0),
          
          // Statistics row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                'Total',
                totalTodos.toString(),
                Colors.blue,
                Icons.list,
              ),
              _buildStatItem(
                context,
                'Completed',
                completedTodos.toString(),
                Colors.green,
                Icons.check_circle,
              ),
              _buildStatItem(
                context,
                'Pending',
                pendingTodos.toString(),
                Colors.orange,
                Icons.pending,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a single statistic item
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24.0,
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
