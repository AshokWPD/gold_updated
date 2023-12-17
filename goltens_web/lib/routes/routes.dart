import 'package:flutter/material.dart';
import 'package:goltens_web/main.dart';
import 'package:goltens_web/pages/admin/admin_app_choose_page.dart';
import 'package:goltens_web/pages/admin/dashboard_page.dart';
import 'package:goltens_web/pages/admin/edit_profile_page.dart';
import 'package:goltens_web/pages/admin/group_detail_page.dart';
import 'package:goltens_web/pages/admin/master_list_page.dart';
import 'package:goltens_web/pages/admin/groups_page.dart';
import 'package:goltens_web/pages/admin/message_detail_page.dart';
import 'package:goltens_web/pages/admin/messages_detail_page.dart';
import 'package:goltens_web/pages/admin/messages_page.dart';
import 'package:goltens_web/pages/admin/other_files_page.dart';
import 'package:goltens_web/pages/admin/pending_requests_page.dart';
import 'package:goltens_web/pages/admin/risk_assessment_detail_page.dart';
import 'package:goltens_web/pages/admin/risk_assessment_page.dart';
import 'package:goltens_web/pages/admin/sub_admins_page.dart';
import 'package:goltens_web/pages/admin/user_orientation_page.dart';
import 'package:goltens_web/pages/admin/users_and_subadmins_page.dart';
import 'package:goltens_web/pages/admin/users_page.dart';
import 'package:goltens_web/pages/admin/feedback/feedback_dashboard_page.dart';
import 'package:goltens_web/pages/admin/auth/login_page.dart';
import 'package:goltens_web/pages/admin/auth/reset_password_page.dart';
import 'package:goltens_web/pages/admin/feedback/feedback_detail_page.dart';
import 'package:goltens_web/pages/admin/feedback/feedbacks_page.dart';
import 'package:goltens_web/pages/admin/meeting/meeting_dashboard_page.dart';
import 'package:goltens_web/pages/auth/admin_approval_page.dart';
import 'package:goltens_web/pages/auth/admin_rejected_page.dart';
import 'package:goltens_web/pages/auth/auth_page.dart';
import 'package:goltens_web/pages/auth/profile_page.dart';
import 'package:goltens_web/pages/auth/reset_password.dart';
import 'package:goltens_web/pages/feedback/feedback_assigned_page.dart';
import 'package:goltens_web/pages/feedback/feedback_dashboard_page.dart';
import 'package:goltens_web/pages/feedback/feedback_list_page.dart';
import 'package:goltens_web/pages/feedback/feedback_page.dart';
import 'package:goltens_web/pages/group/group_info_page.dart';
import 'package:goltens_web/pages/group/group_detail_page.dart';
import 'package:goltens_web/pages/group/home_page.dart';
import 'package:goltens_web/pages/group/manage_members_page.dart';
import 'package:goltens_web/pages/master-list/master_list_page.dart';
import 'package:goltens_web/pages/message/message_detail_page.dart';
import 'package:goltens_web/pages/others/app_choose_page.dart';
import 'package:goltens_web/pages/others/not_found_page.dart';
import 'package:goltens_web/pages/others/privacy_policy_page.dart';
import 'package:goltens_web/pages/others/user_type_choose_page.dart';
import 'package:goltens_web/pages/risk_assessment/risk_assessment_detail.dart';

class RoutingData {
  final String route;
  final Map<String, dynamic> _queryParameters;

  RoutingData({
    required this.route,
    required Map<String, dynamic> queryParameters,
  }) : _queryParameters = queryParameters;

  operator [](String key) => _queryParameters[key];
}

extension StringExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);

    return RoutingData(
      route: uriData.path,
      queryParameters: uriData.queryParameters,
    );
  }
}

MaterialPageRoute pageRoute(Widget widgetPage, RouteSettings settings) {
  return MaterialPageRoute(
    settings: settings,
    builder: (context) => widgetPage,
  );
}

dynamic navigateTo({
  required String routeName,
  Map<String, dynamic>? queryParams,
}) {
  if (queryParams != null) {
    final stringParams = queryParams.map((k, v) => MapEntry(k, v.toString()));
    routeName = Uri(path: routeName, queryParameters: stringParams).toString();
  }

  return navigatorKey.currentState?.pushNamed(routeName);
}

dynamic navigateToStart({
  required String routeName,
  Map<String, dynamic>? queryParams,
}) {
  if (queryParams != null) {
    routeName = Uri(path: routeName, queryParameters: queryParams).toString();
  }

  return navigatorKey.currentState?.pushNamedAndRemoveUntil(
    routeName,
    (route) => false,
  );
}

