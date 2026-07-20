import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Uri? resourceLinkUri(String rawUrl) {
  final String cleaned = rawUrl
      .replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')
      .trim();

  if (cleaned.isEmpty) {
    return null;
  }

  final Uri? initialUri = Uri.tryParse(cleaned);
  if (initialUri == null) {
    return null;
  }

  final String normalized = initialUri.hasScheme
      ? cleaned
      : cleaned.startsWith('//')
          ? 'https:$cleaned'
          : 'https://$cleaned';

  final Uri? sanitizedUri = Uri.tryParse(normalized);
  if (sanitizedUri == null || sanitizedUri.host.trim().isEmpty) {
    return null;
  }

  return sanitizedUri;
}

Future<bool> launchResourceLink(String rawUrl) async {
  try {
    final Uri? sanitizedUri = resourceLinkUri(rawUrl);
    if (sanitizedUri == null) {
      debugPrint('Unable to launch resource link: invalid URL "$rawUrl"');
      return false;
    }

    final Uri uri = _driveWebUri(rawUrl, sanitizedUri);

    final bool openedWithNonBrowserApp = await _tryLaunchResourceUri(
      uri,
      LaunchMode.externalNonBrowserApplication,
      rawUrl,
    );
    if (openedWithNonBrowserApp) {
      return true;
    }

    return _tryLaunchResourceUri(
      uri,
      LaunchMode.externalApplication,
      rawUrl,
    );
  } catch (error, stackTrace) {
    debugPrint('Unable to launch resource link "$rawUrl": $error');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}

Future<bool> _tryLaunchResourceUri(
  Uri uri,
  LaunchMode mode,
  String rawUrl,
) async {
  try {
    return await launchUrl(
      uri,
      mode: mode,
      webOnlyWindowName: '_blank',
    );
  } catch (error) {
    debugPrint('Unable to launch resource link "$rawUrl" with $mode: $error');
    return false;
  }
}

Uri _driveWebUri(String rawUrl, Uri uri) {
  if (!rawUrl.toLowerCase().contains('drive.google.com')) {
    return uri;
  }

  return uri.replace(
    scheme: 'https',
    host: uri.host.isEmpty ? 'drive.google.com' : uri.host,
  );
}
