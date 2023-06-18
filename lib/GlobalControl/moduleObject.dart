class ModuleObject {
  late String uid="uid";
  late String location="location";
  late String pushKey="pushKey";
  late String phoneNumber="phoneNumber";
  late String token="token";
  late String chatid="chatid";
  late String latitude="latitude";
  late String longitude="longitude";
  late String date="date";
  late String qty="qty";
  late String packageID="packageID";
  late String note="note";
  late String status="status";
  late String price="price";
  late String recLatitude="recLatitude";
  late String recLongitude="recLongitude";
  late String returnDate="returnDate";
  late String returnNote="returnNote";
  late String dLastName="dLastName";
  late String dFirstName="dFirstName";
  late String dPhone="dPhone";
  late String assignBy="assignBy";
  late String workStatus="workStatus";
  late String driverUID="driverUID";
  late String completeDate="completeDate";
  late String senderPhone="senderPhone";
  late String senderName="senderName";
  late String ABACode="ABACode";

  toJson(data) {
    return {
      'uid': data['uid'],
      'location': data['location'],
      'pushKey': data['pushKey'],
      'phoneNumber': data['phoneNumber'],
      'token': data['token'],
      'chatid': data['chatid'],
      'latitude': data['latitude'],
      'longitude': data['longitude'],
      'date': data['date'],
      'qty': data['qty'],
      'packageID': data['packageID'],
      'note': data['note'],
      'status': data['status'],
      'price': data['price'],
      'recLatitude': data['recLatitude'],
      'recLongitude': data['recLongitude'],
      'returnDate': data['returnDate'],
      'returnNote': data['returnNote'],
      'dLastName': data['dLastName'],
      'dFirstName': data['dFirstName'],
      'dPhone': data['dPhone'],
      'assignBy': data['assignBy'],
      'workStatus': data['workStatus'],
      'driverUID': data['driverUID'],
      'completeDate': data['completeDate'],
      'senderPhone': data['senderPhone'],
      'senderName': data['senderName'],
      'ABACode': data['ABACode'],
    };
  }
}
