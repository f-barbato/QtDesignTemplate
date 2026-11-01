# QtDesignTemplate

Template for C++ applications using Qt 6.8+, Qt Quick, and the MVVM pattern.
The CMake project is maintained in VS Code; Qt Design Studio is used
to design the UI without generating build files.

## Project structure

```text
app/
  main.cpp
  core/
    models/       # domain data and rules, independent of the UI
    interfaces/   # service and repository contracts
  services/       # networking, persistence, and integration implementations
  viewmodels/     # QObject state and commands exposed to the UI
  ui/
    App.qml       # connects the View to the ViewModel
    pages/        # .ui.qml screens
    components/   # shared components and constants
    assets/       # images and fonts
tests/            # ViewModel and QML integration tests
```

`MainViewModel` exposes the button state and the screen message.
`main.cpp` injects it into the `viewModel` property of `App.qml`.
In Qt Design Studio, the same property uses a QML mock without requiring
a C++ plugin in the designer runtime.

## Requirements

- Qt 6.8+ with Quick and QuickControls2; Qt Test to build the tests.
- CMake 3.21+, Ninja, and a C++17 compiler.
- GDB for debugging in VS Code on Linux.

## Reusing the template

Copy `CMakeUserPresets.json.example` to `CMakeUserPresets.json` and set
`QT_ROOT` there to your Qt kit directory. This ignored local file is the
single kit configuration used by both VS Code tasks and local presets:

```sh
cmake --preset debug-local
cmake --build --preset debug-local
ctest --preset debug-local
```

Customize the defaults in `cmake/application.cmake`, or override its cache
variables in your configure preset: `APP_NAME`, `APP_EXECUTABLE_NAME`,
`APP_IDENTIFIER`, `APP_VENDOR`, `APP_DESCRIPTION`, `APP_LICENSE`, and
`APP_ICON`. Set `APP_VERSION_MAJOR`, `APP_VERSION_MINOR`, and
`APP_VERSION_PATCH` (the fix component) in the same file or preset.
`APP_VERSION` is assembled as `major.minor.patch` and used for the CMake
project, runtime application version, bundles, and installation packages.

```sh
cmake --preset release-local \
  -DAPP_VERSION_MAJOR=1 -DAPP_VERSION_MINOR=2 -DAPP_VERSION_PATCH=3
```

These settings control the executable filename, runtime window title,
bundle identity, desktop entry, and package metadata.

The internal CMake target `QtDesignTemplateApp` and QML URIs `app.ui`,
`app.ui.pages`, and `app.ui.components` are intentionally stable and do
not need to match the product name. The example screen text and the
Design Studio project filename can be customized separately.

## Build and run from the terminal

Set `QT_ROOT` to the Qt kit directory, not the top-level installation
directory. For example, on Linux:

```sh
export QT_ROOT="$HOME/Qt/6.12.0/gcc_64"
cmake --preset debug
cmake --build --preset debug
ctest --preset debug
./build/debug/app/QtDesignTemplateApp
```

Alternatively, specify the kit directly when configuring:

```sh
cmake --preset debug -DCMAKE_PREFIX_PATH="$HOME/Qt/6.12.0/gcc_64"
```

The `debug` preset uses `build/debug` and includes tests.
The `release` preset uses `build/release` and does not build tests:

```sh
cmake --preset release
cmake --build --preset release
./build/release/app/QtDesignTemplateApp
```

## Packaging

Configure Release with the Qt kit for the target platform, then run the
`package` build preset:

```sh
cmake --preset release
cmake --build --preset package
```

The preset builds the application and runs CPack, including Qt runtime
and QML deployment through the CMake install rules.
Packages are written to `build/release/packages/`.

| Platform | Default format | Additional requirements |
| --- | --- | --- |
| Windows | NSIS `.exe` installer | NSIS installed and available to CPack |
| macOS | `.dmg` containing the `.app` bundle | Native macOS build environment |
| Linux | `.deb` and `.rpm` | `dpkg-deb`, `dpkg-shlibdeps`, and `rpmbuild` |

Build each package on its target operating system. Linux packages may
still require compatible system libraries.
Windows signing and macOS signing/notarization are not configured.

### Linux AppImage

Install `linuxdeploy` and `linuxdeploy-plugin-qt` from their official
releases and make them executable and available on `PATH`.
The x86_64 AppImage tool filenames are also supported.
The linuxdeploy AppImage output plugin must be available (it is bundled
with the official linuxdeploy AppImage).

```sh
cmake --preset release
cmake --build --preset package-appimage
```

To generate DEB, RPM, and AppImage together:

```sh
cmake --build --preset package-linux
```

All outputs are written to `build/release/packages/`. AppImage creation
uses `build/release/AppDir` as its staging directory.
The staging directory is recreated before every AppImage build to avoid
shipping obsolete files. Customize the application metadata and
icon before distributing your application. Build on the oldest Linux
distribution you intend to support and test on each target distribution.

## Visual Studio Code

Install the recommended **CMake Tools** and **C/C++** extensions.
Use GDB on Linux, LLDB on macOS, or the Windows MSVC debug configuration.
Install the **CodeLLDB** extension (`vadimcn.vscode-lldb`) for the macOS
configuration.
On Windows, launch VS Code from an MSVC developer environment and use
the corresponding Qt MSVC kit; Ninja must be on `PATH`.

1. Create `CMakeUserPresets.json` as described above.
2. Select `debug-local` using **CMake: Select Configure Preset**, run
   **CMake: Configure**, and select `QtDesignTemplateApp` as the
   Launch/Debug Target.
3. Press **F5** with the debug configuration for your platform.

F5 first runs the `Build QtDesignTemplate` task, which depends on
`Configure QtDesignTemplate`: it configures using the local Qt kit,
builds the app, and starts the debugger. **Ctrl+Shift+B**
runs the same build without starting the debugger. The tasks use the
`debug-local` preset.

## Continuous integration

`.github/workflows/build.yml` builds and tests on Linux, Windows, and
macOS using Qt 6.8.3, runs QML linting, and uploads native packages.
The Linux job generates DEB, RPM, and AppImage; Windows generates NSIS,
and macOS generates DMG. Remote jobs must pass before considering those
platforms verified; adding a workflow is not a substitute for running it.

## Qt Design Studio

Open `QtDesignTemplate.qmlproject` and edit
`app/ui/pages/Home.ui.qml`. The `App.qml` preview uses the QML mock,
while the compiled executable uses the C++ ViewModel.

The `enableCMakeGeneration: false` property disables build-file generation:
Design Studio and VS Code share QML sources, not build files.
After moving or renaming files, close and reopen the project.

When adding QML files or resources, update the relevant `CMakeLists.txt`.
The `.qmlproject` collects files for the designer but does not define the build.
The `qmldir` files in module directories enable QML imports from source:
keep them updated when adding public types.

The template uses only standard Qt modules. Studio components or a
virtual keyboard require additional QML/CMake dependencies.

## Qt Insight

Insight is optional and disabled by default. To enable it, install
Qt InsightTracker and configure `qtinsight.conf` with your project token.
The included token is a placeholder; do not commit real credentials.

```sh
cmake --preset debug -DLINK_INSIGHT=ON
cmake --build --preset debug
```

To use Insight with F5 as well, set `LINK_INSIGHT` to `ON` in the
`cacheVariables` of your `debug-local` configure preset.
