import 'package:flutter/foundation.dart';

class UserProfileData {
  const UserProfileData({
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.gender,
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.nin,
    required this.emergencyName,
    required this.emergencyPhone,
    this.avatarBytes,
  });

  final String name, phone, email, dob, gender;
  final String bloodType, allergies, chronicConditions, nin;
  final String emergencyName, emergencyPhone;
  final Uint8List? avatarBytes;

  UserProfileData copyWith({
    String? name, String? phone, String? email, String? dob, String? gender,
    String? bloodType, String? allergies, String? chronicConditions, String? nin,
    String? emergencyName, String? emergencyPhone,
    Uint8List? avatarBytes, bool clearAvatar = false,
  }) => UserProfileData(
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    bloodType: bloodType ?? this.bloodType,
    allergies: allergies ?? this.allergies,
    chronicConditions: chronicConditions ?? this.chronicConditions,
    nin: nin ?? this.nin,
    emergencyName: emergencyName ?? this.emergencyName,
    emergencyPhone: emergencyPhone ?? this.emergencyPhone,
    avatarBytes: clearAvatar ? null : (avatarBytes ?? this.avatarBytes),
  );
}

class UserProfile extends ValueNotifier<UserProfileData> {
  UserProfile._() : super(const UserProfileData(
    name: 'John Doe',
    phone: '+255 712 345 678',
    email: 'john.doe@afyahub.co.tz',
    dob: '15 Mar 1990',
    gender: 'Male',
    bloodType: 'O+',
    allergies: 'None',
    chronicConditions: 'None',
    nin: '',
    emergencyName: 'Jane Doe',
    emergencyPhone: '+255 698 765 432',
  ));

  static final UserProfile instance = UserProfile._();
  void update(UserProfileData data) => value = data;
  String get firstName => value.name.trim().split(' ').first;
}