Route<dynamic> routeGenerator(RouteSettings settings) {
  var routingData = settings.name?.getRoutingData;

  switch (routingData?.route) {
    // USER, SUBADMIN ROUTES
    case '/':
      return pageRoute(const AuthPage(), settings);
    case '/choose-app':
      return pageRoute(const AppChoosePage(), settings);
    case '/choose-user-type':
      return pageRoute(const UserTypeChoosePage(), settings);
    case '/home':
      var page = routingData?['page'].toString();
      return pageRoute(HomePage(page: page), settings);
    case '/assessment-detail':
      var groupId = int.tryParse(routingData?['group_id']);
      var groupName = routingData?['group_name'].toString();

      return pageRoute(
        AssessmentDetailPage(groupId: groupId, groupName: groupName),
        settings,
      );
    case '/feedback':
      return pageRoute(const FeedbackPage(), settings);
    case '/feedback-dashboard':
      return pageRoute(const UserFeedbackDashboardPage(), settings);
    case '/feedback-list':
      var filter = routingData?['filter'].toString();
      return pageRoute(FeedbackListPage(filter: filter), settings);
    case '/feedback-assigned':
      return pageRoute(const FeedbackAssignedPage(), settings);
    case '/master-list':
      return pageRoute(const SubAdminMasterListPage(), settings);
    case '/group-detail':
      return pageRoute(const UserGroupDetailPage(), settings);
    case '/message-detail':
      return pageRoute(const UserMessageDetailPage(), settings);
    case '/admin-approval':
      return pageRoute(const AdminApprovalPage(), settings);
    case '/admin-rejected':
      return pageRoute(const AdminRejectedPage(), settings);
    case '/manage-members':
      return pageRoute(const ManageMembersPage(), settings);
    case '/reset-password':
      return pageRoute(const UserResetPasswordPage(), settings);
    case '/profile':
      return pageRoute(const ProfilePage(), settings);
    case '/group-info':
      return pageRoute(const GroupInfoPage(), settings);

    // COMMON ROUTES
    case '/privacy-policy':
      return pageRoute(const PrivacyPolicyPage(), settings);

    // ADMIN ROUTES
    case '/admin':
      return pageRoute(const LoginPage(), settings);
    case '/admin/reset-password':
      return pageRoute(const ResetPasswordPage(), settings);

    case '/admin/app-choose':
      return pageRoute(const AdminAppChoosePage(), settings);
    case '/admin/communication-dashboard':
      return pageRoute(const DashboardPage(), settings);
    case '/admin/pending-requests':
      return pageRoute(const PendingRequestsPage(), settings);

    case '/admin/users':
      return pageRoute(const UsersPage(), settings);
    case '/admin/subadmins':
      return pageRoute(const SubAdminsPage(), settings);
    case '/admin/users-and-subadmins':
      return pageRoute(const UsersAndSubAdminsPage(), settings);

    case '/admin/groups':
      return pageRoute(const GroupsPage(), settings);
    case '/admin/groups-detail':
      var groupId = int.tryParse(routingData?['group_id']);
      return pageRoute(GroupDetailPage(groupId: groupId), settings);

    case '/admin/messages':
      return pageRoute(const MessagesPage(), settings);
    case '/admin/messages-detail':
      var groupId = int.tryParse(routingData?['group_id']);
      return pageRoute(MessagesDetailPage(groupId: groupId), settings);
    case '/admin/message-detail':
      var groupId = int.tryParse(routingData?['group_id']);
      var messageId = int.tryParse(routingData?['message_id']);

      return pageRoute(
        MessageDetailPage(groupId: groupId, messageId: messageId),
        settings,
      );

    case '/admin/risk-assessment':
      return pageRoute(const RiskAssessmentPage(), settings);
    case '/admin/risk-assessment-detail':
      var groupId = int.tryParse(routingData?['group_id']);
      return pageRoute(RiskAssessmentDetailPage(groupId: groupId), settings);

    case '/admin/master-list':
      return pageRoute(const MasterListPage(), settings);
    case '/admin/other-file':
      return pageRoute(const OtherFilesPage(), settings);
    case '/admin/user-orientation':
      return pageRoute(const UserOrientationPage(), settings);
    case '/admin/edit-profile':
      return pageRoute(const EditProfilePage(), settings);

    case '/admin/feedback-dashboard':
      return pageRoute(const FeedbackDashboardPage(), settings);
    case '/admin/feedbacks':
      var color = routingData?['color'].toString();
      var status = routingData?['status'].toString();
      return pageRoute(Feedbacks(color: color, status: status), settings);
    case '/admin/feedbacks-detail':
      return pageRoute(const FeedbackDetailPage(), settings);

    case '/admin/meeting-dashboard':
      return pageRoute(const MeetingDashboardPage(), settings);

    default:
      return pageRoute(const NotFoundPage(), settings);
  }
}
