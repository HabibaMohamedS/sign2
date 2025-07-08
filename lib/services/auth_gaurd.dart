import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign2/app/routes/app_routes.dart';
import 'package:sign2/services/storage_services.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final cache = StorageService();
    if (!cache.isLoggedIn || cache.cachedUser == null) {
      // user is not authenticated redirect to login
      return  RouteSettings(name: '${AppRoutes.login}?next=$route');
    }
    return null; // user is authenticated, continue
  }
}
