import 'package:flutter/material.dart';
import '../models/resource_model.dart';
import '../utils/resource_link_launcher.dart';

class ResourceItem extends StatelessWidget {
  final ResourceModel resource;
  final VoidCallback onDelete;

  const ResourceItem({super.key, required this.resource, required this.onDelete});

  IconData get _icon {
    if (_isUrlResource) {
      return Icons.link_rounded;
    }
    if (resource is MediaResource) {
      return Icons.image_rounded;
    }
    final String docType = resource is DocumentResource
        ? (resource as DocumentResource).docType.toLowerCase()
        : '';
    if (docType == 'pdf') {
      return Icons.picture_as_pdf_rounded;
    }
    return Icons.description_rounded;
  }

  bool get _isUrlResource {
    return resource is LinkResource ||
        (resource is MediaResource &&
            (resource as MediaResource).platform.toLowerCase() == 'url');
  }

  bool get _isLink => _isUrlResource;

  String get _resourceUrl {
    if (resource is LinkResource) {
      return (resource as LinkResource).linkUrl;
    }
    if (resource is MediaResource) {
      return (resource as MediaResource).mediaUrl;
    }
    if (resource is DocumentResource) {
      return (resource as DocumentResource).fileUrl;
    }
    return '';
  }

  String get _subtitle {
    if (_isLink) {
      return _resourceUrl;
    }
    if (resource is DocumentResource) {
      return (resource as DocumentResource).docType.toUpperCase();
    }
    if (resource is MediaResource) {
      return (resource as MediaResource).platform;
    }
    return resource.contentType;
  }

  Future<void> _openResource(BuildContext context) async {
    if (_resourceUrl.trim().isEmpty) {
      return;
    }

    final bool opened = await launchResourceLink(_resourceUrl);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open resource.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _isLink ? () => _openResource(context) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF000080).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: const Color(0xFF000080), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    _subtitle,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      color: _isLink
                          ? const Color(0xFF000080)
                          : const Color(0xFF94A3B8),
                      decoration: _isLink
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _openResource(context),
              icon: Icon(
                _isLink ? Icons.open_in_new_rounded : Icons.download_rounded,
                color: const Color(0xFF000080),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.delete_outline_rounded,
                  color: Color(0xFFEF4444), size: 20),
            ),
          ],
        ),
      ),
    );
  }
}


