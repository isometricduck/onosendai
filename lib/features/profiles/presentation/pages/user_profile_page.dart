import 'package:cyberspace_client/cyberspace_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:onosendai/core/images/images.dart';
import 'package:onosendai/features/profiles/presentation/riverpod/profile_providers.dart';
import 'package:onosendai/features/theme/cyber_theme.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.cyberTheme;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final profileAsync = ref.watch(currentUserProfileProvider);

    final body = ColoredBox(
      color: theme.pageBackground,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(currentUserProfileProvider.future),
              child: profileAsync.when(
                loading: () =>
                    const _ScrollableCenter(child: CircularProgressIndicator()),
                error: (error, _) => _ProfileError(
                  showInlineHeader: !isMobile,
                  onRetry: () => ref.invalidate(currentUserProfileProvider),
                ),
                data: (profile) => _ProfileContent(
                  profile: profile,
                  showInlineHeader: !isMobile,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!isMobile) {
      return Scaffold(backgroundColor: theme.pageBackground, body: body);
    }

    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(
        backgroundColor: theme.pageBackground,
        foregroundColor: theme.headingText,
        surfaceTintColor: theme.pageBackground,
        title: Text(
          'PROFILE',
          style: theme.mainFont.copyWith(
            color: theme.headingText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: body,
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserProfile profile;
  final bool showInlineHeader;

  const _ProfileContent({
    required this.profile,
    required this.showInlineHeader,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;
    final joinedAt = profile.createdAt;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
      children: [
        if (showInlineHeader) const _InlineHeader(),
        if (showInlineHeader) const SizedBox(height: 28),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: theme.cardBorder),
            color: theme.cardBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ProfilePicture(url: profile.profilePictureUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '@${profile.username}',
                        style: theme.mainFont.copyWith(
                          color: theme.headingText,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (_hasText(profile.bio)) ...[
                        const SizedBox(height: 6),
                        Text(
                          profile.bio!.trim(),
                          style: theme.mainFont,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _ProfileFields(
          fields: [
            if (_hasText(profile.websiteName) || _hasText(profile.websiteUrl))
              _ProfileField(
                'Website',
                _joinWebsite(profile.websiteName, profile.websiteUrl),
              ),
            if (_hasText(profile.locationName))
              _ProfileField('Location', profile.locationName!),
            if (joinedAt != null)
              _ProfileField('Joined', _formatDate(joinedAt)),
            _ProfileField('Followers', profile.followersCount.toString()),
            _ProfileField('Following', profile.followingCount.toString()),
          ],
        ),
      ],
    );
  }
}

class _ProfilePicture extends StatelessWidget {
  static const _size = 72.0;

  final String? url;

  const _ProfilePicture({required this.url});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: theme.cardBorder)),
      child: SizedBox.square(
        dimension: _size,
        child: _hasText(url)
            ? ClipRect(
                child: ShadedNetworkImage(
                  url: url!.trim(),
                  fit: BoxFit.cover,
                  width: _size,
                  height: _size,
                  effect: theme.imageShaderEffect,
                  fallbackColor: theme.headingText,
                  placeholderBuilder: (_) => _ProfilePictureFallback(
                    icon: LucideIcons.user,
                    color: theme.metaText,
                  ),
                  errorBuilder: (_) => _ProfilePictureFallback(
                    icon: LucideIcons.userX,
                    color: theme.metaText,
                  ),
                ),
              )
            : _ProfilePictureFallback(
                icon: LucideIcons.user,
                color: theme.metaText,
              ),
      ),
    );
  }
}

class _ProfilePictureFallback extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _ProfilePictureFallback({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(child: Icon(icon, color: color, size: 28));
  }
}

class _ProfileFields extends StatelessWidget {
  final List<_ProfileField> fields;

  const _ProfileFields({required this.fields});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.cardBorder),
        color: theme.cardBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            for (var index = 0; index < fields.length; index++) ...[
              _ProfileFieldRow(field: fields[index]),
              if (index != fields.length - 1)
                Divider(color: theme.cardBorder, height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileFieldRow extends StatelessWidget {
  final _ProfileField field;

  const _ProfileFieldRow({required this.field});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              field.label,
              style: theme.mainFont.copyWith(
                color: theme.metaText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              field.value,
              style: theme.mainFont.copyWith(color: theme.headingText),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final bool showInlineHeader;
  final VoidCallback onRetry;

  const _ProfileError({required this.showInlineHeader, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
      children: [
        if (showInlineHeader) const _InlineHeader(),
        if (showInlineHeader) const SizedBox(height: 120),
        Center(
          child: Column(
            children: [
              Text(
                'Could not load profile.',
                style: theme.mainFont.copyWith(color: theme.headingText),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScrollableCenter extends StatelessWidget {
  final Widget child;

  const _ScrollableCenter({required this.child});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.55,
          child: Center(child: child),
        ),
      ],
    );
  }
}

class _InlineHeader extends StatelessWidget {
  const _InlineHeader();

  @override
  Widget build(BuildContext context) {
    final theme = context.cyberTheme;

    return Row(
      children: [
        Icon(LucideIcons.user, color: theme.headingText),
        const SizedBox(width: 10),
        Text(
          'Profile',
          style: theme.mainFont.copyWith(
            color: theme.headingText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProfileField {
  final String label;
  final String value;

  const _ProfileField(this.label, this.value);
}

String _joinWebsite(String? name, String? url) {
  final values = [
    if (_hasText(name)) name!.trim(),
    if (_hasText(url)) url!.trim(),
  ];
  return values.join(' - ');
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

String _formatDate(DateTime value) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final local = value.toLocal();
  return '${months[local.month - 1]} ${local.day}, ${local.year}';
}
