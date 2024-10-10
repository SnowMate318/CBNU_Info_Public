class ExternalAnn {
  String category;
  String categorySub;
  String url;
  int postId;
  String title;
  String postOrganization;
  String startDate;
  String closingDate;
  String applyUrl;
  int hits;
  String imgUrl;
  String imgFilepath;
  String imgThumbnailUrl;
  String imgThumbnailFilepath;


  ExternalAnn.init()
      : category = '',
        categorySub = '',
        url = '',
        postId = -1,
        title = '',
        postOrganization = '',
        startDate = '',
        closingDate = '',
        applyUrl = '',
        hits = -1,
        imgUrl = '',
        imgFilepath = '',
        imgThumbnailUrl = '',
        imgThumbnailFilepath = '';

  ExternalAnn.fromMap(Map<String, dynamic> map)
      : category = map['category'] ?? '전체',
        categorySub = map['category_sub'] ?? '',
        url = map['url'] ?? '',
        postId = map['post_id']?? -1,
        title = map['title'] ?? '',
        postOrganization = map['post_organization'] ?? '',
        startDate = map['startdate'] ?? '',
        closingDate = map['closingdate']?? '',
        applyUrl = map['apply_url'] ?? '',
        hits = map['hits'] ?? '',
        imgUrl = map['img_url'] ?? '',
        imgFilepath = map['img_filepath']?? '',
        imgThumbnailUrl = map['img_thumbnail_url'] ?? '',
        imgThumbnailFilepath = map['img_thumbnail_filepath'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'category' : category,
      'category_sub' : categorySub,
      'url' : url,
      'post_id' : postId,
      'title' : title,
      'post_organization' : postOrganization,
      'startdate' : startDate,
      'closingdate' : closingDate,
      'apply_url' : applyUrl,
      'hits' : hits,
      'img_url' : imgUrl,
      'img_filepath' : imgFilepath,
      'img_thumbnail_url' : imgThumbnailUrl,
      'img_thumbnail_filepath' : imgThumbnailFilepath,
    };
  }
}