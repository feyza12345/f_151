enum LessonLocation {
  atStudentsHome('Öğrencinin Evi'),
  atTeachersHome('Öğretmenin Evi'),
  atStudentsOrTeachersHome('Öğrenci veya Öğretmenin Evi'),
  online('Online');

  final String name;
  const LessonLocation(this.name);
}
