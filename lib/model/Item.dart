class Item {
  int id;
  String itemName;
  String image;
  String description;
  int rating;
  int active;

  Item({
    required this.id,
    required this.itemName,
    required this.image,
    required this.rating,
    required this.active,
    required this.description,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemName: json['item_name'],
      image: json['image'],
      rating: json['rating'],
      active: json['active'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'image': image,
      'rating': rating,
      'active': active,
      'description': description,
    };
  }
}

//DTO Class
class ResponseItemModel {
  bool success;
  List<Item> data;
  String message;
  String stackTrace;

  ResponseItemModel({
    required this.success,
    required this.data,
    required this.message,
    required this.stackTrace,
  });

  factory ResponseItemModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Item> dataList = list.map((i) => Item.fromJson(i)).toList();

    return ResponseItemModel(
      success: json['success'],
      data: dataList,
      message: json['message'],
      stackTrace: json['stack_trace'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'message': message,
      'stack_trace': stackTrace,
    };
  }
}
