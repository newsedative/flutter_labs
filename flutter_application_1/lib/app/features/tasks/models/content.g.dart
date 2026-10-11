part of 'content.dart';

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(
    id: (json['id'] as num?)?.toInt() ?? 0,
    title: (json['title'] as String?) ?? 'Без названия',
    author: (json['author'] as String?) ?? 'Неизвестный автор',
    description: (json['description'] as String?) ??
        (json['body'] as String?) ??
        'Описание отсутствует',
    image: (json['image'] as String?) ?? (json['thumbnail'] as String?) ?? '',
  );
}

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author,
  'description': instance.description,
  'image': instance.image,
};
