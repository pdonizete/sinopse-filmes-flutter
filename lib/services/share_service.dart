import 'package:share_plus/share_plus.dart';

abstract class ShareService {
  Future<void> shareText(String text);
}

class SystemShareService implements ShareService {
  @override
  Future<void> shareText(String text) {
    return SharePlus.instance.share(ShareParams(text: text));
  }
}
