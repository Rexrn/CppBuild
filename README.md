# CppBuild
An package-based build system for C++ that leverages [premake5](https://github.com/premake/premake-core) as a generator.

|[Installation](#installation)|[Quick Start](#quick-start)|[Contributing](#contributing)|
|:---:|:---:|:---:|
|[**Goals**](#goals)|[**Examples**](Examples/index.md)|[**Documentation**](Documentation/index.md)|


## Quick Start

Create two files:

### 1. Project setup

**`Main.cpp`**
```cpp
#include <iostream>

int main()
{
	std::cout << "Hello with CppBuild";
}
```

Then create **`package.lua`** in the same folder:

```lua
return {
	name = "MyApp",
	type = "ConsoleApp",
	cppStandard = "C++17",
	files = {
		"Main.cpp"
	}
}
```

### 2. Building the project

Run following command **in the project root**.

```
cppbuild vs2019
```

You can select one of the following generators:
- `vs2019`
- `vs2017`
- `vs2015`
- `gmake`
- `gmake2`
- `xcode`
- and more (for complete documentation [look here](https://github.com/premake/premake-core/wiki/Modules))

<!-- TODO:
This will perform all necessary commands to:

1. configure
2. build
3. install (locally)

your program. You will find your executable in `install/bin` folder. -->

## Installation

Manual:

1. Download [premake5](https://github.com/premake/premake-core)
   1. Make it available as `premake5` from console (use `PATH` environmental variable)
2. Download CppBuild repository, unpack to any available folder and run `install-cppbuild` script.

Installer:

`// TODO`

## Goals

The main goal is to allow easy and powerful C++ project (package)
management. **CppBuild** wants to be a better and more
user friendly replacement to [CMake](https://github.com/Kitware/CMake). CMake is powerful
but its script language is a pain in the ass :(

## Examples

**Visit [Examples](Examples/index.md) for more examples.**

## Documentation

**Visit [Documentation](Documentation/index.md) for a documentation.**

## Contributing

All contributions are appreciated.

Remember that the purpose of this project