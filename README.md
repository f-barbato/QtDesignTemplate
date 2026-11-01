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
Customize the package maintainer, license metadata, desktop file, and
icon before distributing your application. Build on the oldest Linux
distribution you intend to support and test on each target distribution.

## Visual Studio Code

Install the recommended **CMake Tools** and **C/C++** extensions.
The included build and debug configurations target Linux.

1. Update `CMAKE_PREFIX_PATH` in `.vscode/tasks.json` and `QT_ROOT` in
   `cmake.configureEnvironment` in `.vscode/settings.json` for your Qt kit.
   The current path is
   `$HOME/Qt/6.12.0/gcc_64`.
2. CMake Tools supplies `QT_ROOT` from these workspace settings to the
   configure presets. Terminal commands still require `export QT_ROOT=...`
   or an explicit `-DCMAKE_PREFIX_PATH=...`.
3. Select `debug` using **CMake: Select Configure Preset**, run
   **CMake: Configure**, and select `QtDesignTemplateApp` as the
   Launch/Debug Target.
4. Press **F5** with the `Debug QtDesignTemplate` configuration.

F5 first runs the `Build QtDesignTemplate` task, which depends on
`Configure QtDesignTemplate`: it configures with an explicit
`CMAKE_PREFIX_PATH`, builds the app, and starts GDB. **Ctrl+Shift+B**
runs the same build without starting the debugger. The tasks use the
`debug` preset.

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

The VS Code configure task reapplies the `debug` preset, which sets
`LINK_INSIGHT=OFF`. To use Insight with F5 as well, add
`-DLINK_INSIGHT=ON` to the arguments of the `Configure QtDesignTemplate` task.
