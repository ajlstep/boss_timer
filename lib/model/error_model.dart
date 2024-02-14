class ErrorModel {
  Error? e;
  String? _errorString;
  ErrorModel({required this.e}) {
    _errorString = e == null ? null : e.toString();
  }
  String get err => _errorString ?? '';
}
