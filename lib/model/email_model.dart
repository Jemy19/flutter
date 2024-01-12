class Email {
  const Email({
    required this.sender,
    required this.subject,
    required this.message,
    required this.containsPictures,
  });

  final String sender;
  final String subject;
  final String message;
  final bool containsPictures;
}
