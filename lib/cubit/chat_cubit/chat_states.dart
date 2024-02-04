abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class ChatGetChatsSuccessState extends ChatStates {}

class ChatSendMessageSuccessState extends ChatStates {}

class ChatSendMessageErrorState extends ChatStates {}

class ChatGetMessageSuccessState extends ChatStates {}

class ChatGetMessageErrorState extends ChatStates {}
