import 'package:dio/dio.dart';

import '../../../data/dio/endpoints.dart';
import '../models/content.dart';
import 'content_repository_interface.dart';

class ContentRepository implements ContentRepositoryInterface {
  final Dio dio;

  const ContentRepository({required this.dio});

  static const List<String> _authors = [
    'Анна',
    'Дмитрий',
    'Мария',
    'Иван',
    'Елена',
    'Артём',
  ];

  @override
  Future<List<Content>> getContent() async {
    try {
      final Response response = await dio.get(Endpoints.content);
      final dynamic rawData = response.data;

      final List<dynamic> items;
      if (rawData is List) {
        items = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        items = rawData['data'] as List<dynamic>;
      } else {
        throw const FormatException('Некорректный формат ответа API');
      }

      return items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final map = Map<String, dynamic>.from(item as Map);
        final id = int.tryParse(map['id']?.toString() ?? '') ?? index + 1;
        final title = map['title']?.toString() ?? 'Без названия';
        final description = map['description']?.toString() ??
            map['body']?.toString() ??
            'Описание отсутствует';
        final author = map['author']?.toString() ??
            _authors[(id - 1) % _authors.length];
        final image = map['image']?.toString() ??
            map['thumbnail']?.toString() ??
            '';

        return Content(
          id: id,
          title: title,
          author: author,
          description: description,
          image: image,
        );
      }).toList();
    } on DioException catch (e) {
      throw e.message ?? 'Ошибка сети';
    } on FormatException {
      rethrow;
    } catch (_) {
      throw 'Не удалось загрузить данные';
    }
  }
}
