class UserPermissions {
  final bool? canUserCreatePosts;
  final bool? canUserManagePosts;
  final bool? canUserCreateWork;
  final bool? canUserManageWork;
  final bool? canUserCreateNotifications;
  final bool? canUserManageNotifications;
  final bool? canUserViewProfileData;
  final bool? canUserManagePermissions;

  UserPermissions({
    this.canUserCreatePosts,
    this.canUserManagePosts,
    this.canUserCreateWork,
    this.canUserManageWork,
    this.canUserCreateNotifications,
    this.canUserManageNotifications,
    this.canUserViewProfileData,
    this.canUserManagePermissions,
  });
}