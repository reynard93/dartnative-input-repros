# DartNative iOS `TextField.onSubmitted` reproduction

Minimal app uses only DartNative `TextField` and native `Button`. It checks
both keyboard actions (`TextInputAction.next` and `TextInputAction.done`) and a
manual Dart button control.

## Create and run

Use a DartNative SDK with `dn` available. From this repository's root:

```sh
SDK=/path/to/dartnative-sdk/zero
"$SDK/bin/dn" --suppress-analytics create /tmp/dn-ios-submission-repro \
  --empty --platforms ios \
  --project-name dn_ios_submission_repro \
  --org com.example \
  --description 'Minimal DartNative iOS TextField submit reproduction' \
  --no-pub
cp ios-submission/main.dart /tmp/dn-ios-submission-repro/lib/main.dart
cd /tmp/dn-ios-submission-repro
"$SDK/bin/dn" --suppress-analytics pub get
"$SDK/bin/dn" --suppress-analytics --device-id <SIMULATOR_UDID> run --verbose
```

On a brand-new simulator, iOS may show its first-use keyboard prompt; tap
`Continue` once. Then tap each field, type text, and tap its keyboard action.

## Xcode deployment-target workaround

`dn create` currently writes `IPHONEOS_DEPLOYMENT_TARGET = 14.0` to the
new Xcode project. Our Xcode 26.6 build succeeded with that setting. Upstream
issue [#17](https://github.com/DartNative/dartnative/issues/17) reports that
Xcode 27 rejects it; when that occurs, update generated project settings before
`dn run`:

```sh
cd /tmp/dn-ios-submission-repro
sed -i '' \
  's/IPHONEOS_DEPLOYMENT_TARGET = 14.0;/IPHONEOS_DEPLOYMENT_TARGET = 15.0;/g' \
  ios/Runner.xcodeproj/project.pbxproj
```

This changes generated project metadata only; do not change Simulator keyboard
preferences.

## Observed result

Tested on iPhone 17 Pro simulator `CC4E141F-93CC-4580-B788-CEA7D02960FE`
(iOS 26.5), DartNative 3.45.0-0.1.pre (`2186eee074`), Xcode 26.6
(`17F113`).

- `next-text` + keyboard `next`: keyboard dismisses; `Next onSubmitted count`
  stays `0`.
- `done-text` + keyboard `done`: keyboard dismisses; `Done onSubmitted count`
  stays `0`.
- `Manual submit (Dart)` increments its count and emits
  `[submit-repro] manual button`, proving ordinary Dart callback/state updates
  work.

No `forms_kit`, `Form`, or application code is involved. Reproduction used
software keyboard only. No global `ConnectHardwareKeyboard` or other Simulator
keyboard preference was changed.
