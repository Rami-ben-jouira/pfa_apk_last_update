class Conversation {
  final String idConversation;
  final String createdAt;
  final List<String> chatMessages;
  final String childId;

  final String parentId;

  Conversation({
    required this.idConversation,
    required this.createdAt,
    required this.chatMessages,
    required this.childId,
    required this.parentId,
  });

  // Convert a Conversation instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'idConversation': idConversation,
      'createdAt': createdAt,
      'chatMessages': chatMessages,
      'childId': childId,
      'parentId': parentId,
    };
  }

  // Create a Conversation from a map.
  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      idConversation: map['idConversation'],
      createdAt: map['createdAt'],
      chatMessages: List<String>.from(map['chatMessages']),
      childId: map['childId'],
      parentId: map['parentId'],
    );
  }
}
