import 'package:flutter/material.dart';
import 'package:whisper_frontend/views/views.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const HomeView(),
};
