import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';
import 'package:quizzes/src/utils/utils.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({super.key});

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setFriendlyRouteName(title: 'Coming soon', url: 'coming_soon');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetpng('coming_soon'),
      fit: BoxFit.cover,
    );
  }
}
