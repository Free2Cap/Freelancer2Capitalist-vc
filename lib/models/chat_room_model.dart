class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? sequnece;
  List<dynamic>? users;
  List<dynamic>? projects;

  ChatRoomModel(
      {this.chatroomid,
      this.participants,
      this.lastMessage,
      this.sequnece,
      this.users,
      this.projects});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    sequnece = map["sequnece"].toDate();
    users = map["users"];
    projects = map["projects"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage,
      "sequnece": sequnece,
      "users": users,
      "projects": projects
    };
  }
}
