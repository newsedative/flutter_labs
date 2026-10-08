import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/features/tasks/models/task_item.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.onChanged,
    required this.onTap,
    super.key,
  });

  final TaskItem task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: task.isDone ? 0.68 : 1,
      duration: const Duration(milliseconds: 180),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFEDEDF3)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 13, 14, 13),
            child: Row(
              children: [
                Checkbox(
                  value: task.isDone,
                  onChanged: onChanged,
                  activeColor: const Color(0xFF6958D8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 7),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: task.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(task.icon, color: task.color, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF303348),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF9294A3),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: task.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.time,
                            style: TextStyle(
                              color: task.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB7B8C3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            task.category,
                            style: const TextStyle(
                              color: Color(0xFF9294A3),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFB7B8C3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
