class Photo {
  String photoName = '';

  Photo();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'photo_name': photoName,
    };
    return map;
  }

  Photo.fromMap(Map<dynamic, dynamic> map) {
    photoName = map['photo_name'];
  }
}
