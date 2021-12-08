/// Representation of Vivarium User
class VivariumUser {
  final String? userName;
  final String? userEmail;
  final String? userId;
  final String? imageUrl;

  VivariumUser({this.imageUrl, this.userEmail, this.userId, this.userName});

  bool get isSignedIn => userId != null;

  @override
  String toString() {
    return '{userName: $userName, userEmail: $userEmail, userId: $userId, imageUrl: $imageUrl}';
  }
}
