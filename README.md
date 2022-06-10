# javer - Simple Java Version Manager for Windows
javer is a simple script that manages Java versions on Windows. It allows you to easily switch between installed JDKs without going through your system preferences.

## Installation
1. Clone this repository: `git clone https://github.com/mboskamp/javer.git`
2. Add `%JAVA_HOME%\bin` to your `PATH` variable in Windows.
3. Add the path to javer to your `PATH` variable (e.g. C:\util\javer)

## Usage
* `javer` or `javer -h`: Display help.
* `javer -a version path`: Register a new JDK installation with `version` (e.g. `8`, `11`, `15`, ...) and path (path to the JDK folder)
* `javer -r version`: Remove a JDK version from javer. The JDK folder will not be deleted from your disc.
* `javer -u version`: Use JDK version. **Note:**The version change will not be active for already active cmd sessions.
* `javer -l`: List all registered JDK versions.
* `javer -v`: Display version information about javer and java. **Note:** If you switched to a different java version the change will not be active for the current cmd session.

## License
Apache License 2.0
