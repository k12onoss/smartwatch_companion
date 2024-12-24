class WatchUser {
  final String uid;
  final String? name;
  final String? email;
  final String? photo;

  const WatchUser({required this.uid, this.name, this.email, this.photo});

  static const empty = WatchUser(uid: '');
}
