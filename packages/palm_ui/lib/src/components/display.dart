import 'package:flutter/material.dart';

import '../theme/palm_ui_theme.dart';

class PalmUICard extends StatelessWidget {
  const PalmUICard({
    super.key,
    this.child,
    this.title,
    this.description,
    this.footer,
  });

  final Widget? child;
  final Widget? title;
  final Widget? description;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              DefaultTextStyle(
                style: TextStyle(
                  color: theme.cardForeground,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                child: title!,
              ),
            if (description != null) ...[
              const SizedBox(height: 4),
              DefaultTextStyle(
                style: TextStyle(color: theme.mutedForeground, fontSize: 14),
                child: description!,
              ),
            ],
            if (child != null) ...[
              if (title != null || description != null)
                const SizedBox(height: 12),
              DefaultTextStyle(
                style: TextStyle(color: theme.cardForeground, fontSize: 14),
                child: child!,
              ),
            ],
            if (footer != null) ...[const SizedBox(height: 12), footer!],
          ],
        ),
      ),
    );
  }
}

enum PalmUIBadgeVariant { primary, secondary, destructive, outline }

class PalmUIBadge extends StatelessWidget {
  const PalmUIBadge({
    super.key,
    required this.child,
    this.variant = PalmUIBadgeVariant.primary,
  });

  final Widget child;
  final PalmUIBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final (background, foreground, border) = switch (variant) {
      PalmUIBadgeVariant.primary => (
        theme.primary,
        theme.primaryForeground,
        theme.primary,
      ),
      PalmUIBadgeVariant.secondary => (
        theme.secondary,
        theme.secondaryForeground,
        theme.secondary,
      ),
      PalmUIBadgeVariant.destructive => (
        theme.destructive,
        theme.destructiveForeground,
        theme.destructive,
      ),
      PalmUIBadgeVariant.outline => (
        Colors.transparent,
        theme.foreground,
        theme.border,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: DefaultTextStyle(
          style: TextStyle(
            color: foreground,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          child: child,
        ),
      ),
    );
  }
}

class PalmUIAvatar extends StatelessWidget {
  const PalmUIAvatar({super.key, this.fallback, this.image, this.size = 40});

  final Widget? fallback;
  final ImageProvider? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.muted,
        shape: BoxShape.circle,
        image: image == null
            ? null
            : DecorationImage(image: image!, fit: BoxFit.cover),
      ),
      child: image == null
          ? DefaultTextStyle(
              style: TextStyle(
                color: theme.foreground,
                fontWeight: FontWeight.w600,
              ),
              child: fallback ?? const SizedBox.shrink(),
            )
          : null,
    );
  }
}

enum PalmUIAlertVariant { neutral, destructive }

class PalmUIAlert extends StatelessWidget {
  const PalmUIAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.variant = PalmUIAlertVariant.neutral,
  });

  final Widget title;
  final Widget? description;
  final IconData? icon;
  final PalmUIAlertVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final color = variant == PalmUIAlertVariant.destructive
        ? theme.destructive
        : theme.foreground;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(
          color: variant == PalmUIAlertVariant.destructive
              ? theme.destructive
              : theme.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon ?? Icons.info_outline, color: color, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    child: title,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle(
                      style: TextStyle(
                        color: theme.mutedForeground,
                        fontSize: 14,
                      ),
                      child: description!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PalmUISeparator extends StatelessWidget {
  const PalmUISeparator({super.key, this.axis = Axis.horizontal});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final color = PalmUITheme.of(context).border;
    if (axis == Axis.horizontal) {
      return Container(height: 1, color: color);
    }
    return SizedBox(
      height: 24,
      child: Center(child: Container(width: 1, color: color)),
    );
  }
}

class PalmUISkeleton extends StatefulWidget {
  const PalmUISkeleton({super.key, this.width, this.height = 16});

  /// Null expands to the parent's max width when that max is bounded.
  final double? width;
  final double height;

  @override
  State<PalmUISkeleton> createState() => _PalmUISkeletonState();
}

class _PalmUISkeletonState extends State<PalmUISkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: theme.muted,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
      ),
    );
  }
}

class PalmUISpinner extends StatelessWidget {
  const PalmUISpinner({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: 2, color: theme.primary),
    );
  }
}

enum PalmUITextVariant {
  h1,
  h2,
  h3,
  h4,
  p,
  lead,
  large,
  small,
  muted,
  blockquote,
}

class PalmUIText extends StatelessWidget {
  const PalmUIText(this.text, {super.key, this.variant = PalmUITextVariant.p});

