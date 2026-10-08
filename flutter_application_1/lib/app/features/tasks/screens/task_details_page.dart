import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/extensions/date_time_extensions.dart';
import 'package:flutter_application_1/app/features/tasks/models/task_item.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({required this.task, super.key});

  final TaskItem task;

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskItem get task => widget.task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7FB),
        leading: IconButton(
          tooltip: 'Назад',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Детали задачи',
          style: TextStyle(
            color: Color(0xFF20243A),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        children: [
          _buildTaskHeader(),
          const SizedBox(height: 26),
          const Text(
            'Информация',
            style: TextStyle(
              color: Color(0xFF20243A),
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 13),
          _buildInformationCard(),
          const SizedBox(height: 25),
          const Text(
            'Описание',
            style: TextStyle(
              color: Color(0xFF20243A),
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: _cardDecoration,
            child: Text(
              task.details,
              style: const TextStyle(
                color: Color(0xFF77798A),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () => setState(() => task.isDone = !task.isDone),
            style: FilledButton.styleFrom(
              backgroundColor: task.isDone
                  ? const Color(0xFFECE9FF)
                  : const Color(0xFF6958D8),
              foregroundColor: task.isDone
                  ? const Color(0xFF6958D8)
                  : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: Icon(
              task.isDone
                  ? Icons.undo_rounded
                  : Icons.check_circle_outline_rounded,
            ),
            label: Text(
              task.isDone ? 'Вернуть в работу' : 'Отметить выполненной',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            task.color,
            Color.lerp(task.color, const Color(0xFF20243A), 0.2)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: task.color.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(task.icon, color: Colors.white, size: 29),
          ),
          const SizedBox(height: 22),
          Text(
            task.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              task.isDone ? 'Выполнена' : 'В работе',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: _cardDecoration,
      child: Column(
        children: [
          _InformationRow(
            icon: Icons.calendar_today_rounded,
            label: 'Дата',
            value: DateTime.now().russianDateLabel,
            color: const Color(0xFF6958D8),
          ),
          const Divider(height: 1, color: Color(0xFFEDEDF3)),
          _InformationRow(
            icon: Icons.schedule_rounded,
            label: 'Время',
            value: task.time,
            color: task.color,
          ),
          const Divider(height: 1, color: Color(0xFFEDEDF3)),
          _InformationRow(
            icon: Icons.sell_outlined,
            label: 'Категория',
            value: task.category,
            color: const Color(0xFF48A891),
          ),
        ],
      ),
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: const Color(0xFFEDEDF3)),
  );
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF9294A3), fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF303348),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
