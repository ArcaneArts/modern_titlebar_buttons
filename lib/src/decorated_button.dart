import 'package:arcane/arcane.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modern_titlebar_buttons/src/get_theme.dart';
import 'package:modern_titlebar_buttons/src/theme_type.dart';
import 'package:universal_io/io.dart';

class DecoratedMinimizeButton extends StatelessWidget {
  const DecoratedMinimizeButton({
    Key? key,
    this.type = ThemeType.auto,
    required this.onPressed,
    this.width,
    this.height,
  }) : super(key: key);

  /// Specify the type of theme you want to be
  /// used for the titlebar buttonss
  final ThemeType? type;

  /// Specify a nullable onPressed callback
  /// used when this button is pressed
  final VoidCallback? onPressed;

  /// Width of the Button
  final double? width;

  /// Height of the Button
  final double? height;

  @override
  Widget build(BuildContext context) {
    return RawDecoratedTitlebarButton(
      type: type,
      name: 'minimize',
      onPressed: onPressed,
      width: width,
      height: height,
    );
  }
}

class DecoratedMaximizeButton extends StatelessWidget {
  const DecoratedMaximizeButton({
    Key? key,
    this.type = ThemeType.auto,
    required this.onPressed,
    this.width,
    this.height,
  }) : super(key: key);

  /// Specify the type of theme you want to be
  /// used for the titlebar buttonss
  final ThemeType? type;

  /// Specify a nullable onPressed callback
  /// used when this button is pressed
  final VoidCallback? onPressed;

  /// Width of the Button
  final double? width;

  /// Height of the Button
  final double? height;

  @override
  Widget build(BuildContext context) {
    return RawDecoratedTitlebarButton(
      type: type,
      name: 'maximize',
      onPressed: onPressed,
      width: width,
      height: height,
    );
  }
}

class DecoratedCloseButton extends StatelessWidget {
  const DecoratedCloseButton({
    Key? key,
    this.type = ThemeType.auto,
    required this.onPressed,
    this.width,
    this.height,
  }) : super(key: key);

  /// Specify the type of theme you want to be
  /// used for the titlebar buttonss
  final ThemeType? type;

  /// Specify a nullable onPressed callback
  /// used when this button is pressed
  final VoidCallback? onPressed;

  /// Width of the Button
  final double? width;

  /// Height of the Button
  final double? height;

  @override
  Widget build(BuildContext context) {
    return RawDecoratedTitlebarButton(
      type: type,
      name: 'close',
      onPressed: onPressed,
      width: width,
      height: height,
    );
  }
}

class RawDecoratedTitlebarButton extends StatefulWidget {
  const RawDecoratedTitlebarButton({
    Key? key,
    this.type = ThemeType.auto,
    required this.name,
    required this.onPressed,
    this.width,
    this.height,
  }) : super(key: key);

  /// Specify the type of theme you want to be
  /// used for the titlebar buttonss
  final ThemeType? type;

  /// Specify the name of the button that
  /// you are trying to create
  final String name;

  /// Specify a nullable onPressed callback
  /// used when this button is pressed
  final VoidCallback? onPressed;

  /// Width of the Button
  final double? width;

  /// Height of the Button
  final double? height;

  @override
  State<RawDecoratedTitlebarButton> createState() =>
      _RawDecoratedTitlebarButtonState();
}

class _RawDecoratedTitlebarButtonState
    extends State<RawDecoratedTitlebarButton> {
  bool isHovering = false;
  bool isActive = false;
  late String theme = '';

  @override
  void initState() {
    super.initState();
    getTheme().then((value) => setState(() => theme = value));
  }

  @override
  Widget build(BuildContext context) {
    ThemeType type =
        widget.type != null && widget.type != ThemeType.auto
            ? widget.type!
            : ThemeType.values.firstWhere(
              (element) => theme.toParamCase().contains(
                describeEnum(element).toParamCase(),
              ),
              orElse: () => ThemeType.adwaita,
            );

    String themeName = describeEnum(type).toParamCase();
    String themeColor =
        type == ThemeType.pop ||
                type == ThemeType.arc ||
                type == ThemeType.materia ||
                type == ThemeType.unity
            ? Theme.of(context).brightness == Brightness.dark
                ? '-dark'
                : '-light'
            : '';

    String state =
        isActive
            ? '-active'
            : isHovering
            ? '-hover'
            : '';

    String fileName = '${widget.name}$state.svg';
    String prefix =
        'packages/modern_titlebar_buttons/assets/themes'
        '/$themeName$themeColor/';
    String themePath =
        prefix +
        (File(prefix + fileName).existsSync()
            ? fileName
            : '${widget.name}.svg');

    void onEntered({required bool hover}) => setState(() => isHovering = hover);
    void onActive({required bool hover}) => setState(() => isActive = hover);

    Color? effectiveColor =
        type == ThemeType.osxArc
            ? null
            : (!isHovering &&
                    !isActive &&
                    type == ThemeType.yaru &&
                    widget.name != 'close' ||
                type == ThemeType.breeze ||
                type == ThemeType.elementary ||
                (!isHovering && !isActive && type == ThemeType.adwaita))
            ? (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black)
            : null;

    Widget buttonIcon = SvgPicture.asset(
      themePath,
      width: widget.width,
      height: widget.height,
      color: effectiveColor,
    );

    if (type == ThemeType.osxArc) {
      final double size = widget.width ?? 15.0;
      buttonIcon = ClipOval(child: buttonIcon);
      buttonIcon = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isHovering ? Colors.black.withOpacity(0.1) : Colors.transparent,
        ),
        child: Center(child: buttonIcon),
      );
    }

    return MouseRegion(
      onExit: (value) => onEntered(hover: false),
      onHover: (value) => onEntered(hover: true),
      child: GestureDetector(
        onTapDown: (_) => onActive(hover: true),
        onTapCancel: () => onActive(hover: false),
        onTapUp: (_) => onActive(hover: false),
        onTap: widget.onPressed,
        child: Container(
          padding:
              type == ThemeType.osxArc
                  ? EdgeInsets.zero
                  : const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 15),
          child: buttonIcon,
        ),
      ),
    );
  }
}
