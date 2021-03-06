# Installed Apps

Flutter <a href="https://pub.dev/packages/installed_apps" target="_blank">plugin</a> with utility methods related to installed apps on device.
(Currently only Android is supported.)

## Getting Started
1. [Installation Guide](https://pub.dev/packages/installed_apps/install)
2. [Example](https://pub.dev/packages/installed_apps/example)

---

#### Get list of installed apps 
```dart
List<AppInfo> apps = await getInstalledApps(excludeSystemApps: false);
```
*Use packageNamePrefix to filter for apps that have package name starting with certain prefix.

#### Get app info with package name 
```dart
AppInfo app = await getAppInfo(packageName);
```

#### Start app with package name
```dart
await startApp(packageName)
```
#### Open app settings screen (App Info) with package name
```dart
await openSettings(packageName)
```
#### Check if app is system app
```dart
bool isSystemApp = await isSystemApp(packageName)
```

