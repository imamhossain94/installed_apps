import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

void main() => runApp(App());

class App extends MaterialApp {
  @override
  Widget get home => HomeScreen();
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Installed Apps Example")),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: const Text("Installed Apps"),
                subtitle: const Text(
                    "Get installed apps on device. With options to exclude system app, get app icon & matching package name prefix."),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstalledAppsScreen(),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: const Text("App Info"),
                subtitle: const Text("Get app info with package name"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppInfoScreen(),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: const Text("Start App"),
                subtitle: const Text(
                    "Start app with package name. Get callback of success or failure."),
                onTap: () => startApp("com.google.android.gm"),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: const Text("Go To App Settings Screen"),
                subtitle: const Text(
                    "Directly navigate to app settings screen with package name"),
                onTap: () => openAppSettings("com.google.android.gm"),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: const Text("Check If System App"),
                subtitle:
                    const Text("Check if app is system app with package name"),
                onTap: () => isSystemApp("com.google.android.gm").then(
                  (bool? value) => _showDialog(
                      context,
                      value ?? false
                          ? "The requested app is system app."
                          : "Requested app in not system app."),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class InstalledAppsScreen extends StatefulWidget {
  @override
  State<InstalledAppsScreen> createState() => _InstalledAppsScreenState();
}

class _InstalledAppsScreenState extends State<InstalledAppsScreen> {
  late final _installedApps = getInstalledApps();
  late final _icons = _installedApps.then((installedApps) => getAppIconsPng(
      installedApps
          .map((appInfo) => appInfo.packageName)
          .toList(growable: false)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Installed Apps")),
      body: FutureBuilder<List<AppInfo>>(
        future: _installedApps,
        builder:
            (BuildContext buildContext, AsyncSnapshot<List<AppInfo>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final app = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: FutureBuilder<List<Uint8List?>>(
                                  future: _icons,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox();
                                    }
                                    return Image.memory(snapshot.data![index]!);
                                  },
                                )
                                // child: Image.memory(app.icon!),
                                ),
                            title: Text(app.name),
                            subtitle: Text(app.versionInfo),
                            onTap: () => startApp(app.packageName),
                            onLongPress: () => openAppSettings(app.packageName),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                          "Error occurred while getting installed apps ...."))
              : const Center(child: Text("Getting installed apps ...."));
        },
      ),
    );
  }
}

class AppInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Info")),
      body: FutureBuilder<AppInfo?>(
        future: getAppInfo("com.google.android.gm"),
        builder: (BuildContext buildContext, AsyncSnapshot<AppInfo?> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? Center(
                      child: Column(
                        children: [
                          // Image.memory(snapshot.data!.icon!),
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                          Text(snapshot.data!.versionInfo)
                        ],
                      ),
                    )
                  : const Center(
                      child: Text("Error while getting app info ...."))
              : const Center(child: Text("Getting app info ...."));
        },
      ),
    );
  }
}
