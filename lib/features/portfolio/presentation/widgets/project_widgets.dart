import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ds_core/ds_core.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/core_strings.dart';

class ProjectImageCarousel extends StatelessWidget {
  const ProjectImageCarousel({super.key, required this.images, this.height = 280});

  final List<String> images;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            images[i],
            height: height,
            fit: BoxFit.contain,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) return child;
              return SizedBox(
                width: height * 0.65,
                child: DsShimmer(
                  child: ShimmerBlock(height: height, borderRadius: 0),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProjectLinksRow extends StatelessWidget {
  const ProjectLinksRow({super.key, required this.links});

  final Map<String, String> links;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: links.entries
          .map(
            (e) => DsButton(
              label: _label(e.key),
              variant: DsButtonVariant.ghost,
              trailing: const Icon(
                Icons.open_in_new_rounded,
                size: 13,
                color: AppColors.muted,
              ),
              onTap: () => launchUrl(
                Uri.parse(e.value),
                mode: LaunchMode.externalApplication,
              ),
            ),
          )
          .toList(),
    );
  }

  String _label(String key) => switch (key) {
        CoreStrings.linkKeyGithub => AppStrings.linkLabelGithub,
        CoreStrings.linkKeyDownload => AppStrings.linkLabelDownload,
        CoreStrings.linkKeyDemo => AppStrings.linkLabelLiveDemo,
        CoreStrings.linkKeyPlaystore => AppStrings.linkLabelPlayStore,
        CoreStrings.linkKeyAppstore => AppStrings.linkLabelAppStore,
        _ => '${key[0].toUpperCase()}${key.substring(1)}',
      };
}
