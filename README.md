# SKSE/CommonLibSSE - CMake Template Project

I hate doing a project in C++ that uses any dependencies because dealing with includes and linking errors is aggravating. Creating an SKSE plugin is even worse and only in recent years has the community started to pretend like good developers who document their stuff...

Anyway, this template was designed so you can very quickly get started with developing an SKSE plugin for Skyrim Special Edition. You can either use SKSE64 or CommonLibSSE for this and I will explain how to properly set-up your development environment.

## Requirements

### Visual Studio, MSVC and CMake

[Visual Studio](https://visualstudio.microsoft.com/) is an IDE but comes with important build tools that you can't really get otherwise. You have to install VS in order to install the build tools even if you end up using another IDE. Downloading the Community Edition will get you the Visual Studio Installer from where you can pick all sorts of features and tools you want to install. Here is what you should select:

- Workloads:
  - Desktop development with C++
- Individual components:
  - Compilers, build tools and runtimes:
    - C++ 2019 Redistributable MSMs
    - C++ Clang Compiler for Windows (11.0.0)
    - C++ Clang-cl for v142 build tools (x64/x86)
    - C++ CMake tools for Windows
    - MSVC v142 - VS 2019 C++ x64/x85 build tools (latest)
  - SDKs, libraries and frameworks:
    - Windows 10 SDK (10.0.19041.0)

Note that you don't need this exact Windows 10 SDK version, you can also use a newer one it is only important that you have at least one Windows 10 SDK installed.

### vcpkg for CommonLibSSE

If you want to use CommonLibSSE then you need to install [vcpkg](https://github.com/microsoft/vcpkg#quick-start-windows). It's a package manage that lets us easily install dependencies. I like CPM a bit more than vcpkg because you have to literally do nothing where as with vcpkg you still have to manually install each dependency. After installing vcpkg and running `.\vcpkg\vcpkg integrate install` run the following commands to install all needed packages:

- `vcpkg.exe install boost-atomic:x64-windows`
- `vcpkg.exe install boost-stl-interfaces:x64-windows`
- `vcpkg.exe install spdlog:x64-windows`

## Settings up your IDE

### CLion

After cloning the repo and opening project start by adjusting your toolchains in the settings (File | Settings | Build, Execution, Deployment | Toolchains). Make sure that Visual Studio x64 is present or adding it if it isn't (make sure the Architecture is `amd64`).

Next change the CMake settings (File | Settings | Build, Execution, Deployment | CMake). Create a new profile with Build type `Debug` and the Visual Studio x64 Toolchain. Update your "CMake options" with the following:

```bash
-G "Visual Studio 16 2019" -A x64
```

This will set the cmake-generator to `Visual Studio 16 2019` and the Architecture to `x64`. Append either `-DUSE_SKSE=YES` or `-DUSE_COMMONLIB=YES` if you want to build SKSE or CommonLibSSE. Note that you will need to install vcpkg and certain packages if you want to build CommonLibSSE. You also need to tell CMake to include vcpkg by appending `-DCMAKE_TOOLCHAIN_FILE=E:/Tools/vcpkg/scripts/buildsystems/vcpkg.cmake` to the CMake options (make sure to replace the path with your installation path).

Your CMake options should look something like this if you want to build with SKSE:

```bash
-G "Visual Studio 16 2019" -A x64 -DUSE_SKSE=YES
```

and like this if you want to build with CommonLibSSE:

```bash
-G "Visual Studio 16 2019" -A x64 -DUSE_COMMONLIB=YES -DCMAKE_TOOLCHAIN_FILE=E:/Tools/vcpkg/scripts/buildsystems/vcpkg.cmake
```

### Visual Studio

Before opening the project in Visual Studio, open the [CMakeSettings.json](CMakeSettings.json) file and changing the `cmakeToolchain` path to your own vcpkg installation. You can also change `cmakeCommandArgs` to either `-DUSE_SKSE=YES` or `-DUSE_COMMONLIB=YES`.

### Visual Studio Code

For VSC I recommend getting the [CMake Tools](https://github.com/microsoft/vscode-cmake-tools) extension and adjusting the settings in [settings.json](.vscode/settings.json).

In the settings file change the `cmake.configureSettings` to use either `USE_SKSE=YES` or `USE_COMMONLIB=YES` and replacing the path to vcpkg in `CMAKE_TOOLCHAIN_FILE` to your own installation of vcpkg if you want to build CommonLibSSE.

Use the "CMake: Configure" command to configure CMake and make sure to select build type `Debug` and kit `Visual Studio Community 2019 Release - amd64`. You can build the project with the "CMake: Build" command.

### CLI

If you are more of a CLI user or use an IDE I have not listed here then this is what you wanna do if you want to build with SKSE or CommonLibSSE:

Configure CMake to build with SKSE:

```bash
cmake -Bbuild/ -G "Visual Studio 16 2019" -A x64 -DUSE_SKSE=YES
```

Configure CMake to build with CommonLibSSE:

```bash
cmake -Bbuild/ -G "Visual Studio 16 2019" -A x64 -DUSE_COMMONLIB=YES -DCMAKE_TOOLCHAIN_FILE=E:/Tools/vcpkg/scripts/buildsystems/vcpkg.cmake
```

Build the project:

```bash
cmake --build ./build
```
