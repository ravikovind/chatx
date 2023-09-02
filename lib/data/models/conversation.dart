/*
{
        participants: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: "User",
                required: true,
            },
        ],
        messages: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: "Message",
                required: false,
            },
        ],
        type: {
            type: String,
            enum: ["private", "group"],
            default: "private",
            trim: true,
            required: false,
        },
        name: {
            type: String,
            trim: true,
            required: false,
            default: null,
        },
        description: {
            type: String,
            trim: true,
            required: false,
            default: null,
        },
        avatar: {
            type: String,
            trim: true,
            required: false,
            default: null,
        },
        status: {
            type: Boolean,
            default: true,
            required: false,
        },
        createdBy: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User",
            required: false,
        },
    }
*/

import 'package:chatx/data/models/user.dart';
import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  const Conversation({
    this.id,
    this.participants,
    this.type,
    this.name,
    this.description,
    this.avatar,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
  final String? id;
  final List<User>? participants;
  final String? type;
  final String? name;
  final String? description;
  final String? avatar;
  final bool? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// [fromJson] method is used to convert a json object to a [Conversation] instance.
  /// [json] is the json object that needs to be converted.

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id']?.toString(),
      participants: List<User>.from(
        json['participants']?.map((x) => User.fromJson(x)) ?? <User>[],
      ),
      type: json['type']?.toString() == 'group' ? 'group' : 'private',
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      avatar: json['avatar']?.toString(),
      status: json['status']?.toString() == 'true' ? true : false,
      createdAt: DateTime.tryParse('${json['createdAt']}'),
      updatedAt: DateTime.tryParse('${json['updatedAt']}'),
    );
  }

  /// [toJson] method is used to convert a [Conversation] instance to json object.
  /// [conversation] is the [Conversation] instance that needs to be converted.

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants?.map((x) => x.toJson()).toList(),
      'type': type,
      'name': name,
      'description': description,
      'avatar': avatar,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// entity

  Map<String, dynamic> get entity {
    return {
      'participants': participants?.map((x) => '${x.id}').toList(),
      'type': type,
    };
  }

  @override
  List<Object?> get props => [
        id,
        participants,
        type,
        name,
        description,
        avatar,
        status,
        createdAt,
        updatedAt,
      ];
}
