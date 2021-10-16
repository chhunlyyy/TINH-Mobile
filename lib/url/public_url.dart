class PublicUrl {
  final String _url = 'http://192.168.100.3:8000'; // local url
  final String _apiString = '/mobile/';
  String getUrl() {
    return _url + _apiString;
  }
}
