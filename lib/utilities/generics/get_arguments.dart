import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute =
        ModalRoute.of(this); //This is used to pass data across routes
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T; //Type casting to T
      }
    }
    return null;
  }
}
