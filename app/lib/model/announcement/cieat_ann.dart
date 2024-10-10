class CieatAnn{
  String host;
  int articleIdx;
  String title;
  String state;
  String url;
  String artOrganization;
  String recruitTime;
  String recruitTimeStart;
  String recruitTimeClose;
  String partClass;
  String partGrade;
  String category;
  double score;
  int point;
  String htmlpath;

  CieatAnn.init()
      : host = '씨앗',
        articleIdx = -1,
        title = '',
        state = '',
        url = '',
        artOrganization = '',
        recruitTime = '',
        recruitTimeStart = '',
        recruitTimeClose = '',
        partClass = '',
        partGrade = '',
        category = '',
        score = 0.0,
        point = -1,
        htmlpath = '';

  CieatAnn.fromMap(Map<String, dynamic> map)
      : host = '씨앗',
        articleIdx = map['article_idx'] ?? -1,
        title = map['title']?? '',
        state = map['state'] ?? '',
        url = map['url'] ?? '',
        artOrganization = map['art_organization']?? '',
        recruitTime = map['recruit_time'] ?? '',
        recruitTimeStart = map['recruit_time_start'] ?? '',
        recruitTimeClose = map['recruit_time_close']?? '',
        partClass = map['part_class'] ?? '',
        partGrade = map['part_grade'] ?? '',
        category = map['category']?? '',
        score = map['score'] ?? 0.0,
        point = map['point'] ?? -1,
        htmlpath = map['htmlpath']?? '';


  Map<String, dynamic> toJson() {
    return {
      'article_idx' : host,
      'title' : title,
      'state' : state,
      'url' : url,
      'art_organization' : artOrganization,
      'recruit_time' : recruitTime,
      'recruit_time_start' : recruitTimeStart,
      'recruit_time_close' : recruitTimeClose,
      'part_class' : partClass,
      'part_grade' : partGrade,
      'category' : category,
      'score' : score,
      'point' : point,
      'htmlpath' : htmlpath,
    };
  }
}
