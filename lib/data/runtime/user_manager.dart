import 'package:flutter/material.dart';

class UserManager {
  final String nick;
  final String email;
  ValueNotifier<List<String>> friends;
  ValueNotifier<List<String>> friendRequests;

  UserManager._({
    required this.nick,
    required this.email,
    required this.friends,
    required this.friendRequests,
  });

  factory UserManager.fromJson(Map<String, dynamic> json) {
    return UserManager._(
      nick: json['nick'],
      email: json['email'],
      friends: ValueNotifier(List.from(json['friends'])),
      friendRequests: ValueNotifier(List.from(json['friendRequests'])),
    );
  }

  void addFriend(String friend) {
    final newFriends = [...friends.value, friend];
    friends.value = newFriends;
  }

  void addFriendRequest(String friend) {
    final newFriendRequests = [...friendRequests.value, friend];
    friendRequests.value = newFriendRequests;
  }
}
