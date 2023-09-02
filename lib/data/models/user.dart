/*
 name: {
        type: String,
        match: [/^[a-zA-Z ]+$/, "Name should be valid."],
        trim: true,
        required: false,
    },
    email: {
        type: String,
        match: [/^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$/, "Email should be valid."],
        trim: true,
        required: true,
        lowercase: true,
    },
    password: {
        type: String,
        trim: true,
        required: true,
    },
    verified: {
        type: Boolean,
        default: false,
    },
    phone: {
        type: String,
        match: [/^[0-9]+$/, "Phone number should be valid."],
        trim: true,
        required: false,
    },
    gender: {
        type: String,
        enum: ["male", "female", "other"],
        trim: true,
        required: false,
    },
    dateOfBirth: {
        type: Date,
        required: false,
    },
    avatar: {
        type: String,
        required: false,
    },
    status: {
        type: Boolean,
        default: true,
    },
    devices: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Device',
        required: false,
        trim: true,
    }]
  }
*/

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.verified,
    this.phone,
    this.gender = 'other',
    this.dateOfBirth,
    this.avatar,
    this.status,
    this.accessToken,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final bool? verified;
  final int? phone;
  final String gender;
  final DateTime? dateOfBirth;
  final String? avatar;
  final bool? status;
  final String? accessToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// copyWith method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    bool? verified,
    int? phone,
    String? gender,
    DateTime? dateOfBirth,
    String? avatar,
    bool? status,
    String? accessToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        verified: verified ?? this.verified,
        phone: phone ?? this.phone,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        avatar: avatar ?? this.avatar,
        status: status ?? this.status,
        accessToken: accessToken ?? this.accessToken,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// fromJson method
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['_id']?.toString(),
        name: json['name']?.toString(),
        email: json['email']?.toString(),
        password: json['password']?.toString(),
        verified: json['verified'],
        phone: int.tryParse('${json['phone']}'),
        gender: json['gender']?.toString() ?? 'other',
        dateOfBirth: DateTime.tryParse('${json['dateOfBirth']}'),
        avatar: json['avatar']?.toString(),
        status: json['status'],
        accessToken: json['accessToken']?.toString(),
        createdAt: DateTime.tryParse('${json['createdAt']}'),
        updatedAt: DateTime.tryParse('${json['updatedAt']}'),
      );

  /// toJson method
  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'password': password,
        'verified': verified,
        'phone': phone,
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'avatar': avatar,
        'status': status,
        'accessToken': accessToken,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// entity method
  /// name, verified, phone, gender, dateOfBirth, status
  Map<String, dynamic> get entity => {
        'name': name,
        'verified': verified,
        'phone': phone,
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'avatar': avatar,
        'status': status,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        verified,
        phone,
        gender,
        dateOfBirth,
        avatar,
        status,
        accessToken,
        createdAt,
        updatedAt,
      ];
}
