import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_core/services/auth.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:provider/provider.dart';

FileType nameToFileType(String name) {
  switch (name) {
    case 'image':
      return FileType.image;
    case 'video':
      return FileType.video;
    case 'audio':
      return FileType.audio;
    default:
      return FileType.any;
  }
}

Future<void> fetchCurrentUser(BuildContext context) async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      var userResponse = await AuthService.getMe();

      if (context.mounted) {
        context.read<GlobalState>().setUserResponse(userResponse);
      }
    } catch (e) {
      if (context.mounted) {
        context.read<GlobalState>().setUserResponse(null);
      }

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    }
  });
}

Future<void> authNavigate(BuildContext context) async {
  try {
    final userResponse = await AuthService.getMe();

    if (context.mounted) {
      context.read<GlobalState>().setUserResponse(userResponse);

      if (userResponse.data.type == UserType.admin) {
        navigateToStart(routeName: '/admin');
        return;
      }

      switch (userResponse.data.adminApproved) {
        case AdminApproved.approved:
          if (userResponse.data.type == UserType.userAndSubAdmin) {
            navigateToStart(routeName: '/choose-user-type');
          } else {
            navigateToStart(routeName: '/choose-app');
          }

          break;
        case AdminApproved.pending:
          navigateToStart(routeName: '/admin-approval');

          break;
        case AdminApproved.rejected:
          navigateToStart(routeName: '/admin-rejected');
          break;
      }
    }
  } on DioError catch (e) {
    // Force Exit if Server not Available
    if (e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.connectTimeout) {
      // Cannot Exit On Web
    }
  } catch (e) {
    // Pass
  }
}
