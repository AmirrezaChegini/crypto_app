class AppException implements Exception {
  final String _message;
  AppException(this._message);
  String get message => _message;
}

class BadRequestEx extends AppException {
  BadRequestEx({String? message})
      : super(message ?? 'Data has been entered incoorectly');
}

class NotAuthEx extends AppException {
  NotAuthEx({String? message}) : super(message ?? 'Youare not authorized');
}

class ForbiddexnEx extends AppException {
  ForbiddexnEx({String? message}) : super(message ?? 'You have not permission');
}

class NotFoundEx extends AppException {
  NotFoundEx({String? message}) : super(message ?? 'No data found');
}

class NotMethodAllowEx extends AppException {
  NotMethodAllowEx({String? message})
      : super(message ?? 'This method for request not allowed');
}

class ServerEx extends AppException {
  ServerEx({String? message})
      : super(message ?? 'There is a problem from server');
}

class FetchDataEx extends AppException {
  FetchDataEx({String? message})
      : super(message ?? 'Your internet is not connected');
}
