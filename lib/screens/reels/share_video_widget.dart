import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class ShareVideoWidget {
  Future<void> shareTo(String videoUrl, String thumb) async {
    if (videoUrl.isEmpty) {
      print('No video URL provided');
      return;
    }

    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'content/${DateTime.now().millisecondsSinceEpoch}',
      title: 'Watch this amazing video!',
      contentDescription: 'Check out this video!',
      imageUrl: thumb,
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata('video_url', videoUrl),
    );

    BranchLinkProperties lp = BranchLinkProperties(
      channel: 'social',
      feature: 'sharing',
    );

    // Generate the short link
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);

    if (response.success) {
      // Share.share(response.result, subject: 'Check out this video!');

      CustomSocialShare().toAll(response.result ?? '');
    } else {
      print('Error generating Branch link: ${response.errorMessage}');
    }
  }
}
