import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/app/di.dart';
import 'package:flutter_application_1/app/extensions/date_time_extensions.dart';
import 'package:flutter_application_1/app/features/tasks/bloc/home_bloc.dart';
import 'package:flutter_application_1/app/features/tasks/models/content.dart';
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
  late final HomeBloc _homeBloc;
  final _searchController = TextEditingController();
  String _query = '';

  static const List<Color> _taskColors = [
    Color(0xFF6958D8),
    Color(0xFFE99A62),
    Color(0xFF48A891),
    Color(0xFFE47783),
    Color(0xFF5F9BFF),
  ];

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
  void initState() {
    super.initState();
    _homeBloc = getIt<HomeBloc>();
    _homeBloc.add(const HomeLoad());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  TaskItem _mapContentToTask(Content content) {
    final color = _taskColors[content.id % _taskColors.length];
    final hour = (content.id % 12) + 8;
    final minutes = (content.id * 7) % 60;

    return TaskItem(
      title: content.title,
      details: content.description,
      time: '${hour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}',
      category: 'Личное',
      color: color,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  Widget _buildContent(HomeState state) {
    final List<TaskItem> currentTasks;
    if (state is HomeLoadSuccess) {
      currentTasks = state.content.map(_mapContentToTask).toList();
    } else {
      currentTasks = _tasks;
    }

    final visibleTasks = currentTasks.where((task) {
      final normalizedQuery = _query.toLowerCase();
      final matchesSearch =
          task.title.toLowerCase().contains(normalizedQuery) ||
          task.details.toLowerCase().contains(normalizedQuery) ||
          task.category.toLowerCase().contains(normalizedQuery);
      return matchesSearch;
    }).toList();

    return SafeArea(
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
                const SizedBox(height: 24),
                _buildSearchField(),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Text(
                      'Задачи',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 9),
                    CountBadge(count: visibleTasks.length),
                  ],
                ),
                const SizedBox(height: 15),
                if (visibleTasks.isEmpty)
                  _buildEmptyState()
                else
                  ...visibleTasks.map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: TaskCard(
                        task: task,
                        onTap: () => _openTaskDetails(task),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (context, state) {
          if (state is HomeLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HomeLoadFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.signal_wifi_connected_no_internet_4_rounded,
                      size: 56,
                      color: Color(0xFF6958D8),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Не удалось загрузить данные',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.exception}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF646B82)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _homeBloc.add(const HomeLoad()),
                      child: const Text('Повторить запрос'),
                    ),
                  ],
                ),
              ),
            );
          }

          return _buildContent(state);
        },
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
    await Navigator.of(context)
        .pushNamed<void>(AppRouter.taskDetails, arguments: task);
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
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final timeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final shouldAdd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая задача'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    hintText: 'Например, прочитать книгу',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите название задачи';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: detailsController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    hintText: 'Дополнительная информация',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Время',
                    hintText: 'Например, 14:30',
                    prefixIcon: Icon(Icons.schedule_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
    final title = titleController.text.trim();
    final details = detailsController.text.trim();
    final time = timeController.text.trim();
    titleController.dispose();
    detailsController.dispose();
    timeController.dispose();
    if (shouldAdd != true || !mounted) return;

    setState(() {
      _tasks.add(
        TaskItem(
          title: title,
          details: details,
          time: time.isEmpty ? 'Без времени' : time,
          category: 'Личное',
          color: const Color(0xFF6958D8),
          icon: Icons.check_circle_outline_rounded,
        ),
      );
      _query = '';
      _searchController.clear();
    });
  }
}
