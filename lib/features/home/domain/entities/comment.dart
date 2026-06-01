class Comment {
  final String id;
  final String postId;
  final String text;
  final String username;

  Comment({
    required this.id,
    required this.postId,
    required this.text,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'text': text,
      'username': username, 
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      text: json['text'],
      username: json['username'],
    );
  }
}