  final String text;
  final PalmUITextVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    final style = switch (variant) {
      PalmUITextVariant.h1 => TextStyle(
        color: theme.foreground,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      PalmUITextVariant.h2 => TextStyle(
        color: theme.foreground,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      PalmUITextVariant.h3 => TextStyle(
        color: theme.foreground,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      PalmUITextVariant.h4 => TextStyle(
        color: theme.foreground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      PalmUITextVariant.p => TextStyle(
        color: theme.foreground,
        fontSize: 16,
        height: 1.5,
      ),
      PalmUITextVariant.lead => TextStyle(
        color: theme.mutedForeground,
        fontSize: 18,
        height: 1.45,
      ),
      PalmUITextVariant.large => TextStyle(
        color: theme.foreground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      PalmUITextVariant.small => TextStyle(
        color: theme.foreground,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      PalmUITextVariant.muted => TextStyle(
        color: theme.mutedForeground,
        fontSize: 14,
      ),
      PalmUITextVariant.blockquote => TextStyle(
        color: theme.foreground,
        fontSize: 16,
        fontStyle: FontStyle.italic,
      ),
    };
    final child = Text(text, style: style);
    if (variant == PalmUITextVariant.blockquote) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: theme.border, width: 2)),
        ),
        child: Padding(padding: const EdgeInsets.only(left: 12), child: child),
      );
    }
    return child;
  }
}

class PalmUIEmpty extends StatelessWidget {
  const PalmUIEmpty({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
  });

  final Widget title;
  final Widget? description;
  final IconData? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            color: theme.mutedForeground,
            size: 32,
          ),
          const SizedBox(height: 8),
          DefaultTextStyle(
            style: TextStyle(
              color: theme.foreground,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            child: title,
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            DefaultTextStyle(
              style: TextStyle(color: theme.mutedForeground, fontSize: 14),
              textAlign: TextAlign.center,
              child: description!,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 12), action!],
        ],
      ),
    );
  }
}

class PalmUIItem extends StatelessWidget {
  const PalmUIItem({
    super.key,
    required this.title,
    this.description,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final Widget title;
  final Widget? description;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(theme.radius),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kPalmUIMinTouchTarget),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius),
              border: Border.all(color: theme.border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 12)],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(
                            color: theme.foreground,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          child: title,
                        ),
                        if (description != null)
                          DefaultTextStyle(
                            style: TextStyle(
                              color: theme.mutedForeground,
                              fontSize: 13,
                            ),
                            child: description!,
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PalmUIKbd extends StatelessWidget {
  const PalmUIKbd(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.muted,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Text(
          text,
          style: TextStyle(
            color: theme.foreground,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class PalmUIAspectRatio extends StatelessWidget {
  const PalmUIAspectRatio({
    super.key,
    required this.ratio,
    required this.child,
  });

  final double ratio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: ratio, child: child);
  }
}

class PalmUIProgressIndicator extends StatelessWidget {
  const PalmUIProgressIndicator({
    super.key,
    required this.width,
    required this.color,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 8,
      child: ColoredBox(color: color),
    );
  }
}

class PalmUIProgress extends StatelessWidget {
  const PalmUIProgress({super.key, this.value});

  /// From 0 to 1. Null shows an indeterminate partial bar.
  final double? value;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fraction = (value ?? 0.35).clamp(0.0, 1.0);
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: 8,
                  child: ColoredBox(color: theme.secondary),
                ),
                PalmUIProgressIndicator(
                  width: constraints.maxWidth * fraction,
                  color: theme.primary,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PalmUIScrollArea extends StatefulWidget {
  const PalmUIScrollArea({super.key, required this.child, this.height = 160});

  final Widget child;
  final double height;

  @override
  State<PalmUIScrollArea> createState() => _PalmUIScrollAreaState();
}

class _PalmUIScrollAreaState extends State<PalmUIScrollArea> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return SizedBox(
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.border),
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Scrollbar(
          controller: _controller,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _controller,
            padding: const EdgeInsets.all(12),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class PalmUITable extends StatelessWidget {
  const PalmUITable({super.key, required this.headers, required this.rows});

  final List<String> headers;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.border),
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder(
            horizontalInside: BorderSide(color: theme.border),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: theme.muted),
              children: [
                for (final header in headers)
                  _cell(header, theme.foreground, bold: true),
              ],
            ),
            for (final row in rows)
              TableRow(
                children: [
                  for (final cell in row) _cell(cell, theme.foreground),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _cell(String text, Color color, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class PalmUICarousel extends StatefulWidget {
  const PalmUICarousel({
    super.key,
    required this.items,
    this.height = 160,
    this.onPageChanged,
  });

  final List<Widget> items;
  final double height;
  final ValueChanged<int>? onPageChanged;

  @override
  State<PalmUICarousel> createState() => _PalmUICarouselState();
}

class _PalmUICarouselState extends State<PalmUICarousel> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = PalmUITheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView(
            controller: _controller,
            onPageChanged: (page) {
              setState(() => _page = page);
              widget.onPageChanged?.call(page);
            },
            children: [
              for (final item in widget.items)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.muted,
                      borderRadius: BorderRadius.circular(theme.radius),
                      border: Border.all(color: theme.border),
                    ),
                    child: Center(child: item),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.items.length; i++)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _page ? theme.primary : theme.border,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
