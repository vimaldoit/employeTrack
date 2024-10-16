import 'package:url_launcher/url_launcher.dart';

callNumber(String number) async {
  var url = Uri.parse("tel:$number");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
