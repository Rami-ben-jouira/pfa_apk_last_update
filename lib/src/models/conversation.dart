class Conversation {
  final String idConversation;
  final String createdAt;
  final List<String> chatMessages;
  final String parentId;

  Conversation({
    required this.idConversation,
    required this.createdAt,
    required this.chatMessages,
    required this.parentId,
  });

  // Convert a Conversation instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'idConversation': idConversation,
      'createdAt': createdAt,
      'chatMessages': chatMessages,
      'parentId': parentId,
    };
  }

  // Create a Conversation from a map.
  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      idConversation: map['idConversation'],
      createdAt: map['createdAt'],
      chatMessages: List<String>.from(map['chatMessages']),
      parentId: map['parentId'],
    );
  }
}
