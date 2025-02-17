import 'dart:convert';

import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

import '../../model/success_models/home_post_success_model.dart';

class ShareVideoWidget {
  Future<void> shareTo(PostsListData post) async {
    if (post.postVideo!.isEmpty) {
      print('No video URL provided');
      return;
    }

    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'content/${post.postId}',
      contentDescription: post.postDescription ?? '',
      imageUrl: post.postImage ?? '',
      contentMetadata: BranchContentMetaData()
        ..addCustomMetadata("post_id", post.postId),
    );

    BranchLinkProperties linkProperties = BranchLinkProperties(
      channel: 'app',
      feature: 'share',
      campaign: 'video_sharing',
      stage: 'new',
    );

    BranchResponse response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: linkProperties,
    );

    if (response.success) {
      String branchLink = response.result ?? '';
      print('Generated Branch Link: $branchLink');

      // Share the link
      CustomSocialShare().toAll(branchLink);
    } else {
      print('Error generating Branch link: ${response.errorMessage}');
    }
  }
}
