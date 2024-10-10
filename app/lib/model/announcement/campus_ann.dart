class CampusAnn {
  int idx;
  String major;
  String nid;
  String title;
  String url;
  String datePost;

  CampusAnn.init()
      : idx = -1,
        major = '',
        nid = '',
        title = '',
        url = '',
        datePost = '';

  CampusAnn.fromMap(Map<String, dynamic> map)
      : idx = map['idx'] ?? -1,
        major = map['major'] ?? '',
        nid = map['nid'] ?? '',
        title = map['title']?? '',
        url = map['url'] ?? '',
        datePost = map['date_post'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'idx' : idx,
      'major' : major,
      'nid' : nid,
      'title' : title,
      'url' : url,
      'date_post' : datePost,
    };
  }
}
