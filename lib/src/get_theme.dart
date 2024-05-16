import 'package:dbus/dbus.dart';
import 'package:gsettings/gsettings.dart';
import 'package:universal_io/io.dart';

Future<String> getTheme() async {
  if (Platform.isMacOS) {
    return 'osx-arc';
  } else if (Platform.isWindows) {
    return 'materia';
  } else if (Platform.isLinux) {
    final settings = GSettings('org.gnome.desktop.interface');
    return (await settings.get('gtk-theme') as DBusString).value;
  }

  return '';
}
