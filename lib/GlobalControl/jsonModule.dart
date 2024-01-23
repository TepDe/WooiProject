class JsonModule {
  toTelegramString(data) {
    return "${data['uid'] ?? "មិនមាន"} = uid \n" +
        "${data['location'] ?? "មិនមាន"} = location \n" +
        "${data['pushKey'] ?? "មិនមាន"} = pushKey \n" +
        "${data['phoneNumber'] ?? "មិនមាន"} = Receiver phoneNumber \n" +
        "${data['latitude'] ?? "មិនមាន"} = latitude \n" +
        "${data['longitude'] ?? "មិនមាន"} = longitude \n" +
        "${data['date'] ?? "មិនមាន"} = date \n" +
        "${data['qty'] ?? "មិនមាន"} = qty \n" +
        "${data['packageID'] ?? "មិនមាន"} = packageID \n" +
        "${data['note'] ?? "មិនមាន"} = note \n" +
        "${data['status'] ?? "មិនមាន"} = status \n" +
        "${data['price'] ?? "មិនមាន"} = price \n" +
        "${data['recLatitude'] ?? "មិនមាន"} = recLatitude \n" +
        "${data['recLongitude'] ?? "មិនមាន"} = recLongitude \n" +
        "${data['returnDate'] ?? "មិនមាន"} = returnDate \n" +
        "${data['returnNote'] ?? "មិនមាន"} = returnNote \n" +
        "${data['dLastName'] ?? "មិនមាន"} = dLastName \n" +
        "${data['dFirstName'] ?? "មិនមាន"} = dFirstName \n" +
        "${data['dPhone'] ?? "មិនមាន"} = dPhone \n" +
        "${data['assignBy'] ?? "មិនមាន"} = assignBy \n" +
        "${data['workStatus'] ?? "មិនមាន"} = workStatus \n" +
        "${data['driverUID'] ?? "មិនមាន"} = driverUID \n" +
        "${data['completeDate'] ?? "មិនមាន"} = completeDate \n" +
        "${data['senderPhone'] ?? "មិនមាន"} = senderPhone \n" +
        "${data['senderName'] ?? "មិនមាន"} = senderName \n" +
        "${data['token'] ?? "មិនមាន"} = token \n" +
        "${data['chatid'] ?? "មិនមាន"} = chatid \n" +
        "${data['ABACode'] ?? "មិនមាន"} = ABACode \n"+
        "${data['rielPrice'] ?? "មិនមាន"} = rielPrice \n";
  }
}
