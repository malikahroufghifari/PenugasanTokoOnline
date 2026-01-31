class ResponseDataMap {
bool status;
String message;
Map? data;
String? role;
ResponseDataMap({required this.status, required this.message, this.data, this.role});
}