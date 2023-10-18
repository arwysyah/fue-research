# FPS_RESEARCH_EXAMPLE

1. Go to **File > Build Settings > Player Settings**
   and check and make sure it is same with steps following under the section:

- In **Scripting Backend**, change to IL2CPP

- (Android) **Target Architectures**, select ARMv7 and ARM64

- (Android) For the best compatibility set **Active Input Handling** to `Input Manager (Old)` or `Both`.  
  (The new input system has some issues with touch input on Android)

- (iOS) Select **Target SDK** depending on where you will run your app (simulator or physical device).  
  We recommend starting with a physical device and the `Device SDK` setting, due to limited simulator support.

- (Web) Set <b>Publishing settings > Compression format</b> to Brotli or Disabled.  
  Some users report that Unity gets stuck on the loading screen with the Gzip setting, due to MIME type errors.

  <img src="https://raw.githubusercontent.com/juicycleff/flutter-unity-view-widget/master/files/Screenshot%202019-03-27%2007.31.55.png" width="400" />

2. In **File > Build Settings**, make sure to have at least 1 scene added to your build.

Some options in the **Build settings** window get overridden by the plugin's export script.
Attempting to change settings like `Development Build`, `Script Debugging` and `Export project` in this window will not make a difference.
If you end up having to change a build setting that doesn't seem to respond, take a lookat the export script `FlutterUnityIntegration\Editor\Build.cs`.

### Unity exporting

1. After importing the unitypackage, you should now see a **Flutter** option at the top of the Unity editor.

2. Click on **Flutter** and select the appropriate export option:

- For android use **Export Android Debug** or **Export Android Release**.  
  This will export to _android/unityLibrary_.
- For iOS use **Export iOS Debug** or **Export iOS Release**.  
  This will export to _ios/UnityLibrary_.
- Do not use **Flutter > Export _Platform_ plugin** as it was specially added to work with [`flutter_unity_cli`](https://github.com/juicycleff/flutter_unity_cli) for larger projects.

  <img src="https://github.com/juicycleff/flutter-unity-view-widget/blob/master/files/Unity_Build_Options.png?raw=true" width="400" />

Proceed to the next section to handle iOS and Android specific setup after the export.

### Platform specific setup (after Unity export)

After exporting Unity, you will need to make some small changes in your iOS or Android project.  
You will likely need to do this **only once**. These changes remain on future Unity exports.

information_source: <b>Android</b>

1. Setting the Android NDK

- If you have Unity and Flutter installed on the same machine, the easiest approach is to use the path of the NDK Unity uses. You can find the path to the NDK in Unity under `Edit -> Preferences -> External Tool`:

![NDK Path](files/ndkPath.png)

- Copy the path and paste it into your flutter project at `android/local.properties` as `ndk.dir=`.  
  (For windows you will need to replace `\` with `\\`.)  
  Don't simply copy and paste this, make sure it the path matches your Unity version!

```properties
    // mac
    ndk.dir=/Applications/Unity/Hub/Editor/2020.3.19f1/PlaybackEngines/AndroidPlayer/NDK
    // windows
    ndk.dir=C:\\Program Files\\Unity\\Hub\\Editor\\2021.3.13f1\\Editor\\Data\\PlaybackEngines\\AndroidPlayer\\NDK
```

- With the above setup, you shouldn't have to define any NDK version or setting in gradle files.  
  If you don't have Unity on the device making your Flutter buids, you can instead define it in `android/app/build.gradle`.

```gradle

android {

  ndkVersion "21.3.6528147" // or your ndk version
}
```

- To find the exact version that Unity uses, check `source.properties` at the NDK path described above.

2. Depending on your gradle version, you might need to make sure the `minSdkVersion` set in `android\app\build.gradle` matches the version that is set in Unity.  
   Check the **Minimum API Level** setting in the Unity player settings, and match that version.

3. The Unity export script automatically sets the rest up for you. You are done with the Android setup.  
   But if you want to manually set up the changes made by the export, continue.

Optional manual Android setup

4. Open the _android/settings.gradle_ file and change the following:

```diff
+    include ":unityLibrary"
+    project(":unityLibrary").projectDir = file("./unityLibrary")
```

5. Open the _android/app/build.gradle_ file and change the following:

```diff
     dependencies {
+        implementation project(':unityLibrary')
     }
```

6. open the _android/build.gradle_ file and change the following:

```diff
allprojects {
    repositories {
+       flatDir {
+           dirs "${project(':unityLibrary').projectDir}/libs"
+       }
        google()
        mavenCentral()
    }
}
```

7. After that run your flutter by your android device in VS code looks like this

```diff

flutter run

```
