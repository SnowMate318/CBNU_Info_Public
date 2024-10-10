class Food{
  String menuDate;
  String foodTime;
  String cafeteriaName;
  String foodName;
  int foodIdx;

  Food.init()
      : menuDate = '',
        foodTime = '',
        cafeteriaName = '',
        foodName = '',
        foodIdx = -1;

  Food.fromMap(Map<String, dynamic> map)
      : menuDate = map['menu_date'] ?? '',
        foodTime = map['food_time']?? '',
        cafeteriaName = map['cafeteria_name'] ?? '',
        foodName = map['food_name'] ?? '',
        foodIdx = map['food_idx'] ?? -1;

  Map<String, dynamic> toJson() {
    return {
      'menu_date' : menuDate,
      'food_time' : foodTime,
      'cafeteria_name' : cafeteriaName,
      'food_name' : foodName,
      'food_idx' : foodIdx,
    };
  }
}
