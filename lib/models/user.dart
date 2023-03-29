// ignore_for_file: non_constant_identifier_names


class User {
  final String id;
  final String name;
  final String about_me;
  final int rating;
  final String dob;
  final String street;
  // ignore: prefer_typing_uninitialized_variables
  final created_at;

  User({required this.id, required this.name, required this.about_me, required this.rating, required this.dob, required this.street, required this.created_at});
}