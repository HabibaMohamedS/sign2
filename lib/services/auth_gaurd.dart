// routes/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/services/storage_services.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final cache = StorageService();
    if (!cache.isLoggedIn || cache.cachedUser == null) {
      // Jump to login; keep the intended route so you
      // can redirect back after successful login if you like.
      return const RouteSettings(name: AppRoutes.login);
    }
    return null; // user is authenticated – continue
  }
}
