import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/extensions/date_time_extensions.dart';
import 'package:flutter_application_1/app/features/tasks/models/task_filter.dart';
import 'package:flutter_application_1/app/features/tasks/models/task_item.dart';
import 'package:flutter_application_1/app/router/app_router.dart';
import 'package:flutter_application_1/app/widgets/count_badge.dart';
import 'package:flutter_application_1/app/widgets/task_card.dart';

class TasksHomePage extends StatefulWidget {
  const TasksHomePage({super.key});

  @override
  State<TasksHomePage> createState() => _TasksHomePageState();
}

class _TasksHomePageState extends State<TasksHomePage> {
  final _searchController = TextEditingController();
  TaskFilter _filter = TaskFilter.all;
  String _query = '';
  final List<TaskItem> _tasks = [
    TaskItem(
      title: 'Подготовить презентацию',
      details: 'Обновить слайды для встречи',
      time: '09:30',
      category: 'Личное',
      color: const Color(0xFF6958D8),
      icon: Icons.work_outline_rounded,
    ),
    TaskItem(
      title: 'Позвонить маме',
      details: 'Узнать, как прошла поездка',
      time: '11:00',
      category: 'Личное',
      color: const Color(0xFFE99A62),
      icon: Icons.favorite_border_rounded,
    ),
    TaskItem(
      title: 'Купить продукты',
      details: 'Молоко, авокадо, хлеб',
      time: '18:30',
      category: 'Личное',
      color: const Color(0xFF48A891),
      icon: Icons.shopping_bag_outlined,
    ),
    TaskItem(
      title: 'Вечерняя пробежка',
      details: 'Лёгкий маршрут в парке',
      time: '19:00',
      category: 'Личное',
      color: const Color(0xFFE47783),
      icon: Icons.directions_run_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _completedCount => _tasks.where((task) => task.isDone).length;

  List<TaskItem> get _visibleTasks {
    return _tasks.where((task) {
      final matchesFilter = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.active => !task.isDone,
        TaskFilter.done => task.isDone,
      };
      final normalizedQuery = _query.toLowerCase();
      final matchesSearch =
          task.title.toLowerCase().contains(normalizedQuery) ||
          task.details.toLowerCase().contains(normalizedQuery) ||
          task.category.toLowerCase().contains(normalizedQuery);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final completed = _completedCount;
    final total = _tasks.length;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildTopBar(),
                  const SizedBox(height: 30),
                  Text(
                    DateTime.now().russianDateLabel,
                    style: const TextStyle(
                      color: Color(0xFF8A8C9D),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Твой план',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  _buildProgressCard(completed, total),
                  const SizedBox(height: 26),
                  _buildSearchField(),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text(
                        'Задачи',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 9),
                      CountBadge(count: _visibleTasks.length),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildFilters(),
                  const SizedBox(height: 14),
                  if (_visibleTasks.isEmpty)
                    _buildEmptyState()
                  else
                    ..._visibleTasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: TaskCard(
                          task: task,
                          onTap: () => _openTaskDetails(task),
                          onChanged: (value) {
                            setState(() => task.isDone = value ?? false);
                          },
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Новая задача'),
        backgroundColor: const Color(0xFF6958D8),
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _openTaskDetails(TaskItem task) async {
    await Navigator.of(context).pushNamed<void>(
      AppRouter.taskDetails,
      arguments: task,
    );
    if (mounted) setState(() {});
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFECE9FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 25,
            color: Color(0xFF6958D8),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'планер',
          style: TextStyle(
            color: Color(0xFF20243A),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const Spacer(),
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE8D8),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'А',
            style: TextStyle(
              color: Color(0xFFB06C3A),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(int completed, int total) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7565E6), Color(0xFF5D4BC8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6958D8).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completed == 0
                          ? 'Хороший день начинается\nс маленьких шагов'
                          : 'Отличная работа!\nПродолжай в том же духе',
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.3,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$completed из $total задач выполнено',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 54,
                height: 54,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.24),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.24),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value.trim()),
      decoration: InputDecoration(
        hintText: 'Найти задачу',
        hintStyle: const TextStyle(color: Color(0xFFA3A5B2), fontSize: 14),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF9294A3),
          size: 21,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEDEDF3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFB8B0F2)),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    const labels = {
      TaskFilter.all: 'Все',
      TaskFilter.active: 'В работе',
      TaskFilter.done: 'Готово',
    };
    return Row(
      children: TaskFilter.values.map((filter) {
        final selected = _filter == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(labels[filter]!),
            selected: selected,
            onSelected: (_) => setState(() => _filter = filter),
            showCheckmark: false,
            labelStyle: TextStyle(
              color: selected ? Colors.white : const Color(0xFF77798A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFF6958D8),
            side: BorderSide(
              color: selected
                  ? const Color(0xFF6958D8)
                  : const Color(0xFFEDEDF3),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEDF3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 34, color: Color(0xFFAAA7C3)),
          const SizedBox(height: 10),
          Text(
            _query.isNotEmpty ? 'Ничего не найдено' : 'Здесь пока пусто',
            style: const TextStyle(
              color: Color(0xFF52556A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Попробуй изменить поиск или фильтр',
            style: TextStyle(color: Color(0xFF9698A7), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTaskDialog() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая задача'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Например, прочитать книгу',
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (title == null || title.isEmpty || !mounted) return;

    setState(() {
      _tasks.add(
        TaskItem(
          title: title,
          details: 'Новая задача',
          time: 'Сегодня',
          category: 'Личное',
          color: const Color(0xFF6958D8),
          icon: Icons.check_circle_outline_rounded,
        ),
      );
      _filter = TaskFilter.all;
      _query = '';
      _searchController.clear();
    });
  }
}
