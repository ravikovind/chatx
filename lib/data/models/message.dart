/*
{
    message: {
        type: String,
        trim: true,
        default: "New message",
        required: false,
    },
    type: {
        type: String,
        enum: ["message", "image", "video", "audio", "document", "location", "contact", "sticker", "gif"],
        default: "message",
        trim: true,
        required: false,
    },
    status: {
        type: String,
        enum: ["sent", "delivered", "read"],
        default: "sent",
        trim: true,
        required: false,
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        trim: true,
    },
    receivers: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        trim: true,
    }],
    deleted: {
        type: Boolean,
        default: false,
        required: false,
    },
}
*/

import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    this.id,
    this.message,
    this.type,
    this.status,
    this.sender,
    this.receivers,
    this.deleted,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? message;
  final String? type;
  final String? status;
  final String? sender;
  final List<String>? receivers;
  final bool? deleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// factory constructor to create a `Message` instance from a json
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['_id']?.toString(),
        message: json['message']?.toString(),
        type: json['type']?.toString(),
        status: json['status']?.toString(),
        sender: json['sender']?.toString(),
        receivers: List<String>.from(
          json['receivers']?.map((x) => x.toString()) ?? <String>[],
        ),
        // deleted: json['deleted']?.toString() == 'true',
        // createdAt: DateTime.tryParse('${json['createdAt']}'),
        // updatedAt: DateTime.tryParse('${json['updatedAt']}'),
      );

  /// convert a `Message` instance to a json\map
  Map<String, dynamic> toJson() => {
        '_id': id,
        'message': message,
        'type': type,
        'status': status,
        'sender': sender,
        'receiver': receivers?.map((x) => x).toList() ?? <String>[],
        // 'deleted': deleted,
        // 'createdAt': createdAt?.toIso8601String(),
        // 'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        message,
        type,
        status,
        sender,
        receivers,
        deleted,
        createdAt,
        updatedAt,
      ];
}
