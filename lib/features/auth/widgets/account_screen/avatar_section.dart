import 'package:flutter/material.dart';

class AvatarSection extends StatelessWidget {
  final String userName;
  final String defaultImagePath;

  const AvatarSection({
    super.key,
    required this.userName,
    required this.defaultImagePath,
  });

  Future<String> fetchUserProfileImage() async {
    await Future.delayed(const Duration(seconds: 0));
    String imageUrl = 'https://robohash.org/$userName.png?set=set4';
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUserProfileImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(defaultImagePath),
          );
        } else if (snapshot.hasData) {
          String imageUrl = snapshot.data!;
          return CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl),
          );
        } else {
          return CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(defaultImagePath),
          );
        }
      },
    );
  }
}
