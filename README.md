# WinUtil - Modular Windows Utility Tool

A comprehensive Windows utility tool with a modern, modular architecture for application management, system tweaking, and automation.

## 📁 Project Structure

```
WinUtil/
├── Config/                          # Static JSON configurations
│   ├── applications.json            # App definitions (winget/choco IDs)
│   ├── tweaks.json                  # Tweak definitions (registry, services, scripts)
│   ├── preset.json                  # Preset groupings (app/tweak IDs)
│   └── feature.json                 # Feature definitions (legacy support)
├── Modules/                         # Code organized by domain
│   ├── Applications/                # App management
│   │   ├── Install.ps1              # Function: Install-App
│   │   ├── Uninstall.ps1            # Function: Uninstall-App
│   │   └── General.ps1              # Function: Invoke-AppAction (dispatcher)
│   ├── Tweaks/                      # Tweak subsystems
│   │   ├── Registry.ps1             # Function: Invoke-RegistryTweak
│   │   ├── Services.ps1             # Function: Invoke-ServiceTweak
│   │   ├── Scripts.ps1              # Function: Invoke-ScriptTweak
│   │   └── General.ps1              # Function: Invoke-TweakAction (dispatcher)
│   ├── UI/                          # UI components
│   │   ├── XAML/                    # XAML files
│   │   │   └── MainWindow.xaml      # WPF UI definition
│   │   ├── Binding.ps1              # Function: Populate-UI
│   │   └── Events.ps1               # Function: Register-ButtonHandlers
│   ├── Process/                     # Threading (runspaces)
│   │   ├── Runner.ps1               # Function: Start-Runspace
│   │   └── Tracker.ps1              # Function: Track-Runspaces
│   ├── Presets/                     # Preset logic
│   │   ├── Loader.ps1               # Function: Load-Presets
│   │   └── Validator.ps1            # Function: Test-Presets
│   └── Logger/                      # Logging
│       └── Core.ps1                 # Function: Write-Log
├── Scripts/                         # Entry points
│   ├── Main.ps1                     # Function: Invoke-Automation | Start-GUI
│   └── Build.ps1                    # Function: Compile-ToSingleFile
├── LICENSE
└── README.md
```

## 🚀 Quick Start

### GUI Mode (Default)
```powershell
.\Scripts\Main.ps1
# or
.\Scripts\Main.ps1 -GUI
```

### Automation Mode
```powershell
.\Scripts\Main.ps1 -ConfigPath "automation.json" -Run
```

### Validation Mode
```powershell
.\Scripts\Main.ps1 -Validate
```

## Usage

### Main Usage
Run the compiled WinUtil application:

```powershell
# Run GUI mode (default)
.\winutil.ps1

# Validate configuration
.\winutil.ps1 -Validate
```

### Build System
To rebuild the compiled version from source modules:

```powershell
.\Scripts\Build.ps1
```

This compiles all modules and configurations into a single `winutil.ps1` file.

## 🏗️ Architecture Overview

### Modular Design Principles

1. **Modularity**: Apps and tweaks are isolated in separate modules. Adding new functionality only requires creating new module files.

2. **Config-Driven**: All app/tweak logic is derived from JSON configuration files—no hardcoded IDs or definitions.

3. **Concurrency**: Uses PowerShell runspaces (not jobs) for lightweight threading with proper tracking and cleanup.

4. **UI/Logic Decoupling**: XAML is stored externally; UI logic is separated into binding and event modules.

5. **Scalability**: The structure supports easy addition of new tweak types, applications, and UI components.

## 📋 Module Responsibilities

### Applications Module (`Modules/Applications/`)
- **Install.ps1**: Handles direct app installation via winget/chocolatey
- **Uninstall.ps1**: Handles app removal
- **General.ps1**: Dispatches actions and determines installation method

### Tweaks Module (`Modules/Tweaks/`)
- **Registry.ps1**: Processes registry modifications with undo support
- **Services.ps1**: Manages Windows service startup types
- **Scripts.ps1**: Executes PowerShell scripts for complex tweaks
- **General.ps1**: Dispatches tweak actions based on type

### UI Module (`Modules/UI/`)
- **XAML/MainWindow.xaml**: Modern dark-themed WPF interface
- **Binding.ps1**: Populates UI controls with configuration data
- **Events.ps1**: Handles button clicks and user interactions

