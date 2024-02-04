abstract class PostStates {}

class PostInitialState extends PostStates {}

class PostChangeBottomNavState extends PostStates {}

class PostNewPostState extends PostStates {}

class PostCreatePostLoadingState extends PostStates {}

class PostCreatePostSuccessState extends PostStates {}

class PostCreatePostErrorState extends PostStates {}

class PostImagePickedLoadingState extends PostStates {}

class PostImagePickedSuccessState extends PostStates {}

class PostImagePickedErrorState extends PostStates {}

class PostRemovePostImageState extends PostStates {}

class PostRemoveUploadedPostImageState extends PostStates {}

class PostGetPostsLoadingState extends PostStates {}

class PostGetPostsSuccessState extends PostStates {}

class PostEditCommentLoadingState extends PostStates {}

class PostEditCommentSuccessState extends PostStates {}

class PostEditCommentErrorState extends PostStates {
  final String error;

  PostEditCommentErrorState(this.error);
}

class PostGetPostsErrorState extends PostStates {}

class PostEditPostLoadingState extends PostStates {}

class PostEditPostSuccessState extends PostStates {}

class PostEditPostErrorState extends PostStates {
  final String error;

  PostEditPostErrorState(this.error);
}

class PostDeletePostLoadingState extends PostStates {}

class PostDeleteCommentSuccessState extends PostStates {}

class PostDeleteCommentErrorState extends PostStates {
  final String error;

  PostDeleteCommentErrorState(this.error);
}

class PostDeletePostSuccessState extends PostStates {}

class PostDeletePostErrorState extends PostStates {
  final String error;

  PostDeletePostErrorState(this.error);
}

class PostLikePostSuccessState extends PostStates {}

class PostLikePostErrorState extends PostStates {
  final String error;

  PostLikePostErrorState(this.error);
}

class PostCommentOnPostSuccessState extends PostStates {}

class PostCommentOnPostErrorState extends PostStates {
  final String error;

  PostCommentOnPostErrorState(this.error);
}

class PostGetCommentSuccessState extends PostStates {}

class PostGetCommentErrorState extends PostStates {}

class PostSearchOnSubmitState extends PostStates {}

class PostSearchOnChangeState extends PostStates {}

class PostSearchOnTapState extends PostStates {}
