

class Data{
  String host;
  String title;
  String url;
  String date;

  Data({required this.host, required this.title, required this.url, required this.date});
}

class CampusAnnouncement {
  String host;
  String title;
  String datepost;
  String url;
  String nid;
  CampusAnnouncement({required this.host, required this.title, required this.datepost, required this.url, required this.nid});
}

class Cieat{
  String host = "씨앗";
  String title;
  String url;
  String recruittimeclose;
  Cieat({required this.title, required this.url, required this.recruittimeclose});
}

class Food{
  String menudate;
  String foodtime;
  String cafeterianame;
  String foodname;
  Food({required this.menudate, required this.foodtime, required this.cafeterianame, required this.foodname});
}

class ExternalAnnouncement {
  String category;
  String url;
  String title;
  String postorganization;
  String closingdate;
  ExternalAnnouncement({required this.category, required this.url, required this.title, required this.postorganization, required this.closingdate});
}