### Process Module (`Modules/Process/`)
- **Runner.ps1**: Creates and manages PowerShell runspaces
- **Tracker.ps1**: Tracks active operations and prevents conflicts

### Presets Module (`Modules/Presets/`)
- **Loader.ps1**: Loads and processes preset configurations
- **Validator.ps1**: Validates preset integrity and generates statistics

### Logger Module (`Modules/Logger/`)
- **Core.ps1**: Centralized logging with console and UI output

## 🔧 Configuration Files

### applications.json
Defines available applications with winget/chocolatey package IDs:
```json
{
  "7zip": {
    "category": "Utilities", 
    "content": "7-Zip",
    "description": "File archiver with high compression ratio",
    "winget": "7zip.7zip",
    "choco": "7zip"
  }
}
```

### tweaks.json
Defines system modifications:
```json
{
  "WPFTweaksAH": {
    "Content": "Disable Activity History",
    "Description": "Erases recent docs, clipboard, and run history",
    "category": "Essential Tweaks",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
        "Name": "EnableActivityFeed", 
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ]
  }
}
```

### preset.json
Groups apps and tweaks for bulk operations:
```json
{
  "Standard": [
    "WPFTweaksAH",
    "WPFTweaksTele", 
    "WPFTweaksServices"
  ],
  "Minimal": [
    "WPFTweaksHome",
    "WPFTweaksTele"
  ]
}
```

## 🔄 Key Workflows

### App Installation (GUI)
1. User selects apps from ListView
2. Click "Install" → Events.ps1 triggers
3. Process/Runner.ps1 creates parallel runspaces:
   ```powershell
   Invoke-AppAction -AppID "7zip" -Action Install
   ```
4. Logger.ps1 updates UI with progress

### Tweak Application (CLI)
```powershell
.\Scripts\Main.ps1 -ConfigPath .\automation.json -Run
```

Example automation.json:
```json
{
  "Tweaks": ["WPFTweaksTele", "WPFTweaksAH"],
  "Apps": ["7zip", "brave"],
  "Presets": ["Standard"]
}
```

### Threading with Runspaces
- **Process/Runner.ps1**: Creates lightweight PowerShell runspaces
- **Process/Tracker.ps1**: Maintains thread safety and prevents conflicts
- All operations are tracked and can be monitored/cancelled

## 🛠️ Development

### Adding New Applications
1. Add entry to `Config/applications.json`
2. No code changes required—handled automatically

### Adding New Tweak Types
1. Create new module file: `Modules/Tweaks/NewType.ps1`
2. Implement `Invoke-NewTypeTweak` function
3. Update `Modules/Tweaks/General.ps1` dispatcher

### Adding UI Components
1. Modify `Modules/UI/XAML/MainWindow.xaml`
2. Update `Modules/UI/Binding.ps1` for data binding
3. Add event handlers in `Modules/UI/Events.ps1`

## 📦 Build System

The build system can compile everything into a single PowerShell file:

```powershell
# Basic compilation
.\Scripts\Build.ps1

# Include configuration files
.\Scripts\Build.ps1 -IncludeConfig

# Minified output
.\Scripts\Build.ps1 -Minify -OutputPath "winutil-min.ps1"
```

## 🔍 Validation & Testing

Validate configuration integrity:
```powershell
.\Scripts\Main.ps1 -Validate
```

This will:
- Check all preset references exist in apps/tweaks configs
- Generate statistics about the configuration
- Report any missing or invalid references

## 📝 Logging

All operations are logged with timestamps and severity levels:
- **INFO**: Normal operations
- **WARN**: Non-critical issues  
- **ERROR**: Operation failures
- **DEBUG**: Detailed diagnostic information

Logs appear in both console and GUI (if running in GUI mode).

## 🤝 Contributing

1. Follow the modular architecture principles
2. Add new functionality as separate modules
3. Update configuration files rather than hardcoding values
4. Include proper error handling and logging
5. Test with the validation system

## 📄 License

This project maintains the same license as the original WinUtil project.

---

**Note**: This modular architecture provides a scalable foundation for Windows system management while maintaining the functionality and user experience of the original WinUtil tool. 