import 'package:flutter/material.dart';

class BadgedIconButton extends StatelessWidget {
  const BadgedIconButton({
    super.key,
    required this.noBadgeIcon,
    required this.badgeIcon,
    required this.onPressed,
    this.badge,
    this.size = 40,
    this.iconSize = 24,
    this.tapRadius = 24,
    this.badgeOffset = const Offset(-4, 4),
    this.enabledColor,
    this.disabledColor,
  });

  final Widget noBadgeIcon;
  final Widget badgeIcon;
  final VoidCallback? onPressed;
  final Object? badge;
  final double size;
  final double iconSize;
  final double tapRadius;
  final Offset badgeOffset;
  final Color? enabledColor;
  final Color? disabledColor;

  bool get _isEnabled => onPressed != null;
  bool get _hasBadge => badge != null;

  @override
  Widget build(BuildContext context) {
    final Object? badge = this.badge;
    final Color iconColor = _resolveIconColor(context);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        SizedBox(
          width: size,
          height: size,
          child: InkResponse(
            onTap: onPressed,
            radius: tapRadius,
            child: Center(
              child: SizedBox(
                width: iconSize,
                height: iconSize,
                child: IconTheme.merge(
                  data: IconThemeData(size: iconSize, color: iconColor),
                  child: _hasBadge ? badgeIcon : noBadgeIcon,
                ),
              ),
            ),
          ),
        ),
        if (_isEnabled && badge != null)
          Positioned(
            top: badgeOffset.dy,
            right: badgeOffset.dx,
            child: IgnorePointer(child: BadgedIconButtonBadge(content: badge)),
          ),
      ],
    );
  }

  Color _resolveIconColor(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (!_isEnabled) {
      return disabledColor ?? colorScheme.onSurface.withValues(alpha: 0.38);
    }
    return enabledColor ?? colorScheme.onSurface;
  }
}

class BadgedIconButtonBadge extends StatelessWidget {
  const BadgedIconButtonBadge({super.key, required this.content})
    : assert(content is String || content is Widget);

  final Object content;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      child: _buildChild(theme),
    );
  }

  Widget _buildChild(ThemeData theme) {
    final Object content = this.content;
    if (content is Widget) {
      return content;
    }
    return Text(
      content as String,
      textAlign: TextAlign.center,
      style: theme.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 8,
        height: 1,
      ),
    );
  }
}
