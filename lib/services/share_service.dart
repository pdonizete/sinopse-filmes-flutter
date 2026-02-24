import 'package:share_plus/share_plus.dart';

class ShareService {
  const ShareService();

  Future<void> shareText(String content) async {
    await Share.share(content);
  }
}
