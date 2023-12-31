class Failure {
  int? code;
  String? message;
  dynamic? body;

  Failure(this.code, this.message, {this.body});

  factory Failure.fromJson(Map<String, dynamic> json, int code) {
    return Failure(code, json['message']);
  }
}
