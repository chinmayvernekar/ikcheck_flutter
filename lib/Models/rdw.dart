class rdw {
  String? success;
  String? active;
  String? uuid;
  String? status;

  rdw({this.success, this.active, this.uuid, this.status});

  rdw.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    active = json['active'];
    uuid = json['uuid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['active'] = this.active;
    data['uuid'] = this.uuid;
    data['status'] = this.status;
    return data;
  }
}