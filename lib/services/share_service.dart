import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareText(String text) {
    return Share.share(text);
  }
}
