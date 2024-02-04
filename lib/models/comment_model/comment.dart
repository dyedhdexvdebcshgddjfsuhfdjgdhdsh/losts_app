import 'package:social_app/models/comment_model/comment_model.dart';

class MainComment extends CommentModel {
  final String commentId;

  MainComment.fromJson({
    required Map<String, dynamic> json,
    required this.commentId,
  }) : super.fromJson(json);
}
