import 'dart:io';
import 'dart:convert';

main() {
  var destinationAddress = InternetAddress("192.168.1.255");

  RawDatagramSocket.bind(InternetAddress.anyIPv4, 2221)
      .then((RawDatagramSocket udpSocket) {
    udpSocket.broadcastEnabled = true;
    udpSocket.listen((e) {
      Datagram? dg = udpSocket.receive();
      if (dg != null) {
        String s = new String.fromCharCodes(dg.data);
        if (s == "IAM") {
          print("Server found on ${dg.address.address}");
          udpSocket.close();
        }
      }
    });

    print("Looking for the server...");
    List<int> data = utf8.encode('WHOISBRAIN');
    udpSocket.send(data, destinationAddress, 2222);
  });
}
