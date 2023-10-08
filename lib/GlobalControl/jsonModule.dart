class JsonModule {
  toTelegramString(data) {
    return "uid = ${data['uid'] ?? ""}\n" +
        "location = ${data['location'] ?? ""}\n" +
        "pushKey = ${data['pushKey'] ?? ""}\n" +
        "phoneNumber = ${data['phoneNumber'] ?? ""}\n" +
        "token = ${data['token'] ?? ""}\n" +
        "chatid = ${data['chatid'] ?? ""}\n" +
        "latitude = ${data['latitude'] ?? ""}\n" +
        "longitude = ${data['longitude'] ?? ""}\n" +
        "date = ${data['date'] ?? ""}\n" +
        "qty = ${data['qty'] ?? ""}\n" +
        "packageID = ${data['packageID'] ?? ""}\n" +
        "note = ${data['note'] ?? ""}\n" +
        "status = ${data['status'] ?? ""}\n" +
        "price = ${data['price'] ?? ""}\n" +
        "recLatitude = ${data['recLatitude'] ?? ""}\n" +
        "recLongitude = ${data['recLongitude'] ?? ""}\n" +
        "returnDate = ${data['returnDate'] ?? ""}\n" +
        "returnNote = ${data['returnNote'] ?? ""}\n" +
        "dLastName = ${data['dLastName'] ?? ""}\n" +
        "dFirstName = ${data['dFirstName'] ?? ""}\n" +
        "dPhone = ${data['dPhone'] ?? ""}\n" +
        "assignBy = ${data['assignBy'] ?? ""}\n" +
        "workStatus = ${data['workStatus'] ?? ""}\n" +
        "driverUID = ${data['driverUID'] ?? ""}\n" +
        "completeDate = ${data['completeDate'] ?? ""}\n" +
        "senderPhone = ${data['senderPhone'] ?? ""}\n" +
        "senderName = ${data['senderName'] ?? ""}\n" +
        "ABACode = ${data['ABACode'] ?? ""}\n";
  }
}
