<#
.SYNOPSIS
WinUtil - Windows Utility Tool

.DESCRIPTION
Compiled Windows utility tool for installing applications and applying tweaks

.PARAMETER LogLevel
Logging level (INFO, WARN, ERROR, DEBUG)
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('INFO', 'WARN', 'ERROR', 'DEBUG')]
    [string]$LogLevel = 'INFO'
)

# ========================================
# EMBEDDED CONFIGURATION
# ========================================

$global:AppsConfig = '{
    "1password": {
        "category": "Utilities",
        "choco": "1password",
        "content": "1Password",
        "description": "1Password is a password manager that allows you to store and manage your passwords securely.",
        "link": "https://1password.com/",
        "winget": "AgileBits.1Password"
    },
    "7zip": {
        "category": "Utilities",
        "choco": "7zip",
        "content": "7-Zip",
        "description": "7-Zip is a free and open-source file archiver utility. It supports several compression formats and provides a high compression ratio, making it a popular choice for file compression.",
        "link": "https://www.7-zip.org/",
        "winget": "7zip.7zip"
    },
    "adobe": {
        "category": "Document",
        "choco": "adobereader",
        "content": "Adobe Acrobat Reader",
        "description": "Adobe Acrobat Reader is a free PDF viewer with essential features for viewing, printing, and annotating PDF documents.",
        "link": "https://www.adobe.com/acrobat/pdf-reader.html",
        "winget": "Adobe.Acrobat.Reader.64-bit"
    },
    "advancedip": {
        "category": "Pro Tools",
        "choco": "advanced-ip-scanner",
        "content": "Advanced IP Scanner",
        "description": "Advanced IP Scanner is a fast and easy-to-use network scanner. It is designed to analyze LAN networks and provides information about connected devices.",
        "link": "https://www.advanced-ip-scanner.com/",
        "winget": "Famatech.AdvancedIPScanner"
    },
    "affine": {
        "category": "Document",
        "choco": "na",
        "content": "AFFiNE",
        "description": "AFFiNE is an open source alternative to Notion. Write, draw, plan all at once. Selfhost it to sync across devices.",
        "link": "https://affine.pro/",
        "winget": "ToEverything.AFFiNE"
    },
    "aimp": {
        "category": "Multimedia Tools",
        "choco": "aimp",
        "content": "AIMP (Music Player)",
        "description": "AIMP is a feature-rich music player with support for various audio formats, playlists, and customizable user interface.",
        "link": "https://www.aimp.ru/",
        "winget": "AIMP.AIMP"
    },
    "alacritty": {
        "category": "Utilities",
        "choco": "alacritty",
        "content": "Alacritty Terminal",
        "description": "Alacritty is a fast, cross-platform, and GPU-accelerated terminal emulator. It is designed for performance and aims to be the fastest terminal emulator available.",
        "link": "https://alacritty.org/",
        "winget": "Alacritty.Alacritty"
    },
    "anaconda3": {
        "category": "Development",
        "choco": "anaconda3",
        "content": "Anaconda",
        "description": "Anaconda is a distribution of the Python and R programming languages for scientific computing.",
        "link": "https://www.anaconda.com/products/distribution",
        "winget": "Anaconda.Anaconda3"
    },
    "angryipscanner": {
        "category": "Pro Tools",
        "choco": "angryip",
        "content": "Angry IP Scanner",
        "description": "Angry IP Scanner is an open-source and cross-platform network scanner. It is used to scan IP addresses and ports, providing information about network connectivity.",
        "link": "https://angryip.org/",
        "winget": "angryziber.AngryIPScanner"
    },
    "anki": {
        "category": "Document",
        "choco": "anki",
        "content": "Anki",
        "description": "Anki is a flashcard application that helps you memorize information with intelligent spaced repetition.",
        "link": "https://apps.ankiweb.net/",
        "winget": "Anki.Anki"
    },
    "anydesk": {
        "category": "Utilities",
        "choco": "anydesk",
        "content": "AnyDesk",
        "description": "AnyDesk is a remote desktop software that enables users to access and control computers remotely. It is known for its fast connection and low latency.",
        "link": "https://anydesk.com/",
        "winget": "AnyDesk.AnyDesk"
    },
    "audacity": {
        "category": "Multimedia Tools",
        "choco": "audacity",
        "content": "Audacity",
        "description": "Audacity is a free and open-source audio editing software known for its powerful recording and editing capabilities.",
        "link": "https://www.audacityteam.org/",
        "winget": "Audacity.Audacity"
    },
    "autoruns": {
        "category": "Microsoft Tools",
        "choco": "autoruns",
        "content": "Autoruns",
        "description": "This utility shows you what programs are configured to run during system bootup or login",
        "link": "https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns",
        "winget": "Microsoft.Sysinternals.Autoruns"
    },
    "rdcman": {
        "category": "Microsoft Tools",
        "choco": "rdcman",
        "content": "RDCMan",
        "description": "RDCMan manages multiple remote desktop connections. It is useful for managing server labs where you need regular access to each machine such as automated checkin systems and data centers.",
        "link": "https://learn.microsoft.com/en-us/sysinternals/downloads/rdcman",
        "winget": "Microsoft.Sysinternals.RDCMan"
    },
    "autohotkey": {
        "category": "Utilities",
        "choco": "autohotkey",
        "content": "AutoHotkey",
        "description": "AutoHotkey is a scripting language for Windows that allows users to create custom automation scripts and macros. It is often used for automating repetitive tasks and customizing keyboard shortcuts.",
        "link": "https://www.autohotkey.com/",
        "winget": "AutoHotkey.AutoHotkey"
    },
    "azuredatastudio": {
        "category": "Microsoft Tools",
        "choco": "azure-data-studio",
        "content": "Microsoft Azure Data Studio",
        "description": "Azure Data Studio is a data management tool that enables you to work with SQL Server, Azure SQL DB and SQL DW from Windows, macOS and Linux.",
        "link": "https://docs.microsoft.com/sql/azure-data-studio/what-is-azure-data-studio",
        "winget": "Microsoft.AzureDataStudio"
    },
    "barrier": {
        "category": "Utilities",
        "choco": "barrier",
        "content": "Barrier",
        "description": "Barrier is an open-source software KVM (keyboard, video, and mouseswitch). It allows users to control multiple computers with a single keyboard and mouse, even if they have different operating systems.",
        "link": "https://github.com/debauchee/barrier",
        "winget": "DebaucheeOpenSourceGroup.Barrier"
    },
    "bat": {
        "category": "Utilities",
        "choco": "bat",
        "content": "Bat (Cat)",
        "description": "Bat is a cat command clone with syntax highlighting. It provides a user-friendly and feature-rich alternative to the traditional cat command for viewing and concatenating files.",
        "link": "https://github.com/sharkdp/bat",
        "winget": "sharkdp.bat"
    },
    "bitwarden": {
        "category": "Utilities",
        "choco": "bitwarden",
        "content": "Bitwarden",
        "description": "Bitwarden is an open-source password management solution. It allows users to store and manage their passwords in a secure and encrypted vault, accessible across multiple devices.",
        "link": "https://bitwarden.com/",
        "winget": "Bitwarden.Bitwarden"
    },
    "bleachbit": {
        "category": "Utilities",
        "choco": "bleachbit",
        "content": "BleachBit",
        "description": "Clean Your System and Free Disk Space",
        "link": "https://www.bleachbit.org/",
        "winget": "BleachBit.BleachBit"
    },
    "blender": {
        "category": "Multimedia Tools",
        "choco": "blender",
        "content": "Blender (3D Graphics)",
        "description": "Blender is a powerful open-source 3D creation suite, offering modeling, sculpting, animation, and rendering tools.",
        "link": "https://www.blender.org/",
        "winget": "BlenderFoundation.Blender"
    },
    "brave": {
        "category": "Browsers",
        "choco": "brave",
        "content": "Brave",
        "description": "Brave is a privacy-focused web browser that blocks ads and trackers, offering a faster and safer browsing experience.",
        "link": "https://www.brave.com",
        "winget": "Brave.Brave"
    },
    "bulkcrapuninstaller": {
        "category": "Utilities",
        "choco": "bulk-crap-uninstaller",
        "content": "Bulk Crap Uninstaller",
        "description": "Bulk Crap Uninstaller is a free and open-source uninstaller utility for Windows. It helps users remove unwanted programs and clean up their system by uninstalling multiple applications at once.",
        "link": "https://www.bcuninstaller.com/",
        "winget": "Klocman.BulkCrapUninstaller"
    },
    "bulkrenameutility": {
        "category": "Utilities",
        "choco": "bulkrenameutility",
        "content": "Bulk Rename Utility",
        "description": "Bulk Rename Utility allows you to easily rename files and folders recursively based upon find-replace, character place, fields, sequences, regular expressions, EXIF data, and more.",
        "link": "https://www.bulkrenameutility.co.uk",
        "winget": "TGRMNSoftware.BulkRenameUtility"
    },
    "AdvancedRenamer": {
        "category": "Utilities",
        "choco": "advanced-renamer",
        "content": "Advanced Renamer",
        "description": "Advanced Renamer is a program for renaming multiple files and folders at once. By configuring renaming methods the names can be manipulated in various ways.",
        "link": "https://www.advancedrenamer.com/",
        "winget": "HulubuluSoftware.AdvancedRenamer"
    },
    "calibre": {
        "category": "Document",
        "choco": "calibre",
        "content": "Calibre",
        "description": "Calibre is a powerful and easy-to-use e-book manager, viewer, and converter.",
        "link": "https://calibre-ebook.com/",
        "winget": "calibre.calibre"
    },
    "carnac": {
        "category": "Utilities",
        "choco": "carnac",
        "content": "Carnac",
        "description": "Carnac is a keystroke visualizer for Windows. It displays keystrokes in an overlay, making it useful for presentations, tutorials, and live demonstrations.",
        "link": "https://carnackeys.com/",
        "winget": "code52.Carnac"
    },
    "cemu": {
        "category": "Games",
        "choco": "cemu",
        "content": "Cemu",
        "description": "Cemu is a highly experimental software to emulate Wii U applications on PC.",
        "link": "https://cemu.info/",
        "winget": "Cemu.Cemu"
    },
    "chatterino": {
        "category": "Communications",
        "choco": "chatterino",
        "content": "Chatterino",
        "description": "Chatterino is a chat client for Twitch chat that offers a clean and customizable interface for a better streaming experience.",
        "link": "https://www.chatterino.com/",
        "winget": "ChatterinoTeam.Chatterino"
    },
    "chrome": {
        "category": "Browsers",
        "choco": "googlechrome",
        "content": "Chrome",
        "description": "Google Chrome is a widely used web browser known for its speed, simplicity, and seamless integration with Google services.",
        "link": "https://www.google.com/chrome/",
        "winget": "Google.Chrome"
    },
    "chromium": {
        "category": "Browsers",
        "choco": "chromium",
        "content": "Chromium",
        "description": "Chromium is the open-source project that serves as the foundation for various web browsers, including Chrome.",
        "link": "https://github.com/Hibbiki/chromium-win64",
        "winget": "Hibbiki.Chromium"
    },
    "clementine": {
        "category": "Multimedia Tools",
        "choco": "clementine",
        "content": "Clementine",
        "description": "Clementine is a modern music player and library organizer, supporting various audio formats and online radio services.",
        "link": "https://www.clementine-player.org/",
        "winget": "Clementine.Clementine"
    },
    "clink": {
        "category": "Development",
        "choco": "clink",
        "content": "Clink",
        "description": "Clink is a powerful Bash-compatible command-line interface (CLIenhancement for Windows, adding features like syntax highlighting and improved history).",
        "link": "https://mridgers.github.io/clink/",
        "winget": "chrisant996.Clink"
    },
    "clonehero": {
        "category": "Games",
        "choco": "na",
        "content": "Clone Hero",
        "description": "Clone Hero is a free rhythm game, which can be played with any 5 or 6 button guitar controller.",
        "link": "https://clonehero.net/",
        "winget": "CloneHeroTeam.CloneHero"
    },
    "cmake": {
        "category": "Development",
        "choco": "cmake",
        "content": "CMake",
        "description": "CMake is an open-source, cross-platform family of tools designed to build, test and package software.",
        "link": "https://cmake.org/",
        "winget": "Kitware.CMake"
    },
    "copyq": {
        "category": "Utilities",
        "choco": "copyq",
        "content": "CopyQ (Clipboard Manager)",
        "description": "CopyQ is a clipboard manager with advanced features, allowing you to store, edit, and retrieve clipboard history.",
        "link": "https://copyq.readthedocs.io/",
        "winget": "hluk.CopyQ"
    },
    "cpuz": {
        "category": "Utilities",
        "choco": "cpu-z",
        "content": "CPU-Z",
        "description": "CPU-Z is a system monitoring and diagnostic tool for Windows. It provides detailed information about the computer''s hardware components, including the CPU, memory, and motherboard.",
        "link": "https://www.cpuid.com/softwares/cpu-z.html",
        "winget": "CPUID.CPU-Z"
    },
    "crystaldiskinfo": {
        "category": "Utilities",
        "choco": "crystaldiskinfo",
        "content": "Crystal Disk Info",
        "description": "Crystal Disk Info is a disk health monitoring tool that provides information about the status and performance of hard drives. It helps users anticipate potential issues and monitor drive health.",
        "link": "https://crystalmark.info/en/software/crystaldiskinfo/",
        "winget": "CrystalDewWorld.CrystalDiskInfo"
    },
    "capframex": {
        "category": "Utilities",
        "choco": "na",
        "content": "CapFrameX",
        "description": "Frametimes capture and analysis tool based on Intel''s PresentMon. Overlay provided by Rivatuner Statistics Server.",
        "link": "https://www.capframex.com/",
        "winget": "CXWorld.CapFrameX"
    },
    "crystaldiskmark": {
        "category": "Utilities",
        "choco": "crystaldiskmark",
        "content": "Crystal Disk Mark",
        "description": "Crystal Disk Mark is a disk benchmarking tool that measures the read and write speeds of storage devices. It helps users assess the performance of their hard drives and SSDs.",
        "link": "https://crystalmark.info/en/software/crystaldiskmark/",
        "winget": "CrystalDewWorld.CrystalDiskMark"
    },
    "darktable": {
        "category": "Multimedia Tools",
        "choco": "darktable",
        "content": "darktable",
        "description": "Open-source photo editing tool, offering an intuitive interface, advanced editing capabilities, and a non-destructive workflow for seamless image enhancement.",
        "link": "https://www.darktable.org/install/",
        "winget": "darktable.darktable"
    },
    "DaxStudio": {
        "category": "Development",
        "choco": "daxstudio",
        "content": "DaxStudio",
        "description": "DAX (Data Analysis eXpressions) Studio is the ultimate tool for executing and analyzing DAX queries against Microsoft Tabular models.",
        "link": "https://daxstudio.org/",
        "winget": "DaxStudio.DaxStudio"
    },
    "ddu": {
        "category": "Utilities",
        "choco": "ddu",
        "content": "Display Driver Uninstaller",
        "description": "Display Driver Uninstaller (DDU) is a tool for completely uninstalling graphics drivers from NVIDIA, AMD, and Intel. It is useful for troubleshooting graphics driver-related issues.",
        "link": "https://www.wagnardsoft.com/display-driver-uninstaller-DDU-",
        "winget": "Wagnardsoft.DisplayDriverUninstaller"
    },
    "deluge": {
        "category": "Utilities",
        "choco": "deluge",
        "content": "Deluge",
        "description": "Deluge is a free and open-source BitTorrent client. It features a user-friendly interface, support for plugins, and the ability to manage torrents remotely.",
        "link": "https://deluge-torrent.org/",
        "winget": "DelugeTeam.Deluge"
    },
    "devtoys": {
        "category": "Utilities",
        "choco": "devtoys",
        "content": "DevToys",
        "description": "DevToys is a collection of development-related utilities and tools for Windows. It includes tools for file management, code formatting, and productivity enhancements for developers.",
        "link": "https://devtoys.app/",
        "winget": "DevToys-app.DevToys"
    },
    "digikam": {
        "category": "Multimedia Tools",
        "choco": "digikam",
        "content": "digiKam",
        "description": "digiKam is an advanced open-source photo management software with features for organizing, editing, and sharing photos.",
        "link": "https://www.digikam.org/",
        "winget": "KDE.digikam"
    },
    "discord": {
        "category": "Communications",
        "choco": "discord",
        "content": "Discord",
        "description": "Discord is a popular communication platform with voice, video, and text chat, designed for gamers but used by a wide range of communities.",
        "link": "https://discord.com/",
        "winget": "Discord.Discord"
    },
    "ditto": {
        "category": "Utilities",
        "choco": "ditto",
        "content": "Ditto",
        "description": "Ditto is an extension to the standard windows clipboard.",
        "link": "https://github.com/sabrogden/Ditto",
        "winget": "Ditto.Ditto"
    },
    "dockerdesktop": {
        "category": "Development",
        "choco": "docker-desktop",
        "content": "Docker Desktop",
        "description": "Docker Desktop is a powerful tool for containerized application development and deployment.",
        "link": "https://www.docker.com/products/docker-desktop",
        "winget": "Docker.DockerDesktop"
    },
    "dotnet3": {
        "category": "Microsoft Tools",
        "choco": "dotnetcore3-desktop-runtime",
        "content": ".NET Desktop Runtime 3.1",
        "description": ".NET Desktop Runtime 3.1 is a runtime environment required for running applications developed with .NET Core 3.1.",
        "link": "https://dotnet.microsoft.com/download/dotnet/3.1",
        "winget": "Microsoft.DotNet.DesktopRuntime.3_1"
    },
    "dotnet5": {
        "category": "Microsoft Tools",
        "choco": "dotnet-5.0-runtime",
        "content": ".NET Desktop Runtime 5",
        "description": ".NET Desktop Runtime 5 is a runtime environment required for running applications developed with .NET 5.",
        "link": "https://dotnet.microsoft.com/download/dotnet/5.0",
        "winget": "Microsoft.DotNet.DesktopRuntime.5"
    },
    "dotnet6": {
        "category": "Microsoft Tools",
        "choco": "dotnet-6.0-runtime",
        "content": ".NET Desktop Runtime 6",
        "description": ".NET Desktop Runtime 6 is a runtime environment required for running applications developed with .NET 6.",
        "link": "https://dotnet.microsoft.com/download/dotnet/6.0",
        "winget": "Microsoft.DotNet.DesktopRuntime.6"
    },
    "dotnet7": {
        "category": "Microsoft Tools",
        "choco": "dotnet-7.0-runtime",
        "content": ".NET Desktop Runtime 7",
        "description": ".NET Desktop Runtime 7 is a runtime environment required for running applications developed with .NET 7.",
        "link": "https://dotnet.microsoft.com/download/dotnet/7.0",
        "winget": "Microsoft.DotNet.DesktopRuntime.7"
    },
    "dotnet8": {
        "category": "Microsoft Tools",
        "choco": "dotnet-8.0-runtime",
        "content": ".NET Desktop Runtime 8",
        "description": ".NET Desktop Runtime 8 is a runtime environment required for running applications developed with .NET 8.",
        "link": "https://dotnet.microsoft.com/download/dotnet/8.0",
        "winget": "Microsoft.DotNet.DesktopRuntime.8"
    },
    "dotnet9": {
        "category": "Microsoft Tools",
        "choco": "dotnet-9.0-runtime",
        "content": ".NET Desktop Runtime 9",
        "description": ".NET Desktop Runtime 9 is a runtime environment required for running applications developed with .NET 9.",
        "link": "https://dotnet.microsoft.com/download/dotnet/9.0",
        "winget": "Microsoft.DotNet.DesktopRuntime.9"
    },
    "dmt": {
        "winget": "GNE.DualMonitorTools",
        "choco": "dual-monitor-tools",
        "category": "Utilities",
        "content": "Dual Monitor Tools",
        "link": "https://dualmonitortool.sourceforge.net/",
        "description": "Dual Monitor Tools (DMT) is a FOSS app that allows you to customize the handling of multiple monitors. Useful for fullscreen games and apps that handle a second monitor poorly and can improve your workflow."
    },
    "duplicati": {
        "category": "Utilities",
        "choco": "duplicati",
        "content": "Duplicati",
        "description": "Duplicati is an open-source backup solution that supports encrypted, compressed, and incremental backups. It is designed to securely store data on cloud storage services.",
        "link": "https://www.duplicati.com/",
        "winget": "Duplicati.Duplicati"
    },
    "eaapp": {
        "category": "Games",
        "choco": "ea-app",
        "content": "EA App",
        "description": "EA App is a platform for accessing and playing Electronic Arts games.",
        "link": "https://www.ea.com/ea-app",
        "winget": "ElectronicArts.EADesktop"
    },
    "eartrumpet": {
        "category": "Multimedia Tools",
        "choco": "eartrumpet",
        "content": "EarTrumpet (Audio)",
        "description": "EarTrumpet is an audio control app for Windows, providing a simple and intuitive interface for managing sound settings.",
        "link": "https://eartrumpet.app/",
        "winget": "File-New-Project.EarTrumpet"
    },
    "edge": {
        "category": "Browsers",
        "choco": "microsoft-edge",
        "content": "Edge",
        "description": "Microsoft Edge is a modern web browser built on Chromium, offering performance, security, and integration with Microsoft services.",
        "link": "https://www.microsoft.com/edge",
        "winget": "Microsoft.Edge"
    },
    "efibooteditor": {
        "category": "Pro Tools",
        "choco": "na",
        "content": "EFI Boot Editor",
        "description": "EFI Boot Editor is a tool for managing the EFI/UEFI boot entries on your system. It allows you to customize the boot configuration of your computer.",
        "link": "https://www.easyuefi.com/",
        "winget": "EFIBootEditor.EFIBootEditor"
    },
    "emulationstation": {
        "category": "Games",
        "choco": "emulationstation",
        "content": "Emulation Station",
        "description": "Emulation Station is a graphical and themeable emulator front-end that allows you to access all your favorite games in one place.",
        "link": "https://emulationstation.org/",
        "winget": "Emulationstation.Emulationstation"
    },
    "epicgames": {
        "category": "Games",
        "choco": "epicgameslauncher",
        "content": "Epic Games Launcher",
        "description": "Epic Games Launcher is the client for accessing and playing games from the Epic Games Store.",
        "link": "https://www.epicgames.com/store/en-US/",
        "winget": "EpicGames.EpicGamesLauncher"
    },
    "esearch": {
        "category": "Utilities",
        "choco": "everything",
        "content": "Everything Search",
        "description": "Everything Search is a fast and efficient file search utility for Windows.",
        "link": "https://www.voidtools.com/",
        "winget": "voidtools.Everything"
    },
    "espanso": {
        "category": "Utilities",
        "choco": "espanso",
        "content": "Espanso",
        "description": "Cross-platform and open-source Text Expander written in Rust",
        "link": "https://espanso.org/",
        "winget": "Espanso.Espanso"
    },
    "falkon": {
        "category": "Browsers",
        "choco": "falkon",
        "content": "Falkon",
        "description": "Falkon is a lightweight and fast web browser with a focus on user privacy and efficiency.",
        "link": "https://www.falkon.org/",
        "winget": "KDE.Falkon"
    },
    "fastfetch": {
        "category": "Utilities",
        "choco": "na",
        "content": "Fastfetch",
        "description": "Fastfetch is a neofetch-like tool for fetching system information and displaying them in a pretty way",
        "link": "https://github.com/fastfetch-cli/fastfetch/",
        "winget": "Fastfetch-cli.Fastfetch"
    },
    "ferdium": {
        "category": "Communications",
        "choco": "ferdium",
        "content": "Ferdium",
        "description": "Ferdium is a messaging application that combines multiple messaging services into a single app for easy management.",
        "link": "https://ferdium.org/",
        "winget": "Ferdium.Ferdium"
    },
    "ffmpeg": {
        "category": "Multimedia Tools",
        "choco": "ffmpeg-full",
        "content": "FFmpeg (full)",
        "description": "FFmpeg is a powerful multimedia processing tool that enables users to convert, edit, and stream audio and video files with a vast range of codecs and formats.",
        "link": "https://ffmpeg.org/",
        "winget": "Gyan.FFmpeg"
    },
    "fileconverter": {
        "category": "Utilities",
        "choco": "file-converter",
        "content": "File-Converter",
        "description": "File Converter is a very simple tool which allows you to convert and compress one or several file(s) using the context menu in windows explorer.",
        "link": "https://file-converter.io/",
        "winget": "AdrienAllard.FileConverter"
    },
    "files": {
        "category": "Utilities",
        "choco": "files",
        "content": "Files",
        "description": "Alternative file explorer.",
        "link": "https://github.com/files-community/Files",
        "winget": "na"
    },
    "firealpaca": {
        "category": "Multimedia Tools",
        "choco": "firealpaca",
        "content": "Fire Alpaca",
        "description": "Fire Alpaca is a free digital painting software that provides a wide range of drawing tools and a user-friendly interface.",
        "link": "https://firealpaca.com/",
        "winget": "FireAlpaca.FireAlpaca"
    },
    "firefox": {
        "category": "Browsers",
        "choco": "firefox",
        "content": "Firefox",
        "description": "Mozilla Firefox is an open-source web browser known for its customization options, privacy features, and extensions.",
        "link": "https://www.mozilla.org/en-US/firefox/new/",
        "winget": "Mozilla.Firefox"
    },
    "firefoxesr": {
        "category": "Browsers",
        "choco": "FirefoxESR",
        "content": "Firefox ESR",
        "description": "Mozilla Firefox is an open-source web browser known for its customization options, privacy features, and extensions. Firefox ESR (Extended Support Release) receives major updates every 42 weeks with minor updates such as crash fixes, security fixes and policy updates as needed, but at least every four weeks.",
        "link": "https://www.mozilla.org/en-US/firefox/enterprise/",
        "winget": "Mozilla.Firefox.ESR"
    },
    "flameshot": {
        "category": "Multimedia Tools",
        "choco": "flameshot",
        "content": "Flameshot (Screenshots)",
        "description": "Flameshot is a powerful yet simple to use screenshot software, offering annotation and editing features.",
        "link": "https://flameshot.org/",
        "winget": "Flameshot.Flameshot"
    },
    "lightshot": {
        "category": "Multimedia Tools",
        "choco": "lightshot",
        "content": "Lightshot (Screenshots)",
        "description": "Ligthshot is an Easy-to-use, light-weight screenshot software tool, where you can optionally edit your screenshots using different tools, share them via Internet and/or save to disk, and customize the available options.",
        "link": "https://app.prntscr.com/",
        "winget": "Skillbrains.Lightshot"
    },
    "floorp": {
        "category": "Browsers",
        "choco": "na",
        "content": "Floorp",
        "description": "Floorp is an open-source web browser project that aims to provide a simple and fast browsing experience.",
        "link": "https://floorp.app/",
        "winget": "Ablaze.Floorp"
    },
    "flow": {
        "category": "Utilities",
        "choco": "flow-launcher",
        "content": "Flow launcher",
        "description": "Keystroke launcher for Windows to search, manage and launch files, folders bookmarks, websites and more.",
        "link": "https://www.flowlauncher.com/",
        "winget": "Flow-Launcher.Flow-Launcher"
    },
    "flux": {
        "category": "Utilities",
        "choco": "flux",
        "content": "F.lux",
        "description": "f.lux adjusts the color temperature of your screen to reduce eye strain during nighttime use.",
        "link": "https://justgetflux.com/",
        "winget": "flux.flux"
    },
    "foobar": {
        "category": "Multimedia Tools",
        "choco": "foobar2000",
        "content": "foobar2000 (Music Player)",
        "description": "foobar2000 is a highly customizable and extensible music player for Windows, known for its modular design and advanced features.",
        "link": "https://www.foobar2000.org/",
        "winget": "PeterPawlowski.foobar2000"
    },
    "foxpdfeditor": {
        "category": "Document",
        "choco": "na",
        "content": "Foxit PDF Editor",
        "description": "Foxit PDF Editor is a feature-rich PDF editor and viewer with a familiar ribbon-style interface.",
        "link": "https://www.foxit.com/pdf-editor/",
        "winget": "Foxit.PhantomPDF"
    },
    "foxpdfreader": {
        "category": "Document",
        "choco": "foxitreader",
        "content": "Foxit PDF Reader",
        "description": "Foxit PDF Reader is a free PDF viewer with a familiar ribbon-style interface.",
        "link": "https://www.foxit.com/pdf-reader/",
        "winget": "Foxit.FoxitReader"
    },
    "freecad": {
        "category": "Multimedia Tools",
        "choco": "freecad",
        "content": "FreeCAD",
        "description": "FreeCAD is a parametric 3D CAD modeler, designed for product design and engineering tasks, with a focus on flexibility and extensibility.",
        "link": "https://www.freecadweb.org/",
        "winget": "FreeCAD.FreeCAD"
    },
    "fxsound": {
        "category": "Multimedia Tools",
        "choco": "fxsound",
        "content": "FxSound",
        "description": "FxSound is free open-source software to boost sound quality, volume, and bass. Including an equalizer, effects, and presets for customized audio.",
        "link": "https://www.fxsound.com/",
        "winget": "FxSound.FxSound"
    },
    "fzf": {
        "category": "Utilities",
        "choco": "fzf",
        "content": "Fzf",
        "description": "A command-line fuzzy finder",
        "link": "https://github.com/junegunn/fzf/",
        "winget": "junegunn.fzf"
    },
    "geforcenow": {
        "category": "Games",
        "choco": "nvidia-geforce-now",
        "content": "GeForce NOW",
        "description": "GeForce NOW is a cloud gaming service that allows you to play high-quality PC games on your device.",
        "link": "https://www.nvidia.com/en-us/geforce-now/",
        "winget": "Nvidia.GeForceNow"
    },
    "gimp": {
        "category": "Multimedia Tools",
        "choco": "gimp",
        "content": "GIMP (Image Editor)",
        "description": "GIMP is a versatile open-source raster graphics editor used for tasks such as photo retouching, image editing, and image composition.",
        "link": "https://www.gimp.org/",
        "winget": "GIMP.GIMP.3"
    },
    "git": {
        "category": "Development",
        "choco": "git",
        "content": "Git",
        "description": "Git is a distributed version control system widely used for tracking changes in source code during software development.",
        "link": "https://git-scm.com/",
        "winget": "Git.Git"
    },
    "gitbutler": {
        "category": "Development",
        "choco": "na",
        "content": "Git Butler",
        "description": "A Git client for simultaneous branches on top of your existing workflow.",
        "link": "https://gitbutler.com/",
        "winget": "GitButler.GitButler"
    },
    "gitextensions": {
        "category": "Development",
        "choco": "git;gitextensions",
        "content": "Git Extensions",
        "description": "Git Extensions is a graphical user interface for Git, providing additional features for easier source code management.",
        "link": "https://gitextensions.github.io/",
        "winget": "GitExtensionsTeam.GitExtensions"
    },
    "githubcli": {
        "category": "Development",
        "choco": "git;gh",
        "content": "GitHub CLI",
        "description": "GitHub CLI is a command-line tool that simplifies working with GitHub directly from the terminal.",
        "link": "https://cli.github.com/",
        "winget": "GitHub.cli"
    },
    "githubdesktop": {
        "category": "Development",
        "choco": "git;github-desktop",
        "content": "GitHub Desktop",
        "description": "GitHub Desktop is a visual Git client that simplifies collaboration on GitHub repositories with an easy-to-use interface.",
        "link": "https://desktop.github.com/",
        "winget": "GitHub.GitHubDesktop"
    },
    "gitkrakenclient": {
        "category": "Development",
        "choco": "gitkraken",
        "content": "GitKraken Client",
        "description": "GitKraken Client is a powerful visual Git client from Axosoft that works with ALL git repositories on any hosting environment.",
        "link": "https://www.gitkraken.com/git-client",
        "winget": "Axosoft.GitKraken"
    },
    "glaryutilities": {
        "category": "Utilities",
        "choco": "glaryutilities-free",
        "content": "Glary Utilities",
        "description": "Glary Utilities is a comprehensive system optimization and maintenance tool for Windows.",
        "link": "https://www.glarysoft.com/glary-utilities/",
        "winget": "Glarysoft.GlaryUtilities"
    },
    "godotengine": {
        "category": "Development",
        "choco": "godot",
        "content": "Godot Engine",
        "description": "Godot Engine is a free, open-source 2D and 3D game engine with a focus on usability and flexibility.",
        "link": "https://godotengine.org/",
        "winget": "GodotEngine.GodotEngine"
    },
    "gog": {
        "category": "Games",
        "choco": "goggalaxy",
        "content": "GOG Galaxy",
        "description": "GOG Galaxy is a gaming client that offers DRM-free games, additional content, and more.",
        "link": "https://www.gog.com/galaxy",
        "winget": "GOG.Galaxy"
    },
    "gitify": {
        "category": "Development",
        "choco": "na",
        "content": "Gitify",
        "description": "GitHub notifications on your menu bar.",
        "link": "https://www.gitify.io/",
        "winget": "Gitify.Gitify"
    },
    "golang": {
        "category": "Development",
        "choco": "golang",
        "content": "Go",
        "description": "Go (or Golang) is a statically typed, compiled programming language designed for simplicity, reliability, and efficiency.",
        "link": "https://go.dev/",
        "winget": "GoLang.Go"
    },
    "googledrive": {
        "category": "Utilities",
        "choco": "googledrive",
        "content": "Google Drive",
        "description": "File syncing across devices all tied to your google account",
        "link": "https://www.google.com/drive/",
        "winget": "Google.GoogleDrive"
    },
    "gpuz": {
        "category": "Utilities",
        "choco": "gpu-z",
        "content": "GPU-Z",
        "description": "GPU-Z provides detailed information about your graphics card and GPU.",
        "link": "https://www.techpowerup.com/gpuz/",
        "winget": "TechPowerUp.GPU-Z"
    },
    "greenshot": {
        "category": "Multimedia Tools",
        "choco": "greenshot",
        "content": "Greenshot (Screenshots)",
        "description": "Greenshot is a light-weight screenshot software tool with built-in image editor and customizable capture options.",
        "link": "https://getgreenshot.org/",
        "winget": "Greenshot.Greenshot"
    },
    "gsudo": {
        "category": "Utilities",
        "choco": "gsudo",
        "content": "Gsudo",
        "description": "Gsudo is a sudo implementation for Windows, allowing elevated privilege execution.",
        "link": "https://gerardog.github.io/gsudo/",
        "winget": "gerardog.gsudo"
    },
    "guilded": {
        "category": "Communications",
        "choco": "na",
        "content": "Guilded",
        "description": "Guilded is a communication and productivity platform that includes chat, scheduling, and collaborative tools for gaming and communities.",
        "link": "https://www.guilded.gg/",
        "winget": "Guilded.Guilded"
    },
    "handbrake": {
        "category": "Multimedia Tools",
        "choco": "handbrake",
        "content": "HandBrake",
        "description": "HandBrake is an open-source video transcoder, allowing you to convert video from nearly any format to a selection of widely supported codecs.",
        "link": "https://handbrake.fr/",
        "winget": "HandBrake.HandBrake"
    },
    "harmonoid": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "Harmonoid",
        "description": "Plays and manages your music library. Looks beautiful and juicy. Playlists, visuals, synced lyrics, pitch shift, volume boost and more.",
        "link": "https://harmonoid.com/",
        "winget": "Harmonoid.Harmonoid"
    },
    "heidisql": {
        "category": "Pro Tools",
        "choco": "heidisql",
        "content": "HeidiSQL",
        "description": "HeidiSQL is a powerful and easy-to-use client for MySQL, MariaDB, Microsoft SQL Server, and PostgreSQL databases. It provides tools for database management and development.",
        "link": "https://www.heidisql.com/",
        "winget": "HeidiSQL.HeidiSQL"
    },
    "helix": {
        "category": "Development",
        "choco": "helix",
        "content": "Helix",
        "description": "Helix is a neovim alternative built in rust.",
        "link": "https://helix-editor.com/",
        "winget": "Helix.Helix"
    },
    "heroiclauncher": {
        "category": "Games",
        "choco": "na",
        "content": "Heroic Games Launcher",
        "description": "Heroic Games Launcher is an open-source alternative game launcher for Epic Games Store.",
        "link": "https://heroicgameslauncher.com/",
        "winget": "HeroicGamesLauncher.HeroicGamesLauncher"
    },
    "hexchat": {
        "category": "Communications",
        "choco": "hexchat",
        "content": "Hexchat",
        "description": "HexChat is a free, open-source IRC (Internet Relay Chat) client with a graphical interface for easy communication.",
        "link": "https://hexchat.github.io/",
        "winget": "HexChat.HexChat"
    },
    "hwinfo": {
        "category": "Utilities",
        "choco": "hwinfo",
        "content": "HWiNFO",
        "description": "HWiNFO provides comprehensive hardware information and diagnostics for Windows.",
        "link": "https://www.hwinfo.com/",
        "winget": "REALiX.HWiNFO"
    },
    "hwmonitor": {
        "category": "Utilities",
        "choco": "hwmonitor",
        "content": "HWMonitor",
        "description": "HWMonitor is a hardware monitoring program that reads PC systems main health sensors.",
        "link": "https://www.cpuid.com/softwares/hwmonitor.html",
        "winget": "CPUID.HWMonitor"
    },
    "imageglass": {
        "category": "Multimedia Tools",
        "choco": "imageglass",
        "content": "ImageGlass (Image Viewer)",
        "description": "ImageGlass is a versatile image viewer with support for various image formats and a focus on simplicity and speed.",
        "link": "https://imageglass.org/",
        "winget": "DuongDieuPhap.ImageGlass"
    },
    "imgburn": {
        "category": "Multimedia Tools",
        "choco": "imgburn",
        "content": "ImgBurn",
        "description": "ImgBurn is a lightweight CD, DVD, HD-DVD, and Blu-ray burning application with advanced features for creating and burning disc images.",
        "link": "https://www.imgburn.com/",
        "winget": "LIGHTNINGUK.ImgBurn"
    },
    "inkscape": {
        "category": "Multimedia Tools",
        "choco": "inkscape",
        "content": "Inkscape",
        "description": "Inkscape is a powerful open-source vector graphics editor, suitable for tasks such as illustrations, icons, logos, and more.",
        "link": "https://inkscape.org/",
        "winget": "Inkscape.Inkscape"
    },
    "itch": {
        "category": "Games",
        "choco": "itch",
        "content": "Itch.io",
        "description": "Itch.io is a digital distribution platform for indie games and creative projects.",
        "link": "https://itch.io/",
        "winget": "ItchIo.Itch"
    },
    "itunes": {
        "category": "Multimedia Tools",
        "choco": "itunes",
        "content": "iTunes",
        "description": "iTunes is a media player, media library, and online radio broadcaster application developed by Apple Inc.",
        "link": "https://www.apple.com/itunes/",
        "winget": "Apple.iTunes"
    },
    "jami": {
        "category": "Communications",
        "choco": "jami",
        "content": "Jami",
        "description": "Jami is a secure and privacy-focused communication platform that offers audio and video calls, messaging, and file sharing.",
        "link": "https://jami.net/",
        "winget": "SFLinux.Jami"
    },
    "java8": {
        "category": "Development",
        "choco": "corretto8jdk",
        "content": "Amazon Corretto 8 (LTS)",
        "description": "Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK).",
        "link": "https://aws.amazon.com/corretto",
        "winget": "Amazon.Corretto.8.JDK"
    },
    "java11": {
        "category": "Development",
        "choco": "corretto11jdk",
        "content": "Amazon Corretto 11 (LTS)",
        "description": "Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK).",
        "link": "https://aws.amazon.com/corretto",
        "winget": "Amazon.Corretto.11.JDK"
    },
    "java17": {
        "category": "Development",
        "choco": "corretto17jdk",
        "content": "Amazon Corretto 17 (LTS)",
        "description": "Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK).",
        "link": "https://aws.amazon.com/corretto",
        "winget": "Amazon.Corretto.17.JDK"
    },
    "java21": {
        "category": "Development",
        "choco": "corretto21jdk",
        "content": "Amazon Corretto 21 (LTS)",
        "description": "Amazon Corretto is a no-cost, multiplatform, production-ready distribution of the Open Java Development Kit (OpenJDK).",
        "link": "https://aws.amazon.com/corretto",
        "winget": "Amazon.Corretto.21.JDK"
    },
    "jdownloader": {
        "category": "Utilities",
        "choco": "jdownloader",
        "content": "JDownloader",
        "description": "JDownloader is a feature-rich download manager with support for various file hosting services.",
        "link": "https://jdownloader.org/",
        "winget": "AppWork.JDownloader"
    },
    "jellyfinmediaplayer": {
        "category": "Multimedia Tools",
        "choco": "jellyfin-media-player",
        "content": "Jellyfin Media Player",
        "description": "Jellyfin Media Player is a client application for the Jellyfin media server, providing access to your media library.",
        "link": "https://github.com/jellyfin/jellyfin-media-player",
        "winget": "Jellyfin.JellyfinMediaPlayer"
    },
    "jellyfinserver": {
        "category": "Multimedia Tools",
        "choco": "jellyfin",
        "content": "Jellyfin Server",
        "description": "Jellyfin Server is an open-source media server software, allowing you to organize and stream your media library.",
        "link": "https://jellyfin.org/",
        "winget": "Jellyfin.Server"
    },
    "jetbrains": {
        "category": "Development",
        "choco": "jetbrainstoolbox",
        "content": "Jetbrains Toolbox",
        "description": "Jetbrains Toolbox is a platform for easy installation and management of JetBrains developer tools.",
        "link": "https://www.jetbrains.com/toolbox/",
        "winget": "JetBrains.Toolbox"
    },
    "joplin": {
        "category": "Document",
        "choco": "joplin",
        "content": "Joplin (FOSS Notes)",
        "description": "Joplin is an open-source note-taking and to-do application with synchronization capabilities.",
        "link": "https://joplinapp.org/",
        "winget": "Joplin.Joplin"
    },
    "jpegview": {
        "category": "Utilities",
        "choco": "jpegview",
        "content": "JPEG View",
        "description": "JPEGView is a lean, fast and highly configurable viewer/editor for JPEG, BMP, PNG, WEBP, TGA, GIF, JXL, HEIC, HEIF, AVIF and TIFF images with a minimal GUI",
        "link": "https://github.com/sylikc/jpegview",
        "winget": "sylikc.JPEGView"
    },
    "kdeconnect": {
        "category": "Utilities",
        "choco": "kdeconnect-kde",
        "content": "KDE Connect",
        "description": "KDE Connect allows seamless integration between your KDE desktop and mobile devices.",
        "link": "https://community.kde.org/KDEConnect",
        "winget": "KDE.KDEConnect"
    },
    "kdenlive": {
        "category": "Multimedia Tools",
        "choco": "kdenlive",
        "content": "Kdenlive (Video Editor)",
        "description": "Kdenlive is an open-source video editing software with powerful features for creating and editing professional-quality videos.",
        "link": "https://kdenlive.org/",
        "winget": "KDE.Kdenlive"
    },
    "keepass": {
        "category": "Utilities",
        "choco": "keepassxc",
        "content": "KeePassXC",
        "description": "KeePassXC is a cross-platform, open-source password manager with strong encryption features.",
        "link": "https://keepassxc.org/",
        "winget": "KeePassXCTeam.KeePassXC"
    },
    "klite": {
        "category": "Multimedia Tools",
        "choco": "k-litecodecpack-standard",
        "content": "K-Lite Codec Standard",
        "description": "K-Lite Codec Pack Standard is a collection of audio and video codecs and related tools, providing essential components for media playback.",
        "link": "https://www.codecguide.com/",
        "winget": "CodecGuide.K-LiteCodecPack.Standard"
    },
    "kodi": {
        "category": "Multimedia Tools",
        "choco": "kodi",
        "content": "Kodi Media Center",
        "description": "Kodi is an open-source media center application that allows you to play and view most videos, music, podcasts, and other digital media files.",
        "link": "https://kodi.tv/",
        "winget": "XBMCFoundation.Kodi"
    },
    "krita": {
        "category": "Multimedia Tools",
        "choco": "krita",
        "content": "Krita (Image Editor)",
        "description": "Krita is a powerful open-source painting application. It is designed for concept artists, illustrators, matte and texture artists, and the VFX industry.",
        "link": "https://krita.org/en/features/",
        "winget": "KDE.Krita"
    },
    "lazygit": {
        "category": "Development",
        "choco": "lazygit",
        "content": "Lazygit",
        "description": "Simple terminal UI for git commands",
        "link": "https://github.com/jesseduffield/lazygit/",
        "winget": "JesseDuffield.lazygit"
    },
    "libreoffice": {
        "category": "Document",
        "choco": "libreoffice-fresh",
        "content": "LibreOffice",
        "description": "LibreOffice is a powerful and free office suite, compatible with other major office suites.",
        "link": "https://www.libreoffice.org/",
        "winget": "TheDocumentFoundation.LibreOffice"
    },
    "librewolf": {
        "category": "Browsers",
        "choco": "librewolf",
        "content": "LibreWolf",
        "description": "LibreWolf is a privacy-focused web browser based on Firefox, with additional privacy and security enhancements.",
        "link": "https://librewolf-community.gitlab.io/",
        "winget": "LibreWolf.LibreWolf"
    },
    "linkshellextension": {
        "category": "Utilities",
        "choco": "linkshellextension",
        "content": "Link Shell extension",
        "description": "Link Shell Extension (LSE) provides for the creation of Hardlinks, Junctions, Volume Mountpoints, Symbolic Links, a folder cloning process that utilises Hardlinks or Symbolic Links and a copy process taking care of Junctions, Symbolic Links, and Hardlinks. LSE, as its name implies is implemented as a Shell extension and is accessed from Windows Explorer, or similar file/folder managers.",
        "link": "https://schinagl.priv.at/nt/hardlinkshellext/hardlinkshellext.html",
        "winget": "HermannSchinagl.LinkShellExtension"
    },
    "linphone": {
        "category": "Communications",
        "choco": "linphone",
        "content": "Linphone",
        "description": "Linphone is an open-source voice over IP (VoIPservice that allows for audio and video calls, messaging, and more.",
        "link": "https://www.linphone.org/",
        "winget": "BelledonneCommunications.Linphone"
    },
    "livelywallpaper": {
        "category": "Utilities",
        "choco": "lively",
        "content": "Lively Wallpaper",
        "description": "Free and open-source software that allows users to set animated desktop wallpapers and screensavers.",
        "link": "https://www.rocksdanister.com/lively/",
        "winget": "rocksdanister.LivelyWallpaper"
    },
    "localsend": {
        "category": "Utilities",
        "choco": "localsend.install",
        "content": "LocalSend",
        "description": "An open source cross-platform alternative to AirDrop.",
        "link": "https://localsend.org/",
        "winget": "LocalSend.LocalSend"
    },
    "lockhunter": {
        "category": "Utilities",
        "choco": "lockhunter",
        "content": "LockHunter",
        "description": "LockHunter is a free tool to delete files blocked by something you do not know.",
        "link": "https://lockhunter.com/",
        "winget": "CrystalRich.LockHunter"
    },
    "logseq": {
        "category": "Document",
        "choco": "logseq",
        "content": "Logseq",
        "description": "Logseq is a versatile knowledge management and note-taking application designed for the digital thinker. With a focus on the interconnectedness of ideas, Logseq allows users to seamlessly organize their thoughts through a combination of hierarchical outlines and bi-directional linking. It supports both structured and unstructured content, enabling users to create a personalized knowledge graph that adapts to their evolving ideas and insights.",
        "link": "https://logseq.com/",
        "winget": "Logseq.Logseq"
    },
    "malwarebytes": {
        "category": "Utilities",
        "choco": "malwarebytes",
        "content": "Malwarebytes",
        "description": "Malwarebytes is an anti-malware software that provides real-time protection against threats.",
        "link": "https://www.malwarebytes.com/",
        "winget": "Malwarebytes.Malwarebytes"
    },
    "masscode": {
        "category": "Document",
        "choco": "na",
        "content": "massCode (Snippet Manager)",
        "description": "massCode is a fast and efficient open-source code snippet manager for developers.",
        "link": "https://masscode.io/",
        "winget": "antonreshetov.massCode"
    },
    "matrix": {
        "category": "Communications",
        "choco": "element-desktop",
        "content": "Element",
        "description": "Element is a client for Matrix—an open network for secure, decentralized communication.",
        "link": "https://element.io/",
        "winget": "Element.Element"
    },
    "meld": {
        "category": "Utilities",
        "choco": "meld",
        "content": "Meld",
        "description": "Meld is a visual diff and merge tool for files and directories.",
        "link": "https://meldmerge.org/",
        "winget": "Meld.Meld"
    },
    "ModernFlyouts": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "Modern Flyouts",
        "description": "An open source, modern, Fluent Design-based set of flyouts for Windows.",
        "link": "https://github.com/ModernFlyouts-Community/ModernFlyouts/",
        "winget": "ModernFlyouts.ModernFlyouts"
    },
    "monitorian": {
        "category": "Utilities",
        "choco": "monitorian",
        "content": "Monitorian",
        "description": "Monitorian is a utility for adjusting monitor brightness and contrast on Windows.",
        "link": "https://github.com/emoacht/Monitorian",
        "winget": "emoacht.Monitorian"
    },
    "moonlight": {
        "category": "Games",
        "choco": "moonlight-qt",
        "content": "Moonlight/GameStream Client",
        "description": "Moonlight/GameStream Client allows you to stream PC games to other devices over your local network.",
        "link": "https://moonlight-stream.org/",
        "winget": "MoonlightGameStreamingProject.Moonlight"
    },
    "Motrix": {
        "category": "Utilities",
        "choco": "motrix",
        "content": "Motrix Download Manager",
        "description": "A full-featured download manager.",
        "link": "https://motrix.app/",
        "winget": "agalwood.Motrix"
    },
    "mpchc": {
        "category": "Multimedia Tools",
        "choco": "mpc-hc-clsid2",
        "content": "Media Player Classic - Home Cinema",
        "description": "Media Player Classic - Home Cinema (MPC-HC) is a free and open-source video and audio player for Windows. MPC-HC is based on the original Guliverkli project and contains many additional features and bug fixes.",
        "link": "https://github.com/clsid2/mpc-hc/",
        "winget": "clsid2.mpc-hc"
    },
    "mremoteng": {
        "category": "Pro Tools",
        "choco": "mremoteng",
        "content": "mRemoteNG",
        "description": "mRemoteNG is a free and open-source remote connections manager. It allows you to view and manage multiple remote sessions in a single interface.",
        "link": "https://mremoteng.org/",
        "winget": "mRemoteNG.mRemoteNG"
    },
    "msedgeredirect": {
        "category": "Utilities",
        "choco": "msedgeredirect",
        "content": "MSEdgeRedirect",
        "description": "A Tool to Redirect News, Search, Widgets, Weather, and More to Your Default Browser.",
        "link": "https://github.com/rcmaehl/MSEdgeRedirect",
        "winget": "rcmaehl.MSEdgeRedirect"
    },
    "msiafterburner": {
        "category": "Utilities",
        "choco": "msiafterburner",
        "content": "MSI Afterburner",
        "description": "MSI Afterburner is a graphics card overclocking utility with advanced features.",
        "link": "https://www.msi.com/Landing/afterburner",
        "winget": "Guru3D.Afterburner"
    },
    "mullvadvpn": {
        "category": "Pro Tools",
        "choco": "mullvad-app",
        "content": "Mullvad VPN",
        "description": "This is the VPN client software for the Mullvad VPN service.",
        "link": "https://github.com/mullvad/mullvadvpn-app",
        "winget": "MullvadVPN.MullvadVPN"
    },
    "BorderlessGaming": {
        "category": "Utilities",
        "choco": "borderlessgaming",
        "content": "Borderless Gaming",
        "description": "Play your favorite games in a borderless window; no more time consuming alt-tabs.",
        "link": "https://github.com/Codeusa/Borderless-Gaming",
        "winget": "Codeusa.BorderlessGaming"
    },
    "EqualizerAPO": {
        "category": "Multimedia Tools",
        "choco": "equalizerapo",
        "content": "Equalizer APO",
        "description": "Equalizer APO is a parametric / graphic equalizer for Windows.",
        "link": "https://sourceforge.net/projects/equalizerapo",
        "winget": "na"
    },
    "CompactGUI": {
        "category": "Utilities",
        "choco": "compactgui",
        "content": "Compact GUI",
        "description": "Transparently compress active games and programs using Windows 10/11 APIs",
        "link": "https://github.com/IridiumIO/CompactGUI",
        "winget": "IridiumIO.CompactGUI"
    },
    "ExifCleaner": {
        "category": "Utilities",
        "choco": "na",
        "content": "ExifCleaner",
        "description": "Desktop app to clean metadata from images, videos, PDFs, and other files.",
        "link": "https://github.com/szTheory/exifcleaner",
        "winget": "szTheory.exifcleaner"
    },
    "mullvadbrowser": {
        "category": "Browsers",
        "choco": "na",
        "content": "Mullvad Browser",
        "description": "Mullvad Browser is a privacy-focused web browser, developed in partnership with the Tor Project.",
        "link": "https://mullvad.net/browser",
        "winget": "MullvadVPN.MullvadBrowser"
    },
    "musescore": {
        "category": "Multimedia Tools",
        "choco": "musescore",
        "content": "MuseScore",
        "description": "Create, play back and print beautiful sheet music with free and easy to use music notation software MuseScore.",
        "link": "https://musescore.org/en",
        "winget": "Musescore.Musescore"
    },
    "musicbee": {
        "category": "Multimedia Tools",
        "choco": "musicbee",
        "content": "MusicBee (Music Player)",
        "description": "MusicBee is a customizable music player with support for various audio formats. It includes features like an integrated search function, tag editing, and more.",
        "link": "https://getmusicbee.com/",
        "winget": "MusicBee.MusicBee"
    },
    "mp3tag": {
        "category": "Multimedia Tools",
        "choco": "mp3tag",
        "content": "Mp3tag (Metadata Audio Editor)",
        "description": "Mp3tag is a powerful and yet easy-to-use tool to edit metadata of common audio formats.",
        "link": "https://www.mp3tag.de/en/",
        "winget": "Mp3tag.Mp3tag"
    },
    "tagscanner": {
        "category": "Multimedia Tools",
        "choco": "tagscanner",
        "content": "TagScanner (Tag Scanner)",
        "description": "TagScanner is a powerful tool for organizing and managing your music collection",
        "link": "https://www.xdlab.ru/en/",
        "winget": "SergeySerkov.TagScanner"
    },
    "nanazip": {
        "category": "Utilities",
        "choco": "nanazip",
        "content": "NanaZip",
        "description": "NanaZip is a fast and efficient file compression and decompression tool.",
        "link": "https://github.com/M2Team/NanaZip",
        "winget": "M2Team.NanaZip"
    },
    "netbird": {
        "category": "Pro Tools",
        "choco": "netbird",
        "content": "NetBird",
        "description": "NetBird is a Open Source alternative comparable to TailScale that can be connected to a selfhosted Server.",
        "link": "https://netbird.io/",
        "winget": "netbird"
    },
    "naps2": {
        "category": "Document",
        "choco": "naps2",
        "content": "NAPS2 (Document Scanner)",
        "description": "NAPS2 is a document scanning application that simplifies the process of creating electronic documents.",
        "link": "https://www.naps2.com/",
        "winget": "Cyanfish.NAPS2"
    },
    "neofetchwin": {
        "category": "Utilities",
        "choco": "na",
        "content": "Neofetch",
        "description": "Neofetch is a command-line utility for displaying system information in a visually appealing way.",
        "link": "https://github.com/nepnep39/neofetch-win",
        "winget": "nepnep.neofetch-win"
    },
    "neovim": {
        "category": "Development",
        "choco": "neovim",
        "content": "Neovim",
        "description": "Neovim is a highly extensible text editor and an improvement over the original Vim editor.",
        "link": "https://neovim.io/",
        "winget": "Neovim.Neovim"
    },
    "nextclouddesktop": {
        "category": "Utilities",
        "choco": "nextcloud-client",
        "content": "Nextcloud Desktop",
        "description": "Nextcloud Desktop is the official desktop client for the Nextcloud file synchronization and sharing platform.",
        "link": "https://nextcloud.com/install/#install-clients",
        "winget": "Nextcloud.NextcloudDesktop"
    },
    "nglide": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "nGlide (3dfx compatibility)",
        "description": "nGlide is a 3Dfx Voodoo Glide wrapper. It allows you to play games that use Glide API on modern graphics cards without the need for a 3Dfx Voodoo graphics card.",
        "link": "https://www.zeus-software.com/downloads/nglide",
        "winget": "ZeusSoftware.nGlide"
    },
    "nmap": {
        "category": "Pro Tools",
        "choco": "nmap",
        "content": "Nmap",
        "description": "Nmap (Network Mapper) is an open-source tool for network exploration and security auditing. It discovers devices on a network and provides information about their ports and services.",
        "link": "https://nmap.org/",
        "winget": "Insecure.Nmap"
    },
    "nodejs": {
        "category": "Development",
        "choco": "nodejs",
        "content": "NodeJS",
        "description": "NodeJS is a JavaScript runtime built on Chrome''s V8 JavaScript engine for building server-side and networking applications.",
        "link": "https://nodejs.org/",
        "winget": "OpenJS.NodeJS"
    },
    "nodejslts": {
        "category": "Development",
        "choco": "nodejs-lts",
        "content": "NodeJS LTS",
        "description": "NodeJS LTS provides Long-Term Support releases for stable and reliable server-side JavaScript development.",
        "link": "https://nodejs.org/",
        "winget": "OpenJS.NodeJS.LTS"
    },
    "nomacs": {
        "category": "Multimedia Tools",
        "choco": "nomacs",
        "content": "Nomacs (Image viewer)",
        "description": "Nomacs is a free, open-source image viewer that supports multiple platforms. It features basic image editing capabilities and supports a variety of image formats.",
        "link": "https://nomacs.org/",
        "winget": "nomacs.nomacs"
    },
    "notepadplus": {
        "category": "Document",
        "choco": "notepadplusplus",
        "content": "Notepad++",
        "description": "Notepad++ is a free, open-source code editor and Notepad replacement with support for multiple languages.",
        "link": "https://notepad-plus-plus.org/",
        "winget": "Notepad++.Notepad++"
    },
    "nuget": {
        "category": "Microsoft Tools",
        "choco": "nuget.commandline",
        "content": "NuGet",
        "description": "NuGet is a package manager for the .NET framework, enabling developers to manage and share libraries in their .NET applications.",
        "link": "https://www.nuget.org/",
        "winget": "Microsoft.NuGet"
    },
    "nushell": {
        "category": "Utilities",
        "choco": "nushell",
        "content": "Nushell",
        "description": "Nushell is a new shell that takes advantage of modern hardware and systems to provide a powerful, expressive, and fast experience.",
        "link": "https://www.nushell.sh/",
        "winget": "Nushell.Nushell"
    },
    "nvclean": {
        "category": "Utilities",
        "choco": "na",
        "content": "NVCleanstall",
        "description": "NVCleanstall is a tool designed to customize NVIDIA driver installations, allowing advanced users to control more aspects of the installation process.",
        "link": "https://www.techpowerup.com/nvcleanstall/",
        "winget": "TechPowerUp.NVCleanstall"
    },
    "nvm": {
        "category": "Development",
        "choco": "nvm",
        "content": "Node Version Manager",
        "description": "Node Version Manager (NVM) for Windows allows you to easily switch between multiple Node.js versions.",
        "link": "https://github.com/coreybutler/nvm-windows",
        "winget": "CoreyButler.NVMforWindows"
    },
    "obs": {
        "category": "Multimedia Tools",
        "choco": "obs-studio",
        "content": "OBS Studio",
        "description": "OBS Studio is a free and open-source software for video recording and live streaming. It supports real-time video/audio capturing and mixing, making it popular among content creators.",
        "link": "https://obsproject.com/",
        "winget": "OBSProject.OBSStudio"
    },
    "obsidian": {
        "category": "Document",
        "choco": "obsidian",
        "content": "Obsidian",
        "description": "Obsidian is a powerful note-taking and knowledge management application.",
        "link": "https://obsidian.md/",
        "winget": "Obsidian.Obsidian"
    },
    "okular": {
        "category": "Document",
        "choco": "okular",
        "content": "Okular",
        "description": "Okular is a versatile document viewer with advanced features.",
        "link": "https://okular.kde.org/",
        "winget": "KDE.Okular"
    },
    "onedrive": {
        "category": "Microsoft Tools",
        "choco": "onedrive",
        "content": "OneDrive",
        "description": "OneDrive is a cloud storage service provided by Microsoft, allowing users to store and share files securely across devices.",
        "link": "https://onedrive.live.com/",
        "winget": "Microsoft.OneDrive"
    },
    "onlyoffice": {
        "category": "Document",
        "choco": "onlyoffice",
        "content": "ONLYOffice Desktop",
        "description": "ONLYOffice Desktop is a comprehensive office suite for document editing and collaboration.",
        "link": "https://www.onlyoffice.com/desktop.aspx",
        "winget": "ONLYOFFICE.DesktopEditors"
    },
    "OPAutoClicker": {
        "category": "Utilities",
        "choco": "autoclicker",
        "content": "OPAutoClicker",
        "description": "A full-fledged autoclicker with two modes of autoclicking, at your dynamic cursor location or at a prespecified location.",
        "link": "https://www.opautoclicker.com",
        "winget": "OPAutoClicker.OPAutoClicker"
    },
    "openhashtab": {
        "category": "Utilities",
        "choco": "openhashtab",
        "content": "OpenHashTab",
        "description": "OpenHashTab is a shell extension for conveniently calculating and checking file hashes from file properties.",
        "link": "https://github.com/namazso/OpenHashTab/",
        "winget": "namazso.OpenHashTab"
    },
    "openrgb": {
        "category": "Utilities",
        "choco": "openrgb",
        "content": "OpenRGB",
        "description": "OpenRGB is an open-source RGB lighting control software designed to manage and control RGB lighting for various components and peripherals.",
        "link": "https://openrgb.org/",
        "winget": "CalcProgrammer1.OpenRGB"
    },
    "openscad": {
        "category": "Multimedia Tools",
        "choco": "openscad",
        "content": "OpenSCAD",
        "description": "OpenSCAD is a free and open-source script-based 3D CAD modeler. It is especially useful for creating parametric designs for 3D printing.",
        "link": "https://www.openscad.org/",
        "winget": "OpenSCAD.OpenSCAD"
    },
    "openshell": {
        "category": "Utilities",
        "choco": "open-shell",
        "content": "Open Shell (Start Menu)",
        "description": "Open Shell is a Windows Start Menu replacement with enhanced functionality and customization options.",
        "link": "https://github.com/Open-Shell/Open-Shell-Menu",
        "winget": "Open-Shell.Open-Shell-Menu"
    },
    "OpenVPN": {
        "category": "Pro Tools",
        "choco": "openvpn-connect",
        "content": "OpenVPN Connect",
        "description": "OpenVPN Connect is an open-source VPN client that allows you to connect securely to a VPN server. It provides a secure and encrypted connection for protecting your online privacy.",
        "link": "https://openvpn.net/",
        "winget": "OpenVPNTechnologies.OpenVPNConnect"
    },
    "OVirtualBox": {
        "category": "Utilities",
        "choco": "virtualbox",
        "content": "Oracle VirtualBox",
        "description": "Oracle VirtualBox is a powerful and free open-source virtualization tool for x86 and AMD64/Intel64 architectures.",
        "link": "https://www.virtualbox.org/",
        "winget": "Oracle.VirtualBox"
    },
    "ownclouddesktop": {
        "category": "Utilities",
        "choco": "owncloud-client",
        "content": "ownCloud Desktop",
        "description": "ownCloud Desktop is the official desktop client for the ownCloud file synchronization and sharing platform.",
        "link": "https://owncloud.com/desktop-app/",
        "winget": "ownCloud.ownCloudDesktop"
    },
    "Paintdotnet": {
        "category": "Multimedia Tools",
        "choco": "paint.net",
        "content": "Paint.NET",
        "description": "Paint.NET is a free image and photo editing software for Windows. It features an intuitive user interface and supports a wide range of powerful editing tools.",
        "link": "https://www.getpaint.net/",
        "winget": "dotPDN.PaintDotNet"
    },
    "parsec": {
        "category": "Utilities",
        "choco": "parsec",
        "content": "Parsec",
        "description": "Parsec is a low-latency, high-quality remote desktop sharing application for collaborating and gaming across devices.",
        "link": "https://parsec.app/",
        "winget": "Parsec.Parsec"
    },
    "pdf24creator": {
        "category": "Document",
        "choco": "pdf24",
        "content": "PDF24 creator",
        "description": "Free and easy-to-use online/desktop PDF tools that make you more productive",
        "link": "https://tools.pdf24.org/en/",
        "winget": "geeksoftwareGmbH.PDF24Creator"
    },
    "pdfsam": {
        "category": "Document",
        "choco": "pdfsam",
        "content": "PDFsam Basic",
        "description": "PDFsam Basic is a free and open-source tool for splitting, merging, and rotating PDF files.",
        "link": "https://pdfsam.org/",
        "winget": "PDFsam.PDFsam"
    },
    "peazip": {
        "category": "Utilities",
        "choco": "peazip",
        "content": "PeaZip",
        "description": "PeaZip is a free, open-source file archiver utility that supports multiple archive formats and provides encryption features.",
        "link": "https://peazip.github.io/",
        "winget": "Giorgiotani.Peazip"
    },
    "piimager": {
        "category": "Utilities",
        "choco": "rpi-imager",
        "content": "Raspberry Pi Imager",
        "description": "Raspberry Pi Imager is a utility for writing operating system images to SD cards for Raspberry Pi devices.",
        "link": "https://www.raspberrypi.com/software/",
        "winget": "RaspberryPiFoundation.RaspberryPiImager"
    },
    "playnite": {
        "category": "Games",
        "choco": "playnite",
        "content": "Playnite",
        "description": "Playnite is an open-source video game library manager with one simple goal: To provide a unified interface for all of your games.",
        "link": "https://playnite.link/",
        "winget": "Playnite.Playnite"
    },
    "plex": {
        "category": "Multimedia Tools",
        "choco": "plexmediaserver",
        "content": "Plex Media Server",
        "description": "Plex Media Server is a media server software that allows you to organize and stream your media library. It supports various media formats and offers a wide range of features.",
        "link": "https://www.plex.tv/your-media/",
        "winget": "Plex.PlexMediaServer"
    },
    "plexdesktop": {
        "category": "Multimedia Tools",
        "choco": "plex",
        "content": "Plex Desktop",
        "description": "Plex Desktop for Windows is the front end for Plex Media Server.",
        "link": "https://www.plex.tv",
        "winget": "Plex.Plex"
    },
    "Portmaster": {
        "category": "Pro Tools",
        "choco": "portmaster",
        "content": "Portmaster",
        "description": "Portmaster is a free and open-source application that puts you back in charge over all your computers network connections.",
        "link": "https://safing.io/",
        "winget": "Safing.Portmaster"
    },
    "posh": {
        "category": "Development",
        "choco": "oh-my-posh",
        "content": "Oh My Posh (Prompt)",
        "description": "Oh My Posh is a cross-platform prompt theme engine for any shell.",
        "link": "https://ohmyposh.dev/",
        "winget": "JanDeDobbeleer.OhMyPosh"
    },
    "postman": {
        "category": "Development",
        "choco": "postman",
        "content": "Postman",
        "description": "Postman is a collaboration platform for API development that simplifies the process of developing APIs.",
        "link": "https://www.postman.com/",
        "winget": "Postman.Postman"
    },
    "powerautomate": {
        "category": "Microsoft Tools",
        "choco": "powerautomatedesktop",
        "content": "Power Automate",
        "description": "Using Power Automate Desktop you can automate tasks on the desktop as well as the Web.",
        "link": "https://www.microsoft.com/en-us/power-platform/products/power-automate",
        "winget": "Microsoft.PowerAutomateDesktop"
    },
    "powerbi": {
        "category": "Microsoft Tools",
        "choco": "powerbi",
        "content": "Power BI",
        "description": "Create stunning reports and visualizations with Power BI Desktop. It puts visual analytics at your fingertips with intuitive report authoring. Drag-and-drop to place content exactly where you want it on the flexible and fluid canvas. Quickly discover patterns as you explore a single unified view of linked, interactive visualizations.",
        "link": "https://www.microsoft.com/en-us/power-platform/products/power-bi/",
        "winget": "Microsoft.PowerBI"
    },
    "powershell": {
        "category": "Microsoft Tools",
        "choco": "powershell-core",
        "content": "PowerShell",
        "description": "PowerShell is a task automation framework and scripting language designed for system administrators, offering powerful command-line capabilities.",
        "link": "https://github.com/PowerShell/PowerShell",
        "winget": "Microsoft.PowerShell"
    },
    "powertoys": {
        "category": "Microsoft Tools",
        "choco": "powertoys",
        "content": "PowerToys",
        "description": "PowerToys is a set of utilities for power users to enhance productivity, featuring tools like FancyZones, PowerRename, and more.",
        "link": "https://github.com/microsoft/PowerToys",
        "winget": "Microsoft.PowerToys"
    },
    "prismlauncher": {
        "category": "Games",
        "choco": "prismlauncher",
        "content": "Prism Launcher",
        "description": "Prism Launcher is an Open Source Minecraft launcher with the ability to manage multiple instances, accounts and mods.",
        "link": "https://prismlauncher.org/",
        "winget": "PrismLauncher.PrismLauncher"
    },
    "processlasso": {
        "category": "Utilities",
        "choco": "plasso",
        "content": "Process Lasso",
        "description": "Process Lasso is a system optimization and automation tool that improves system responsiveness and stability by adjusting process priorities and CPU affinities.",
        "link": "https://bitsum.com/",
        "winget": "BitSum.ProcessLasso"
    },
    "spotify": {
        "category": "Multimedia Tools",
        "choco": "spotify",
        "content": "Spotify",
        "description": "Spotify is a digital music service that gives you access to millions of songs, podcasts, and videos from artists all over the world.",
        "link": "https://www.spotify.com/",
        "winget": "Spotify.Spotify"
    },
    "processmonitor": {
        "category": "Microsoft Tools",
        "choco": "procexp",
        "content": "SysInternals Process Monitor",
        "description": "SysInternals Process Monitor is an advanced monitoring tool that shows real-time file system, registry, and process/thread activity.",
        "link": "https://docs.microsoft.com/en-us/sysinternals/downloads/procmon",
        "winget": "Microsoft.Sysinternals.ProcessMonitor"
    },
    "orcaslicer": {
        "category": "Utilities",
        "choco": "orcaslicer",
        "content": "OrcaSlicer",
        "description": "G-code generator for 3D printers (Bambu, Prusa, Voron, VzBot, RatRig, Creality, etc.)",
        "link": "https://github.com/SoftFever/OrcaSlicer",
        "winget": "SoftFever.OrcaSlicer"
    },
    "prucaslicer": {
        "category": "Utilities",
        "choco": "prusaslicer",
        "content": "PrusaSlicer",
        "description": "PrusaSlicer is a powerful and easy-to-use slicing software for 3D printing with Prusa 3D printers.",
        "link": "https://www.prusa3d.com/prusaslicer/",
        "winget": "Prusa3d.PrusaSlicer"
    },
    "psremoteplay": {
        "category": "Games",
        "choco": "ps-remote-play",
        "content": "PS Remote Play",
        "description": "PS Remote Play is a free application that allows you to stream games from your PlayStation console to a PC or mobile device.",
        "link": "https://remoteplay.dl.playstation.net/remoteplay/lang/gb/",
        "winget": "PlayStation.PSRemotePlay"
    },
    "putty": {
        "category": "Pro Tools",
        "choco": "putty",
        "content": "PuTTY",
        "description": "PuTTY is a free and open-source terminal emulator, serial console, and network file transfer application. It supports various network protocols such as SSH, Telnet, and SCP.",
        "link": "https://www.chiark.greenend.org.uk/~sgtatham/putty/",
        "winget": "PuTTY.PuTTY"
    },
    "python3": {
        "category": "Development",
        "choco": "python",
        "content": "Python3",
        "description": "Python is a versatile programming language used for web development, data analysis, artificial intelligence, and more.",
        "link": "https://www.python.org/",
        "winget": "Python.Python.3.12"
    },
    "qbittorrent": {
        "category": "Utilities",
        "choco": "qbittorrent",
        "content": "qBittorrent",
        "description": "qBittorrent is a free and open-source BitTorrent client that aims to provide a feature-rich and lightweight alternative to other torrent clients.",
        "link": "https://www.qbittorrent.org/",
        "winget": "qBittorrent.qBittorrent"
    },
    "transmission": {
        "category": "Utilities",
        "choco": "transmission",
        "content": "Transmission",
        "description": "Transmission is a cross-platform BitTorrent client that is open source, easy, powerful, and lean.",
        "link": "https://transmissionbt.com/",
        "winget": "Transmission.Transmission"
    },
    "tixati": {
        "category": "Utilities",
        "choco": "tixati.portable",
        "content": "Tixati",
        "description": "Tixati is a cross-platform BitTorrent client written in C++ that has been designed to be light on system resources.",
        "link": "https://www.tixati.com/",
        "winget": "Tixati.Tixati.Portable"
    },
    "qtox": {
        "category": "Communications",
        "choco": "qtox",
        "content": "QTox",
        "description": "QTox is a free and open-source messaging app that prioritizes user privacy and security in its design.",
        "link": "https://qtox.github.io/",
        "winget": "Tox.qTox"
    },
    "quicklook": {
        "category": "Utilities",
        "choco": "quicklook",
        "content": "Quicklook",
        "description": "Bring macOS “Quick Look” feature to Windows",
        "link": "https://github.com/QL-Win/QuickLook",
        "winget": "QL-Win.QuickLook"
    },
    "rainmeter": {
        "category": "Utilities",
        "choco": "na",
        "content": "Rainmeter",
        "description": "Rainmeter is a desktop customization tool that allows you to create and share customizable skins for your desktop.",
        "link": "https://www.rainmeter.net/",
        "winget": "Rainmeter.Rainmeter"
    },
    "revo": {
        "category": "Utilities",
        "choco": "revo-uninstaller",
        "content": "Revo Uninstaller",
        "description": "Revo Uninstaller is an advanced uninstaller tool that helps you remove unwanted software and clean up your system.",
        "link": "https://www.revouninstaller.com/",
        "winget": "RevoUninstaller.RevoUninstaller"
    },
    "WiseProgramUninstaller": {
        "category": "Utilities",
        "choco": "na",
        "content": "Wise Program Uninstaller (WiseCleaner)",
        "description": "Wise Program Uninstaller is the perfect solution for uninstalling Windows programs, allowing you to uninstall applications quickly and completely using its simple and user-friendly interface.",
        "link": "https://www.wisecleaner.com/wise-program-uninstaller.html",
        "winget": "WiseCleaner.WiseProgramUninstaller"
    },
    "revolt": {
        "category": "Communications",
        "choco": "na",
        "content": "Revolt",
        "description": "Find your community, connect with the world. Revolt is one of the best ways to stay connected with your friends and community without sacrificing any usability.",
        "link": "https://revolt.chat/",
        "winget": "Revolt.RevoltDesktop"
    },
    "ripgrep": {
        "category": "Utilities",
        "choco": "ripgrep",
        "content": "Ripgrep",
        "description": "Fast and powerful commandline search tool",
        "link": "https://github.com/BurntSushi/ripgrep/",
        "winget": "BurntSushi.ripgrep.MSVC"
    },
    "rufus": {
        "category": "Utilities",
        "choco": "rufus",
        "content": "Rufus Imager",
        "description": "Rufus is a utility that helps format and create bootable USB drives, such as USB keys or pen drives.",
        "link": "https://rufus.ie/",
        "winget": "Rufus.Rufus"
    },
    "rustdesk": {
        "category": "Pro Tools",
        "choco": "rustdesk.portable",
        "content": "RustDesk",
        "description": "RustDesk is a free and open-source remote desktop application. It provides a secure way to connect to remote machines and access desktop environments.",
        "link": "https://rustdesk.com/",
        "winget": "RustDesk.RustDesk"
    },
    "rustlang": {
        "category": "Development",
        "choco": "rust",
        "content": "Rust",
        "description": "Rust is a programming language designed for safety and performance, particularly focused on systems programming.",
        "link": "https://www.rust-lang.org/",
        "winget": "Rustlang.Rust.MSVC"
    },
    "sagethumbs": {
        "category": "Utilities",
        "choco": "sagethumbs",
        "content": "SageThumbs",
        "description": "Provides support for thumbnails in Explorer with more formats.",
        "link": "https://sagethumbs.en.lo4d.com/windows",
        "winget": "CherubicSoftware.SageThumbs"
    },
    "sandboxie": {
        "category": "Utilities",
        "choco": "sandboxie",
        "content": "Sandboxie Plus",
        "description": "Sandboxie Plus is a sandbox-based isolation program that provides enhanced security by running applications in an isolated environment.",
        "link": "https://github.com/sandboxie-plus/Sandboxie",
        "winget": "Sandboxie.Plus"
    },
    "sdio": {
        "category": "Utilities",
        "choco": "sdio",
        "content": "Snappy Driver Installer Origin",
        "description": "Snappy Driver Installer Origin is a free and open-source driver updater with a vast driver database for Windows.",
        "link": "https://www.glenn.delahoy.com/snappy-driver-installer-origin/",
        "winget": "GlennDelahoy.SnappyDriverInstallerOrigin"
    },
    "session": {
        "category": "Communications",
        "choco": "session",
        "content": "Session",
        "description": "Session is a private and secure messaging app built on a decentralized network for user privacy and data protection.",
        "link": "https://getsession.org/",
        "winget": "Oxen.Session"
    },
    "sharex": {
        "category": "Multimedia Tools",
        "choco": "sharex",
        "content": "ShareX (Screenshots)",
        "description": "ShareX is a free and open-source screen capture and file sharing tool. It supports various capture methods and offers advanced features for editing and sharing screenshots.",
        "link": "https://getsharex.com/",
        "winget": "ShareX.ShareX"
    },
    "nilesoftShell": {
        "category": "Utilities",
        "choco": "nilesoft-shell",
        "content": "Nilesoft Shell",
        "description": "Shell is an expanded context menu tool that adds extra functionality and customization options to the Windows context menu.",
        "link": "https://nilesoft.org/",
        "winget": "Nilesoft.Shell"
    },
    "sidequest": {
        "category": "Games",
        "choco": "sidequest",
        "content": "SideQuestVR",
        "description": "SideQuestVR is a community-driven platform that enables users to discover, install, and manage virtual reality content on Oculus Quest devices.",
        "link": "https://sidequestvr.com/",
        "winget": "SideQuestVR.SideQuest"
    },
    "signal": {
        "category": "Communications",
        "choco": "signal",
        "content": "Signal",
        "description": "Signal is a privacy-focused messaging app that offers end-to-end encryption for secure and private communication.",
        "link": "https://signal.org/",
        "winget": "OpenWhisperSystems.Signal"
    },
    "signalrgb": {
        "category": "Utilities",
        "choco": "na",
        "content": "SignalRGB",
        "description": "SignalRGB lets you control and sync your favorite RGB devices with one free application.",
        "link": "https://www.signalrgb.com/",
        "winget": "WhirlwindFX.SignalRgb"
    },
    "simplenote": {
        "category": "Document",
        "choco": "simplenote",
        "content": "simplenote",
        "description": "Simplenote is an easy way to keep notes, lists, ideas and more.",
        "link": "https://simplenote.com/",
        "winget": "Automattic.Simplenote"
    },
    "simplewall": {
        "category": "Pro Tools",
        "choco": "simplewall",
        "content": "Simplewall",
        "description": "Simplewall is a free and open-source firewall application for Windows. It allows users to control and manage the inbound and outbound network traffic of applications.",
        "link": "https://github.com/henrypp/simplewall",
        "winget": "Henry++.simplewall"
    },
    "skype": {
        "category": "Communications",
        "choco": "skype",
        "content": "Skype",
        "description": "Skype is a widely used communication platform offering video calls, voice calls, and instant messaging services.",
        "link": "https://www.skype.com/",
        "winget": "Microsoft.Skype"
    },
    "slack": {
        "category": "Communications",
        "choco": "slack",
        "content": "Slack",
        "description": "Slack is a collaboration hub that connects teams and facilitates communication through channels, messaging, and file sharing.",
        "link": "https://slack.com/",
        "winget": "SlackTechnologies.Slack"
    },
    "spacedrive": {
        "category": "Utilities",
        "choco": "na",
        "content": "Spacedrive File Manager",
        "description": "Spacedrive is a file manager that offers cloud storage integration and file synchronization across devices.",
        "link": "https://www.spacedrive.com/",
        "winget": "spacedrive.Spacedrive"
    },
    "spacesniffer": {
        "category": "Utilities",
        "choco": "spacesniffer",
        "content": "SpaceSniffer",
        "description": "A tool application that lets you understand how folders and files are structured on your disks",
        "link": "http://www.uderzo.it/main_products/space_sniffer/",
        "winget": "UderzoSoftware.SpaceSniffer"
    },
    "starship": {
        "category": "Development",
        "choco": "starship",
        "content": "Starship (Shell Prompt)",
        "description": "Starship is a minimal, fast, and customizable prompt for any shell.",
        "link": "https://starship.rs/",
        "winget": "starship"
    },
    "steam": {
        "category": "Games",
        "choco": "steam-client",
        "content": "Steam",
        "description": "Steam is a digital distribution platform for purchasing and playing video games, offering multiplayer gaming, video streaming, and more.",
        "link": "https://store.steampowered.com/about/",
        "winget": "Valve.Steam"
    },
    "strawberry": {
        "category": "Multimedia Tools",
        "choco": "strawberrymusicplayer",
        "content": "Strawberry (Music Player)",
        "description": "Strawberry is an open-source music player that focuses on music collection management and audio quality. It supports various audio formats and features a clean user interface.",
        "link": "https://www.strawberrymusicplayer.org/",
        "winget": "StrawberryMusicPlayer.Strawberry"
    },
    "stremio": {
        "winget": "Stremio.Stremio",
        "choco": "stremio",
        "category": "Multimedia Tools",
        "content": "Stremio",
        "link": "https://www.stremio.com/",
        "description": "Stremio is a media center application that allows users to organize and stream their favorite movies, TV shows, and video content."
    },
    "sublimemerge": {
        "category": "Development",
        "choco": "sublimemerge",
        "content": "Sublime Merge",
        "description": "Sublime Merge is a Git client with advanced features and a beautiful interface.",
        "link": "https://www.sublimemerge.com/",
        "winget": "SublimeHQ.SublimeMerge"
    },
    "sublimetext": {
        "category": "Development",
        "choco": "sublimetext4",
        "content": "Sublime Text",
        "description": "Sublime Text is a sophisticated text editor for code, markup, and prose.",
        "link": "https://www.sublimetext.com/",
        "winget": "SublimeHQ.SublimeText.4"
    },
    "sumatra": {
        "category": "Document",
        "choco": "sumatrapdf",
        "content": "Sumatra PDF",
        "description": "Sumatra PDF is a lightweight and fast PDF viewer with minimalistic design.",
        "link": "https://www.sumatrapdfreader.org/free-pdf-reader.html",
        "winget": "SumatraPDF.SumatraPDF"
    },
    "pdfgear": {
        "category": "Document",
        "choco": "na",
        "content": "PDFgear",
        "description": "PDFgear is a piece of full-featured PDF management software for Windows, Mac, and mobile, and it''s completely free to use.",
        "link": "https://www.pdfgear.com/",
        "winget": "PDFgear.PDFgear"
    },
    "sunshine": {
        "category": "Games",
        "choco": "sunshine",
        "content": "Sunshine/GameStream Server",
        "description": "Sunshine is a GameStream server that allows you to remotely play PC games on Android devices, offering low-latency streaming.",
        "link": "https://github.com/LizardByte/Sunshine",
        "winget": "LizardByte.Sunshine"
    },
    "superf4": {
        "category": "Utilities",
        "choco": "superf4",
        "content": "SuperF4",
        "description": "SuperF4 is a utility that allows you to terminate programs instantly by pressing a customizable hotkey.",
        "link": "https://stefansundin.github.io/superf4/",
        "winget": "StefanSundin.Superf4"
    },
    "swift": {
        "category": "Development",
        "choco": "na",
        "content": "Swift toolchain",
        "description": "Swift is a general-purpose programming language that''s approachable for newcomers and powerful for experts.",
        "link": "https://www.swift.org/",
        "winget": "Swift.Toolchain"
    },
    "synctrayzor": {
        "category": "Utilities",
        "choco": "synctrayzor",
        "content": "SyncTrayzor",
        "description": "Windows tray utility / filesystem watcher / launcher for Syncthing",
        "link": "https://github.com/canton7/SyncTrayzor/",
        "winget": "SyncTrayzor.SyncTrayzor"
    },
    "sqlmanagementstudio": {
        "category": "Microsoft Tools",
        "choco": "sql-server-management-studio",
        "content": "Microsoft SQL Server Management Studio",
        "description": "SQL Server Management Studio (SSMS) is an integrated environment for managing any SQL infrastructure, from SQL Server to Azure SQL Database. SSMS provides tools to configure, monitor, and administer instances of SQL Server and databases.",
        "link": "https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16",
        "winget": "Microsoft.SQLServerManagementStudio"
    },
    "tabby": {
        "category": "Utilities",
        "choco": "tabby",
        "content": "Tabby.sh",
        "description": "Tabby is a highly configurable terminal emulator, SSH and serial client for Windows, macOS and Linux",
        "link": "https://tabby.sh/",
        "winget": "Eugeny.Tabby"
    },
    "tailscale": {
        "category": "Utilities",
        "choco": "tailscale",
        "content": "Tailscale",
        "description": "Tailscale is a secure and easy-to-use VPN solution for connecting your devices and networks.",
        "link": "https://tailscale.com/",
        "winget": "tailscale.tailscale"
    },
    "TcNoAccSwitcher": {
        "category": "Games",
        "choco": "tcno-acc-switcher",
        "content": "TCNO Account Switcher",
        "description": "A Super-fast account switcher for Steam, Battle.net, Epic Games, Origin, Riot, Ubisoft and many others!",
        "link": "https://github.com/TCNOco/TcNo-Acc-Switcher",
        "winget": "TechNobo.TcNoAccountSwitcher"
    },
    "tcpview": {
        "category": "Microsoft Tools",
        "choco": "tcpview",
        "content": "SysInternals TCPView",
        "description": "SysInternals TCPView is a network monitoring tool that displays a detailed list of all TCP and UDP endpoints on your system.",
        "link": "https://docs.microsoft.com/en-us/sysinternals/downloads/tcpview",
        "winget": "Microsoft.Sysinternals.TCPView"
    },
    "teams": {
        "category": "Communications",
        "choco": "microsoft-teams",
        "content": "Teams",
        "description": "Microsoft Teams is a collaboration platform that integrates with Office 365 and offers chat, video conferencing, file sharing, and more.",
        "link": "https://www.microsoft.com/en-us/microsoft-teams/group-chat-software",
        "winget": "Microsoft.Teams"
    },
    "teamviewer": {
        "category": "Utilities",
        "choco": "teamviewer9",
        "content": "TeamViewer",
        "description": "TeamViewer is a popular remote access and support software that allows you to connect to and control remote devices.",
        "link": "https://www.teamviewer.com/",
        "winget": "TeamViewer.TeamViewer"
    },
    "telegram": {
        "category": "Communications",
        "choco": "telegram",
        "content": "Telegram",
        "description": "Telegram is a cloud-based instant messaging app known for its security features, speed, and simplicity.",
        "link": "https://telegram.org/",
        "winget": "Telegram.TelegramDesktop"
    },
    "unigram": {
        "category": "Communications",
        "choco": "na",
        "content": "Unigram",
        "description": "Unigram - Telegram for Windows",
        "link": "https://unigramdev.github.io/",
        "winget": "Telegram.Unigram"
    },
    "terminal": {
        "category": "Microsoft Tools",
        "choco": "microsoft-windows-terminal",
        "content": "Windows Terminal",
        "description": "Windows Terminal is a modern, fast, and efficient terminal application for command-line users, supporting multiple tabs, panes, and more.",
        "link": "https://aka.ms/terminal",
        "winget": "Microsoft.WindowsTerminal"
    },
    "Thonny": {
        "category": "Development",
        "choco": "thonny",
        "content": "Thonny Python IDE",
        "description": "Python IDE for beginners.",
        "link": "https://github.com/thonny/thonny",
        "winget": "AivarAnnamaa.Thonny"
    },
    "MuEditor": {
        "category": "Development",
        "choco": "na",
        "content": "Code With Mu (Mu Editor)",
        "description": "Mu is a Python code editor for beginner programmers",
        "link": "https://codewith.mu/",
        "winget": "Mu.Mu"
    },
    "thorium": {
        "category": "Browsers",
        "choco": "na",
        "content": "Thorium Browser AVX2",
        "description": "Browser built for speed over vanilla chromium. It is built with AVX2 optimizations and is the fastest browser on the market.",
        "link": "https://thorium.rocks/",
        "winget": "Alex313031.Thorium.AVX2"
    },
    "thunderbird": {
        "category": "Communications",
        "choco": "thunderbird",
        "content": "Thunderbird",
        "description": "Mozilla Thunderbird is a free and open-source email client, news client, and chat client with advanced features.",
        "link": "https://www.thunderbird.net/",
        "winget": "Mozilla.Thunderbird"
    },
    "betterbird": {
        "category": "Communications",
        "choco": "betterbird",
        "content": "Betterbird",
        "description": "Betterbird is a fork of Mozilla Thunderbird with additional features and bugfixes.",
        "link": "https://www.betterbird.eu/",
        "winget": "Betterbird.Betterbird"
    },
    "tidal": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "Tidal",
        "description": "Tidal is a music streaming service known for its high-fidelity audio quality and exclusive content. It offers a vast library of songs and curated playlists.",
        "link": "https://tidal.com/",
        "winget": "9NNCB5BS59PH"
    },
    "tor": {
        "category": "Browsers",
        "choco": "tor-browser",
        "content": "Tor Browser",
        "description": "Tor Browser is designed for anonymous web browsing, utilizing the Tor network to protect user privacy and security.",
        "link": "https://www.torproject.org/",
        "winget": "TorProject.TorBrowser"
    },
    "totalcommander": {
        "category": "Utilities",
        "choco": "TotalCommander",
        "content": "Total Commander",
        "description": "Total Commander is a file manager for Windows that provides a powerful and intuitive interface for file management.",
        "link": "https://www.ghisler.com/",
        "winget": "Ghisler.TotalCommander"
    },
    "treesize": {
        "category": "Utilities",
        "choco": "treesizefree",
        "content": "TreeSize Free",
        "description": "TreeSize Free is a disk space manager that helps you analyze and visualize the space usage on your drives.",
        "link": "https://www.jam-software.com/treesize_free/",
        "winget": "JAMSoftware.TreeSize.Free"
    },
    "ttaskbar": {
        "category": "Utilities",
        "choco": "translucenttb",
        "content": "Translucent Taskbar",
        "description": "Translucent Taskbar is a tool that allows you to customize the transparency of the Windows taskbar.",
        "link": "https://github.com/TranslucentTB/TranslucentTB",
        "winget": "9PF4KZ2VN4W9"
    },
    "twinkletray": {
        "category": "Utilities",
        "choco": "twinkle-tray",
        "content": "Twinkle Tray",
        "description": "Twinkle Tray lets you easily manage the brightness levels of multiple monitors.",
        "link": "https://twinkletray.com/",
        "winget": "xanderfrangos.twinkletray"
    },
    "ubisoft": {
        "category": "Games",
        "choco": "ubisoft-connect",
        "content": "Ubisoft Connect",
        "description": "Ubisoft Connect is Ubisoft''s digital distribution and online gaming service, providing access to Ubisoft''s games and services.",
        "link": "https://ubisoftconnect.com/",
        "winget": "Ubisoft.Connect"
    },
    "ungoogled": {
        "category": "Browsers",
        "choco": "ungoogled-chromium",
        "content": "Ungoogled",
        "description": "Ungoogled Chromium is a version of Chromium without Google''s integration for enhanced privacy and control.",
        "link": "https://github.com/Eloston/ungoogled-chromium",
        "winget": "eloston.ungoogled-chromium"
    },
    "unity": {
        "category": "Development",
        "choco": "unityhub",
        "content": "Unity Game Engine",
        "description": "Unity is a powerful game development platform for creating 2D, 3D, augmented reality, and virtual reality games.",
        "link": "https://unity.com/",
        "winget": "Unity.UnityHub"
    },
    "vagrant": {
        "category": "Development",
        "choco": "vagrant",
        "content": "Vagrant",
        "description": "Vagrant is an open-source tool for building and managing virtualized development environments.",
        "link": "https://www.vagrantup.com/",
        "winget": "Hashicorp.Vagrant"
    },
    "vc2015_32": {
        "category": "Microsoft Tools",
        "choco": "na",
        "content": "Visual C++ 2015-2022 32-bit",
        "description": "Visual C++ 2015-2022 32-bit redistributable package installs runtime components of Visual C++ libraries required to run 32-bit applications.",
        "link": "https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads",
        "winget": "Microsoft.VCRedist.2015+.x86"
    },
    "vc2015_64": {
        "category": "Microsoft Tools",
        "choco": "na",
        "content": "Visual C++ 2015-2022 64-bit",
        "description": "Visual C++ 2015-2022 64-bit redistributable package installs runtime components of Visual C++ libraries required to run 64-bit applications.",
        "link": "https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads",
        "winget": "Microsoft.VCRedist.2015+.x64"
    },
    "ventoy": {
        "category": "Pro Tools",
        "choco": "ventoy",
        "content": "Ventoy",
        "description": "Ventoy is an open-source tool for creating bootable USB drives. It supports multiple ISO files on a single USB drive, making it a versatile solution for installing operating systems.",
        "link": "https://www.ventoy.net/",
        "winget": "Ventoy.Ventoy"
    },
    "vesktop": {
        "category": "Communications",
        "choco": "na",
        "content": "Vesktop",
        "description": "A cross platform electron-based desktop app aiming to give you a snappier Discord experience with Vencord pre-installed.",
        "link": "https://github.com/Vencord/Vesktop",
        "winget": "Vencord.Vesktop"
    },
    "viber": {
        "category": "Communications",
        "choco": "viber",
        "content": "Viber",
        "description": "Viber is a free messaging and calling app with features like group chats, video calls, and more.",
        "link": "https://www.viber.com/",
        "winget": "Viber.Viber"
    },
    "videomass": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "Videomass",
        "description": "Videomass by GianlucaPernigotto is a cross-platform GUI for FFmpeg, streamlining multimedia file processing with batch conversions and user-friendly features.",
        "link": "https://jeanslack.github.io/Videomass/",
        "winget": "GianlucaPernigotto.Videomass"
    },
    "visualstudio": {
        "category": "Development",
        "choco": "visualstudio2022community",
        "content": "Visual Studio 2022",
        "description": "Visual Studio 2022 is an integrated development environment (IDE) for building, debugging, and deploying applications.",
        "link": "https://visualstudio.microsoft.com/",
        "winget": "Microsoft.VisualStudio.2022.Community"
    },
    "vivaldi": {
        "category": "Browsers",
        "choco": "vivaldi",
        "content": "Vivaldi",
        "description": "Vivaldi is a highly customizable web browser with a focus on user personalization and productivity features.",
        "link": "https://vivaldi.com/",
        "winget": "Vivaldi.Vivaldi"
    },
    "vlc": {
        "category": "Multimedia Tools",
        "choco": "vlc",
        "content": "VLC (Video Player)",
        "description": "VLC Media Player is a free and open-source multimedia player that supports a wide range of audio and video formats. It is known for its versatility and cross-platform compatibility.",
        "link": "https://www.videolan.org/vlc/",
        "winget": "VideoLAN.VLC"
    },
    "voicemeeter": {
        "category": "Multimedia Tools",
        "choco": "voicemeeter",
        "content": "Voicemeeter (Audio)",
        "description": "Voicemeeter is a virtual audio mixer that allows you to manage and enhance audio streams on your computer. It is commonly used for audio recording and streaming purposes.",
        "link": "https://voicemeeter.com/",
        "winget": "VB-Audio.Voicemeeter"
    },
    "VoicemeeterPotato": {
        "category": "Multimedia Tools",
        "choco": "voicemeeter-potato",
        "content": "Voicemeeter Potato",
        "description": "Voicemeeter Potato is the ultimate version of the Voicemeeter Audio Mixer Application endowed with Virtual Audio Device to mix and manage any audio sources from or to any audio devices or applications.",
        "link": "https://voicemeeter.com/",
        "winget": "VB-Audio.Voicemeeter.Potato"
    },
    "vrdesktopstreamer": {
        "category": "Games",
        "choco": "na",
        "content": "Virtual Desktop Streamer",
        "description": "Virtual Desktop Streamer is a tool that allows you to stream your desktop screen to VR devices.",
        "link": "https://www.vrdesktop.net/",
        "winget": "VirtualDesktop.Streamer"
    },
    "vscode": {
        "category": "Development",
        "choco": "vscode",
        "content": "VS Code",
        "description": "Visual Studio Code is a free, open-source code editor with support for multiple programming languages.",
        "link": "https://code.visualstudio.com/",
        "winget": "Microsoft.VisualStudioCode"
    },
    "vscodium": {
        "category": "Development",
        "choco": "vscodium",
        "content": "VS Codium",
        "description": "VSCodium is a community-driven, freely-licensed binary distribution of Microsoft''s VS Code.",
        "link": "https://vscodium.com/",
        "winget": "VSCodium.VSCodium"
    },
    "waterfox": {
        "category": "Browsers",
        "choco": "waterfox",
        "content": "Waterfox",
        "description": "Waterfox is a fast, privacy-focused web browser based on Firefox, designed to preserve user choice and privacy.",
        "link": "https://www.waterfox.net/",
        "winget": "Waterfox.Waterfox"
    },
    "wazuh": {
        "category": "Utilities",
        "choco": "wazuh-agent",
        "content": "Wazuh.",
        "description": "Wazuh is an open-source security monitoring platform that offers intrusion detection, compliance checks, and log analysis.",
        "link": "https://wazuh.com/",
        "winget": "Wazuh.WazuhAgent"
    },
    "wezterm": {
        "category": "Development",
        "choco": "wezterm",
        "content": "Wezterm",
        "description": "WezTerm is a powerful cross-platform terminal emulator and multiplexer",
        "link": "https://wezfurlong.org/wezterm/index.html",
        "winget": "wez.wezterm"
    },
    "windowspchealth": {
        "category": "Utilities",
        "choco": "na",
        "content": "Windows PC Health Check",
        "description": "Windows PC Health Check is a tool that helps you check if your PC meets the system requirements for Windows 11.",
        "link": "https://support.microsoft.com/en-us/windows/how-to-use-the-pc-health-check-app-9c8abd9b-03ba-4e67-81ef-36f37caa7844",
        "winget": "Microsoft.WindowsPCHealthCheck"
    },
    "WindowGrid": {
        "category": "Utilities",
        "choco": "windowgrid",
        "content": "WindowGrid",
        "description": "WindowGrid is a modern window management program for Windows that allows the user to quickly and easily layout their windows on a dynamic grid using just the mouse.",
        "link": "http://windowgrid.net/",
        "winget": "na"
    },
    "wingetui": {
        "category": "Utilities",
        "choco": "wingetui",
        "content": "UniGetUI",
        "description": "UniGetUI is a GUI for Winget, Chocolatey, and other Windows CLI package managers.",
        "link": "https://www.marticliment.com/wingetui/",
        "winget": "MartiCliment.UniGetUI"
    },
    "winmerge": {
        "category": "Document",
        "choco": "winmerge",
        "content": "WinMerge",
        "description": "WinMerge is a visual text file and directory comparison tool for Windows.",
        "link": "https://winmerge.org/",
        "winget": "WinMerge.WinMerge"
    },
    "winpaletter": {
        "category": "Utilities",
        "choco": "WinPaletter",
        "content": "WinPaletter",
        "description": "WinPaletter is a tool for adjusting the color palette of Windows 10, providing customization options for window colors.",
        "link": "https://github.com/Abdelrhman-AK/WinPaletter",
        "winget": "Abdelrhman-AK.WinPaletter"
    },
    "winrar": {
        "category": "Utilities",
        "choco": "winrar",
        "content": "WinRAR",
        "description": "WinRAR is a powerful archive manager that allows you to create, manage, and extract compressed files.",
        "link": "https://www.win-rar.com/",
        "winget": "RARLab.WinRAR"
    },
    "winscp": {
        "category": "Pro Tools",
        "choco": "winscp",
        "content": "WinSCP",
        "description": "WinSCP is a popular open-source SFTP, FTP, and SCP client for Windows. It allows secure file transfers between a local and a remote computer.",
        "link": "https://winscp.net/",
        "winget": "WinSCP.WinSCP"
    },
    "wireguard": {
        "category": "Pro Tools",
        "choco": "wireguard",
        "content": "WireGuard",
        "description": "WireGuard is a fast and modern VPN (Virtual Private Network) protocol. It aims to be simpler and more efficient than other VPN protocols, providing secure and reliable connections.",
        "link": "https://www.wireguard.com/",
        "winget": "WireGuard.WireGuard"
    },
    "wireshark": {
        "category": "Pro Tools",
        "choco": "wireshark",
        "content": "Wireshark",
        "description": "Wireshark is a widely-used open-source network protocol analyzer. It allows users to capture and analyze network traffic in real-time, providing detailed insights into network activities.",
        "link": "https://www.wireshark.org/",
        "winget": "WiresharkFoundation.Wireshark"
    },
    "wisetoys": {
        "category": "Utilities",
        "choco": "na",
        "content": "WiseToys",
        "description": "WiseToys is a set of utilities and tools designed to enhance and optimize your Windows experience.",
        "link": "https://toys.wisecleaner.com/",
        "winget": "WiseCleaner.WiseToys"
    },
    "TeraCopy": {
        "category": "Utilities",
        "choco": "TeraCopy",
        "content": "TeraCopy",
        "description": "Copy your files faster and more securely",
        "link": "https://codesector.com/teracopy",
        "winget": "CodeSector.TeraCopy"
    },
    "wizfile": {
        "category": "Utilities",
        "choco": "na",
        "content": "WizFile",
        "description": "Find files by name on your hard drives almost instantly.",
        "link": "https://antibody-software.com/wizfile/",
        "winget": "AntibodySoftware.WizFile"
    },
    "wiztree": {
        "category": "Utilities",
        "choco": "wiztree",
        "content": "WizTree",
        "description": "WizTree is a fast disk space analyzer that helps you quickly find the files and folders consuming the most space on your hard drive.",
        "link": "https://wiztreefree.com/",
        "winget": "AntibodySoftware.WizTree"
    },
    "xdm": {
        "category": "Utilities",
        "choco": "xdm",
        "content": "Xtreme Download Manager",
        "description": "Xtreme Download Manager is an advanced download manager with support for various protocols and browsers.*Browser integration deprecated by google store. No official release.*",
        "link": "https://xtremedownloadmanager.com/",
        "winget": "subhra74.XtremeDownloadManager"
    },
    "xeheditor": {
        "category": "Utilities",
        "choco": "HxD",
        "content": "HxD Hex Editor",
        "description": "HxD is a free hex editor that allows you to edit, view, search, and analyze binary files.",
        "link": "https://mh-nexus.de/en/hxd/",
        "winget": "MHNexus.HxD"
    },
    "xemu": {
        "category": "Games",
        "choco": "na",
        "content": "XEMU",
        "description": "XEMU is an open-source Xbox emulator that allows you to play Xbox games on your PC, aiming for accuracy and compatibility.",
        "link": "https://xemu.app/",
        "winget": "xemu-project.xemu"
    },
    "xnview": {
        "category": "Utilities",
        "choco": "xnview",
        "content": "XnView classic",
        "description": "XnView is an efficient image viewer, browser and converter for Windows.",
        "link": "https://www.xnview.com/en/xnview/",
        "winget": "XnSoft.XnView.Classic"
    },
    "xournal": {
        "category": "Document",
        "choco": "xournalplusplus",
        "content": "Xournal++",
        "description": "Xournal++ is an open-source handwriting notetaking software with PDF annotation capabilities.",
        "link": "https://xournalpp.github.io/",
        "winget": "Xournal++.Xournal++"
    },
    "xpipe": {
        "category": "Pro Tools",
        "choco": "xpipe",
        "content": "XPipe",
        "description": "XPipe is an open-source tool for orchestrating containerized applications. It simplifies the deployment and management of containerized services in a distributed environment.",
        "link": "https://xpipe.io/",
        "winget": "xpipe-io.xpipe"
    },
    "yarn": {
        "category": "Development",
        "choco": "yarn",
        "content": "Yarn",
        "description": "Yarn is a fast, reliable, and secure dependency management tool for JavaScript projects.",
        "link": "https://yarnpkg.com/",
        "winget": "Yarn.Yarn"
    },
    "ytdlp": {
        "category": "Multimedia Tools",
        "choco": "yt-dlp",
        "content": "Yt-dlp",
        "description": "Command-line tool that allows you to download videos from YouTube and other supported sites. It is an improved version of the popular youtube-dl.",
        "link": "https://github.com/yt-dlp/yt-dlp",
        "winget": "yt-dlp.yt-dlp"
    },
    "zerotierone": {
        "category": "Utilities",
        "choco": "zerotier-one",
        "content": "ZeroTier One",
        "description": "ZeroTier One is a software-defined networking tool that allows you to create secure and scalable networks.",
        "link": "https://zerotier.com/",
        "winget": "ZeroTier.ZeroTierOne"
    },
    "zim": {
        "category": "Document",
        "choco": "zim",
        "content": "Zim Desktop Wiki",
        "description": "Zim Desktop Wiki is a graphical text editor used to maintain a collection of wiki pages.",
        "link": "https://zim-wiki.org/",
        "winget": "Zimwiki.Zim"
    },
    "znote": {
        "category": "Document",
        "choco": "na",
        "content": "Znote",
        "description": "Znote is a note-taking application.",
        "link": "https://znote.io/",
        "winget": "alagrede.znote"
    },
    "zoom": {
        "category": "Communications",
        "choco": "zoom",
        "content": "Zoom",
        "description": "Zoom is a popular video conferencing and web conferencing service for online meetings, webinars, and collaborative projects.",
        "link": "https://zoom.us/",
        "winget": "Zoom.Zoom"
    },
    "zoomit": {
        "category": "Utilities",
        "choco": "na",
        "content": "ZoomIt",
        "description": "A screen zoom, annotation, and recording tool for technical presentations and demos",
        "link": "https://learn.microsoft.com/en-us/sysinternals/downloads/zoomit",
        "winget": "Microsoft.Sysinternals.ZoomIt"
    },
    "zotero": {
        "category": "Document",
        "choco": "zotero",
        "content": "Zotero",
        "description": "Zotero is a free, easy-to-use tool to help you collect, organize, cite, and share your research materials.",
        "link": "https://www.zotero.org/",
        "winget": "DigitalScholar.Zotero"
    },
    "zoxide": {
        "category": "Utilities",
        "choco": "zoxide",
        "content": "Zoxide",
        "description": "Zoxide is a fast and efficient directory changer (cd) that helps you navigate your file system with ease.",
        "link": "https://github.com/ajeetdsouza/zoxide",
        "winget": "ajeetdsouza.zoxide"
    },
    "zulip": {
        "category": "Communications",
        "choco": "zulip",
        "content": "Zulip",
        "description": "Zulip is an open-source team collaboration tool with chat streams for productive and organized communication.",
        "link": "https://zulipchat.com/",
        "winget": "Zulip.Zulip"
    },
    "syncthingtray": {
        "category": "Utilities",
        "choco": "syncthingtray",
        "content": "Syncthingtray",
        "description": "Might be the alternative for Synctrayzor. Windows tray utility / filesystem watcher / launcher for Syncthing",
        "link": "https://github.com/Martchus/syncthingtray",
        "winget": "Martchus.syncthingtray"
    },
    "miniconda": {
        "category": "Development",
        "choco": "miniconda3",
        "content": "Miniconda",
        "description": "Miniconda is a free minimal installer for conda. It is a small bootstrap version of Anaconda that includes only conda, Python, the packages they both depend on, and a small number of other useful packages (like pip, zlib, and a few others).",
        "link": "https://docs.conda.io/projects/miniconda",
        "winget": "Anaconda.Miniconda3"
    },
    "pixi": {
        "category": "Development",
        "choco": "pixi",
        "content": "Pixi",
        "description": "Pixi is a fast software package manager built on top of the existing conda ecosystem. Spins up development environments quickly on Windows, macOS and Linux. Pixi supports Python, R, C/C++, Rust, Ruby, and many other languages.",
        "link": "https://pixi.sh",
        "winget": "prefix-dev.pixi"
    },
    "temurin": {
        "category": "Development",
        "choco": "temurin",
        "content": "Eclipse Temurin",
        "description": "Eclipse Temurin is the open source Java SE build based upon OpenJDK.",
        "link": "https://adoptium.net/temurin/",
        "winget": "EclipseAdoptium.Temurin.21.JDK"
    },
    "intelpresentmon": {
        "category": "Utilities",
        "choco": "na",
        "content": "Intel-PresentMon",
        "description": "A new gaming performance overlay and telemetry application to monitor and measure your gaming experience.",
        "link": "https://game.intel.com/us/stories/intel-presentmon/",
        "winget": "Intel.PresentMon.Beta"
    },
    "pyenvwin": {
        "category": "Development",
        "choco": "pyenv-win",
        "content": "Python Version Manager (pyenv-win)",
        "description": "pyenv for Windows is a simple python version management tool. It lets you easily switch between multiple versions of Python.",
        "link": "https://pyenv-win.github.io/pyenv-win/",
        "winget": "na"
    },
    "tightvnc": {
        "category": "Utilities",
        "choco": "TightVNC",
        "content": "TightVNC",
        "description": "TightVNC is a free and Open Source remote desktop software that lets you access and control a computer over the network. With its intuitive interface, you can interact with the remote screen as if you were sitting in front of it. You can open files, launch applications, and perform other actions on the remote desktop almost as if you were physically there",
        "link": "https://www.tightvnc.com/",
        "winget": "GlavSoft.TightVNC"
    },
    "ultravnc": {
        "category": "Utilities",
        "choco": "ultravnc",
        "content": "UltraVNC",
        "description": "UltraVNC is a powerful, easy to use and free - remote pc access softwares - that can display the screen of another computer (via internet or network) on your own screen. The program allows you to use your mouse and keyboard to control the other PC remotely. It means that you can work on a remote computer, as if you were sitting in front of it, right from your current location.",
        "link": "https://uvnc.com/",
        "winget": "uvncbvba.UltraVnc"
    },
    "windowsfirewallcontrol": {
        "category": "Utilities",
        "choco": "windowsfirewallcontrol",
        "content": "Windows Firewall Control",
        "description": "Windows Firewall Control is a powerful tool which extends the functionality of Windows Firewall and provides new extra features which makes Windows Firewall better.",
        "link": "https://www.binisoft.org/wfc",
        "winget": "BiniSoft.WindowsFirewallControl"
    },
    "vistaswitcher": {
        "category": "Utilities",
        "choco": "na",
        "content": "VistaSwitcher",
        "description": "VistaSwitcher makes it easier for you to locate windows and switch focus, even on multi-monitor systems. The switcher window consists of an easy-to-read list of all tasks running with clearly shown titles and a full-sized preview of the selected task.",
        "link": "https://www.ntwind.com/freeware/vistaswitcher.html",
        "winget": "ntwind.VistaSwitcher"
    },
    "autodarkmode": {
        "category": "Utilities",
        "choco": "auto-dark-mode",
        "content": "Windows Auto Dark Mode",
        "description": "Automatically switches between the dark and light theme of Windows 10 and Windows 11",
        "link": "https://github.com/AutoDarkMode/Windows-Auto-Night-Mode",
        "winget": "Armin2208.WindowsAutoNightMode"
    },
    "AmbieWhiteNoise": {
        "category": "Utilities",
        "choco": "na",
        "content": "Ambie White Noise",
        "description": "Ambie is the ultimate app to help you focus, study, or relax. We use white noise and nature sounds combined with an innovative focus timer to keep you concentrated on doing your best work.",
        "link": "https://ambieapp.com/",
        "winget": "9P07XNM5CHP0"
    },
    "magicwormhole": {
        "category": "Utilities",
        "choco": "magic-wormhole",
        "content": "Magic Wormhole",
        "description": "get things from one computer to another, safely",
        "link": "https://github.com/magic-wormhole/magic-wormhole",
        "winget": "magic-wormhole.magic-wormhole"
    },
    "croc": {
        "category": "Utilities",
        "choco": "croc",
        "content": "croc",
        "description": "Easily and securely send things from one computer to another.",
        "link": "https://github.com/schollz/croc",
        "winget": "schollz.croc"
    },
    "qgis": {
        "category": "Multimedia Tools",
        "choco": "qgis",
        "content": "QGIS",
        "description": "QGIS (Quantum GIS) is an open-source Geographic Information System (GIS) software that enables users to create, edit, visualize, analyze, and publish geospatial information on Windows, Mac, and Linux platforms.",
        "link": "https://qgis.org/en/site/",
        "winget": "OSGeo.QGIS"
    },
    "smplayer": {
        "category": "Multimedia Tools",
        "choco": "smplayer",
        "content": "SMPlayer",
        "description": "SMPlayer is a free media player for Windows and Linux with built-in codecs that can play virtually all video and audio formats.",
        "link": "https://www.smplayer.info",
        "winget": "SMPlayer.SMPlayer"
    },
    "glazewm": {
        "category": "Utilities",
        "choco": "na",
        "content": "GlazeWM",
        "description": "GlazeWM is a tiling window manager for Windows inspired by i3 and Polybar",
        "link": "https://github.com/glzr-io/glazewm",
        "winget": "glzr-io.glazewm"
    },
    "fancontrol": {
        "category": "Utilities",
        "choco": "na",
        "content": "FanControl",
        "description": "Fan Control is a free and open-source software that allows the user to control his CPU, GPU and case fans using temperatures.",
        "link": "https://getfancontrol.com/",
        "winget": "Rem0o.FanControl"
    },
    "fnm": {
        "category": "Development",
        "choco": "fnm",
        "content": "Fast Node Manager",
        "description": "Fast Node Manager (fnm) allows you to switch your Node version by using the Terminal",
        "link": "https://github.com/Schniz/fnm",
        "winget": "Schniz.fnm"
    },
    "Windhawk": {
        "category": "Utilities",
        "choco": "windhawk",
        "content": "Windhawk",
        "description": "The customization marketplace for Windows programs",
        "link": "https://windhawk.net",
        "winget": "RamenSoftware.Windhawk"
    },
    "ForceAutoHDR": {
        "category": "Utilities",
        "choco": "na",
        "content": "ForceAutoHDR",
        "description": "ForceAutoHDR simplifies the process of adding games to the AutoHDR list in the Windows Registry",
        "link": "https://github.com/7gxycn08/ForceAutoHDR",
        "winget": "ForceAutoHDR.7gxycn08"
    },
    "JoyToKey": {
        "category": "Utilities",
        "choco": "joytokey",
        "content": "JoyToKey",
        "description": "enables PC game controllers to emulate the keyboard and mouse input",
        "link": "https://joytokey.net/en/",
        "winget": "JTKsoftware.JoyToKey"
    },
    "nditools": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "NDI Tools",
        "description":"NDI, or Network Device Interface, is a video connectivity standard that enables multimedia systems to identify and communicate with one another over IP and to encode, transmit, and receive high-quality, low latency, frame-accurate video and audio, and exchange metadata in real-time.",
        "link": "https://ndi.video/",
        "winget": "NDI.NDITools"
    },
    "kicad": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "Kicad",
        "description":"Kicad is an open-source EDA tool. It''s a good starting point for those who want to do electrical design and is even used by professionals in the industry.",
        "link": "https://www.kicad.org/",
        "winget": "KiCad.KiCad"
    },
    "dropox": {
        "category": "Utilities",
        "choco": "na",
        "content": "Dropbox",
        "description":"The Dropbox desktop app! Save hard drive space, share and edit files and send for signature – all without the distraction of countless browser tabs.",
        "link": "https://www.dropbox.com/en_GB/desktop",
        "winget": "Dropbox.Dropbox"
    },
    "OFGB": {
        "category": "Utilities",
        "choco": "ofgb",
        "content": "OFGB (Oh Frick Go Back)",
        "description":"GUI Tool to remove ads from various places around Windows 11",
        "link": "https://github.com/xM4ddy/OFGB",
        "winget": "xM4ddy.OFGB"
    },
    "PaleMoon": {
        "category": "Browsers",
        "choco": "paleMoon",
        "content": "PaleMoon",
        "description":"Pale Moon is an Open Source, Goanna-based web browser available for Microsoft Windows and Linux (with other operating systems in development), focusing on efficiency and ease of use.",
        "link": "https://www.palemoon.org/download.shtml",
        "winget": "MoonchildProductions.PaleMoon"
    },
    "Shotcut": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "Shotcut",
        "description": "Shotcut is a free, open source, cross-platform video editor.",
        "link": "https://shotcut.org/",
        "winget": "Meltytech.Shotcut"
    },
    "LenovoLegionToolkit": {
        "category": "Utilities",
        "choco": "na",
        "content": "Lenovo Legion Toolkit",
        "description": "Lenovo Legion Toolkit (LLT) is a open-source utility created for Lenovo Legion (and similar) series laptops, that allows changing a couple of features that are only available in Lenovo Vantage or Legion Zone. It runs no background services, uses less memory, uses virtually no CPU, and contains no telemetry. Just like Lenovo Vantage, this application is Windows only.",
        "link": "https://github.com/BartoszCichecki/LenovoLegionToolkit",
        "winget": "BartoszCichecki.LenovoLegionToolkit"
    },
    "PulsarEdit": {
        "category": "Development",
        "choco": "pulsar",
        "content": "Pulsar",
        "description": "A Community-led Hyper-Hackable Text Editor",
        "link": "https://pulsar-edit.dev/",
        "winget": "Pulsar-Edit.Pulsar"
    },
    "Aegisub": {
        "category": "Development",
        "choco": "aegisub",
        "content": "Aegisub",
        "description": "Aegisub is a free, cross-platform open source tool for creating and modifying subtitles. Aegisub makes it quick and easy to time subtitles to audio, and features many powerful tools for styling them, including a built-in real-time video preview.",
        "link": "https://github.com/Aegisub/Aegisub",
        "winget": "Aegisub.Aegisub"
    },
    "SubtitleEdit": {
        "category": "Multimedia Tools",
        "choco": "na",
        "content": "Subtitle Edit",
        "description": "Subtitle Edit is a free and open source editor for video subtitles.",
        "link": "https://github.com/SubtitleEdit/subtitleedit",
        "winget": "Nikse.SubtitleEdit"
    },
    "Fork": {
        "category": "Development",
        "choco": "git-fork",
        "content": "Fork",
        "description": "Fork - a fast and friendly git client.",
        "link": "https://git-fork.com/",
        "winget": "Fork.Fork"
    },
    "ZenBrowser": {
        "category": "Browsers",
        "choco": "na",
        "content": "Zen Browser",
        "description": "The modern, privacy-focused, performance-driven browser built on Firefox",
        "link": "https://zen-browser.app/",
        "winget": "Zen-Team.Zen-Browser"
    }
}
'
$global:TweaksConfig = '{
  "1": {
    "Essential Tweaks": {
      "WPFTweaksRestorePoint": {
        "Checked": "False",
        "Order": "a001_",
        "Content": "Create Restore Point",
        "Description": "Creates a restore point at runtime in case a revert is needed from WinUtil modifications",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/restorepoint",
        "InvokeScript": [
          "
        # Check if System Restore is enabled for the main drive
        try {
            # Try getting restore points to check if System Restore is enabled
            Enable-ComputerRestore -Drive \"$env:SystemDrive\"
        } catch {
            Write-Host \"An error occurred while enabling System Restore: $_\"
        }\r\n
        # Check if the SystemRestorePointCreationFrequency value exists
        $exists = Get-ItemProperty -path \"HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore\" -Name \"SystemRestorePointCreationFrequency\" -ErrorAction SilentlyContinue
        if($null -eq $exists) {
            write-host ''Changing system to allow multiple restore points per day''
            Set-ItemProperty -Path \"HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore\" -Name \"SystemRestorePointCreationFrequency\" -Value \"0\" -Type DWord -Force -ErrorAction Stop | Out-Null
        }\r\n
        # Attempt to load the required module for Get-ComputerRestorePoint
        try {
            Import-Module Microsoft.PowerShell.Management -ErrorAction Stop
        } catch {
            Write-Host \"Failed to load the Microsoft.PowerShell.Management module: $_\"
            return
        }\r\n
        # Get all the restore points for the current day
        try {
            $existingRestorePoints = Get-ComputerRestorePoint | Where-Object { $_.CreationTime.Date -eq (Get-Date).Date }
        } catch {
            Write-Host \"Failed to retrieve restore points: $_\"
            return
        }\r\n
        # Check if there is already a restore point created today
        if ($existingRestorePoints.Count -eq 0) {
            $description = \"System Restore Point created by WinUtil\"\r\n
            Checkpoint-Computer -Description $description -RestorePointType \"MODIFY_SETTINGS\"
            Write-Host -ForegroundColor Green \"System Restore Point Created Successfully\"
        }
      "
        ]
      },
      "WPFTweaksDeleteTempFiles": {
        "Order": "a002_",
        "InvokeScript": [
          "Get-ChildItem -Path \"C:\\Windows\\Temp\" *.* -Recurse | Remove-Item -Force -Recurse
    Get-ChildItem -Path $env:TEMP *.* -Recurse | Remove-Item -Force -Recurse"
        ],
        "Content": "Delete Temporary Files",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/deletetempfiles",
        "Description": "Erases TEMP Folders"
      },
      "WPFTweaksTele": {
        "InvokeScript": [
          "
      bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
        If ((get-ItemProperty -Path \"HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\" -Name CurrentBuild).CurrentBuild -lt 22557) {
            $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
            Do {
                Start-Sleep -Milliseconds 100
                $preferences = Get-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\TaskManager\" -Name \"Preferences\" -ErrorAction SilentlyContinue
            } Until ($preferences)
            Stop-Process $taskmgr
            $preferences.Preferences[28] = 0
            Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\TaskManager\" -Name \"Preferences\" -Type Binary -Value $preferences.Preferences
        }
        Remove-Item -Path \"HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\MyComputer\\NameSpace\\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}\" -Recurse -ErrorAction SilentlyContinue\r\n
        # Fix Managed by your organization in Edge if regustry path exists then remove it\r\n
        If (Test-Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\") {
            Remove-Item -Path \"HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge\" -Recurse -ErrorAction SilentlyContinue
        }\r\n
        # Group svchost.exe processes
        $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
        Set-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\Control\" -Name \"SvcHostSplitThresholdInKB\" -Type DWord -Value $ram -Force\r\n
        $autoLoggerDir = \"$env:PROGRAMDATA\\Microsoft\\Diagnosis\\ETLLogs\\AutoLogger\"
        If (Test-Path \"$autoLoggerDir\\AutoLogger-Diagtrack-Listener.etl\") {
            Remove-Item \"$autoLoggerDir\\AutoLogger-Diagtrack-Listener.etl\"
        }
        icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null\r\n
        # Disable Defender Auto Sample Submission
        Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction SilentlyContinue | Out-Null
        "
        ],
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/tele",
        "Order": "a003_",
        "Content": "Disable Telemetry",
        "Description": "Disables Microsoft Telemetry. Note: This will lock many Edge Browser settings. Microsoft spies heavily on you when using the Edge browser.",
        "ScheduledTask": [
          {
            "Name": "Microsoft\\Windows\\Application Experience\\Microsoft Compatibility Appraiser",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Application Experience\\ProgramDataUpdater",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Autochk\\Proxy",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Customer Experience Improvement Program\\Consolidator",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Customer Experience Improvement Program\\UsbCeip",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\DiskDiagnostic\\Microsoft-Windows-DiskDiagnosticDataCollector",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Feedback\\Siuf\\DmClient",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Feedback\\Siuf\\DmClientOnScenarioDownload",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Windows Error Reporting\\QueueReporting",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Application Experience\\MareBackup",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Application Experience\\StartupAppTask",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Application Experience\\PcaPatchDbTask",
            "State": "Disabled",
            "OriginalState": "Enabled"
          },
          {
            "Name": "Microsoft\\Windows\\Maps\\MapsUpdateTask",
            "State": "Disabled",
            "OriginalState": "Enabled"
          }
        ],
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\DataCollection",
            "Type": "DWord",
            "Value": "0",
            "Name": "AllowTelemetry",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
            "OriginalValue": "<RemoveEntry>",
            "Name": "AllowTelemetry",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "ContentDeliveryAllowed",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "OemPreInstalledAppsEnabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "PreInstalledAppsEnabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "PreInstalledAppsEverEnabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "SilentInstalledAppsEnabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "SubscribedContent-338387Enabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "SubscribedContent-338388Enabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "SubscribedContent-338389Enabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "SubscribedContent-353698Enabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
            "OriginalValue": "1",
            "Name": "SystemPaneSuggestionsEnabled",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Siuf\\Rules",
            "OriginalValue": "0",
            "Name": "NumberOfSIUFInPeriod",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
            "OriginalValue": "<RemoveEntry>",
            "Name": "DoNotShowFeedbackNotifications",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent",
            "OriginalValue": "<RemoveEntry>",
            "Name": "DisableTailoredExperiencesWithDiagnosticData",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\AdvertisingInfo",
            "OriginalValue": "<RemoveEntry>",
            "Name": "DisabledByGroupPolicy",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\Windows Error Reporting",
            "OriginalValue": "0",
            "Name": "Disabled",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DeliveryOptimization\\Config",
            "OriginalValue": "1",
            "Name": "DODownloadMode",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Remote Assistance",
            "OriginalValue": "1",
            "Name": "fAllowToGetHelp",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\OperationStatusManager",
            "OriginalValue": "0",
            "Name": "EnthusiastMode",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "ShowTaskViewButton",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\People",
            "OriginalValue": "1",
            "Name": "PeopleBand",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "LaunchTo",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem",
            "OriginalValue": "0",
            "Name": "LongPathsEnabled",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "_Comment": "Driver searching is a function that should be left in",
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DriverSearching",
            "OriginalValue": "1",
            "Name": "SearchOrderConfig",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile",
            "OriginalValue": "1",
            "Name": "SystemResponsiveness",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Multimedia\\SystemProfile",
            "OriginalValue": "1",
            "Name": "NetworkThrottlingIndex",
            "Value": "4294967295",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Control Panel\\Desktop",
            "OriginalValue": "1",
            "Name": "MenuShowDelay",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Control Panel\\Desktop",
            "OriginalValue": "1",
            "Name": "AutoEndTasks",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Memory Management",
            "OriginalValue": "0",
            "Name": "ClearPageFileAtShutdown",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SYSTEM\\ControlSet001\\Services\\Ndu",
            "OriginalValue": "1",
            "Name": "Start",
            "Value": "2",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\LanmanServer\\Parameters",
            "OriginalValue": "20",
            "Name": "IRPStackSize",
            "Value": "30",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Feeds",
            "OriginalValue": "<RemoveEntry>",
            "Name": "EnableFeeds",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Feeds",
            "OriginalValue": "1",
            "Name": "ShellFeedsTaskbarViewMode",
            "Value": "2",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
            "OriginalValue": "<RemoveEntry>",
            "Name": "HideSCAMeetNow",
            "Value": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\UserProfileEngagement",
            "OriginalValue": "1",
            "Name": "ScoobeSystemSettingEnabled",
            "Value": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksConsumerFeatures": {
        "Order": "a003_",
        "Content": "Disable ConsumerFeatures",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/consumerfeatures",
        "Description": "Windows 10 will not automatically install any games, third-party apps, or application links from the Windows Store for the signed-in user. Some default Apps will be inaccessible (eg. Phone Link)",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent",
            "OriginalValue": "<RemoveEntry>",
            "Name": "DisableWindowsConsumerFeatures",
            "Value": "1",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksAH": {
        "Order": "a005_",
        "Content": "Disable Activity History",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/ah",
        "Description": "This erases recent docs, clipboard, and run history.",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
            "Name": "EnableActivityFeed",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
            "Name": "PublishUserActivities",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
            "Name": "UploadUserActivities",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          }
        ]
      },
      "WPFTweaksStorage": {
        "UndoScript": [
          "Set-ItemProperty -Path \"HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy\" -Name \"01\" -Value 1 -Type Dword -Force"
        ],
        "Order": "a005_",
        "Content": "Disable Storage Sense",
        "Description": "Storage Sense deletes temp files automatically.",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/storage",
        "InvokeScript": [
          "Set-ItemProperty -Path \"HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy\" -Name \"01\" -Value 0 -Type Dword -Force"
        ]
      },
      "WPFTweaksDVR": {
        "Order": "a005_",
        "Content": "Disable GameDVR",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/dvr",
        "Description": "GameDVR is a Windows App that is a dependency for some Store Games. I''ve never met someone that likes it, but it''s there for the XBOX crowd.",
        "registry": [
          {
            "Path": "HKCU:\\System\\GameConfigStore",
            "Name": "GameDVR_FSEBehavior",
            "Value": "2",
            "OriginalValue": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\System\\GameConfigStore",
            "Name": "GameDVR_Enabled",
            "Value": "0",
            "OriginalValue": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\System\\GameConfigStore",
            "Name": "GameDVR_HonorUserFSEBehaviorMode",
            "Value": "1",
            "OriginalValue": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\System\\GameConfigStore",
            "Name": "GameDVR_EFSEFeatureFlags",
            "Value": "0",
            "OriginalValue": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\GameDVR",
            "Name": "AllowGameDVR",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksWifi": {
        "Order": "a005_",
        "Content": "Disable Wifi-Sense",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/wifi",
        "Description": "Wifi Sense is a spying service that phones home all nearby scanned wifi networks and your current geo location.",
        "registry": [
          {
            "Path": "HKLM:\\Software\\Microsoft\\PolicyManager\\default\\WiFi\\AllowWiFiHotSpotReporting",
            "Name": "Value",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          },
          {
            "Path": "HKLM:\\Software\\Microsoft\\PolicyManager\\default\\WiFi\\AllowAutoConnectToWiFiSenseHotspots",
            "Name": "Value",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          }
        ]
      },
      "WPFTweaksLoc": {
        "Order": "a005_",
        "Content": "Disable Location Tracking",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/loc",
        "Description": "Disables Location Tracking...DUH!",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\location",
            "Name": "Value",
            "Type": "String",
            "Value": "Deny",
            "OriginalValue": "Allow"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Sensor\\Overrides\\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}",
            "Name": "SensorPermissionState",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          },
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\lfsvc\\Service\\Configuration",
            "Name": "Status",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          },
          {
            "Path": "HKLM:\\SYSTEM\\Maps",
            "Name": "AutoUpdateEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          }
        ]
      },
      "WPFTweaksHome": {
        "Order": "a005_",
        "Content": "Disable Homegroup",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/home",
        "Description": "Disables HomeGroup - HomeGroup is a password-protected home networking service that lets you share your stuff with other PCs that are currently running and connected to your network.",
        "service": [
          {
            "Name": "HomeGroupListener",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "HomeGroupProvider",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          }
        ]
      },
      "WPFTweaksHiber": {
        "InvokeScript": [
          "powercfg.exe /hibernate off"
        ],
        "UndoScript": [
          "powercfg.exe /hibernate on"
        ],
        "Order": "a005_",
        "Content": "Disable Hibernation",
        "Description": "Hibernation is really meant for laptops as it saves what''s in memory before turning the pc off. It really should never be used, but some people are lazy and rely on it. Don''t be like Bob. Bob likes hibernation.",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/hiber",
        "registry": [
          {
            "Path": "HKLM:\\System\\CurrentControlSet\\Control\\Session Manager\\Power",
            "Name": "HibernateEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FlyoutMenuSettings",
            "Name": "ShowHibernateOption",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          }
        ]
      },
      "WPFTweaksDisableExplorerAutoDiscovery": {
        "Order": "a005_",
        "InvokeScript": [
          "
      # Previously detected folders
      $bags = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\"\r\n
      # Folder types lookup table
      $bagMRU = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\BagMRU\"\r\n
      # Flush explorer view database
      Remove-Item -Path $bags -Recurse -Force
      Write-Host \"Removed $bags\"\r\n
      Remove-Item -Path $bagMRU -Recurse -Force
      Write-Host \"Removed $bagMRU\"\r\n
      # Every folder
      $allFolders = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\\AllFolders\\Shell\"\r\n
      if (!(Test-Path $allFolders)) {
        New-Item -Path $allFolders -Force
        Write-Host \"Created $allFolders\"
      }\r\n
      # Generic view
      New-ItemProperty -Path $allFolders -Name \"FolderType\" -Value \"NotSpecified\" -PropertyType String -Force
      Write-Host \"Set FolderType to NotSpecified\"\r\n
      Write-Host Please sign out and back in, or restart your computer to apply the changes!
      "
        ],
        "Content": "Disable Explorer Automatic Folder Discovery",
        "Description": "Windows Explorer automatically tries to guess the type of the folder based on its contents, slowing down the browsing experience.",
        "UndoScript": [
          "
      # Previously detected folders
      $bags = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\"\r\n
      # Folder types lookup table
      $bagMRU = \"HKCU:\\Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\BagMRU\"\r\n
      # Flush explorer view database
      Remove-Item -Path $bags -Recurse -Force
      Write-Host \"Removed $bags\"\r\n
      Remove-Item -Path $bagMRU -Recurse -Force
      Write-Host \"Removed $bagMRU\"\r\n
      Write-Host Please sign out and back in, or restart your computer to apply the changes!
      "
        ]
      },
      "WPFTweaksEndTaskOnTaskbar": {
        "UndoScript": [
          "$path = \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\TaskbarDeveloperSettings\"
      $name = \"TaskbarEndTask\"
      $value = 0\r\n
      # Ensure the registry key exists
      if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
      }\r\n
      # Set the property, creating it if it doesn''t exist
      New-ItemProperty -Path $path -Name $name -PropertyType DWord -Value $value -Force | Out-Null"
        ],
        "Order": "a006_",
        "Content": "Enable End Task With Right Click",
        "Description": "Enables option to end task when right clicking a program in the taskbar",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/endtaskontaskbar",
        "InvokeScript": [
          "$path = \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\TaskbarDeveloperSettings\"
      $name = \"TaskbarEndTask\"
      $value = 1\r\n
      # Ensure the registry key exists
      if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
      }\r\n
      # Set the property, creating it if it doesn''t exist
      New-ItemProperty -Path $path -Name $name -PropertyType DWord -Value $value -Force | Out-Null"
        ]
      },
      "WPFTweaksPowershell7": {
        "UndoScript": [
          "Invoke-WPFTweakPS7 -action \"PS5\""
        ],
        "Order": "a009_",
        "Content": "Change Windows Terminal default: PowerShell 5 -> PowerShell 7",
        "Description": "This will edit the config file of the Windows Terminal replacing PowerShell 5 with PowerShell 7 and installing PS7 if necessary",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/powershell7",
        "InvokeScript": [
          "Invoke-WPFTweakPS7 -action \"PS7\""
        ]
      },
      "WPFTweaksPowershell7Tele": {
        "UndoScript": [
          "[Environment]::SetEnvironmentVariable(''POWERSHELL_TELEMETRY_OPTOUT'', '''', ''Machine'')"
        ],
        "Order": "a009_",
        "Content": "Disable Powershell 7 Telemetry",
        "Description": "This will create an Environment Variable called ''POWERSHELL_TELEMETRY_OPTOUT'' with a value of ''1'' which will tell Powershell 7 to not send Telemetry Data.",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/powershell7tele",
        "InvokeScript": [
          "[Environment]::SetEnvironmentVariable(''POWERSHELL_TELEMETRY_OPTOUT'', ''1'', ''Machine'')"
        ]
      },
      "WPFTweaksDiskCleanup": {
        "Order": "a009_",
        "InvokeScript": [
          "
      cleanmgr.exe /d C: /VERYLOWDISK
      Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
      "
        ],
        "Content": "Run Disk Cleanup",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/diskcleanup",
        "Description": "Runs Disk Cleanup on Drive C: and removes old Windows Updates."
      },
      "WPFTweaksRecallOff": {
        "InvokeScript": [
          "
      Write-Host \"Disable Recall\"
      DISM /Online /Disable-Feature /FeatureName:Recall /Quiet /NoRestart
      Write-Host \"Please restart your computer in order for the changes to be fully applied.\"
      "
        ],
        "UndoScript": [
          "
      Write-Host \"Enable Recall\"
      DISM /Online /Enable-Feature /FeatureName:Recall /Quiet /NoRestart
      Write-Host \"Please restart your computer in order for the changes to be fully applied.\"
      "
        ],
        "Order": "a011_",
        "Content": "Disable Recall",
        "Description": "Turn Recall off",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/disablerecall",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsAI",
            "Name": "DisableAIDataAnalysis",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          }
        ]
      },
      "WPFTweaksServices": {
        "Order": "a014_",
        "Content": "Set Services to Manual",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/services",
        "Description": "Turns a bunch of system services to manual that don''t need to be running all the time. This is pretty harmless as if the service is needed, it will simply start on demand.",
        "service": [
          {
            "Name": "AJRouter",
            "StartupType": "Disabled",
            "OriginalType": "Manual"
          },
          {
            "Name": "ALG",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "AppIDSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "AppMgmt",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "AppReadiness",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "AppVClient",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "AppXSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Appinfo",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "AssignedAccessManagerSvc",
            "StartupType": "Disabled",
            "OriginalType": "Manual"
          },
          {
            "Name": "AudioEndpointBuilder",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "AudioSrv",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "Audiosrv",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "AxInstSV",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "BDESVC",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "BFE",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "BITS",
            "StartupType": "AutomaticDelayedStart",
            "OriginalType": "Automatic"
          },
          {
            "Name": "BTAGService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "BcastDVRUserService_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "BluetoothUserService_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "BrokerInfrastructure",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "Browser",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "BthAvctpSvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "BthHFSrv",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "CDPSvc",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "CDPUserSvc_*",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "COMSysApp",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "CaptureService_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "CertPropSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "ClipSVC",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "ConsentUxUserSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "CoreMessagingRegistrar",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "CredentialEnrollmentManagerUserSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "CryptSvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "CscService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DPS",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "DcomLaunch",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "DcpSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DevQueryBroker",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DeviceAssociationBrokerSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DeviceAssociationService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DeviceInstall",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DevicePickerUserSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DevicesFlowUserSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Dhcp",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "DiagTrack",
            "StartupType": "Disabled",
            "OriginalType": "Automatic"
          },
          {
            "Name": "DialogBlockingService",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "DispBrokerDesktopSvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "DisplayEnhancementService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "DmEnrollmentSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Dnscache",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "EFS",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "EapHost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "EntAppSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "EventLog",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "EventSystem",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "FDResPub",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Fax",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "FontCache",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "FrameServer",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "FrameServerMonitor",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "GraphicsPerfSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "HomeGroupListener",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "HomeGroupProvider",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "HvHost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "IEEtwCollectorService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "IKEEXT",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "InstallService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "InventorySvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "IpxlatCfgSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "KeyIso",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "KtmRm",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "LSM",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "LanmanServer",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "LanmanWorkstation",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "LicenseManager",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "LxpSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "MSDTC",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "MSiSCSI",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "MapsBroker",
            "StartupType": "AutomaticDelayedStart",
            "OriginalType": "Automatic"
          },
          {
            "Name": "McpManagementService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "MessagingService_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "MicrosoftEdgeElevationService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "MixedRealityOpenXRSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "MpsSvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "MsKeyboardFilter",
            "StartupType": "Manual",
            "OriginalType": "Disabled"
          },
          {
            "Name": "NPSMSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NaturalAuthentication",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NcaSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NcbService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NcdAutoSetup",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NetSetupSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NetTcpPortSharing",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "Netlogon",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "Netman",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NgcCtnrSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NgcSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "NlaSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "OneSyncSvc_*",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "P9RdrService_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PNRPAutoReg",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PNRPsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PcaSvc",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "PeerDistSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PenService_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PerfHost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PhoneSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PimIndexMaintenanceSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PlugPlay",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PolicyAgent",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Power",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "PrintNotify",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "PrintWorkflowUserSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "ProfSvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "PushToInstall",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "QWAVE",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "RasAuto",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "RasMan",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "RemoteAccess",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "RemoteRegistry",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "RetailDemo",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "RmSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "RpcEptMapper",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "RpcLocator",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "RpcSs",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "SCPolicySvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SCardSvr",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SDRSVC",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SEMgrSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SENS",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "SNMPTRAP",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SNMPTrap",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SSDPSRV",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SamSs",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "ScDeviceEnum",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Schedule",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "SecurityHealthService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Sense",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SensorDataService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SensorService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SensrSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SessionEnv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SharedAccess",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "SharedRealitySvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "ShellHWDetection",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "SmsRouter",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Spooler",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "SstpSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "StiSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "StorSvc",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "SysMain",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "SystemEventsBroker",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "TabletInputService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "TapiSrv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "TermService",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "Themes",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "TieringEngineService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "TimeBroker",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "TimeBrokerSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "TokenBroker",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "TrkWks",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "TroubleshootingSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "TrustedInstaller",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "UI0Detect",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "UdkUserSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "UevAgentService",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "UmRdpService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "UnistoreSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "UserDataSvc_*",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "UserManager",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "UsoSvc",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "VGAuthService",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "VMTools",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "VSS",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "VacSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "VaultSvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "W32Time",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WEPHOSTSVC",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WFDSConMgrSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WMPNetworkSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WManSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WPDBusEnum",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WSService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WSearch",
            "StartupType": "AutomaticDelayedStart",
            "OriginalType": "Automatic"
          },
          {
            "Name": "WaaSMedicSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WalletService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WarpJITSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WbioSrvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Wcmsvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "WcsPlugInService",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WdNisSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WdiServiceHost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WdiSystemHost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WebClient",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Wecsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WerSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WiaRpc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WinDefend",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "WinHttpAutoProxySvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WinRM",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "Winmgmt",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "WlanSvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "WpcMonSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "WpnService",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "WpnUserService_*",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "XblAuthManager",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "XblGameSave",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "XboxGipSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "XboxNetApiSvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "autotimesvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "bthserv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "camsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "cbdhsvc_*",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "cloudidsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "dcsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "defragsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "diagnosticshub.standardcollector.service",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "diagsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "dmwappushservice",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "dot3svc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "edgeupdate",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "edgeupdatem",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "embeddedmode",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "fdPHost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "fhsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "gpsvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "hidserv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "icssvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "iphlpsvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "lfsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "lltdsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "lmhosts",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "mpssvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "msiserver",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "netprofm",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "nsi",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "p2pimsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "p2psvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "perceptionsimulation",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "pla",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "seclogon",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "shpamsvc",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "smphost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "spectrum",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "sppsvc",
            "StartupType": "AutomaticDelayedStart",
            "OriginalType": "Automatic"
          },
          {
            "Name": "ssh-agent",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "svsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "swprv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "tiledatamodelsvc",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "tzautoupdate",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "uhssvc",
            "StartupType": "Disabled",
            "OriginalType": "Disabled"
          },
          {
            "Name": "upnphost",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vds",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vm3dservice",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "vmicguestinterface",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmicheartbeat",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmickvpexchange",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmicrdv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmicshutdown",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmictimesync",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmicvmsession",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmicvss",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "vmvss",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wbengine",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wcncsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "webthreatdefsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "webthreatdefusersvc_*",
            "StartupType": "Automatic",
            "OriginalType": "Automatic"
          },
          {
            "Name": "wercplsupport",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wisvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wlidsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wlpasvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wmiApSrv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "workfolderssvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wscsvc",
            "StartupType": "AutomaticDelayedStart",
            "OriginalType": "Automatic"
          },
          {
            "Name": "wuauserv",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          },
          {
            "Name": "wudfsvc",
            "StartupType": "Manual",
            "OriginalType": "Manual"
          }
        ]
      },
      "WPFTweaksLaptopHibernation": {
        "InvokeScript": [
          "
      Write-Host \"Turn on Hibernation\"
      Start-Process -FilePath powercfg -ArgumentList \"/hibernate on\" -NoNewWindow -Wait\r\n
      # Set hibernation as the default action
      Start-Process -FilePath powercfg -ArgumentList \"/change standby-timeout-ac 60\" -NoNewWindow -Wait
      Start-Process -FilePath powercfg -ArgumentList \"/change standby-timeout-dc 60\" -NoNewWindow -Wait
      Start-Process -FilePath powercfg -ArgumentList \"/change monitor-timeout-ac 10\" -NoNewWindow -Wait
      Start-Process -FilePath powercfg -ArgumentList \"/change monitor-timeout-dc 1\" -NoNewWindow -Wait
      "
        ],
        "UndoScript": [
          "
      Write-Host \"Turn off Hibernation\"
      Start-Process -FilePath powercfg -ArgumentList \"/hibernate off\" -NoNewWindow -Wait\r\n
      # Set standby to detault values
      Start-Process -FilePath powercfg -ArgumentList \"/change standby-timeout-ac 15\" -NoNewWindow -Wait
      Start-Process -FilePath powercfg -ArgumentList \"/change standby-timeout-dc 15\" -NoNewWindow -Wait
      Start-Process -FilePath powercfg -ArgumentList \"/change monitor-timeout-ac 15\" -NoNewWindow -Wait
      Start-Process -FilePath powercfg -ArgumentList \"/change monitor-timeout-dc 15\" -NoNewWindow -Wait
      "
        ],
        "Order": "a014_",
        "Content": "Set Hibernation as default (good for laptops)",
        "Description": "Most modern laptops have connected standby enabled which drains the battery, this sets hibernation as default which will not drain the battery. See issue https://github.com/ChrisTitusTech/winutil/issues/1399",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/laptophibernation",
        "registry": [
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Power\\PowerSettings\\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\\7bc4a2f9-d8fc-4469-b07b-33eb785aaca0",
            "OriginalValue": "1",
            "Name": "Attributes",
            "Value": "2",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Power\\PowerSettings\\abfc2519-3608-4c2a-94ea-171b0ed546ab\\94ac6d29-73ce-41a6-809f-6363ba21b47e",
            "OriginalValue": "0",
            "Name": "Attributes ",
            "Value": "2",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksBraveDebloat": {
        "Order": "a016_",
        "Content": "Debloat Brave",
        "Description": "Disables various annoyances like Brave Rewards,Leo AI,Crypto Wallet and VPN",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave",
            "Name": "BraveRewardsDisabled",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave",
            "Name": "BraveWalletDisabled",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave",
            "Name": "BraveVPNDisabled",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave",
            "Name": "BraveAIChatEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\BraveSoftware\\Brave",
            "Name": "SyncDisabled",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          }
        ]
      },
      "WPFTweaksEdgeDebloat": {
        "Order": "a016_",
        "Content": "Debloat Edge",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/edgedebloat",
        "Description": "Disables various telemetry options, popups, and other annoyances in Edge.",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\EdgeUpdate",
            "Name": "CreateDesktopShortcutDefault",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "PersonalizationReportingEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "ShowRecommendationsEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "HideFirstRunExperience",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "UserFeedbackAllowed",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "ConfigureDoNotTrack",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "AlternateErrorPagesEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "EdgeCollectionsEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "EdgeShoppingAssistantEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "MicrosoftEdgeInsiderPromotionEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "PersonalizationReportingEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "ShowMicrosoftRewards",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "WebWidgetAllowed",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "DiagnosticData",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "EdgeAssetDeliveryServiceEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "EdgeCollectionsEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "CryptoWalletEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
            "Name": "WalletDonationEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "<RemoveEntry>"
          }
        ]
      }
    },
    "Advanced Tweaks - CAUTION": {
      "WPFTweaksBlockAdobeNet": {
        "UndoScript": [
          "
      # Define the local path of the HOSTS file
      $localHostsPath = \"C:\\Windows\\System32\\drivers\\etc\\hosts\"\r\n
      # Load the content of the HOSTS file
      try {
          $hostsContent = Get-Content $localHostsPath -ErrorAction Stop
      } catch {
          Write-Error \"Failed to load the HOSTS file. Error: $_\"
          return
      }\r\n
      # Initialize flags and buffer for new content
      $recording = $true
      $newContent = @()\r\n
      # Iterate over each line of the HOSTS file
      foreach ($line in $hostsContent) {
          if ($line -match \"#AdobeNetBlock-start\") {
              $recording = $false
          }
          if ($recording) {
              $newContent += $line
          }
          if ($line -match \"#AdobeNetBlock-end\") {
              $recording = $true
          }
      }\r\n
      # Write the filtered content back to the HOSTS file
      try {
          $newContent | Set-Content $localHostsPath -Encoding ASCII
          Write-Output \"Successfully removed the AdobeNetBlock section from the HOSTS file.\"
      } catch {
          Write-Error \"Failed to write back to the HOSTS file. Error: $_\"
      }\r\n
      # Flush the DNS resolver cache
      try {
          Invoke-Expression \"ipconfig /flushdns\"
          Write-Output \"DNS cache flushed successfully.\"
      } catch {
          Write-Error \"Failed to flush DNS cache. Error: $_\"
      }
      "
        ],
        "Order": "a021_",
        "Content": "Adobe Network Block",
        "Description": "Reduce user interruptions by selectively blocking connections to Adobe''s activation and telemetry servers. Credit: Ruddernation-Designs",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/blockadobenet",
        "InvokeScript": [
          "
      # Define the URL of the remote HOSTS file and the local paths
      $remoteHostsUrl = \"https://raw.githubusercontent.com/Ruddernation-Designs/Adobe-URL-Block-List/master/hosts\"
      $localHostsPath = \"C:\\Windows\\System32\\drivers\\etc\\hosts\"
      $tempHostsPath = \"C:\\Windows\\System32\\drivers\\etc\\temp_hosts\"\r\n
      # Download the remote HOSTS file to a temporary location
      try {
          Invoke-WebRequest -Uri $remoteHostsUrl -OutFile $tempHostsPath
          Write-Output \"Downloaded the remote HOSTS file to a temporary location.\"
      } catch {
          Write-Error \"Failed to download the HOSTS file. Error: $_\"
      }\r\n
      # Check if the AdobeNetBlock has already been started
      try {
          $localHostsContent = Get-Content $localHostsPath -ErrorAction Stop\r\n
          # Check if AdobeNetBlock markers exist
          $blockStartExists = $localHostsContent -like \"*#AdobeNetBlock-start*\"
          if ($blockStartExists) {
              Write-Output \"AdobeNetBlock-start already exists. Skipping addition of new block.\"
          } else {
              # Load the new block from the downloaded file
              $newBlockContent = Get-Content $tempHostsPath -ErrorAction Stop
              $newBlockContent = $newBlockContent | Where-Object { $_ -notmatch \"^\\s*#\" -and $_ -ne \"\" } # Exclude empty lines and comments
              $newBlockHeader = \"#AdobeNetBlock-start\"
              $newBlockFooter = \"#AdobeNetBlock-end\"\r\n
              # Combine the contents, ensuring new block is properly formatted
              $combinedContent = $localHostsContent + $newBlockHeader, $newBlockContent, $newBlockFooter | Out-String\r\n
              # Write the combined content back to the original HOSTS file
              $combinedContent | Set-Content $localHostsPath -Encoding ASCII
              Write-Output \"Successfully added the AdobeNetBlock.\"
          }
      } catch {
          Write-Error \"Error during processing: $_\"
      }\r\n
      # Clean up temporary file
      Remove-Item $tempHostsPath -ErrorAction Ignore\r\n
      # Flush the DNS resolver cache
      try {
          Invoke-Expression \"ipconfig /flushdns\"
          Write-Output \"DNS cache flushed successfully.\"
      } catch {
          Write-Error \"Failed to flush DNS cache. Error: $_\"
      }
      "
        ]
      },
      "WPFTweaksDebloatAdobe": {
        "UndoScript": [
          "
      function RestoreCCService {
        $originalPath = \"C:\\Program Files (x86)\\Common Files\\Adobe\\Adobe Desktop Common\\ADS\\Adobe Desktop Service.exe.old\"
        $newPath = \"C:\\Program Files (x86)\\Common Files\\Adobe\\Adobe Desktop Common\\ADS\\Adobe Desktop Service.exe\"\r\n
        if (Test-Path -Path $originalPath) {
            Rename-Item -Path $originalPath -NewName \"Adobe Desktop Service.exe\" -Force
            Write-Host \"Adobe Desktop Service has been restored.\"
        } else {
            Write-Host \"Backup file does not exist. No changes were made.\"
        }
      }\r\n
      function AcrobatUpdates {
        # Default Value:
        # 3 = Automatically download and install updates\r\n
        $rootPath = \"HKLM:\\SOFTWARE\\WOW6432Node\\Adobe\\Adobe ARM\\Legacy\\Acrobat\"\r\n
        # Get all subkeys under the specified root path
        $subKeys = Get-ChildItem -Path $rootPath | Where-Object { $_.PSChildName -like \"{*}\" }\r\n
        # Loop through each subkey
        foreach ($subKey in $subKeys) {
            # Get the full registry path
            $fullPath = Join-Path -Path $rootPath -ChildPath $subKey.PSChildName
            try {
                Set-ItemProperty -Path $fullPath -Name Mode -Value 3
            } catch {
                Write-Host \"Registry Key for changing Acrobat Updates does not exist in $fullPath\"
            }
        }
      }\r\n
      RestoreCCService
      AcrobatUpdates
      "
        ],
        "Order": "a021_",
        "Content": "Adobe Debloat",
        "service": [
          {
            "Name": "AGSService",
            "StartupType": "Disabled",
            "OriginalType": "Automatic"
          },
          {
            "Name": "AGMService",
            "StartupType": "Disabled",
            "OriginalType": "Automatic"
          },
          {
            "Name": "AdobeUpdateService",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "Adobe Acrobat Update",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "Adobe Genuine Monitor Service",
            "StartupType": "Disabled",
            "OriginalType": "Automatic"
          },
          {
            "Name": "AdobeARMservice",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "Adobe Licensing Console",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "CCXProcess",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "AdobeIPCBroker",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          },
          {
            "Name": "CoreSync",
            "StartupType": "Manual",
            "OriginalType": "Automatic"
          }
        ],
        "Description": "Manages Adobe Services, Adobe Desktop Service, and Acrobat Updates",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/debloatadobe",
        "InvokeScript": [
          "
      function CCStopper {
        $path = \"C:\\Program Files (x86)\\Common Files\\Adobe\\Adobe Desktop Common\\ADS\\Adobe Desktop Service.exe\"\r\n
        # Test if the path exists before proceeding
        if (Test-Path $path) {
            Takeown /f $path
            $acl = Get-Acl $path
            $acl.SetOwner([System.Security.Principal.NTAccount]\"Administrators\")
            $acl | Set-Acl $path\r\n
            Rename-Item -Path $path -NewName \"Adobe Desktop Service.exe.old\" -Force
        } else {
            Write-Host \"Adobe Desktop Service is not in the default location.\"
        }
      }\r\n\r\n
      function AcrobatUpdates {
        # Editing Acrobat Updates. The last folder before the key is dynamic, therefore using a script.
        # Possible Values for the edited key:
        # 0 = Do not download or install updates automatically
        # 2 = Automatically download updates but let the user choose when to install them
        # 3 = Automatically download and install updates (default value)
        # 4 = Notify the user when an update is available but don''t download or install it automatically
        #   = It notifies the user using Windows Notifications. It runs on startup without having to have a Service/Acrobat/Reader running, therefore 0 is the next best thing.\r\n
        $rootPath = \"HKLM:\\SOFTWARE\\WOW6432Node\\Adobe\\Adobe ARM\\Legacy\\Acrobat\"\r\n
        # Get all subkeys under the specified root path
        $subKeys = Get-ChildItem -Path $rootPath | Where-Object { $_.PSChildName -like \"{*}\" }\r\n
        # Loop through each subkey
        foreach ($subKey in $subKeys) {
            # Get the full registry path
            $fullPath = Join-Path -Path $rootPath -ChildPath $subKey.PSChildName
            try {
                Set-ItemProperty -Path $fullPath -Name Mode -Value 0
                Write-Host \"Acrobat Updates have been disabled.\"
            } catch {
                Write-Host \"Registry Key for changing Acrobat Updates does not exist in $fullPath\"
            }
        }
      }\r\n
      CCStopper
      AcrobatUpdates
      "
        ]
      },
      "WPFTweaksDisableipsix": {
        "InvokeScript": [
          "Disable-NetAdapterBinding -Name \"*\" -ComponentID ms_tcpip6"
        ],
        "UndoScript": [
          "Enable-NetAdapterBinding -Name \"*\" -ComponentID ms_tcpip6"
        ],
        "Order": "a023_",
        "Content": "Disable IPv6",
        "Description": "Disables IPv6.",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/disableipsix",
        "registry": [
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters",
            "Name": "DisabledComponents",
            "Value": "255",
            "OriginalValue": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksTeredo": {
        "InvokeScript": [
          "netsh interface teredo set state disabled"
        ],
        "UndoScript": [
          "netsh interface teredo set state default"
        ],
        "Order": "a023_",
        "Content": "Disable Teredo",
        "Description": "Teredo network tunneling is a ipv6 feature that can cause additional latency, but may cause problems with some games",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/teredo",
        "registry": [
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters",
            "Name": "DisabledComponents",
            "Value": "1",
            "OriginalValue": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksIPv46": {
        "Order": "a023_",
        "Content": "Prefer IPv4 over IPv6",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/ipv46",
        "Description": "To set the IPv4 preference can have latency and security benefits on private networks where IPv6 is not configured.",
        "registry": [
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters",
            "Name": "DisabledComponents",
            "Value": "32",
            "OriginalValue": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksDisableFSO": {
        "Order": "a024_",
        "Content": "Disable Fullscreen Optimizations",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/disablefso",
        "Description": "Disables FSO in all applications. NOTE: This will disable Color Management in Exclusive Fullscreen",
        "registry": [
          {
            "Path": "HKCU:\\System\\GameConfigStore",
            "Name": "GameDVR_DXGIHonorFSEWindowsCompatible",
            "Value": "1",
            "OriginalValue": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksDisableBGapps": {
        "Order": "a024_",
        "Content": "Disable Background Apps",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/disablebgapps",
        "Description": "Disables all Microsoft Store apps from running in the background, which has to be done individually since Win11",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\BackgroundAccessApplications",
            "Name": "GlobalUserDisabled",
            "Value": "1",
            "OriginalValue": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksRemoveCopilot": {
        "InvokeScript": [
          "
      Write-Host \"Remove Copilot\"
      dism /online /remove-package /package-name:Microsoft.Windows.Copilot
      "
        ],
        "UndoScript": [
          "
      Write-Host \"Install Copilot\"
      dism /online /add-package /package-name:Microsoft.Windows.Copilot
      "
        ],
        "Order": "a025_",
        "Content": "Disable Microsoft Copilot",
        "Description": "Disables MS Copilot AI built into Windows since 23H2.",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/removecopilot",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsCopilot",
            "Name": "TurnOffWindowsCopilot",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKCU:\\Software\\Policies\\Microsoft\\Windows\\WindowsCopilot",
            "Name": "TurnOffWindowsCopilot",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "ShowCopilotButton",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          }
        ]
      },
      "WPFTweaksDisableNotifications": {
        "Order": "a026_",
        "Content": "Disable Notification Tray/Calendar",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/disablenotifications",
        "Description": "Disables all Notifications INCLUDING Calendar",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Policies\\Microsoft\\Windows\\Explorer",
            "Name": "DisableNotificationCenter",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications",
            "Name": "ToastEnabled",
            "Type": "DWord",
            "Value": "0",
            "OriginalValue": "1"
          }
        ]
      },
      "WPFTweaksDisableLMS1": {
        "UndoScript": [
          "
      Write-Host \"LMS vPro needs to be redownloaded from intel.com\"\r\n
      "
        ],
        "Order": "a026_",
        "Content": "Disable Intel MM (vPro LMS)",
        "Description": "Intel LMS service is always listening on all ports and could be a huge security risk. There is no need to run LMS on home machines and even in the Enterprise there are better solutions.",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/disablelms1",
        "InvokeScript": [
          "
        Write-Host \"Kill LMS\"
        $serviceName = \"LMS\"
        Write-Host \"Stopping and disabling service: $serviceName\"
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue;
        Set-Service -Name $serviceName -StartupType Disabled -ErrorAction SilentlyContinue;\r\n
        Write-Host \"Removing service: $serviceName\";
        sc.exe delete $serviceName;\r\n
        Write-Host \"Removing LMS driver packages\";
        $lmsDriverPackages = Get-ChildItem -Path \"C:\\Windows\\System32\\DriverStore\\FileRepository\" -Recurse -Filter \"lms.inf*\";
        foreach ($package in $lmsDriverPackages) {
            Write-Host \"Removing driver package: $($package.Name)\";
            pnputil /delete-driver $($package.Name) /uninstall /force;
        }
        if ($lmsDriverPackages.Count -eq 0) {
            Write-Host \"No LMS driver packages found in the driver store.\";
        } else {
            Write-Host \"All found LMS driver packages have been removed.\";
        }\r\n
        Write-Host \"Searching and deleting LMS executable files\";
        $programFilesDirs = @(\"C:\\Program Files\", \"C:\\Program Files (x86)\");
        $lmsFiles = @();
        foreach ($dir in $programFilesDirs) {
            $lmsFiles += Get-ChildItem -Path $dir -Recurse -Filter \"LMS.exe\" -ErrorAction SilentlyContinue;
        }
        foreach ($file in $lmsFiles) {
            Write-Host \"Taking ownership of file: $($file.FullName)\";
            & icacls $($file.FullName) /grant Administrators:F /T /C /Q;
            & takeown /F $($file.FullName) /A /R /D Y;
            Write-Host \"Deleting file: $($file.FullName)\";
            Remove-Item $($file.FullName) -Force -ErrorAction SilentlyContinue;
        }
        if ($lmsFiles.Count -eq 0) {
            Write-Host \"No LMS.exe files found in Program Files directories.\";
        } else {
            Write-Host \"All found LMS.exe files have been deleted.\";
        }
        Write-Host ''Intel LMS vPro service has been disabled, removed, and blocked.'';
       "
        ]
      },
      "WPFTweaksRightClickMenu": {
        "UndoScript": [
          "
      Remove-Item -Path \"HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\" -Recurse -Confirm:$false -Force
      # Restarting Explorer in the Undo Script might not be necessary, as the Registry change without restarting Explorer does work, but just to make sure.
      Write-Host Restarting explorer.exe ...
      Stop-Process -Name \"explorer\" -Force
      "
        ],
        "Order": "a027_",
        "Content": "Set Classic Right-Click Menu ",
        "Description": "Great Windows 11 tweak to bring back good context menus when right clicking things in explorer.",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/rightclickmenu",
        "InvokeScript": [
          "
      New-Item -Path \"HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\" -Name \"InprocServer32\" -force -value \"\"
      Write-Host Restarting explorer.exe ...
      Stop-Process -Name \"explorer\" -Force
      "
        ]
      },
      "WPFTweaksUTC": {
        "Order": "a027_",
        "Content": "Set Time to UTC (Dual Boot)",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/utc",
        "Description": "Essential for computers that are dual booting. Fixes the time sync with Linux Systems.",
        "registry": [
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\TimeZoneInformation",
            "Name": "RealTimeIsUniversal",
            "Type": "DWord",
            "Value": "1",
            "OriginalValue": "0"
          }
        ]
      },
      "WPFTweaksDisableWpbtExecution": {
        "Order": "a027_",
        "Content": "Disable Windows Platform Binary Table (WPBT)",
        "Description": "If enabled then allows your computer vendor to execute a program each time it boots. It enables computer vendors to force install anti-theft software, software drivers, or a software program conveniently. This could also be a security risk.",
        "registry": [
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager",
            "Name": "DisableWpbtExecution",
            "Value": "1",
            "OriginalValue": "<RemoveEntry>",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksDisplay": {
        "InvokeScript": [
          "Set-ItemProperty -Path \"HKCU:\\Control Panel\\Desktop\" -Name \"UserPreferencesMask\" -Type Binary -Value ([byte[]](144,18,3,128,16,0,0,0))"
        ],
        "UndoScript": [
          "Remove-ItemProperty -Path \"HKCU:\\Control Panel\\Desktop\" -Name \"UserPreferencesMask\""
        ],
        "Order": "a027_",
        "Content": "Set Display for Performance",
        "Description": "Sets the system preferences to performance. You can do this manually with sysdm.cpl as well.",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/display",
        "registry": [
          {
            "Path": "HKCU:\\Control Panel\\Desktop",
            "OriginalValue": "1",
            "Name": "DragFullWindows",
            "Value": "0",
            "Type": "String"
          },
          {
            "Path": "HKCU:\\Control Panel\\Desktop",
            "OriginalValue": "1",
            "Name": "MenuShowDelay",
            "Value": "200",
            "Type": "String"
          },
          {
            "Path": "HKCU:\\Control Panel\\Desktop\\WindowMetrics",
            "OriginalValue": "1",
            "Name": "MinAnimate",
            "Value": "0",
            "Type": "String"
          },
          {
            "Path": "HKCU:\\Control Panel\\Keyboard",
            "OriginalValue": "1",
            "Name": "KeyboardDelay",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "ListviewAlphaSelect",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "ListviewShadow",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "TaskbarAnimations",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects",
            "OriginalValue": "1",
            "Name": "VisualFXSetting",
            "Value": "3",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\DWM",
            "OriginalValue": "1",
            "Name": "EnableAeroPeek",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "TaskbarMn",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "TaskbarDa",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "OriginalValue": "1",
            "Name": "ShowTaskViewButton",
            "Value": "0",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search",
            "OriginalValue": "1",
            "Name": "SearchboxTaskbarMode",
            "Value": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFTweaksDeBloat": {
        "appx": [
          "Microsoft.Microsoft3DViewer",
          "Microsoft.AppConnector",
          "Microsoft.BingFinance",
          "Microsoft.BingNews",
          "Microsoft.BingSports",
          "Microsoft.BingTranslator",
          "Microsoft.BingWeather",
          "Microsoft.BingFoodAndDrink",
          "Microsoft.BingHealthAndFitness",
          "Microsoft.BingTravel",
          "Microsoft.MinecraftUWP",
          "Microsoft.GamingServices",
          "Microsoft.GetHelp",
          "Microsoft.Getstarted",
          "Microsoft.Messaging",
          "Microsoft.Microsoft3DViewer",
          "Microsoft.MicrosoftSolitaireCollection",
          "Microsoft.NetworkSpeedTest",
          "Microsoft.News",
          "Microsoft.Office.Lens",
          "Microsoft.Office.Sway",
          "Microsoft.Office.OneNote",
          "Microsoft.OneConnect",
          "Microsoft.People",
          "Microsoft.Print3D",
          "Microsoft.SkypeApp",
          "Microsoft.Wallet",
          "Microsoft.Whiteboard",
          "Microsoft.WindowsAlarms",
          "microsoft.windowscommunicationsapps",
          "Microsoft.WindowsFeedbackHub",
          "Microsoft.WindowsMaps",
          "Microsoft.WindowsSoundRecorder",
          "Microsoft.ConnectivityStore",
          "Microsoft.ScreenSketch",
          "Microsoft.MixedReality.Portal",
          "Microsoft.ZuneMusic",
          "Microsoft.ZuneVideo",
          "Microsoft.Getstarted",
          "Microsoft.MicrosoftOfficeHub",
          "*EclipseManager*",
          "*ActiproSoftwareLLC*",
          "*AdobeSystemsIncorporated.AdobePhotoshopExpress*",
          "*Duolingo-LearnLanguagesforFree*",
          "*PandoraMediaInc*",
          "*CandyCrush*",
          "*BubbleWitch3Saga*",
          "*Wunderlist*",
          "*Flipboard*",
          "*Twitter*",
          "*Facebook*",
          "*Royal Revolt*",
          "*Sway*",
          "*Speed Test*",
          "*Dolby*",
          "*Viber*",
          "*ACGMediaPlayer*",
          "*Netflix*",
          "*OneCalendar*",
          "*LinkedInforWindows*",
          "*HiddenCityMysteryofShadows*",
          "*Hulu*",
          "*HiddenCity*",
          "*AdobePhotoshopExpress*",
          "*HotspotShieldFreeVPN*",
          "*Microsoft.Advertising.Xaml*"
        ],
        "Order": "a028_",
        "Content": "Remove ALL MS Store Apps - NOT RECOMMENDED",
        "Description": "USE WITH CAUTION!!!!! This will remove ALL Microsoft store apps other than the essentials to make winget work. Games installed by MS Store ARE INCLUDED!",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/debloat",
        "InvokeScript": [
          "
        $TeamsPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, ''Microsoft'', ''Teams'')
        $TeamsUpdateExePath = [System.IO.Path]::Combine($TeamsPath, ''Update.exe'')\r\n
        Write-Host \"Stopping Teams process...\"
        Stop-Process -Name \"*teams*\" -Force -ErrorAction SilentlyContinue\r\n
        Write-Host \"Uninstalling Teams from AppData\\Microsoft\\Teams\"
        if ([System.IO.File]::Exists($TeamsUpdateExePath)) {
            # Uninstall app
            $proc = Start-Process $TeamsUpdateExePath \"-uninstall -s\" -PassThru
            $proc.WaitForExit()
        }\r\n
        Write-Host \"Removing Teams AppxPackage...\"
        Get-AppxPackage \"*Teams*\" | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxPackage \"*Teams*\" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue\r\n
        Write-Host \"Deleting Teams directory\"
        if ([System.IO.Directory]::Exists($TeamsPath)) {
            Remove-Item $TeamsPath -Force -Recurse -ErrorAction SilentlyContinue
        }\r\n
        Write-Host \"Deleting Teams uninstall registry key\"
        # Uninstall from Uninstall registry key UninstallString
        $us = (Get-ChildItem -Path HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall, HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like ''*Teams*''}).UninstallString
        if ($us.Length -gt 0) {
            $us = ($us.Replace(''/I'', ''/uninstall '') + '' /quiet'').Replace(''  '', '' '')
            $FilePath = ($us.Substring(0, $us.IndexOf(''.exe'') + 4).Trim())
            $ProcessArgs = ($us.Substring($us.IndexOf(''.exe'') + 5).Trim().replace(''  '', '' ''))
            $proc = Start-Process -FilePath $FilePath -Args $ProcessArgs -PassThru
            $proc.WaitForExit()
        }
      "
        ]
      },
      "WPFTweaksRemoveEdge": {
        "UndoScript": [
          "Uninstall-WinUtilEdgeBrowser -action \"Install\""
        ],
        "Order": "a029_",
        "Content": "Remove Microsoft Edge",
        "Description": "Removes MS Edge when it gets reinstalled by updates. Credit: Psyirius",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/removeedge",
        "InvokeScript": [
          "Uninstall-WinUtilEdgeBrowser -action \"Uninstall\""
        ]
      },
      "WPFTweaksRemoveHomeGallery": {
        "UndoScript": [
          "
      REG ADD \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}\" /f /ve /t REG_SZ /d \"{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}\"
      REG ADD \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}\" /f /ve /t REG_SZ /d \"CLSID_MSGraphHomeFolder\"
      REG DELETE \"HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\" /f /v \"LaunchTo\"
      "
        ],
        "Order": "a029_",
        "Content": "Remove Home and Gallery from explorer",
        "Description": "Removes the Home and Gallery from explorer and sets This PC as default",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/removehomegallery",
        "InvokeScript": [
          "
      REG DELETE \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}\" /f
      REG DELETE \"HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}\" /f
      REG ADD \"HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\" /f /v \"LaunchTo\" /t REG_DWORD /d \"1\"
      "
        ]
      },
      "WPFTweaksRemoveOnedrive": {
        "UndoScript": [
          "
      Write-Host \"Install OneDrive\"
      Start-Process -FilePath winget -ArgumentList \"install -e --accept-source-agreements --accept-package-agreements --silent Microsoft.OneDrive \" -NoNewWindow -Wait
      "
        ],
        "Order": "a030_",
        "Content": "Remove OneDrive",
        "Description": "Moves OneDrive files to Default Home Folders and Uninstalls it.",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/removeonedrive",
        "InvokeScript": [
          "
      $OneDrivePath = $($env:OneDrive)
      Write-Host \"Removing OneDrive\"\r\n
      # Check both traditional and Microsoft Store installations
      $regPath = \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\OneDriveSetup.exe\"
      $msStorePath = \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Appx\\AppxAllUserStore\\Applications\\*OneDrive*\"\r\n
      if (Test-Path $regPath) {
          $OneDriveUninstallString = Get-ItemPropertyValue \"$regPath\" -Name \"UninstallString\"
          $OneDriveExe, $OneDriveArgs = $OneDriveUninstallString.Split(\" \")
          Start-Process -FilePath $OneDriveExe -ArgumentList \"$OneDriveArgs /silent\" -NoNewWindow -Wait
      } elseif (Test-Path $msStorePath) {
          Write-Host \"OneDrive appears to be installed via Microsoft Store\" -ForegroundColor Yellow
          # Attempt to uninstall via winget
          Start-Process -FilePath winget -ArgumentList \"uninstall -e --purge --accept-source-agreements Microsoft.OneDrive\" -NoNewWindow -Wait
      } else {
          Write-Host \"OneDrive doesn''t seem to be installed\" -ForegroundColor Red
          Write-Host \"Running cleanup if OneDrive path exists\" -ForegroundColor Red
      }\r\n
      # Check if OneDrive got Uninstalled (both paths)
      if (Test-Path $OneDrivePath) {
        Write-Host \"Copy downloaded Files from the OneDrive Folder to Root UserProfile\"
        Start-Process -FilePath powershell -ArgumentList \"robocopy ''$($OneDrivePath)'' ''$($env:USERPROFILE.TrimEnd())\\'' /mov /e /xj\" -NoNewWindow -Wait\r\n
        Write-Host \"Removing OneDrive leftovers\"
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:localappdata\\Microsoft\\OneDrive\"
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:localappdata\\OneDrive\"
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:programdata\\Microsoft OneDrive\"
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$env:systemdrive\\OneDriveTemp\"
        reg delete \"HKEY_CURRENT_USER\\Software\\Microsoft\\OneDrive\" -f
        # check if directory is empty before removing:
        If ((Get-ChildItem \"$OneDrivePath\" -Recurse | Measure-Object).Count -eq 0) {
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue \"$OneDrivePath\"
        }\r\n
        Write-Host \"Remove Onedrive from explorer sidebar\"
        Set-ItemProperty -Path \"HKCR:\\CLSID\\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\" -Name \"System.IsPinnedToNameSpaceTree\" -Value 0
        Set-ItemProperty -Path \"HKCR:\\Wow6432Node\\CLSID\\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\" -Name \"System.IsPinnedToNameSpaceTree\" -Value 0\r\n
        Write-Host \"Removing run hook for new users\"
        reg load \"hku\\Default\" \"C:\\Users\\Default\\NTUSER.DAT\"
        reg delete \"HKEY_USERS\\Default\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\" /v \"OneDriveSetup\" /f
        reg unload \"hku\\Default\"\r\n
        Write-Host \"Removing autostart key\"
        reg delete \"HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\" /v \"OneDrive\" /f\r\n
        Write-Host \"Removing startmenu entry\"
        Remove-Item -Force -ErrorAction SilentlyContinue \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\OneDrive.lnk\"\r\n
        Write-Host \"Removing scheduled task\"
        Get-ScheduledTask -TaskPath ''\\'' -TaskName ''OneDrive*'' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false\r\n
        # Add Shell folders restoring default locations
        Write-Host \"Shell Fixing\"
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"AppData\" -Value \"$env:userprofile\\AppData\\Roaming\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Cache\" -Value \"$env:userprofile\\AppData\\Local\\Microsoft\\Windows\\INetCache\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Cookies\" -Value \"$env:userprofile\\AppData\\Local\\Microsoft\\Windows\\INetCookies\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Favorites\" -Value \"$env:userprofile\\Favorites\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"History\" -Value \"$env:userprofile\\AppData\\Local\\Microsoft\\Windows\\History\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Local AppData\" -Value \"$env:userprofile\\AppData\\Local\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"My Music\" -Value \"$env:userprofile\\Music\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"My Video\" -Value \"$env:userprofile\\Videos\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"NetHood\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Network Shortcuts\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"PrintHood\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Printer Shortcuts\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Programs\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Recent\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Recent\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"SendTo\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\SendTo\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Start Menu\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Startup\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Templates\" -Value \"$env:userprofile\\AppData\\Roaming\\Microsoft\\Windows\\Templates\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"{374DE290-123F-4565-9164-39C4925E467B}\" -Value \"$env:userprofile\\Downloads\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Desktop\" -Value \"$env:userprofile\\Desktop\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"My Pictures\" -Value \"$env:userprofile\\Pictures\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"Personal\" -Value \"$env:userprofile\\Documents\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"{F42EE2D3-909F-4907-8871-4C22FC0BF756}\" -Value \"$env:userprofile\\Documents\" -Type ExpandString
        Set-ItemProperty -Path \"HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders\" -Name \"{0DDD015D-B06C-45D5-8C4C-F59713854639}\" -Value \"$env:userprofile\\Pictures\" -Type ExpandString
        Write-Host \"Restarting explorer\"
        taskkill.exe /F /IM \"explorer.exe\"
        Start-Process \"explorer.exe\"\r\n
        Write-Host \"Waiting for explorer to complete loading\"
        Write-Host \"Please Note - The OneDrive folder at $OneDrivePath may still have items in it. You must manually delete it, but all the files should already be copied to the base user folder.\"
        Write-Host \"If there are Files missing afterwards, please Login to Onedrive.com and Download them manually\" -ForegroundColor Yellow
        Start-Sleep 5
      } else {
        Write-Host \"Nothing to Cleanup with OneDrive\" -ForegroundColor Red
      }
      "
        ]
      },
      "WPFTweaksRazerBlock": {
        "InvokeScript": [
          "
          $RazerPath = \"C:\\Windows\\Installer\\Razer\"
          Remove-Item $RazerPath -Recurse -Force
          New-Item -Path \"C:\\Windows\\Installer\\\" -Name \"Razer\" -ItemType \"directory\"
          $Acl = Get-Acl $RazerPath
          $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule(\"NT AUTHORITY\\SYSTEM\",\"Write\",\"ContainerInherit,ObjectInherit\",\"None\",\"Deny\")
          $Acl.SetAccessRule($Ar)
          Set-Acl $RazerPath $Acl
      "
        ],
        "UndoScript": [
          "
          $RazerPath = \"C:\\Windows\\Installer\\Razer\"
          Remove-Item $RazerPath -Recurse -Force
          New-Item -Path \"C:\\Windows\\Installer\\\" -Name \"Razer\" -ItemType \"directory\"
      "
        ],
        "Order": "a031_",
        "Content": "Block Razer Software Installs",
        "Description": "Blocks ALL Razer Software installations. The hardware works fine without any software.",
        "link": "https://winutil.christitus.com/dev/tweaks/essential-tweaks/razerblock",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DriverSearching",
            "Name": "SearchOrderConfig",
            "Value": "0",
            "OriginalValue": "1",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Device Installer",
            "Name": "DisableCoInstallers",
            "Value": "1",
            "OriginalValue": "0",
            "Type": "DWord"
          }
        ]
      },
      "WPFOOSUbutton": {
        "Order": "a039_",
        "Content": "Run OO Shutup 10",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/oosubutton",
        "Type": "Button"
      },
      "WPFchangedns": {
        "Order": "a040_",
        "Content": "DNS",
        "link": "https://winutil.christitus.com/dev/tweaks/z--advanced-tweaks---caution/changedns",
        "ComboItems": "Default DHCP Google Cloudflare Cloudflare_Malware Cloudflare_Malware_Adult Open_DNS Quad9 AdGuard_Ads_Trackers AdGuard_Ads_Trackers_Malware_Adult dns0.eu_Open dns0.eu_ZERO dns0.eu_KIDS",
        "Type": "Combobox"
      }
    }
  },
  "2": {
    "Customize Preferences": {
      "WPFToggleDarkMode": {
        "InvokeScript": [
          "
      Invoke-WinUtilExplorerUpdate
      if ($sync.ThemeButton.Content -eq [char]0xF08C) {
        Invoke-WinutilThemeChange -theme \"Auto\"
      }
      "
        ],
        "Type": "Toggle",
        "UndoScript": [
          "
      Invoke-WinUtilExplorerUpdate
      if ($sync.ThemeButton.Content -eq [char]0xF08C) {
        Invoke-WinutilThemeChange -theme \"Auto\"
      }
      "
        ],
        "Order": "a100_",
        "Content": "Dark Theme for Windows",
        "Description": "Enable/Disable Dark Mode.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/darkmode",
        "registry": [
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
            "Name": "AppsUseLightTheme",
            "Value": "0",
            "OriginalValue": "1",
            "DefaultState": "false",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
            "Name": "SystemUsesLightTheme",
            "Value": "0",
            "OriginalValue": "1",
            "DefaultState": "false",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleBingSearch": {
        "Type": "Toggle",
        "Order": "a101_",
        "Content": "Bing Search in Start Menu",
        "Description": "If enable then includes web search results from Bing in your Start Menu search.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/bingsearch",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search",
            "Name": "BingSearchEnabled",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleNumLock": {
        "Type": "Toggle",
        "Order": "a102_",
        "Content": "NumLock on Startup",
        "Description": "Toggle the Num Lock key state when your computer starts.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/numlock",
        "registry": [
          {
            "Path": "HKU:\\.Default\\Control Panel\\Keyboard",
            "Name": "InitialKeyboardIndicators",
            "Value": "2",
            "OriginalValue": "0",
            "DefaultState": "false",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Control Panel\\Keyboard",
            "Name": "InitialKeyboardIndicators",
            "Value": "2",
            "OriginalValue": "0",
            "DefaultState": "false",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleVerboseLogon": {
        "Type": "Toggle",
        "Order": "a103_",
        "Content": "Verbose Messages During Logon",
        "Description": "Show detailed messages during the login process for troubleshooting and diagnostics.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/verboselogon",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
            "Name": "VerboseStatus",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "false",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleStartMenuRecommendations": {
        "Type": "Toggle",
        "Order": "a104_",
        "Content": "Recommendations in Start Menu",
        "Description": "If disabled then you will not see recommendations in the Start Menu. | Enables ''iseducationenvironment'' | Relogin Required. | WARNING: This will also disable Windows Spotlight on your Lock Screen as a side effect.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/wpftogglestartmenurecommendations",
        "registry": [
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\PolicyManager\\current\\device\\Start",
            "Name": "HideRecommendedSection",
            "Value": "0",
            "OriginalValue": "1",
            "DefaultState": "true",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Microsoft\\PolicyManager\\current\\device\\Education",
            "Name": "IsEducationEnvironment",
            "Value": "0",
            "OriginalValue": "1",
            "DefaultState": "true",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
            "Name": "HideRecommendedSection",
            "Value": "0",
            "OriginalValue": "1",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleHideSettingsHome": {
        "Order": "a105_",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
            "Name": "SettingsPageVisibility",
            "Type": "String",
            "Value": "hide:home",
            "OriginalValue": "show:home",
            "DefaultState": "false"
          }
        ],
        "Content": "Remove Settings Home Page",
        "Description": "Removes the Home page in the Windows Settings app.",
        "Type": "Toggle"
      },
      "WPFToggleSnapWindow": {
        "Type": "Toggle",
        "Order": "a106_",
        "Content": "Snap Window",
        "Description": "If enabled you can align windows by dragging them. | Relogin Required",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/snapwindow",
        "registry": [
          {
            "Path": "HKCU:\\Control Panel\\Desktop",
            "Name": "WindowArrangementActive",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "String"
          }
        ]
      },
      "WPFToggleSnapFlyout": {
        "InvokeScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Type": "Toggle",
        "UndoScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Order": "a107_",
        "Content": "Snap Assist Flyout",
        "Description": "If enabled then Snap preview is disabled when maximize button is hovered.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/snapflyout",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "EnableSnapAssistFlyout",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleSnapSuggestion": {
        "InvokeScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Type": "Toggle",
        "UndoScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Order": "a108_",
        "Content": "Snap Assist Suggestion",
        "Description": "If enabled then you will get suggestions to snap other applications in the left over spaces.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/snapsuggestion",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "SnapAssist",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleMouseAcceleration": {
        "Type": "Toggle",
        "Order": "a109_",
        "Content": "Mouse Acceleration",
        "Description": "If Enabled then Cursor movement is affected by the speed of your physical mouse movements.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/mouseacceleration",
        "registry": [
          {
            "Path": "HKCU:\\Control Panel\\Mouse",
            "Name": "MouseSpeed",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Control Panel\\Mouse",
            "Name": "MouseThreshold1",
            "Value": "6",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          },
          {
            "Path": "HKCU:\\Control Panel\\Mouse",
            "Name": "MouseThreshold2",
            "Value": "10",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleStickyKeys": {
        "Type": "Toggle",
        "Order": "a110_",
        "Content": "Sticky Keys",
        "Description": "If Enabled then Sticky Keys is activated - Sticky keys is an accessibility feature of some graphical user interfaces which assists users who have physical disabilities or help users reduce repetitive strain injury.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/stickykeys",
        "registry": [
          {
            "Path": "HKCU:\\Control Panel\\Accessibility\\StickyKeys",
            "Name": "Flags",
            "Value": "510",
            "OriginalValue": "58",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleHiddenFiles": {
        "InvokeScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Type": "Toggle",
        "UndoScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Order": "a200_",
        "Content": "Show Hidden Files",
        "Description": "If Enabled then Hidden Files will be shown.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/hiddenfiles",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "Hidden",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "false",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleShowExt": {
        "InvokeScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Type": "Toggle",
        "UndoScript": [
          "
      Invoke-WinUtilExplorerUpdate -action \"restart\"
      "
        ],
        "Order": "a201_",
        "Content": "Show File Extensions",
        "Description": "If enabled then File extensions (e.g., .txt, .jpg) are visible.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/showext",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "HideFileExt",
            "Value": "0",
            "OriginalValue": "1",
            "DefaultState": "false",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleTaskbarSearch": {
        "Type": "Toggle",
        "Order": "a202_",
        "Content": "Search Button in Taskbar",
        "Description": "If Enabled Search Button will be on the taskbar.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/taskbarsearch",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search",
            "Name": "SearchboxTaskbarMode",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleTaskView": {
        "Type": "Toggle",
        "Order": "a203_",
        "Content": "Task View Button in Taskbar",
        "Description": "If Enabled then Task View Button in Taskbar will be shown.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/taskview",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "ShowTaskViewButton",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleTaskbarWidgets": {
        "Type": "Toggle",
        "Order": "a204_",
        "Content": "Widgets Button in Taskbar",
        "Description": "If Enabled then Widgets Button in Taskbar will be shown.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/taskbarwidgets",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "TaskbarDa",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleTaskbarAlignment": {
        "Type": "Toggle",
        "Order": "a204_",
        "Content": "Center Taskbar Items",
        "Description": "[Windows 11] If Enabled then the Taskbar Items will be shown on the Center, otherwise the Taskbar Items will be shown on the Left.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/taskbaralignment",
        "registry": [
          {
            "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
            "Name": "TaskbarAl",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "true",
            "Type": "DWord"
          }
        ]
      },
      "WPFToggleDetailedBSoD": {
        "Type": "Toggle",
        "Order": "a205_",
        "Content": "Detailed BSoD",
        "Description": "If Enabled then you will see a detailed Blue Screen of Death (BSOD) with more information.",
        "link": "https://winutil.christitus.com/dev/tweaks/customize-preferences/detailedbsod",
        "registry": [
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\CrashControl",
            "Name": "DisplayParameters",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "false",
            "Type": "DWord"
          },
          {
            "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\CrashControl",
            "Name": "DisableEmoticon",
            "Value": "1",
            "OriginalValue": "0",
            "DefaultState": "false",
            "Type": "DWord"
          }
        ]
      }
    },
    "Performance Plans": {
      "WPFAddUltPerf": {
        "Order": "a080_",
        "Content": "Add and Activate Ultimate Performance Profile",
        "link": "https://winutil.christitus.com/dev/tweaks/performance-plans/addultperf",
        "ButtonWidth": "300",
        "Type": "Button"
      },
      "WPFRemoveUltPerf": {
        "Order": "a081_",
        "Content": "Remove Ultimate Performance Profile",
        "link": "https://winutil.christitus.com/dev/tweaks/performance-plans/removeultperf",
        "ButtonWidth": "300",
        "Type": "Button"
      }
    }
  }
}

'
$global:PresetsConfig = '{
  "Standard": [
    "WPFTweaksAH",
    "WPFTweaksConsumerFeatures",
    "WPFTweaksDisableExplorerAutoDiscovery",
    "WPFTweaksDVR",
    "WPFTweaksHiber",
    "WPFTweaksHome",
    "WPFTweaksLoc",
    "WPFTweaksServices",
    "WPFTweaksStorage",
    "WPFTweaksTele",
    "WPFTweaksWifi",
    "WPFTweaksDiskCleanup",
    "WPFTweaksDeleteTempFiles",
    "WPFTweaksEndTaskOnTaskbar",
    "WPFTweaksRestorePoint",
    "WPFTweaksPowershell7Tele"
  ],
  "Minimal": [
    "WPFTweaksConsumerFeatures",
    "WPFTweaksDisableExplorerAutoDiscovery",
    "WPFTweaksHome",
    "WPFTweaksServices",
    "WPFTweaksTele"
  ]
}
'

$global:MainWindowXAML = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="WinUtil - Windows Utility Tool" 
        Height="900" 
        Width="1400"
        MinHeight="700"
        MinWidth="1000"
        WindowStartupLocation="CenterScreen"
        Background="#FF1A1A1A"
        WindowStyle="None"
        AllowsTransparency="True"
        ResizeMode="CanResize">
    
    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="Resources.xaml"/>
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>
    
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="70"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        
        <!-- Custom Title Bar with Navigation -->
        <Border Grid.Row="0" Background="#FF2D2D30" BorderBrush="#FF3F3F46" BorderThickness="0,0,0,1">
            <Grid Margin="20,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                
                <!-- WinUtil Title (Draggable Area) -->
                <TextBlock Name="titleBar" Grid.Column="0" Text="WinUtil" FontSize="28" FontWeight="Bold" Foreground="#FF0078D4" VerticalAlignment="Center" Margin="0,0,40,0" Cursor="Hand"/>
                
                <!-- Navigation Tabs -->
                <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center" HorizontalAlignment="Left">
                    <Button Name="btnApplicationsTab" Content="Applications" Style="{StaticResource TabButton}" Tag="0" Margin="0,0,8,0"/>
                    <Button Name="btnTweaksTab" Content="Tweaks" Style="{StaticResource TabButton}" Tag="1"/>
                </StackPanel>
                
                <!-- Draggable spacer area -->
                <Rectangle Grid.Column="2" Fill="Transparent" Name="dragArea" Cursor="SizeAll"/>
                
                <!-- Search Box -->
                <TextBox Name="txtSearch" Grid.Column="3"
                         Style="{StaticResource SearchTextBox}"
                         Width="280"
                         Height="36"
                         VerticalAlignment="Center"
                         Margin="20,0,20,0"/>
                
                <!-- Window Controls -->
                <StackPanel Grid.Column="4" Orientation="Horizontal" VerticalAlignment="Center">
                    <Button Name="btnMinimize" Content="&#xE921;" Style="{StaticResource WindowControlButton}" Width="46" Height="32" FontFamily="Segoe MDL2 Assets" FontSize="10"/>
                    <Button Name="btnMaximize" Content="&#xE922;" Style="{StaticResource WindowControlButton}" Width="46" Height="32" FontFamily="Segoe MDL2 Assets" FontSize="10"/>
                    <Button Name="btnClose" Content="&#xE8BB;" Style="{StaticResource WindowControlCloseButton}" Width="46" Height="32" FontFamily="Segoe MDL2 Assets" FontSize="10"/>
                </StackPanel>
            </Grid>
        </Border>
        
        <!-- Main Content Area -->
        <Grid Grid.Row="1" Margin="30">
            <!-- Applications Content -->
            <Grid Name="ApplicationsContent" Visibility="Visible">
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
                
                <!-- Applications Tree -->
                <TreeView Name="trvApplications" Grid.Row="0" Style="{StaticResource ModernTreeView}" Background="Transparent" BorderThickness="0" Margin="0,0,0,20">
                    <!-- TreeView items will be populated via code-behind -->
                </TreeView>
                
                <!-- Application Actions -->
                <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Center">
                    <Button Name="btnInstallApps" Content="Install Selected Applications" Style="{StaticResource ModernButton}" Margin="0,0,15,0" Padding="30,15"/>
                    <Button Name="btnUninstallApps" Content="Uninstall Selected Applications" Style="{StaticResource ModernButton}" Background="#FFD13438" Padding="30,15"/>
                </StackPanel>
            </Grid>
            
            <!-- Tweaks Content -->
            <Grid Name="TweaksContent" Visibility="Collapsed">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                
                <!-- Preset Buttons -->
                <Grid Grid.Row="0" Margin="0,0,0,20">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    
                    <TextBlock Grid.Row="0" Text="Quick Presets" Style="{StaticResource SubHeaderText}" Margin="0,0,0,12"/>
                    <StackPanel Grid.Row="1" Orientation="Horizontal">
                        <Button Name="btnPresetStandard" Content="Standard Setup" Style="{StaticResource ModernButton}" Width="150" Margin="0,0,12,0"/>
                        <Button Name="btnPresetMinimal" Content="Minimal Setup" Style="{StaticResource ModernButton}" Width="150" Margin="0,0,12,0"/>
                        <Button Name="btnClearSelection" Content="Clear All" Style="{StaticResource ModernButton}" Width="120" Background="#FF444444"/>
                    </StackPanel>
                </Grid>
                
                <!-- Main Content Area with Floating Button Bar -->
                <Grid Grid.Row="1">
                    <!-- Tweaks Panels Container -->
                    <ScrollViewer Name="svTweaksPanels" HorizontalScrollBarVisibility="Auto" VerticalScrollBarVisibility="Disabled" Margin="0,0,0,35">
                        <Grid Name="grdTweaksPanels">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            
                            <!-- Panel 1 -->
                            <Border Name="Panel1" Grid.Column="0" Style="{StaticResource TweakPanel}" Margin="0,0,5,0" HorizontalAlignment="Stretch">
                                <TreeView Name="trvTweaksPanel1" Style="{StaticResource ModernTreeView}" Background="Transparent" BorderThickness="0"/>
                            </Border>
                            
                            <!-- Panel 2 -->
                            <Border Name="Panel2" Grid.Column="1" Style="{StaticResource TweakPanel}" Margin="5,0,0,0" HorizontalAlignment="Stretch">
                                <TreeView Name="trvTweaksPanel2" Style="{StaticResource ModernTreeView}" Background="Transparent" BorderThickness="0"/>
                            </Border>
                        </Grid>
                    </ScrollViewer>
                    
                    <!-- Floating Action Bar -->
                    <Border VerticalAlignment="Bottom" HorizontalAlignment="Stretch" 
                            Background="#FF1A1A1A" BorderBrush="#FF3F3F46" BorderThickness="0,1,0,0"
                            Padding="20,6" Margin="0,0,0,0">
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                            <Button Name="btnApplyTweaks" Content="Apply Selected Tweaks" Style="{StaticResource ModernButton}" Margin="0,0,10,0" Padding="20,6"/>
                            <Button Name="btnUndoTweaks" Content="Undo Selected Tweaks" Style="{StaticResource ModernButton}" Background="#FFFF8C00" Padding="20,6"/>
                        </StackPanel>
                    </Border>
                </Grid>
            </Grid>
        </Grid>
    </Grid>
</Window> 
'@

$global:ResourcesXAML = @'
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
    
    <!-- Define styles for consistency -->
    <Style x:Key="ModernButton" TargetType="Button">
        <Setter Property="Background" Value="#FF0078D4"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="Padding" Value="12,6"/>
        <Setter Property="Margin" Value="5,2"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="FontWeight" Value="SemiBold"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Style.Triggers>
            <Trigger Property="IsMouseOver" Value="True">
                <Setter Property="Background" Value="#FF106EBE"/>
            </Trigger>
            <Trigger Property="IsPressed" Value="True">
                <Setter Property="Background" Value="#FF005A9E"/>
            </Trigger>
        </Style.Triggers>
    </Style>
    
    <Style x:Key="TabButton" TargetType="Button">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Foreground" Value="#FFAAAAAA"/>
        <Setter Property="Padding" Value="24,14"/>
        <Setter Property="FontWeight" Value="Medium"/>
        <Setter Property="FontSize" Value="14"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="MinWidth" Value="120"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Name="MainBorder" 
                            Background="{TemplateBinding Background}" 
                            BorderThickness="0" 
                            CornerRadius="6,6,0,0"
                            Margin="0,0,4,0">
                        <Grid>
                            <ContentPresenter x:Name="ContentSite" 
                                            VerticalAlignment="Center" 
                                            HorizontalAlignment="Center" 
                                            ContentSource="Content" 
                                            Margin="{TemplateBinding Padding}"/>
                            
                            <!-- Active indicator line -->
                            <Rectangle Name="ActiveLine"
                                     Height="2"
                                     VerticalAlignment="Bottom"
                                     Fill="#FF0078D4"
                                     Opacity="0"
                                     Margin="8,0,8,0"/>
                        </Grid>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter TargetName="MainBorder" Property="Background" Value="#FF333333"/>
                            <Setter Property="Foreground" Value="White"/>
                        </Trigger>
                        <Trigger Property="IsPressed" Value="True">
                            <Setter TargetName="MainBorder" Property="Background" Value="#FF404040"/>
                            <Setter Property="Foreground" Value="White"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <Style x:Key="ModernListBox" TargetType="ListBox">
        <Setter Property="Background" Value="#FF2D2D30"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="BorderBrush" Value="#FF3F3F46"/>
        <Setter Property="SelectionMode" Value="Multiple"/>
    </Style>
    
    <Style x:Key="ModernTextBox" TargetType="TextBox">
        <Setter Property="Background" Value="#FF2D2D30"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="BorderBrush" Value="#FF3F3F46"/>
        <Setter Property="Padding" Value="8,4"/>
        <Setter Property="FontFamily" Value="Consolas"/>
        <Setter Property="IsReadOnly" Value="True"/>
        <Setter Property="VerticalScrollBarVisibility" Value="Auto"/>
        <Setter Property="HorizontalScrollBarVisibility" Value="Auto"/>
    </Style>
    
    <Style x:Key="SearchTextBox" TargetType="TextBox">
        <Setter Property="Background" Value="#FF1E1E1E"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="BorderBrush" Value="#FF404040"/>
        <Setter Property="Padding" Value="12,0"/>
        <Setter Property="FontSize" Value="14"/>
        <Setter Property="FontWeight" Value="Normal"/>
        <Setter Property="CaretBrush" Value="#FF0078D4"/>
        <Setter Property="SelectionBrush" Value="#FF0078D4"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="TextBox">
                    <Grid>
                        <Border Name="BorderElement"
                                Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                CornerRadius="4">
                            <Grid Margin="{TemplateBinding Padding}">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="Auto"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                
                                <!-- Search Icon -->
                                <TextBlock Grid.Column="0" 
                                          Text="&#xE721;" 
                                          FontFamily="Segoe MDL2 Assets"
                                          Foreground="#FF666666" 
                                          VerticalAlignment="Center"
                                          Margin="0,0,8,0"
                                          FontSize="14"/>
                                
                                <!-- Content and Placeholder -->
                                <Grid Grid.Column="1">
                                    <ScrollViewer x:Name="PART_ContentHost" 
                                                  VerticalAlignment="Center"
                                                  Background="Transparent"
                                                  Focusable="False"/>
                                    
                                    <TextBlock Name="PlaceholderText"
                                               Text="Search..."
                                               Foreground="#FF666666" 
                                               VerticalAlignment="Center"
                                               IsHitTestVisible="False"
                                               Visibility="Collapsed"/>
                                </Grid>
                            </Grid>
                        </Border>
                    </Grid>
                    <ControlTemplate.Triggers>
                        <Trigger Property="Text" Value="">
                            <Setter TargetName="PlaceholderText" Property="Visibility" Value="Visible"/>
                        </Trigger>
                        <Trigger Property="Text" Value="{x:Null}">
                            <Setter TargetName="PlaceholderText" Property="Visibility" Value="Visible"/>
                        </Trigger>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter TargetName="BorderElement" Property="BorderBrush" Value="#FF606060"/>
                        </Trigger>
                        <Trigger Property="IsFocused" Value="True">
                            <Setter TargetName="BorderElement" Property="BorderBrush" Value="#FF0078D4"/>
                            <Setter TargetName="BorderElement" Property="Background" Value="#FF252525"/>
                        </Trigger>
                        <Trigger Property="IsEnabled" Value="False">
                            <Setter TargetName="BorderElement" Property="Background" Value="#FF2D2D30"/>
                            <Setter Property="Foreground" Value="#FF666666"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <Style x:Key="ModernComboBox" TargetType="ComboBox">
        <Setter Property="Background" Value="#FF2D2D30"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="BorderBrush" Value="#FF3F3F46"/>
        <Setter Property="Padding" Value="8,4"/>
    </Style>
    
    <Style x:Key="ModernGroupBox" TargetType="GroupBox">
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderBrush" Value="#FF3F3F46"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="Padding" Value="10"/>
    </Style>
    
    <Style x:Key="ModernTreeView" TargetType="TreeView">
        <Setter Property="Background" Value="#FF2D2D30"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="BorderBrush" Value="#FF3F3F46"/>
    </Style>
    
    <!-- Window Control Button Styles -->
    <Style x:Key="WindowControlButton" TargetType="Button">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="FontFamily" Value="Segoe MDL2 Assets"/>
        <Setter Property="FontSize" Value="10"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Background="{TemplateBinding Background}" 
                            BorderThickness="{TemplateBinding BorderThickness}"
                            BorderBrush="{TemplateBinding BorderBrush}">
                        <ContentPresenter HorizontalAlignment="Center" 
                                        VerticalAlignment="Center"
                                        Margin="{TemplateBinding Padding}"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter Property="Background" Value="#FF404040"/>
                        </Trigger>
                        <Trigger Property="IsPressed" Value="True">
                            <Setter Property="Background" Value="#FF505050"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <Style x:Key="WindowControlCloseButton" TargetType="Button">
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="FontFamily" Value="Segoe MDL2 Assets"/>
        <Setter Property="FontSize" Value="10"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Background="{TemplateBinding Background}" 
                            BorderThickness="{TemplateBinding BorderThickness}"
                            BorderBrush="{TemplateBinding BorderBrush}">
                        <ContentPresenter HorizontalAlignment="Center" 
                                        VerticalAlignment="Center"
                                        Margin="{TemplateBinding Padding}"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter Property="Background" Value="#FFE81123"/>
                        </Trigger>
                        <Trigger Property="IsPressed" Value="True">
                            <Setter Property="Background" Value="#FFF1707A"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <!-- Tweak Panel Border Style -->
    <Style x:Key="TweakPanel" TargetType="Border">
        <Setter Property="Background" Value="#FF2D2D30"/>
        <Setter Property="BorderBrush" Value="#FF3F3F46"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="CornerRadius" Value="6"/>
        <Setter Property="Padding" Value="15"/>
        <Setter Property="HorizontalAlignment" Value="Stretch"/>
    </Style>
    
    <!-- TreeViewItem style for category headers -->
    <Style TargetType="TreeViewItem">
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="FontSize" Value="14"/>
        <Setter Property="FontWeight" Value="SemiBold"/>
        <Setter Property="Margin" Value="0,4,0,2"/>
        <Setter Property="Padding" Value="4,3"/>
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="TreeViewItem">
                    <Grid>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>
                        
                        <!-- Header with expand/collapse toggle -->
                        <Border Grid.Row="0" 
                                Name="HeaderBorder"
                                Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                Padding="{TemplateBinding Padding}"
                                CornerRadius="4">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="Auto"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                
                                <!-- Expander Toggle -->
                                <ToggleButton Grid.Column="0"
                                            Name="Expander"
                                            IsChecked="{Binding IsExpanded, RelativeSource={RelativeSource TemplatedParent}}"
                                            ClickMode="Press"
                                            Background="Transparent"
                                            BorderThickness="0"
                                            Padding="4"
                                            Margin="0,0,8,0"
                                            VerticalAlignment="Center">
                                    <ToggleButton.Template>
                                        <ControlTemplate TargetType="ToggleButton">
                                            <Border Background="{TemplateBinding Background}" 
                                                    BorderThickness="{TemplateBinding BorderThickness}"
                                                    Padding="{TemplateBinding Padding}">
                                                <TextBlock Name="ExpanderSymbol" 
                                                          Text="&#xE76C;" 
                                                          FontFamily="Segoe MDL2 Assets"
                                                          Foreground="#FF0078D4" 
                                                          FontSize="12"
                                                          FontWeight="Bold"
                                                          HorizontalAlignment="Center"
                                                          VerticalAlignment="Center"
                                                          RenderTransformOrigin="0.5,0.5">
                                                    <TextBlock.RenderTransform>
                                                        <RotateTransform Angle="0"/>
                                                    </TextBlock.RenderTransform>
                                                </TextBlock>
                                            </Border>
                                            <ControlTemplate.Triggers>
                                                <Trigger Property="IsChecked" Value="True">
                                                    <Setter TargetName="ExpanderSymbol" Property="RenderTransform">
                                                        <Setter.Value>
                                                            <RotateTransform Angle="90"/>
                                                        </Setter.Value>
                                                    </Setter>
                                                </Trigger>
                                                <Trigger Property="IsMouseOver" Value="True">
                                                    <Setter TargetName="ExpanderSymbol" Property="Foreground" Value="#FF106EBE"/>
                                                </Trigger>
                                            </ControlTemplate.Triggers>
                                        </ControlTemplate>
                                    </ToggleButton.Template>
                                </ToggleButton>
                                
                                <!-- Category Header Text -->
                                <ContentPresenter Grid.Column="1"
                                                Name="PART_Header"
                                                ContentSource="Header"
                                                VerticalAlignment="Center"
                                                TextBlock.Foreground="{TemplateBinding Foreground}"
                                                TextBlock.FontSize="{TemplateBinding FontSize}"
                                                TextBlock.FontWeight="{TemplateBinding FontWeight}"/>
                            </Grid>
                        </Border>
                        
                        <!-- Children Container -->
                        <ItemsPresenter Grid.Row="1" 
                                       Name="ItemsHost"
                                       Margin="16,1,0,0"/>
                    </Grid>
                    
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsExpanded" Value="False">
                            <Setter TargetName="ItemsHost" Property="Visibility" Value="Collapsed"/>
                        </Trigger>
                        <Trigger Property="HasItems" Value="False">
                            <Setter TargetName="Expander" Property="Visibility" Value="Hidden"/>
                        </Trigger>
                        <!-- Only trigger hover on the header border, not when hovering child items -->
                        <Trigger SourceName="HeaderBorder" Property="IsMouseOver" Value="True">
                            <Setter TargetName="HeaderBorder" Property="Background" Value="#FF3A3A3A"/>
                        </Trigger>
                        <Trigger Property="IsSelected" Value="True">
                            <Setter Property="Background" Value="#FF404040"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <!-- TreeViewItem style for checkbox items (applications/tweaks) -->
    <Style x:Key="CheckboxTreeViewItem" TargetType="TreeViewItem">
        <Setter Property="Focusable" Value="False"/>
        <Setter Property="IsTabStop" Value="False"/>
        <Setter Property="Background" Value="Transparent"/>
        <Setter Property="Margin" Value="0"/>
        <Setter Property="Padding" Value="0"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="TreeViewItem">
                    <!-- Just show the header content directly without any TreeViewItem chrome -->
                    <ContentPresenter ContentSource="Header" 
                                    Margin="0"
                                    HorizontalAlignment="Left"
                                    VerticalAlignment="Center"/>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <!-- Toggle Switch Style (styled like a modern toggle) -->
    <Style x:Key="ToggleSwitch" TargetType="CheckBox">
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="FontSize" Value="13"/>
        <Setter Property="Margin" Value="0,1,0,1"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="CheckBox">
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="Auto"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        
                        <!-- Toggle Switch -->
                        <Border Grid.Column="0" 
                                Name="ToggleTrack"
                                Width="36" 
                                Height="20" 
                                Background="#FF404040" 
                                CornerRadius="10" 
                                Margin="0,0,10,0"
                                VerticalAlignment="Center">
                            <Border Name="ToggleThumb" 
                                    Width="14" 
                                    Height="14" 
                                    Background="White" 
                                    CornerRadius="7" 
                                    HorizontalAlignment="Left"
                                    Margin="3,0,0,0">
                                <Border.RenderTransform>
                                    <TranslateTransform X="0"/>
                                </Border.RenderTransform>
                            </Border>
                        </Border>
                        
                        <!-- Content Text -->
                        <ContentPresenter Grid.Column="1" 
                                        VerticalAlignment="Center"
                                        Content="{TemplateBinding Content}"
                                        TextBlock.Foreground="{TemplateBinding Foreground}"
                                        TextBlock.FontSize="{TemplateBinding FontSize}"/>
                    </Grid>
                    
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsChecked" Value="True">
                            <Setter TargetName="ToggleTrack" Property="Background" Value="#FF0078D4"/>
                            <Setter TargetName="ToggleThumb" Property="RenderTransform">
                                <Setter.Value>
                                    <TranslateTransform X="16"/>
                                </Setter.Value>
                            </Setter>
                        </Trigger>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter TargetName="ToggleTrack" Property="Opacity" Value="0.8"/>
                        </Trigger>
                        <Trigger Property="IsPressed" Value="True">
                            <Setter TargetName="ToggleThumb" Property="Width" Value="22"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <!-- Tweak Button Style -->
    <Style x:Key="TweakButton" TargetType="Button">
        <Setter Property="Background" Value="#FF0078D4"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="Padding" Value="16,8"/>
        <Setter Property="Margin" Value="0,4,0,4"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="FontSize" Value="14"/>
        <Setter Property="FontWeight" Value="Medium"/>
        <Setter Property="Cursor" Value="Hand"/>
        <Setter Property="HorizontalAlignment" Value="Left"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Background="{TemplateBinding Background}" 
                            BorderBrush="{TemplateBinding BorderBrush}" 
                            BorderThickness="{TemplateBinding BorderThickness}" 
                            CornerRadius="4"
                            Padding="{TemplateBinding Padding}">
                        <ContentPresenter HorizontalAlignment="Center" 
                                        VerticalAlignment="Center"
                                        Content="{TemplateBinding Content}"
                                        TextBlock.Foreground="{TemplateBinding Foreground}"
                                        TextBlock.FontSize="{TemplateBinding FontSize}"
                                        TextBlock.FontWeight="{TemplateBinding FontWeight}"/>
                    </Border>
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter Property="Background" Value="#FF106EBE"/>
                        </Trigger>
                        <Trigger Property="IsPressed" Value="True">
                            <Setter Property="Background" Value="#FF005A9E"/>
                        </Trigger>
                        <Trigger Property="IsEnabled" Value="False">
                            <Setter Property="Background" Value="#FF666666"/>
                            <Setter Property="Foreground" Value="#FFAAAAAA"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
    
    <!-- Tweak ComboBox Style -->
    <Style x:Key="TweakComboBox" TargetType="ComboBox">
        <Setter Property="Background" Value="#FF2D2D30"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="BorderThickness" Value="1"/>
        <Setter Property="BorderBrush" Value="#FF404040"/>
        <Setter Property="Padding" Value="12,8"/>
        <Setter Property="Margin" Value="0,4,0,4"/>
        <Setter Property="FontSize" Value="14"/>
        <Setter Property="MinWidth" Value="200"/>
        <Setter Property="HorizontalAlignment" Value="Left"/>
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="ComboBox">
                    <Grid>
                        <Border Name="MainBorder"
                                Background="{TemplateBinding Background}" 
                                BorderBrush="{TemplateBinding BorderBrush}" 
                                BorderThickness="{TemplateBinding BorderThickness}" 
                                CornerRadius="4">
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>
                                
                                <ContentPresenter Grid.Column="0"
                                                Name="ContentSite"
                                                IsHitTestVisible="False"
                                                Content="{TemplateBinding SelectionBoxItem}"
                                                ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"
                                                Margin="{TemplateBinding Padding}"
                                                VerticalAlignment="Center"
                                                HorizontalAlignment="Left"/>
                                
                                <ToggleButton Grid.Column="1"
                                            Name="ToggleButton"
                                            Background="Transparent"
                                            BorderThickness="0"
                                            IsChecked="{Binding Path=IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}"
                                            ClickMode="Press"
                                            Focusable="False"
                                            Width="30">
                                    <Path Data="M 0 0 L 4 4 L 8 0 Z" 
                                          Fill="#FF666666" 
                                          HorizontalAlignment="Center" 
                                          VerticalAlignment="Center"/>
                                </ToggleButton>
                            </Grid>
                        </Border>
                        
                        <Popup Name="Popup"
                               Placement="Bottom"
                               IsOpen="{TemplateBinding IsDropDownOpen}"
                               AllowsTransparency="True"
                               Focusable="False"
                               PopupAnimation="Slide">
                            <Border Name="DropDownBorder"
                                    Background="#FF2D2D30"
                                    BorderBrush="#FF404040"
                                    BorderThickness="1"
                                    CornerRadius="4"
                                    MaxHeight="{TemplateBinding MaxDropDownHeight}"
                                    MinWidth="{Binding ActualWidth, RelativeSource={RelativeSource TemplatedParent}}">
                                <ScrollViewer>
                                    <ItemsPresenter KeyboardNavigation.DirectionalNavigation="Contained"/>
                                </ScrollViewer>
                            </Border>
                        </Popup>
                    </Grid>
                    
                    <ControlTemplate.Triggers>
                        <Trigger Property="IsMouseOver" Value="True">
                            <Setter TargetName="MainBorder" Property="BorderBrush" Value="#FF606060"/>
                        </Trigger>
                        <Trigger Property="IsFocused" Value="True">
                            <Setter TargetName="MainBorder" Property="BorderBrush" Value="#FF0078D4"/>
                        </Trigger>
                    </ControlTemplate.Triggers>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
        <Setter Property="ItemContainerStyle">
            <Setter.Value>
                <Style TargetType="ComboBoxItem">
                    <Setter Property="Background" Value="Transparent"/>
                    <Setter Property="Foreground" Value="White"/>
                    <Setter Property="Padding" Value="12,6"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="ComboBoxItem">
                                <Border Background="{TemplateBinding Background}" 
                                        Padding="{TemplateBinding Padding}">
                                    <ContentPresenter/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsHighlighted" Value="True">
                                        <Setter Property="Background" Value="#FF0078D4"/>
                                    </Trigger>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter Property="Background" Value="#FF106EBE"/>
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </Setter.Value>
        </Setter>
    </Style>
    
    <Style x:Key="HeaderText" TargetType="TextBlock">
        <Setter Property="FontSize" Value="18"/>
        <Setter Property="FontWeight" Value="Bold"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="Margin" Value="0,0,0,20"/>
    </Style>
    
    <Style x:Key="SubHeaderText" TargetType="TextBlock">
        <Setter Property="FontSize" Value="14"/>
        <Setter Property="FontWeight" Value="SemiBold"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="Margin" Value="0,0,0,10"/>
    </Style>
    
    <Style x:Key="DescriptionText" TargetType="TextBlock">
        <Setter Property="Foreground" Value="#FFB0B0B0"/>
        <Setter Property="TextWrapping" Value="Wrap"/>
        <Setter Property="Margin" Value="0,0,0,10"/>
    </Style>

</ResourceDictionary> 
'@

# ========================================
# EMBEDDED FUNCTIONS
# ========================================

# ----------------------------------------
# MODULE: Logger\Core.ps1
# ----------------------------------------
function Write-Log {
    <#
    .SYNOPSIS
    Writes log messages to console and optionally to UI
    
    .PARAMETER Message
    The message to log
    
    .PARAMETER Level
    Log level: INFO, WARN, ERROR, DEBUG
    
    .PARAMETER UITextBox
    Optional UI TextBox to update with log messages
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('INFO', 'WARN', 'ERROR', 'DEBUG')]
        [string]$Level = 'INFO',
        
        [Parameter(Mandatory=$false)]
        $UITextBox = $null
    )
    
    # Check if we should log this level
    $currentLogLevel = if ($global:WinUtilLogLevel) { $global:WinUtilLogLevel } else { 'INFO' }
    $levelPriority = @{
        'ERROR' = 1
        'WARN' = 2
        'INFO' = 3
        'DEBUG' = 4
    }
    
    # Skip if current level is below the configured level
    if ($levelPriority[$Level] -gt $levelPriority[$currentLogLevel]) {
        return
    }
    
    # Create timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Format the log message
    $logMessage = "[$timestamp] [$Level] $Message"
    
    # Write to console with appropriate color
    switch ($Level) {
        'INFO' { 
            Write-Host $logMessage -ForegroundColor Green 
        }
        'WARN' { 
            Write-Host $logMessage -ForegroundColor Yellow 
        }
        'ERROR' { 
            Write-Host $logMessage -ForegroundColor Red 
        }
        'DEBUG' { 
            Write-Host $logMessage -ForegroundColor Cyan 
        }
        default { 
            Write-Host $logMessage 
        }
    }
    
    # Update UI if TextBox is provided
    if ($UITextBox) {
        try {
            # Ensure we're on the UI thread
            $UITextBox.Dispatcher.Invoke([Action]{
                # Append to existing text
                if ($UITextBox.Text) {
                    $UITextBox.Text += "`r`n"
                }
                $UITextBox.Text += $logMessage
                
                # Auto-scroll to bottom
                $UITextBox.ScrollToEnd()
                
                # Limit text length to prevent memory issues (keep last 10000 characters)
                if ($UITextBox.Text.Length -gt 10000) {
                    $UITextBox.Text = $UITextBox.Text.Substring($UITextBox.Text.Length - 8000)
                }
            })
        }
        catch {
            Write-Host "Failed to update UI TextBox: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Also write to debug stream for advanced logging scenarios
    Write-Debug $logMessage
}

function Initialize-Logging {
    <#
    .SYNOPSIS
    Initializes logging with optional file output
    
    .PARAMETER LogFile
    Optional path to log file
    
    .PARAMETER LogLevel
    Minimum log level to capture
    #>
    param(
        [Parameter(Mandatory=$false)]
        [string]$LogFile = $null,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('INFO', 'WARN', 'ERROR', 'DEBUG')]
        [string]$LogLevel = 'INFO'
    )
    
    # Set global logging variables
    $global:WinUtilLogFile = $LogFile
    $global:WinUtilLogLevel = $LogLevel
    
    # Create log file if specified
    if ($LogFile) {
        try {
            $logDir = Split-Path $LogFile -Parent
            if ($logDir -and -not (Test-Path $logDir)) {
                New-Item -ItemType Directory -Path $logDir -Force | Out-Null
            }
            
            # Create or clear the log file
            "WinUtil Log Session Started: $(Get-Date)" | Out-File -FilePath $LogFile -Encoding UTF8
            Write-Log "Logging initialized. Log file: $LogFile" -Level "INFO"
        }
        catch {
            Write-Log "Failed to initialize log file '$LogFile': $($_.Exception.Message)" -Level "ERROR"
        }
    }
}

# Functions exported: Write-Log, Initialize-Logging 

# ----------------------------------------
# MODULE: Process\Tracker.ps1
# ----------------------------------------
function Initialize-RunspaceTracker {
    <#
    .SYNOPSIS
    Initializes the global runspace tracker
    #>
    
    if (-not $global:WinUtilRunspaceTracker) {
        $global:WinUtilRunspaceTracker = [System.Collections.Concurrent.ConcurrentDictionary[string, hashtable]]::new()
        Write-Log "Runspace tracker initialized" -Level "DEBUG"
    }
}

function Add-RunspaceToTracker {
    <#
    .SYNOPSIS
    Adds a runspace to the global tracker
    
    .PARAMETER RunspaceInfo
    The runspace info hashtable to track
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$RunspaceInfo
    )
    
    try {
        Initialize-RunspaceTracker
        
        $global:WinUtilRunspaceTracker.TryAdd($RunspaceInfo.Name, $RunspaceInfo) | Out-Null
        Write-Log "Added runspace to tracker: $($RunspaceInfo.Name)" -Level "DEBUG"
    }
    catch {
        Write-Log "Failed to add runspace to tracker: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Remove-RunspaceFromTracker {
    <#
    .SYNOPSIS
    Removes a runspace from the global tracker
    
    .PARAMETER Name
    Name of the runspace to remove
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    
    try {
        if ($global:WinUtilRunspaceTracker) {
            $removed = $global:WinUtilRunspaceTracker.TryRemove($Name, [ref]$null)
            if ($removed) {
                Write-Log "Removed runspace from tracker: $Name" -Level "DEBUG"
            }
        }
    }
    catch {
        Write-Log "Failed to remove runspace from tracker: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Get-ActiveRunspaces {
    <#
    .SYNOPSIS
    Gets all currently active runspaces
    
    .PARAMETER FilterByStatus
    Optional status filter (Running, Completed, etc.)
    #>
    param(
        [Parameter(Mandatory=$false)]
        [string]$FilterByStatus = $null
    )
    
    try {
        Initialize-RunspaceTracker
        
        $runspaces = @()
        foreach ($entry in $global:WinUtilRunspaceTracker.GetEnumerator()) {
            $runspaceInfo = $entry.Value
            
            # Update status if runspace is complete
            if ($runspaceInfo.Status -eq "Running" -and $runspaceInfo.AsyncResult.IsCompleted) {
                $runspaceInfo.Status = "Completed"
                $runspaceInfo.EndTime = Get-Date
                $runspaceInfo.Duration = $runspaceInfo.EndTime - $runspaceInfo.StartTime
            }
            
            # Apply filter if specified
            if (-not $FilterByStatus -or $runspaceInfo.Status -eq $FilterByStatus) {
                $runspaces += $runspaceInfo
            }
        }
        
        return $runspaces
    }
    catch {
        Write-Log "Failed to get active runspaces: $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Wait-AllRunspaces {
    <#
    .SYNOPSIS
    Waits for all tracked runspaces to complete
    
    .PARAMETER TimeoutSeconds
    Maximum time to wait in seconds (default: 300)
    #>
    param(
        [Parameter(Mandatory=$false)]
        [int]$TimeoutSeconds = 300
    )
    
    try {
        Write-Log "Waiting for all runspaces to complete (timeout: $TimeoutSeconds seconds)" -Level "DEBUG"
        
        $startTime = Get-Date
        $runningRunspaces = Get-ActiveRunspaces -FilterByStatus "Running"
        
        while ($runningRunspaces.Count -gt 0 -and ((Get-Date) - $startTime).TotalSeconds -lt $TimeoutSeconds) {
            Write-Log "Waiting for $($runningRunspaces.Count) runspaces to complete..." -Level "DEBUG"
            Start-Sleep -Seconds 2
            $runningRunspaces = Get-ActiveRunspaces -FilterByStatus "Running"
        }
        
        if ($runningRunspaces.Count -eq 0) {
            Write-Log "All runspaces completed successfully" -Level "DEBUG"
            return $true
        } else {
            Write-Log "Timeout reached. $($runningRunspaces.Count) runspaces still running" -Level "WARN"
            return $false
        }
    }
    catch {
        Write-Log "Error waiting for runspaces: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

function Stop-AllRunspaces {
    <#
    .SYNOPSIS
    Stops all running runspaces and cleans up the tracker
    #>
    
    try {
        Write-Log "Stopping all runspaces..." -Level "DEBUG"
        
        $runspaces = Get-ActiveRunspaces
        foreach ($runspaceInfo in $runspaces) {
            try {
                if ($runspaceInfo.Status -eq "Running") {
                    Write-Log "Stopping runspace: $($runspaceInfo.Name)" -Level "DEBUG"
                    $runspaceInfo.Runspace.Stop()
                }
                $runspaceInfo.Runspace.Dispose()
            }
            catch {
                Write-Log "Error stopping runspace '$($runspaceInfo.Name)': $($_.Exception.Message)" -Level "ERROR"
            }
        }
        
        # Clear the tracker
        if ($global:WinUtilRunspaceTracker) {
            $global:WinUtilRunspaceTracker.Clear()
        }
        
        # Close the runspace pool
        if ($global:WinUtilRunspacePool) {
            $global:WinUtilRunspacePool.Close()
            $global:WinUtilRunspacePool.Dispose()
            $global:WinUtilRunspacePool = $null
        }
        
        Write-Log "All runspaces stopped and cleaned up" -Level "DEBUG"
    }
    catch {
        Write-Log "Error stopping runspaces: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Test-ExclusiveMode {
    <#
    .SYNOPSIS
    Checks if exclusive mode is active (no other operations should run)
    
    .PARAMETER SetExclusive
    Sets exclusive mode on/off
    #>
    param(
        [Parameter(Mandatory=$false)]
        [bool]$SetExclusive = $null
    )
    
    if ($null -ne $SetExclusive) {
        $global:WinUtilExclusiveMode = $SetExclusive
        $status = if ($SetExclusive) { "enabled" } else { "disabled" }
        Write-Log "Exclusive mode $status" -Level "DEBUG"
    }
    
    return [bool]$global:WinUtilExclusiveMode
}

# Functions exported: Initialize-RunspaceTracker, Add-RunspaceToTracker, Remove-RunspaceFromTracker, Get-ActiveRunspaces, Wait-AllRunspaces, Stop-AllRunspaces, Test-ExclusiveMode 

# ----------------------------------------
# MODULE: Process\Runner.ps1
# ----------------------------------------
function Start-Runspace {
    <#
    .SYNOPSIS
    Starts a runspace to execute a scriptblock in parallel
    
    .PARAMETER ScriptBlock
    The scriptblock to execute
    
    .PARAMETER Parameters
    Parameters to pass to the scriptblock
    
    .PARAMETER Name
    Optional name for the runspace (for tracking)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [ScriptBlock]$ScriptBlock,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Parameters = @{},
        
        [Parameter(Mandatory=$false)]
        [string]$Name = "Runspace_$(Get-Date -Format 'yyyyMMdd_HHmmss_fff')"
    )
    
    try {
        Write-Log "Starting runspace: $Name" -Level "DEBUG"
        
        # Initialize or reinitialize runspace pool to ensure all functions are available
        if (-not $global:WinUtilRunspacePool -or $global:WinUtilRunspacePool.RunspacePoolStateInfo.State -ne 'Opened') {
            Initialize-RunspacePool
        } else {
            # Check if we need to reinitialize due to new functions
            $currentFunctions = Get-Command -CommandType Function | Where-Object { 
                $_.Name -like "Invoke-Winutil*" -or $_.Name -eq "Write-Log" 
            }
            
            if ($currentFunctions.Count -gt ($global:WinUtilRunspacePoolFunctionCount -or 0)) {
                Write-Log "Detected new functions, reinitializing runspace pool..." -Level "DEBUG"
                if ($global:WinUtilRunspacePool) {
                    $global:WinUtilRunspacePool.Close()
                    $global:WinUtilRunspacePool.Dispose()
                }
                Initialize-RunspacePool
            }
        }
        
        # Create the runspace
        $runspace = [PowerShell]::Create()
        $runspace.RunspacePool = $global:WinUtilRunspacePool
        
        # Add the script block
        $null = $runspace.AddScript($ScriptBlock)
        
        # Add parameters
        foreach ($param in $Parameters.GetEnumerator()) {
            $null = $runspace.AddParameter($param.Key, $param.Value)
        }
        
        # Start the runspace
        $asyncResult = $runspace.BeginInvoke()
        
        # Track the runspace
        $runspaceInfo = @{
            Name = $Name
            Runspace = $runspace
            AsyncResult = $asyncResult
            StartTime = Get-Date
            Status = "Running"
        }
        
        Add-RunspaceToTracker -RunspaceInfo $runspaceInfo
        
        Write-Log "Successfully started runspace: $Name" -Level "DEBUG"
        return $runspaceInfo
    }
    catch {
        Write-Log "Failed to start runspace '$Name': $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

function Initialize-RunspacePool {
    <#
    .SYNOPSIS
    Initializes the global runspace pool
    
    .PARAMETER MinRunspaces
    Minimum number of runspaces to maintain
    
    .PARAMETER MaxRunspaces
    Maximum number of runspaces allowed
    #>
    param(
        [Parameter(Mandatory=$false)]
        [int]$MinRunspaces = 1,
        
        [Parameter(Mandatory=$false)]
        [int]$MaxRunspaces = 5
    )
    
    try {
        Write-Log "Initializing runspace pool (Min: $MinRunspaces, Max: $MaxRunspaces)" -Level "DEBUG"
        
        # Create initial session state
        $initialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
        
        # Get all functions that start with "Invoke-Winutil" or "Write-Log" for runspaces
        $allFunctions = Get-Command -CommandType Function | Where-Object { 
            $_.Name -like "Invoke-Winutil*" -or $_.Name -eq "Write-Log" 
        }
        
        Write-Log "Found $($allFunctions.Count) functions to import into runspace pool" -Level "DEBUG"
        
        foreach ($function in $allFunctions) {
            try {
                $functionDefinition = "function $($function.Name) { $($function.Definition) }"
                $sessionStateFunction = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry($function.Name, $functionDefinition)
                $initialSessionState.Commands.Add($sessionStateFunction)
                Write-Log "Added function to runspace pool: $($function.Name)" -Level "DEBUG"
            } catch {
                Write-Log "Failed to add function to runspace pool: $($function.Name) - $($_.Exception.Message)" -Level "WARN"
            }
        }
        
        # Store function count for future reference
        $global:WinUtilRunspacePoolFunctionCount = $allFunctions.Count
        
        # Create the runspace pool
        $global:WinUtilRunspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(
            $MinRunspaces, 
            $MaxRunspaces, 
            $initialSessionState, 
            $Host
        )
        
        $global:WinUtilRunspacePool.Open()
        
        Write-Log "Runspace pool initialized successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Failed to initialize runspace pool: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Wait-Runspace {
    <#
    .SYNOPSIS
    Waits for a runspace to complete and returns the result
    
    .PARAMETER RunspaceInfo
    The runspace info object returned from Start-Runspace
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$RunspaceInfo
    )
    
    try {
        Write-Log "Waiting for runspace to complete: $($RunspaceInfo.Name)" -Level "DEBUG"
        
        # Wait for completion
        $result = $RunspaceInfo.Runspace.EndInvoke($RunspaceInfo.AsyncResult)
        
        # Update status
        $RunspaceInfo.Status = "Completed"
        $RunspaceInfo.EndTime = Get-Date
        $RunspaceInfo.Duration = $RunspaceInfo.EndTime - $RunspaceInfo.StartTime
        
        # Check for errors
        if ($RunspaceInfo.Runspace.HadErrors) {
            $errors = $RunspaceInfo.Runspace.Streams.Error.ReadAll()
            Write-Log "Runspace '$($RunspaceInfo.Name)' completed with errors: $($errors -join '; ')" -Level "ERROR"
            $RunspaceInfo.Errors = $errors
        } else {
            Write-Log "Runspace '$($RunspaceInfo.Name)' completed successfully in $($RunspaceInfo.Duration.TotalSeconds) seconds" -Level "DEBUG"
        }
        
        # Clean up
        $RunspaceInfo.Runspace.Dispose()
        Remove-RunspaceFromTracker -Name $RunspaceInfo.Name
        
        return $result
    }
    catch {
        Write-Log "Error waiting for runspace '$($RunspaceInfo.Name)': $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

# Functions exported: Start-Runspace, Initialize-RunspacePool, Wait-Runspace 

# ----------------------------------------
# MODULE: Applications\Install.ps1
# ----------------------------------------
function Invoke-WinutilInstallApp {
    <#
    .SYNOPSIS
    Installs an application using winget or chocolatey
    
    .PARAMETER App
    App object from applications.json containing winget/choco IDs
    
    .PARAMETER Method
    Installation method: 'winget' or 'choco'
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$App,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('winget', 'choco')]
        [string]$Method
    )
    
    try {
        Write-Log "Installing $($App.content)..." -Level "INFO"
        
        switch ($Method) {
            'winget' {
                if ($App.winget -and $App.winget -ne "na") {
                    $process = Start-Process -FilePath "winget" -ArgumentList "install", "--id", $App.winget, "--accept-package-agreements", "--accept-source-agreements" -Wait -PassThru -NoNewWindow
                    if ($process.ExitCode -eq 0) {
                        Write-Log "Successfully installed $($App.content)" -Level "INFO"
                        return $true
                    } else {
                        Write-Log "Failed to install $($App.content) via winget. Exit code: $($process.ExitCode)" -Level "ERROR"
                        return $false
                    }
                } else {
                    Write-Log "No winget ID available for $($App.content)" -Level "WARN"
                    return $false
                }
            }
            
            'choco' {
                if ($App.choco -and $App.choco -ne "na") {
                    $process = Start-Process -FilePath "choco" -ArgumentList "install", $App.choco, "-y" -Wait -PassThru -NoNewWindow
                    if ($process.ExitCode -eq 0) {
                        Write-Log "Successfully installed $($App.content)" -Level "INFO"
                        return $true
                    } else {
                        Write-Log "Failed to install $($App.content) via chocolatey. Exit code: $($process.ExitCode)" -Level "ERROR"
                        return $false
                    }
                } else {
                    Write-Log "No chocolatey ID available for $($App.content)" -Level "WARN"
                    return $false
                }
            }
        }
    }
    catch {
        Write-Log "Exception during installation of $($App.content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Install-App 

# ----------------------------------------
# MODULE: Applications\Uninstall.ps1
# ----------------------------------------
function Invoke-WinutilUninstallApp {
    <#
    .SYNOPSIS
    Uninstalls an application using winget or chocolatey
    
    .PARAMETER App
    App object from applications.json containing winget/choco IDs
    
    .PARAMETER Method
    Uninstallation method: 'winget' or 'choco'
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$App,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('winget', 'choco')]
        [string]$Method
    )
    
    try {
        Write-Log "Uninstalling $($App.content)..." -Level "INFO"
        
        switch ($Method) {
            'winget' {
                if ($App.winget -and $App.winget -ne "na") {
                    $process = Start-Process -FilePath "winget" -ArgumentList "uninstall", "--id", $App.winget -Wait -PassThru -NoNewWindow
                    if ($process.ExitCode -eq 0) {
                        Write-Log "Successfully uninstalled $($App.content)" -Level "INFO"
                        return $true
                    } else {
                        Write-Log "Failed to uninstall $($App.content) via winget. Exit code: $($process.ExitCode)" -Level "ERROR"
                        return $false
                    }
                } else {
                    Write-Log "No winget ID available for $($App.content)" -Level "WARN"
                    return $false
                }
            }
            
            'choco' {
                if ($App.choco -and $App.choco -ne "na") {
                    $process = Start-Process -FilePath "choco" -ArgumentList "uninstall", $App.choco, "-y" -Wait -PassThru -NoNewWindow
                    if ($process.ExitCode -eq 0) {
                        Write-Log "Successfully uninstalled $($App.content)" -Level "INFO"
                        return $true
                    } else {
                        Write-Log "Failed to uninstall $($App.content) via chocolatey. Exit code: $($process.ExitCode)" -Level "ERROR"
                        return $false
                    }
                } else {
                    Write-Log "No chocolatey ID available for $($App.content)" -Level "WARN"
                    return $false
                }
            }
        }
    }
    catch {
        Write-Log "Exception during uninstallation of $($App.content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Uninstall-App 

# ----------------------------------------
# MODULE: Applications\General.ps1
# ----------------------------------------
function Invoke-WinutilAppAction {
    <#
    .SYNOPSIS
    Dispatcher for app installation/uninstallation actions
    
    .PARAMETER AppID
    ID of the app from applications.json
    
    .PARAMETER Action
    Action to perform: 'Install' or 'Uninstall'
    
    .PARAMETER Config
    Configuration object containing apps
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$AppID,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('Install', 'Uninstall')]
        [string]$Action,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Config
    )
    
    try {
        # Look up app in configuration
        if (-not $Config.PSObject.Properties.Name -contains $AppID) {
            Write-Log "App ID '$AppID' not found in configuration" -Level "ERROR"
            return $false
        }
        
        $app = $Config.$AppID
        Write-Log "Processing $Action for app: $($app.content)" -Level "DEBUG"
        
        # Determine installation method - prefer winget over choco
        $method = $null
        if ($app.winget -and $app.winget -ne "na") {
            $method = "winget"
        } elseif ($app.choco -and $app.choco -ne "na") {
            $method = "choco"
        } else {
            Write-Log "No valid installation method found for $($app.content)" -Level "ERROR"
            return $false
        }
        
        # Dispatch to appropriate action
        switch ($Action) {
            'Install' {
                return Invoke-WinutilInstallApp -App $app -Method $method
            }
            'Uninstall' {
                return Invoke-WinutilUninstallApp -App $app -Method $method
            }
        }
    }
    catch {
        Write-Log "Exception in Invoke-WinutilAppAction for $AppID`: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-WinutilAppAction 

# ----------------------------------------
# MODULE: Tweaks\Registry.ps1
# ----------------------------------------
function Invoke-WinutilRegistryTweak {
    <#
    .SYNOPSIS
    Applies or undoes registry tweaks
    
    .PARAMETER Tweak
    Tweak object from tweaks.json containing registry entries
    
    .PARAMETER Undo
    Whether to undo the tweak (restore original values)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Tweak,
        
        [Parameter(Mandatory=$false)]
        [bool]$Undo = $false
    )
    
    try {
        $action = if ($Undo) { "Undoing" } else { "Applying" }
        Write-Log "$action registry tweak: $($Tweak.Content)" -Level "DEBUG"
        
        if (-not $Tweak.registry) {
            Write-Log "No registry entries found for tweak: $($Tweak.Content)" -Level "WARN"
            return $true
        }
        
        $success = $true
        foreach ($regEntry in $Tweak.registry) {
            try {
                $path = $regEntry.Path
                $name = $regEntry.Name
                $type = $regEntry.Type
                
                # Determine value to set
                $value = if ($Undo) { $regEntry.OriginalValue } else { $regEntry.Value }
                
                # Ensure the registry path exists
                if (-not (Test-Path $path)) {
                    Write-Log "Creating registry path: $path" -Level "DEBUG"
                    New-Item -Path $path -Force | Out-Null
                }
                
                # Handle special cases
                if ($value -eq "<RemoveEntry>") {
                    # Remove the registry entry
                    if (Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue) {
                        Write-Log "Removing registry entry: $path\$name" -Level "DEBUG"
                        Remove-ItemProperty -Path $path -Name $name -Force
                    }
                } else {
                    # Set the registry value
                    Write-Log "Setting registry: $path\$name = $value ($type)" -Level "DEBUG"
                    Set-ItemProperty -Path $path -Name $name -Value $value -Type $type -Force
                }
            }
            catch {
                Write-Log "Failed to process registry entry $($regEntry.Path)\$($regEntry.Name): $($_.Exception.Message)" -Level "ERROR"
                $success = $false
            }
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-RegistryTweak for $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-RegistryTweak 

# ----------------------------------------
# MODULE: Tweaks\Services.ps1
# ----------------------------------------
function Invoke-WinutilServiceTweak {
    <#
    .SYNOPSIS
    Applies or undoes service tweaks
    
    .PARAMETER Tweak
    Tweak object from tweaks.json containing service entries
    
    .PARAMETER Undo
    Whether to undo the tweak (restore original startup types)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Tweak,
        
        [Parameter(Mandatory=$false)]
        [bool]$Undo = $false
    )
    
    try {
        $action = if ($Undo) { "Undoing" } else { "Applying" }
        Write-Log "$action service tweak: $($Tweak.Content)" -Level "DEBUG"
        
        if (-not $Tweak.service) {
            Write-Log "No service entries found for tweak: $($Tweak.Content)" -Level "WARN"
            return $true
        }
        
        $success = $true
        foreach ($serviceEntry in $Tweak.service) {
            try {
                $serviceName = $serviceEntry.Name
                $startupType = if ($Undo) { $serviceEntry.OriginalType } else { $serviceEntry.StartupType }
                
                # Check if service exists
                $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
                if (-not $service) {
                    Write-Log "Service '$serviceName' not found, skipping" -Level "WARN"
                    continue
                }
                
                Write-Log "Setting service '$serviceName' startup type to '$startupType'" -Level "DEBUG"
                
                # Stop service if it's running and we're disabling it
                if ($startupType -eq "Disabled" -and $service.Status -eq "Running") {
                    Write-Log "Stopping service '$serviceName' before disabling" -Level "DEBUG"
                    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
                }
                
                # Set the startup type
                Set-Service -Name $serviceName -StartupType $startupType
                
                Write-Log "Successfully set service '$serviceName' to '$startupType'" -Level "DEBUG"
            }
            catch {
                Write-Log "Failed to process service '$($serviceEntry.Name)': $($_.Exception.Message)" -Level "ERROR"
                $success = $false
            }
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-ServiceTweak for $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-ServiceTweak 

# ----------------------------------------
# MODULE: Tweaks\Scripts.ps1
# ----------------------------------------
function Invoke-WinutilScriptTweak {
    <#
    .SYNOPSIS
    Applies or undoes script tweaks
    
    .PARAMETER Tweak
    Tweak object from tweaks.json containing script commands
    
    .PARAMETER Undo
    Whether to undo the tweak (run undo scripts)
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Tweak,
        
        [Parameter(Mandatory=$false)]
        [bool]$Undo = $false
    )
    
    try {
        $action = if ($Undo) { "Undoing" } else { "Applying" }
        Write-Log "$action script tweak: $($Tweak.Content)" -Level "DEBUG"
        
        $scripts = if ($Undo) { $Tweak.UndoScript } else { $Tweak.InvokeScript }
        
        if (-not $scripts -or $scripts.Count -eq 0) {
            $scriptType = if ($Undo) { "undo" } else { "invoke" }
            Write-Log "No $scriptType scripts found for tweak: $($Tweak.Content)" -Level "WARN"
            return $true
        }
        
        $success = $true
        for ($i = 0; $i -lt $scripts.Count; $i++) {
            try {
                $script = $scripts[$i]
                Write-Log "Executing script $($i + 1)/$($scripts.Count) for tweak: $($Tweak.Content)" -Level "DEBUG"
                
                # Execute the script
                $result = Invoke-Expression $script
                
                # Check if there was an error in the script execution
                if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) {
                    Write-Log "Script execution returned exit code: $LASTEXITCODE" -Level "WARN"
                }
                
                Write-Log "Successfully executed script $($i + 1) for tweak: $($Tweak.Content)" -Level "DEBUG"
            }
            catch {
                Write-Log "Failed to execute script $($i + 1) for tweak $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
                $success = $false
            }
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-ScriptTweak for $($Tweak.Content): $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-ScriptTweak 

# ----------------------------------------
# MODULE: Tweaks\General.ps1
# ----------------------------------------
function Invoke-WinutilTweakAction {
    <#
    .SYNOPSIS
    Dispatcher for tweak apply/undo actions
    
    .PARAMETER TweakID
    ID of the tweak from tweaks.json
    
    .PARAMETER Action
    Action to perform: 'Apply' or 'Undo'
    
    .PARAMETER Config
    Configuration object containing tweaks
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$TweakID,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('Apply', 'Undo')]
        [string]$Action,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Config
    )
    
    try {
        # Look up tweak in configuration
        if (-not $Config.PSObject.Properties.Name -contains $TweakID) {
            Write-Log "Tweak ID '$TweakID' not found in configuration" -Level "ERROR"
            return $false
        }
        
        $tweak = $Config.$TweakID
        $undo = $Action -eq "Undo"
        
        Write-Log "Processing $Action for tweak: $($tweak.Content)" -Level "DEBUG"
        
        $success = $true
        
        # Process registry tweaks
        if ($tweak.registry) {
            Write-Log "Processing registry entries for tweak: $($tweak.Content)" -Level "DEBUG"
            if (-not (Invoke-WinutilRegistryTweak -Tweak $tweak -Undo $undo)) {
                $success = $false
            }
        }
        
        # Process service tweaks
        if ($tweak.service) {
            Write-Log "Processing service entries for tweak: $($tweak.Content)" -Level "DEBUG"
            if (-not (Invoke-WinutilServiceTweak -Tweak $tweak -Undo $undo)) {
                $success = $false
            }
        }
        
        # Process script tweaks
        if (($tweak.InvokeScript -and -not $undo) -or ($tweak.UndoScript -and $undo)) {
            Write-Log "Processing script entries for tweak: $($tweak.Content)" -Level "DEBUG"
            if (-not (Invoke-WinutilScriptTweak -Tweak $tweak -Undo $undo)) {
                $success = $false
            }
        }
        
        if ($success) {
            Write-Log "Successfully completed $Action for tweak: $($tweak.Content)" -Level "DEBUG"
        } else {
            Write-Log "Some operations failed for $Action of tweak: $($tweak.Content)" -Level "WARN"
        }
        
        return $success
    }
    catch {
        Write-Log "Exception in Invoke-WinutilTweakAction for $TweakID`: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Invoke-WinutilTweakAction 

# ----------------------------------------
# MODULE: Presets\Loader.ps1
# ----------------------------------------
function Load-Presets {
    <#
    .SYNOPSIS
    Loads preset configurations from JSON file
    
    .PARAMETER PresetPath
    Path to the presets JSON file
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetPath
    )
    
    try {
        Write-Log "Loading presets from: $PresetPath" -Level "DEBUG"
        
        if (-not (Test-Path $PresetPath)) {
            Write-Log "Preset file not found: $PresetPath" -Level "ERROR"
            return $null
        }
        
        # Read and parse the JSON file
        $jsonContent = Get-Content -Path $PresetPath -Raw -Encoding UTF8
        $presets = $jsonContent | ConvertFrom-Json
        
        Write-Log "Successfully loaded $($presets.PSObject.Properties.Count) presets" -Level "DEBUG"
        
        # Log available presets
        foreach ($preset in $presets.PSObject.Properties) {
            $itemCount = if ($preset.Value -is [array]) { $preset.Value.Count } else { 1 }
            Write-Log "Preset '$($preset.Name)': $itemCount items" -Level "DEBUG"
        }
        
        return $presets
    }
    catch {
        Write-Log "Failed to load presets from '$PresetPath': $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

function Get-PresetItems {
    <#
    .SYNOPSIS
    Gets the items (apps/tweaks) for a specific preset
    
    .PARAMETER Presets
    The presets object loaded from Load-Presets
    
    .PARAMETER PresetName
    Name of the preset to get items for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$true)]
        [string]$PresetName
    )
    
    try {
        if (-not $Presets.PSObject.Properties.Name -contains $PresetName) {
            Write-Log "Preset '$PresetName' not found in configuration" -Level "ERROR"
            return @()
        }
        
        $items = $Presets.$PresetName
        Write-Log "Retrieved $($items.Count) items from preset '$PresetName'" -Level "DEBUG"
        
        return $items
    }
    catch {
        Write-Log "Failed to get items for preset '$PresetName': $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Invoke-PresetApps {
    <#
    .SYNOPSIS
    Installs all apps in a preset
    
    .PARAMETER PresetName
    Name of the preset containing apps
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER Action
    Action to perform: Install or Uninstall
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetName,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('Install', 'Uninstall')]
        [string]$Action = 'Install'
    )
    
    try {
        Write-Log "Processing apps preset '$PresetName' with action '$Action'" -Level "DEBUG"
        
        $appIds = Get-PresetItems -Presets $Presets -PresetName $PresetName
        if ($appIds.Count -eq 0) {
            Write-Log "No apps found in preset '$PresetName'" -Level "WARN"
            return $true
        }
        
        $runspaces = @()
        $successful = 0
        $failed = 0
        
        foreach ($appId in $appIds) {
            try {
                # Validate app exists in configuration
                if (-not $AppsConfig.PSObject.Properties.Name -contains $appId) {
                    Write-Log "App ID '$appId' from preset '$PresetName' not found in apps configuration" -Level "WARN"
                    $failed++
                    continue
                }
                
                # Create scriptblock for parallel execution
                $scriptBlock = {
                    param($AppID, $Action, $Config)
                    return Invoke-WinutilAppAction -AppID $AppID -Action $Action -Config $Config
                }
                
                # Start runspace for this app
                $runspaceInfo = Start-Runspace -ScriptBlock $scriptBlock -Parameters @{
                    AppID = $appId
                    Action = $Action
                    Config = $AppsConfig
                } -Name "PresetApp_$($PresetName)_$($appId)"
                
                if ($runspaceInfo) {
                    $runspaces += $runspaceInfo
                }
            }
            catch {
                Write-Log "Failed to start runspace for app '$appId': $($_.Exception.Message)" -Level "ERROR"
                $failed++
            }
        }
        
        # Wait for all runspaces to complete
        Write-Log "Waiting for $($runspaces.Count) app operations to complete..." -Level "DEBUG"
        foreach ($runspaceInfo in $runspaces) {
            try {
                $result = Wait-Runspace -RunspaceInfo $runspaceInfo
                if ($result) {
                    $successful++
                } else {
                    $failed++
                }
            }
            catch {
                Write-Log "Error waiting for app runspace: $($_.Exception.Message)" -Level "ERROR"
                $failed++
            }
        }
        
        Write-Log "Preset '$PresetName' completed. Success: $successful, Failed: $failed" -Level "INFO"
        return $failed -eq 0
    }
    catch {
        Write-Log "Exception in Invoke-PresetApps for '$PresetName': $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

function Invoke-PresetTweaks {
    <#
    .SYNOPSIS
    Applies all tweaks in a preset
    
    .PARAMETER PresetName
    Name of the preset containing tweaks
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER Action
    Action to perform: Apply or Undo
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetName,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('Apply', 'Undo')]
        [string]$Action = 'Apply'
    )
    
    try {
        Write-Log "Processing tweaks preset '$PresetName' with action '$Action'" -Level "DEBUG"
        
        $tweakIds = Get-PresetItems -Presets $Presets -PresetName $PresetName
        if ($tweakIds.Count -eq 0) {
            Write-Log "No tweaks found in preset '$PresetName'" -Level "WARN"
            return $true
        }
        
        $successful = 0
        $failed = 0
        
        # Process tweaks sequentially to avoid conflicts
        foreach ($tweakId in $tweakIds) {
            try {
                # Validate tweak exists in configuration
                if (-not $TweaksConfig.PSObject.Properties.Name -contains $tweakId) {
                    Write-Log "Tweak ID '$tweakId' from preset '$PresetName' not found in tweaks configuration" -Level "WARN"
                    $failed++
                    continue
                }
                
                # Apply the tweak
                $result = Invoke-WinutilTweakAction -TweakID $tweakId -Action $Action -Config $TweaksConfig
                if ($result) {
                    $successful++
                } else {
                    $failed++
                }
            }
            catch {
                Write-Log "Failed to process tweak '$tweakId': $($_.Exception.Message)" -Level "ERROR"
                $failed++
            }
        }
        
        Write-Log "Tweaks preset '$PresetName' completed. Success: $successful, Failed: $failed" -Level "INFO"
        return $failed -eq 0
    }
    catch {
        Write-Log "Exception in Invoke-PresetTweaks for '$PresetName': $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Functions exported: Load-Presets, Get-PresetItems, Invoke-PresetApps, Invoke-PresetTweaks 

# ----------------------------------------
# MODULE: Presets\Validator.ps1
# ----------------------------------------
function Test-Presets {
    <#
    .SYNOPSIS
    Validates that all app/tweak IDs in presets exist in their respective configurations
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$AppsConfig = $null,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$TweaksConfig = $null
    )
    
    try {
        Write-Log "Validating presets configuration..." -Level "DEBUG"
        
        $validationErrors = @()
        $validationWarnings = @()
        
        foreach ($presetProperty in $Presets.PSObject.Properties) {
            $presetName = $presetProperty.Name
            $presetItems = $presetProperty.Value
            
            Write-Log "Validating preset '$presetName' with $($presetItems.Count) items" -Level "DEBUG"
            
            foreach ($item in $presetItems) {
                $found = $false
                $itemType = "Unknown"
                
                # Check if it's an app
                if ($AppsConfig -and $AppsConfig.PSObject.Properties.Name -contains $item) {
                    $found = $true
                    $itemType = "App"
                }
                
                # Check if it's a tweak
                if ($TweaksConfig -and $TweaksConfig.PSObject.Properties.Name -contains $item) {
                    if ($found) {
                        # Item exists in both configs - this is a warning
                        $warning = "Item '$item' in preset '$presetName' exists in both apps and tweaks configurations"
                        $validationWarnings += $warning
                        Write-Log $warning -Level "WARN"
                    } else {
                        $found = $true
                        $itemType = "Tweak"
                    }
                }
                
                if (-not $found) {
                    $errorMessage = "Item '$item' in preset '$presetName' not found in any configuration"
                    $validationErrors += $errorMessage
                    Write-Log $errorMessage -Level "ERROR"
                } else {
                    Write-Log "Item '$item' in preset '$presetName' validated as $itemType" -Level "DEBUG"
                }
            }
        }
        
        # Summary
        $totalPresets = $Presets.PSObject.Properties.Count
        $totalItems = ($Presets.PSObject.Properties.Value | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        
        Write-Log "Validation completed:" -Level "DEBUG"
        Write-Log "  - Total presets: $totalPresets" -Level "DEBUG"
        Write-Log "  - Total items: $totalItems" -Level "DEBUG"
        Write-Log "  - Errors: $($validationErrors.Count)" -Level "DEBUG"
        Write-Log "  - Warnings: $($validationWarnings.Count)" -Level "DEBUG"
        
        if ($validationErrors.Count -eq 0) {
            Write-Log "All presets are valid!" -Level "DEBUG"
            return @{
                IsValid = $true
                Errors = @()
                Warnings = $validationWarnings
                Summary = @{
                    TotalPresets = $totalPresets
                    TotalItems = $totalItems
                    ErrorCount = 0
                    WarningCount = $validationWarnings.Count
                }
            }
        } else {
            Write-Log "Preset validation failed with $($validationErrors.Count) errors" -Level "ERROR"
            return @{
                IsValid = $false
                Errors = $validationErrors
                Warnings = $validationWarnings
                Summary = @{
                    TotalPresets = $totalPresets
                    TotalItems = $totalItems
                    ErrorCount = $validationErrors.Count
                    WarningCount = $validationWarnings.Count
                }
            }
        }
    }
    catch {
        Write-Log "Exception during preset validation: $($_.Exception.Message)" -Level "ERROR"
        return @{
            IsValid = $false
            Errors = @("Validation exception: $($_.Exception.Message)")
            Warnings = @()
            Summary = @{
                TotalPresets = 0
                TotalItems = 0
                ErrorCount = 1
                WarningCount = 0
            }
        }
    }
}

function Get-PresetStatistics {
    <#
    .SYNOPSIS
    Gets statistics about presets configuration
    
    .PARAMETER Presets
    The presets configuration object
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    #>
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Presets,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$AppsConfig = $null,
        
        [Parameter(Mandatory=$false)]
        [PSCustomObject]$TweaksConfig = $null
    )
    
    try {
        $stats = @{
            TotalPresets = $Presets.PSObject.Properties.Count
            PresetDetails = @{}
            ItemTypes = @{
                Apps = 0
                Tweaks = 0
                Unknown = 0
            }
            TotalItems = 0
        }
        
        foreach ($presetProperty in $Presets.PSObject.Properties) {
            $presetName = $presetProperty.Name
            $presetItems = $presetProperty.Value
            
            $presetStats = @{
                ItemCount = $presetItems.Count
                Apps = 0
                Tweaks = 0
                Unknown = 0
                Items = @()
            }
            
            foreach ($item in $presetItems) {
                $itemInfo = @{
                    ID = $item
                    Type = "Unknown"
                    Found = $false
                }
                
                # Check if it's an app
                if ($AppsConfig -and $AppsConfig.PSObject.Properties.Name -contains $item) {
                    $itemInfo.Type = "App"
                    $itemInfo.Found = $true
                    $presetStats.Apps++
                    $stats.ItemTypes.Apps++
                }
                
                # Check if it's a tweak
                if ($TweaksConfig -and $TweaksConfig.PSObject.Properties.Name -contains $item) {
                    if ($itemInfo.Found) {
                        $itemInfo.Type = "Both"  # Exists in both configs
                    } else {
                        $itemInfo.Type = "Tweak"
                        $itemInfo.Found = $true
                        $presetStats.Tweaks++
                        $stats.ItemTypes.Tweaks++
                    }
                }
                
                if (-not $itemInfo.Found) {
                    $presetStats.Unknown++
                    $stats.ItemTypes.Unknown++
                }
                
                $presetStats.Items += $itemInfo
            }
            
            $stats.PresetDetails[$presetName] = $presetStats
            $stats.TotalItems += $presetItems.Count
        }
        
        return $stats
    }
    catch {
        Write-Log "Exception getting preset statistics: $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

function Show-PresetSummary {
    <#
    .SYNOPSIS
    Displays a formatted summary of preset statistics
    
    .PARAMETER Statistics
    Statistics object from Get-PresetStatistics
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Statistics
    )
    
    try {
        Write-Log "=== PRESET SUMMARY ===" -Level "DEBUG"
        Write-Log "Total Presets: $($Statistics.TotalPresets)" -Level "DEBUG"
        Write-Log "Total Items: $($Statistics.TotalItems)" -Level "DEBUG"
        Write-Log "Apps: $($Statistics.ItemTypes.Apps)" -Level "DEBUG"
        Write-Log "Tweaks: $($Statistics.ItemTypes.Tweaks)" -Level "DEBUG"
        Write-Log "Unknown: $($Statistics.ItemTypes.Unknown)" -Level "DEBUG"
        
        Write-Log "=== PRESET DETAILS ===" -Level "DEBUG"
        foreach ($presetName in $Statistics.PresetDetails.Keys | Sort-Object) {
            $preset = $Statistics.PresetDetails[$presetName]
            Write-Log "Preset '$presetName':" -Level "DEBUG"
            Write-Log "  Total Items: $($preset.ItemCount)" -Level "DEBUG"
            Write-Log "  Apps: $($preset.Apps)" -Level "DEBUG"
            Write-Log "  Tweaks: $($preset.Tweaks)" -Level "DEBUG"
            if ($preset.Unknown -gt 0) {
                Write-Log "  Unknown: $($preset.Unknown)" -Level "WARN"
            }
        }
    }
    catch {
        Write-Log "Exception displaying preset summary: $($_.Exception.Message)" -Level "ERROR"
    }
}

# Functions exported: Test-Presets, Get-PresetStatistics, Show-PresetSummary 

# ----------------------------------------
# MODULE: UI\Binding.ps1
# ----------------------------------------
function Populate-UI {
    <#
    .SYNOPSIS
    Populates the UI with data from configuration files
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER PresetsConfig
    The presets configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Populating UI with configuration data..." -Level "DEBUG"
        
        # Populate applications
        if ($Sync) {
            Populate-Applications -AppsConfig $AppsConfig -Sync $Sync
            Populate-Tweaks -TweaksConfig $TweaksConfig -Sync $Sync
            Populate-Presets -PresetsConfig $PresetsConfig -Sync $Sync
        } else {
            # Fallback to old method
            Populate-Applications -Window $Window -AppsConfig $AppsConfig
            Populate-Tweaks -Window $Window -TweaksConfig $TweaksConfig
            Populate-Presets -Window $Window -PresetsConfig $PresetsConfig
        }
        
        Write-Log "UI population completed successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception during UI population: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Populate-Applications {
    <#
    .SYNOPSIS
    Populates the applications tree view grouped by categories
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Populating applications tree..." -Level "DEBUG"
        
        # Get UI controls - use Sync if available, otherwise fallback to Window
        if ($Sync) {
            $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        } else {
            $trvApplications = $Window.FindName("trvApplications")
        }
        
        if (-not $trvApplications) {
            Write-Log "Could not find applications tree control" -Level "ERROR"
            return
        }
        
        # Group applications by category
        $appsByCategory = @{}
        $categories = @()
        
        foreach ($appProperty in $AppsConfig.PSObject.Properties) {
            $app = $appProperty.Value | Add-Member -MemberType NoteProperty -Name "ID" -Value $appProperty.Name -PassThru
            $category = if ($app.category) { $app.category } else { "Other" }
            
            if (-not $appsByCategory.ContainsKey($category)) {
                $appsByCategory[$category] = @()
                $categories += $category
            }
            
            $appsByCategory[$category] += $app
        }
        
        # Clear and populate tree
        $trvApplications.Items.Clear()
        
        foreach ($category in $categories | Sort-Object) {
            # Create category node
            $categoryNode = New-Object System.Windows.Controls.TreeViewItem
            $categoryNode.Header = $category
            $categoryNode.IsExpanded = $true
            
            # Add applications to category
            foreach ($app in $appsByCategory[$category] | Sort-Object Content) {
                $appNode = New-Object System.Windows.Controls.TreeViewItem
                $appNode.Style = $trvApplications.FindResource("CheckboxTreeViewItem")
                
                # Create checkbox with tooltip for description
                $checkBox = New-Object System.Windows.Controls.CheckBox
                $checkBox.Content = $app.Content
                $checkBox.Tag = $app.ID
                                $checkBox.Foreground = [System.Windows.Media.Brushes]::White
                $checkBox.FontSize = 13
                $checkBox.Margin = "0,1,0,1"
                
                # Add tooltip with description if available
                if ($app.Description) {
                    $checkBox.ToolTip = $app.Description
                }
                
                $appNode.Header = $checkBox
                $categoryNode.Items.Add($appNode)
            }
            
            $trvApplications.Items.Add($categoryNode)
        }
        
        $totalApps = ($appsByCategory.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
        Write-Log "Populated $totalApps applications in $($categories.Count) categories" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception populating applications: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Populate-Tweaks {
    <#
    .SYNOPSIS
    Populates the tweaks TreeViews with categories and tweaks from the configuration
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Populating tweaks..." -Level "DEBUG"
        
        # Get TreeView controls for each panel
        if ($Sync) {
            $trvTweaksPanel1 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel1"
            $trvTweaksPanel2 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel2"
        } else {
            $trvTweaksPanel1 = $Window.FindName("trvTweaksPanel1")
            $trvTweaksPanel2 = $Window.FindName("trvTweaksPanel2")
        }
        
        if (-not $trvTweaksPanel1 -or -not $trvTweaksPanel2) {
            Write-Log "Could not find tweaks panel TreeViews" -Level "ERROR"
            return
        }
        
        # Clear existing content
        $trvTweaksPanel1.Items.Clear()
        $trvTweaksPanel2.Items.Clear()
        
        # Map panel numbers to TreeView controls
        $panelTreeViews = @{
            "1" = $trvTweaksPanel1
            "2" = $trvTweaksPanel2
        }
        
        $totalTweaks = 0
        $totalCategories = 0
        
        # Process each panel
        foreach ($panelProperty in ($TweaksConfig.PSObject.Properties | Sort-Object Name)) {
            $panelNumber = $panelProperty.Name
            $panel = $panelProperty.Value
            $treeView = $panelTreeViews[$panelNumber]
            
            if (-not $treeView) {
                Write-Log "TreeView for panel $panelNumber not found" -Level "WARN"
                continue
            }
            
            Write-Log "Populating Panel $panelNumber" -Level "DEBUG"
            
            $panelTweakCount = 0
            
            # Process each category within the panel
            foreach ($categoryProperty in $panel.PSObject.Properties) {
                $categoryName = $categoryProperty.Name
                $categoryTweaks = $categoryProperty.Value
                
                Write-Log "Processing Category: $categoryName" -Level "DEBUG"
                
                # Create category node
                $categoryNode = New-Object System.Windows.Controls.TreeViewItem
                # We'll set the header with the actual count after processing all tweaks
                $categoryNode.Header = $categoryName
                $categoryNode.IsExpanded = $true
                
                $categoryTweakCount = 0
                
                # Process each tweak in the category
                foreach ($tweakProperty in $categoryTweaks.PSObject.Properties) {
                    $tweakId = $tweakProperty.Name
                    $tweak = $tweakProperty.Value
                    
                    # Add the ID to the tweak object for reference
                    $tweak | Add-Member -MemberType NoteProperty -Name "ID" -Value $tweakId -Force
                    
                    $tweakNode = New-Object System.Windows.Controls.TreeViewItem
                    $tweakNode.Style = $treeView.TryFindResource("CheckboxTreeViewItem")
                    
                    # Determine the control type (default to checkbox if not specified)
                    $controlType = if ($tweak.Type) { $tweak.Type } else { "Checkbox" }
                    
                    switch ($controlType.ToLower()) {
                        "toggle" {
                            # Create toggle switch (CheckBox styled as toggle)
                            $toggleSwitch = New-Object System.Windows.Controls.CheckBox
                            $toggleSwitch.Content = $tweak.Content
                            $toggleSwitch.Tag = $tweak.ID
                            $toggleSwitch.Style = $treeView.TryFindResource("ToggleSwitch")
                            
                            # Set initial state based on DefaultState if available
                            if ($tweak.registry -and $tweak.registry[0].DefaultState) {
                                $toggleSwitch.IsChecked = [bool]::Parse($tweak.registry[0].DefaultState)
                            }
                            
                            # Add tooltip with description if available
                            if ($tweak.Description) {
                                $toggleSwitch.ToolTip = $tweak.Description
                            }
                            
                            # Add immediate execution event handler
                            $toggleSwitch.Add_Checked({
                                param($sender, $e)
                                $tweakId = $sender.Tag
                                Write-Log "Toggle ON: $tweakId" -Level "INFO"
                                # Execute tweak immediately
                                Invoke-TweakExecution -TweakId $tweakId -Action "Apply"
                            })
                            
                            $toggleSwitch.Add_Unchecked({
                                param($sender, $e)
                                $tweakId = $sender.Tag
                                Write-Log "Toggle OFF: $tweakId" -Level "INFO"
                                # Execute undo immediately
                                Invoke-TweakExecution -TweakId $tweakId -Action "Undo"
                            })
                            
                            $tweakNode.Header = $toggleSwitch
                        }
                        
                        "button" {
                            # Create button
                            $button = New-Object System.Windows.Controls.Button
                            $button.Content = $tweak.Content
                            $button.Tag = $tweak.ID
                            $button.Style = $treeView.TryFindResource("TweakButton")
                            
                            # Set custom width if specified
                            if ($tweak.ButtonWidth) {
                                $button.Width = [int]$tweak.ButtonWidth
                            }
                            
                            # Add tooltip with description if available
                            if ($tweak.Description) {
                                $button.ToolTip = $tweak.Description
                            }
                            
                            # Add immediate execution event handler
                            $button.Add_Click({
                                param($sender, $e)
                                $tweakId = $sender.Tag
                                Write-Log "Button clicked: $tweakId" -Level "INFO"
                                # Execute tweak immediately
                                Invoke-TweakExecution -TweakId $tweakId -Action "Apply"
                            })
                            
                            $tweakNode.Header = $button
                        }
                        
                        "combobox" {
                            # Create container for combobox with label
                            $container = New-Object System.Windows.Controls.StackPanel
                            $container.Orientation = [System.Windows.Controls.Orientation]::Vertical
                            
                            # Create label
                            $label = New-Object System.Windows.Controls.TextBlock
                            $label.Text = $tweak.Content
                            $label.Foreground = [System.Windows.Media.Brushes]::White
                            $label.FontSize = 14
                            $label.Margin = "0,0,0,4"
                            
                            # Create combobox
                            $comboBox = New-Object System.Windows.Controls.ComboBox
                            $comboBox.Tag = $tweak.ID
                            $comboBox.Style = $treeView.TryFindResource("TweakComboBox")
                            
                            # Add items from ComboItems property
                            if ($tweak.ComboItems) {
                                $items = $tweak.ComboItems -split ' '
                                foreach ($item in $items) {
                                    $comboBox.Items.Add($item) | Out-Null
                                }
                                # Select first item by default
                                if ($comboBox.Items.Count -gt 0) {
                                    $comboBox.SelectedIndex = 0
                                }
                            }
                            
                            # Add tooltip with description if available
                            if ($tweak.Description) {
                                $container.ToolTip = $tweak.Description
                            }
                            
                            # Add immediate execution event handler
                            $comboBox.Add_SelectionChanged({
                                param($sender, $e)
                                if ($sender.SelectedItem) {
                                    $tweakId = $sender.Tag
                                    $selectedValue = $sender.SelectedItem.ToString()
                                    Write-Log "ComboBox changed: $tweakId = $selectedValue" -Level "INFO"
                                    # Execute tweak immediately with selected value
                                    Invoke-TweakExecution -TweakId $tweakId -Action "Apply" -Value $selectedValue
                                }
                            })
                            
                            $container.Children.Add($label) | Out-Null
                            $container.Children.Add($comboBox) | Out-Null
                            $tweakNode.Header = $container
                        }
                        
                        default {
                            # Create standard checkbox (default behavior)
                            $checkBox = New-Object System.Windows.Controls.CheckBox
                            $checkBox.Content = $tweak.Content
                            $checkBox.Tag = $tweak.ID
                            $checkBox.Foreground = [System.Windows.Media.Brushes]::White
                            $checkBox.FontSize = 13
                            $checkBox.Margin = "0,1,0,1"
                            
                            # Add tooltip with description if available
                            if ($tweak.Description) {
                                $checkBox.ToolTip = $tweak.Description
                            }
                            
                            $tweakNode.Header = $checkBox
                        }
                    }
                    
                    $categoryNode.Items.Add($tweakNode)
                    $categoryTweakCount++
                    $panelTweakCount++
                }
                
                # Only add category if it has tweaks
                if ($categoryTweakCount -gt 0) {
                    # Keep the header as just the category name
                    $categoryNode.Header = $categoryName
                    $treeView.Items.Add($categoryNode)
                    $totalCategories++
                    Write-Log "Added category '$categoryName' with $categoryTweakCount tweaks to panel $panelNumber" -Level "DEBUG"
                }
            }
            
            Write-Log "Panel $panelNumber populated with $panelTweakCount tweaks" -Level "DEBUG"
            $totalTweaks += $panelTweakCount
        }
        
        Write-Log "Populated $totalTweaks tweaks in $totalCategories categories across panels" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception populating tweaks: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Populate-Presets {
    <#
    .SYNOPSIS
    Populates the preset dropdown menus
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER PresetsConfig
    The presets configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Populating presets..." -Level "DEBUG"
        
        # Presets are now handled by buttons, so this function doesn't need to do anything
        Write-Log "Preset buttons will be handled by event handlers" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception populating presets: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Filter-Content {
    <#
    .SYNOPSIS
    Filters both applications and tweaks based on search text
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER SearchText
    Text to search for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [string]$SearchText = ""
    )
    
    try {
        # Filter applications (collapse/expand categories based on search)
        $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        if ($trvApplications) {
            foreach ($categoryNode in $trvApplications.Items) {
                $hasVisibleApps = $false
                
                foreach ($appNode in $categoryNode.Items) {
                    $checkBox = $appNode.Header
                    if ($checkBox -is [System.Windows.Controls.CheckBox]) {
                        $appVisible = -not $SearchText -or 
                                     ($checkBox.Content -and $checkBox.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                     ($checkBox.ToolTip -and $checkBox.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                        
                        $appNode.Visibility = if ($appVisible) { "Visible" } else { "Collapsed" }
                        if ($appVisible) { $hasVisibleApps = $true }
                    }
                }
                
                $categoryNode.Visibility = if ($hasVisibleApps) { "Visible" } else { "Collapsed" }
                if ($hasVisibleApps -and $SearchText) {
                    $categoryNode.IsExpanded = $true
                }
            }
        }
        
        # Filter tweaks across all panels
        $spTweaksPanels = Get-UIControl -Sync $Sync -ControlName "spTweaksPanels"
        if ($spTweaksPanels) {
            foreach ($panelBorder in $spTweaksPanels.Children) {
                if ($panelBorder -is [System.Windows.Controls.Border]) {
                    $panelContent = $panelBorder.Child
                    if ($panelContent -is [System.Windows.Controls.StackPanel]) {
                        # Find the TreeView in the panel
                        $panelTreeView = $panelContent.Children | Where-Object { $_ -is [System.Windows.Controls.TreeView] } | Select-Object -First 1
                        
                        if ($panelTreeView) {
                            $panelHasVisibleContent = $false
                            
                            foreach ($categoryNode in $panelTreeView.Items) {
                                $hasVisibleTweaks = $false
                                
                                foreach ($tweakNode in $categoryNode.Items) {
                                    $control = $tweakNode.Header
                                    $tweakVisible = $false
                                    
                                    # Handle different control types for filtering
                                    if ($control -is [System.Windows.Controls.CheckBox]) {
                                        # Checkbox or Toggle
                                        $tweakVisible = -not $SearchText -or 
                                                       ($control.Content -and $control.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                                       ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                                    }
                                    elseif ($control -is [System.Windows.Controls.Button]) {
                                        # Button
                                        $tweakVisible = -not $SearchText -or 
                                                       ($control.Content -and $control.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                                       ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                                    }
                                    elseif ($control -is [System.Windows.Controls.StackPanel]) {
                                        # ComboBox container
                                        $label = $control.Children | Where-Object { $_ -is [System.Windows.Controls.TextBlock] } | Select-Object -First 1
                                        $tweakVisible = -not $SearchText -or 
                                                       ($label -and $label.Text -and $label.Text.ToLower().Contains($SearchText.ToLower())) -or
                                                       ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                                    }
                                    
                                    $tweakNode.Visibility = if ($tweakVisible) { "Visible" } else { "Collapsed" }
                                    if ($tweakVisible) { 
                                        $hasVisibleTweaks = $true 
                                        $panelHasVisibleContent = $true
                                    }
                                }
                                
                                $categoryNode.Visibility = if ($hasVisibleTweaks) { "Visible" } else { "Collapsed" }
                                if ($hasVisibleTweaks -and $SearchText) {
                                    $categoryNode.IsExpanded = $true
                                }
                            }
                            
                            # Hide entire panel if no content is visible
                            $panelBorder.Visibility = if ($panelHasVisibleContent) { "Visible" } else { "Collapsed" }
                        }
                    }
                }
            }
        }
        
        Write-Log "Content filtered for search: '$SearchText'" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception filtering content: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Filter-ApplicationContent {
    <#
    .SYNOPSIS
    Filters applications based on search text
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER SearchText
    Text to search for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$false)]
        [string]$SearchText = ""
    )
    
    try {
        # Filter applications (collapse/expand categories based on search)
        $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        if ($trvApplications) {
            foreach ($categoryNode in $trvApplications.Items) {
                $hasVisibleApps = $false
                
                foreach ($appNode in $categoryNode.Items) {
                    $checkBox = $appNode.Header
                    if ($checkBox -is [System.Windows.Controls.CheckBox]) {
                        $appVisible = -not $SearchText -or 
                                     ($checkBox.Content -and $checkBox.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                     ($checkBox.ToolTip -and $checkBox.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                        
                        $appNode.Visibility = if ($appVisible) { "Visible" } else { "Collapsed" }
                        if ($appVisible) { $hasVisibleApps = $true }
                    }
                }
                
                $categoryNode.Visibility = if ($hasVisibleApps) { "Visible" } else { "Collapsed" }
                if ($hasVisibleApps -and $SearchText) {
                    $categoryNode.IsExpanded = $true
                }
            }
        }
        
        Write-Log "Applications filtered for search: '$SearchText'" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception filtering applications: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Filter-TweakContent {
    <#
    .SYNOPSIS
    Filters tweaks based on search text
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER SearchText
    Text to search for
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [string]$SearchText = ""
    )
    
    try {
        # Filter tweaks in static panels
        if ($Sync) {
            $trvTweaksPanel1 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel1"
            $trvTweaksPanel2 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel2"
            $panel1Border = Get-UIControl -Sync $Sync -ControlName "Panel1"
            $panel2Border = Get-UIControl -Sync $Sync -ControlName "Panel2"
        } else {
            $trvTweaksPanel1 = $Window.FindName("trvTweaksPanel1")
            $trvTweaksPanel2 = $Window.FindName("trvTweaksPanel2")
            $panel1Border = $Window.FindName("Panel1")
            $panel2Border = $Window.FindName("Panel2")
        }
        
        $panels = @(
            @{ TreeView = $trvTweaksPanel1; Border = $panel1Border }
            @{ TreeView = $trvTweaksPanel2; Border = $panel2Border }
        )
        
        foreach ($panelInfo in $panels) {
            $treeView = $panelInfo.TreeView
            $border = $panelInfo.Border
            
            if ($treeView) {
                $panelHasVisibleContent = $false
                
                foreach ($categoryNode in $treeView.Items) {
                    $hasVisibleTweaks = $false
                    
                    foreach ($tweakNode in $categoryNode.Items) {
                        $control = $tweakNode.Header
                        $tweakVisible = $false
                        
                        # Handle different control types for filtering
                        if ($control -is [System.Windows.Controls.CheckBox]) {
                            # Checkbox or Toggle
                            $tweakVisible = -not $SearchText -or 
                                           ($control.Content -and $control.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                           ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                        }
                        elseif ($control -is [System.Windows.Controls.Button]) {
                            # Button
                            $tweakVisible = -not $SearchText -or 
                                           ($control.Content -and $control.Content.ToString().ToLower().Contains($SearchText.ToLower())) -or
                                           ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                        }
                        elseif ($control -is [System.Windows.Controls.StackPanel]) {
                            # ComboBox container
                            $label = $control.Children | Where-Object { $_ -is [System.Windows.Controls.TextBlock] } | Select-Object -First 1
                            $tweakVisible = -not $SearchText -or 
                                           ($label -and $label.Text -and $label.Text.ToLower().Contains($SearchText.ToLower())) -or
                                           ($control.ToolTip -and $control.ToolTip.ToString().ToLower().Contains($SearchText.ToLower()))
                        }
                        
                        $tweakNode.Visibility = if ($tweakVisible) { "Visible" } else { "Collapsed" }
                        if ($tweakVisible) { 
                            $hasVisibleTweaks = $true 
                            $panelHasVisibleContent = $true
                        }
                    }
                    
                    $categoryNode.Visibility = if ($hasVisibleTweaks) { "Visible" } else { "Collapsed" }
                    if ($hasVisibleTweaks -and $SearchText) {
                        $categoryNode.IsExpanded = $true
                    }
                }
                
                # Hide entire panel if no content is visible
                if ($border) {
                    $border.Visibility = if ($panelHasVisibleContent) { "Visible" } else { "Collapsed" }
                }
            }
        }
        
        Write-Log "Tweaks filtered for search: '$SearchText'" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception filtering tweaks: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Get-SelectedApplications {
    <#
    .SYNOPSIS
    Gets the currently selected applications from the UI
    #>
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        if ($Sync) {
            $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        } else {
            $trvApplications = $Window.FindName("trvApplications")
        }
        
        if (-not $trvApplications) { return @() }
        
        $selectedApps = @()
        
        # Recursively traverse tree and find checked items
        foreach ($categoryNode in $trvApplications.Items) {
            foreach ($appNode in $categoryNode.Items) {
                $checkBox = $appNode.Header
                if ($checkBox -is [System.Windows.Controls.CheckBox] -and $checkBox.IsChecked -and $checkBox.Tag) {
                    $selectedApps += $checkBox.Tag
                }
            }
        }
        
        return $selectedApps
    }
    catch {
        Write-Log "Exception getting selected applications: $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Get-SelectedTweaks {
    <#
    .SYNOPSIS
    Gets the currently selected tweaks from the UI
    #>
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        if ($Sync) {
            $trvTweaksPanel1 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel1"
            $trvTweaksPanel2 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel2"
        } else {
            $trvTweaksPanel1 = $Window.FindName("trvTweaksPanel1")
            $trvTweaksPanel2 = $Window.FindName("trvTweaksPanel2")
        }
        
        $selectedTweaks = @()
        $panels = @($trvTweaksPanel1, $trvTweaksPanel2)
        
        # Traverse all panels and find checked items (only checkboxes, not toggles/buttons)
        foreach ($treeView in $panels) {
            if ($treeView) {
                foreach ($categoryNode in $treeView.Items) {
                    foreach ($tweakNode in $categoryNode.Items) {
                        $control = $tweakNode.Header
                        # Only include standard checkboxes in bulk selection, not toggles/buttons/comboboxes
                        if ($control -is [System.Windows.Controls.CheckBox] -and 
                            $control.Style -eq $null -and  # Standard checkbox (not toggle)
                            $control.IsChecked -and 
                            $control.Tag) {
                            $selectedTweaks += $control.Tag
                        }
                    }
                }
            }
        }
        
        return $selectedTweaks
    }
    catch {
        Write-Log "Exception getting selected tweaks: $($_.Exception.Message)" -Level "ERROR"
        return @()
    }
}

function Set-UIEnabled {
    <#
    .SYNOPSIS
    Enables or disables the UI during operations
    #>
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [bool]$Enabled
    )
    
    try {
        # List of controls to enable/disable
        $controlNames = @(
            "btnInstallApps", "btnUninstallApps", "btnApplyTweaks", "btnUndoTweaks",
            "btnPresetStandard", "btnPresetMinimal", "btnClearSelection"
        )
        
        foreach ($controlName in $controlNames) {
            if ($Sync) {
                $control = Get-UIControl -Sync $Sync -ControlName $controlName
            } else {
                $control = $Window.FindName($controlName)
            }
            
            if ($control) {
                $control.IsEnabled = $Enabled
            }
        }
        
        # Update cursor
        if ($Sync -and $Sync["Form"]) {
            $Sync["Form"].Cursor = if ($Enabled) { [System.Windows.Input.Cursors]::Arrow } else { [System.Windows.Input.Cursors]::Wait }
        } elseif ($Window) {
            $Window.Cursor = if ($Enabled) { [System.Windows.Input.Cursors]::Arrow } else { [System.Windows.Input.Cursors]::Wait }
        }
    }
    catch {
        Write-Log "Exception setting UI enabled state: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Find-VisualChild {
    <#
    .SYNOPSIS
    Helper function to find visual children of a specific type
    #>
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.DependencyObject]$Parent,
        
        [Parameter(Mandatory=$true)]
        [Type]$Type
    )
    
    $childrenCount = [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($Parent)
    
    for ($i = 0; $i -lt $childrenCount; $i++) {
        $child = [System.Windows.Media.VisualTreeHelper]::GetChild($Parent, $i)
        
        if ($child -is $Type) {
            return $child
        }
        
        $foundChild = Find-VisualChild -Parent $child -Type $Type
        if ($foundChild) {
            return $foundChild
        }
    }
    
    return $null
}

function Initialize-UIControls {
    <#
    .SYNOPSIS
    Automatically binds all named UI controls to a sync hashtable for easy access
    
    .PARAMETER Window
    The WPF window object
    
    .PARAMETER Sync
    The sync hashtable to store control references
    
    .PARAMETER XamlContent
    The XAML content string to parse for named controls
    #>
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [string]$XamlContent
    )
    
    try {
        Write-Log "Initializing UI control bindings..." -Level "DEBUG"
        
        # Store the window reference
        $Sync["Form"] = $Window
        
        # Parse XAML and find all named elements
        $xamlDoc = [System.Xml.XmlDocument]::new()
        $xamlDoc.LoadXml($XamlContent)
        
        # Find all elements with Name attributes
        $namedElements = $xamlDoc.SelectNodes("//*[@Name]")
        
        $boundControls = 0
        foreach ($element in $namedElements) {
            $controlName = $element.GetAttribute("Name")
            if ($controlName) {
                try {
                    $control = $Window.FindName($controlName)
                    if ($control) {
                        $Sync[$controlName] = $control
                        $boundControls++
                        Write-Log "Bound control: $controlName" -Level "DEBUG"
                    } else {
                        Write-Log "Control not found: $controlName" -Level "WARN"
                    }
                } catch {
                    Write-Log "Error binding control '$controlName': $($_.Exception.Message)" -Level "WARN"
                }
            }
        }
        
        Write-Log "UI control binding completed: $boundControls controls bound" -Level "DEBUG"
        return $boundControls
    }
    catch {
        Write-Log "Exception during UI control initialization: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Get-UIControl {
    <#
    .SYNOPSIS
    Gets a UI control from the sync hashtable with error handling
    
    .PARAMETER Sync
    The sync hashtable containing control references
    
    .PARAMETER ControlName
    The name of the control to retrieve
    #>
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$true)]
        [string]$ControlName
    )
    
    if ($Sync.ContainsKey($ControlName)) {
        return $Sync[$ControlName]
    } else {
        Write-Log "UI control '$ControlName' not found in sync hashtable" -Level "WARN"
        return $null
    }
}

function Invoke-TweakExecution {
    <#
    .SYNOPSIS
    Executes a tweak immediately when triggered by buttons or toggles
    
    .PARAMETER TweakId
    The ID of the tweak to execute
    
    .PARAMETER Action
    The action to perform (Apply or Undo)
    
    .PARAMETER Value
    Optional value for combobox selections
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$TweakId,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet("Apply", "Undo")]
        [string]$Action,
        
        [Parameter(Mandatory=$false)]
        [string]$Value
    )
    
    try {
        Write-Log "Executing tweak: $TweakId ($Action)" -Level "INFO"
        
        # This is a placeholder for the actual tweak execution logic
        # In the real implementation, this would:
        # 1. Load the tweak configuration
        # 2. Execute registry changes, scripts, service modifications, etc.
        # 3. Handle the specific value for combobox tweaks
        
        # For now, just log the action
        if ($Value) {
            Write-Log "Tweak $TweakId executed with value: $Value" -Level "INFO"
        } else {
            Write-Log "Tweak $TweakId executed ($Action)" -Level "INFO"
        }
        
        # TODO: Implement actual tweak execution logic here
        # This would typically involve calling existing tweak functions
        # based on the TweakId and Action parameters
        
    }
    catch {
        Write-Log "Error executing tweak $TweakId`: $($_.Exception.Message)" -Level "ERROR"
    }
}

# Functions exported: Initialize-UIControls, Get-UIControl, Populate-UI, Populate-Applications, Populate-Tweaks, Populate-Presets, Filter-Applications 

# ----------------------------------------
# MODULE: UI\Events.ps1
# ----------------------------------------
function Register-ButtonHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for all UI buttons and controls
    
    .PARAMETER Window
    The WPF window object (deprecated - use Sync instead)
    
    .PARAMETER AppsConfig
    The applications configuration object
    
    .PARAMETER TweaksConfig
    The tweaks configuration object
    
    .PARAMETER PresetsConfig
    The presets configuration object
    
    .PARAMETER Sync
    The sync hashtable containing UI control references
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        Write-Log "Registering UI event handlers..." -Level "DEBUG"
        
        # Register all handlers (no log TextBox needed anymore)
        if ($Sync) {
            Register-SearchHandlers -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync
            Register-PresetHandlers -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync
            Register-ActionHandlers -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync
            Register-GeneralHandlers -Sync $Sync
        } else {
            # Fallback to old method
            Register-SearchHandlers -Window $Window -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig
            Register-PresetHandlers -Window $Window -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig
            Register-ActionHandlers -Window $Window -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig
            Register-GeneralHandlers -Window $Window
        }
        
        Write-Log "Event handlers registered successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception registering event handlers: $($_.Exception.Message)" -Level "ERROR"
        throw
    }
}

function Register-SearchHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for unified search functionality
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get unified search control
        if ($Sync) {
            $txtSearch = Get-UIControl -Sync $Sync -ControlName "txtSearch"
            $applicationsContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
            $tweaksContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
        } else {
            $txtSearch = $Window.FindName("txtSearch")
            $applicationsContent = $Window.FindName("ApplicationsContent")
            $tweaksContent = $Window.FindName("TweaksContent")
        }
        
        # Unified search handler
        if ($txtSearch) {
            $txtSearch.Add_TextChanged({
                try {
                $searchText = $this.Text
                    
                    # Determine which tab is active and search accordingly
                if ($Sync) {
                        $appContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
                        $tweakContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
                        
                        if ($appContent.Visibility -eq "Visible") {
                            # Search applications
                    Filter-ApplicationContent -Sync $Sync -AppsConfig $AppsConfig -SearchText $searchText
                        } elseif ($tweakContent.Visibility -eq "Visible") {
                            # Search tweaks
                            Filter-TweakContent -Sync $Sync -TweaksConfig $TweaksConfig -SearchText $searchText
                        }
                } else {
                        # Fallback for Window-based approach
                        $appContent = $Window.FindName("ApplicationsContent")
                        $tweakContent = $Window.FindName("TweaksContent")
                        
                        if ($appContent.Visibility -eq "Visible") {
                            Write-Log "Applications search functionality requires Sync hashtable" -Level "WARN"
                        } elseif ($tweakContent.Visibility -eq "Visible") {
                            Write-Log "Tweaks search functionality requires Sync hashtable" -Level "WARN"
                        }
                    }
                } catch {
                    Write-Log "Exception during search: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Function to update search placeholder text
        function Update-SearchPlaceholder {
            param($SearchBox, $PlaceholderText)
            
            try {
                if ($SearchBox) {
                    $SearchBox.ApplyTemplate()
                    $placeholder = $SearchBox.Template.FindName("PlaceholderText", $SearchBox)
                    if ($placeholder) {
                        $placeholder.Text = $PlaceholderText
                    }
                }
            } catch {
                Write-Log "Exception updating search placeholder: $($_.Exception.Message)" -Level "DEBUG"
            }
        }
        
        # Store reference for placeholder updates
        if ($Sync -and $txtSearch) {
            $Sync["SearchBox"] = $txtSearch
        }
        
    }
    catch {
        Write-Log "Exception registering search handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Register-PresetHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for preset buttons
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get preset buttons
        if ($Sync) {
            $btnPresetStandard = Get-UIControl -Sync $Sync -ControlName "btnPresetStandard"
            $btnPresetMinimal = Get-UIControl -Sync $Sync -ControlName "btnPresetMinimal"
            $btnClearSelection = Get-UIControl -Sync $Sync -ControlName "btnClearSelection"
        } else {
            $btnPresetStandard = $Window.FindName("btnPresetStandard")
            $btnPresetMinimal = $Window.FindName("btnPresetMinimal")
            $btnClearSelection = $Window.FindName("btnClearSelection")
        }
        
        # Standard Setup Preset
        if ($btnPresetStandard) {
            $btnPresetStandard.Add_Click({
                try {
                    Write-Log "Applying Standard Setup preset..." -Level "INFO"
                    Apply-Preset -PresetName "standard" -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception applying Standard preset: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Minimal Setup Preset
        if ($btnPresetMinimal) {
            $btnPresetMinimal.Add_Click({
                try {
                    Write-Log "Applying Minimal Setup preset..." -Level "INFO"
                    Apply-Preset -PresetName "minimal" -PresetsConfig $PresetsConfig -AppsConfig $AppsConfig -TweaksConfig $TweaksConfig -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception applying Minimal preset: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Clear All Selection
        if ($btnClearSelection) {
            $btnClearSelection.Add_Click({
                try {
                    Write-Log "Clearing all selections..." -Level "INFO"
                    Clear-AllSelections -Sync $Sync -Window $Window
                }
                catch {
                    Write-Log "Exception clearing selections: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
    }
    catch {
        Write-Log "Exception registering preset handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Register-ActionHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for action buttons (install, uninstall, apply, undo)
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get action buttons
        if ($Sync) {
            $btnInstallApps = Get-UIControl -Sync $Sync -ControlName "btnInstallApps"
            $btnUninstallApps = Get-UIControl -Sync $Sync -ControlName "btnUninstallApps"
            $btnApplyTweaks = Get-UIControl -Sync $Sync -ControlName "btnApplyTweaks"
            $btnUndoTweaks = Get-UIControl -Sync $Sync -ControlName "btnUndoTweaks"
        } else {
            $btnInstallApps = $Window.FindName("btnInstallApps")
            $btnUninstallApps = $Window.FindName("btnUninstallApps")
            $btnApplyTweaks = $Window.FindName("btnApplyTweaks")
            $btnUndoTweaks = $Window.FindName("btnUndoTweaks")
        }
        
        # Install Selected Apps
        if ($btnInstallApps) {
            $btnInstallApps.Add_Click({
                try {
                    $selectedApps = Get-SelectedApplications -Sync $Sync -Window $Window
                    if ($selectedApps.Count -eq 0) {
                        Write-Log "No applications selected for installation" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Starting installation of $($selectedApps.Count) applications..." -Level "INFO"
                    
                    # Disable UI during operation
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    # Install apps in parallel using runspaces
                    $runspaces = @()
                    foreach ($app in $selectedApps) {
                        $scriptBlock = {
                            param($AppID, $Config)
                            return Invoke-WinutilAppAction -AppID $AppID -Action "Install" -Config $Config
                        }
                        
                        $runspaceInfo = Start-Runspace -ScriptBlock $scriptBlock -Parameters @{
                            AppID = $app.ID
                            Config = $AppsConfig
                        } -Name "Install_$($app.ID)"
                        
                        if ($runspaceInfo) {
                            $runspaces += $runspaceInfo
                        }
                    }
                    
                    # Wait for completion and update UI
                    $successful = 0
                    $failed = 0
                    foreach ($runspaceInfo in $runspaces) {
                        $result = Wait-Runspace -RunspaceInfo $runspaceInfo
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Installation completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception during app installation: $($_.Exception.Message)" -Level "ERROR"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
        
        # Uninstall Selected Apps
        if ($btnUninstallApps) {
            $btnUninstallApps.Add_Click({
                try {
                    $selectedApps = Get-SelectedApplications -Sync $Sync -Window $Window
                    if ($selectedApps.Count -eq 0) {
                        Write-Log "No applications selected for uninstallation" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Starting uninstallation of $($selectedApps.Count) applications..." -Level "INFO"
                    
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $runspaces = @()
                    foreach ($app in $selectedApps) {
                        $scriptBlock = {
                            param($AppID, $Config)
                            return Invoke-WinutilAppAction -AppID $AppID -Action "Uninstall" -Config $Config
                        }
                        
                        $runspaceInfo = Start-Runspace -ScriptBlock $scriptBlock -Parameters @{
                            AppID = $app.ID
                            Config = $AppsConfig
                        } -Name "Uninstall_$($app.ID)"
                        
                        if ($runspaceInfo) {
                            $runspaces += $runspaceInfo
                        }
                    }
                    
                    $successful = 0
                    $failed = 0
                    foreach ($runspaceInfo in $runspaces) {
                        $result = Wait-Runspace -RunspaceInfo $runspaceInfo
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Uninstallation completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception during app uninstallation: $($_.Exception.Message)" -Level "ERROR"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
        
        # Apply Selected Tweaks
        if ($btnApplyTweaks) {
            $btnApplyTweaks.Add_Click({
                try {
                    $selectedTweaks = Get-SelectedTweaks -Sync $Sync -Window $Window
                    if ($selectedTweaks.Count -eq 0) {
                        Write-Log "No tweaks selected for application" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Applying $($selectedTweaks.Count) tweaks..." -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $successful = 0
                    $failed = 0
                    
                    # Apply tweaks sequentially to avoid conflicts
                    foreach ($tweakID in $selectedTweaks) {
                        $result = Invoke-WinutilTweakAction -TweakID $tweakID -Action "Apply" -Config $TweaksConfig
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Tweaks application completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception applying tweaks: $($_.Exception.Message)" -Level "ERROR"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
        
        # Undo Selected Tweaks
        if ($btnUndoTweaks) {
            $btnUndoTweaks.Add_Click({
                try {
                    $selectedTweaks = Get-SelectedTweaks -Sync $Sync -Window $Window
                    if ($selectedTweaks.Count -eq 0) {
                        Write-Log "No tweaks selected for undo" -Level "WARN"
                        return
                    }
                    
                    Write-Log "Undoing $($selectedTweaks.Count) tweaks..." -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $false
                    
                    $successful = 0
                    $failed = 0
                    
                    foreach ($tweakID in $selectedTweaks) {
                        $result = Invoke-WinutilTweakAction -TweakID $tweakID -Action "Undo" -Config $TweaksConfig
                        if ($result) { $successful++ } else { $failed++ }
                    }
                    
                    Write-Log "Tweaks undo completed. Success: $successful, Failed: $failed" -Level "INFO"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
                catch {
                    Write-Log "Exception undoing tweaks: $($_.Exception.Message)" -Level "ERROR"
                    Set-UIEnabled -Sync $Sync -Window $Window -Enabled $true
                }
            })
        }
    }
    catch {
        Write-Log "Exception registering action handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Register-GeneralHandlers {
    <#
    .SYNOPSIS
    Registers event handlers for general UI controls including tab switching
    #>
    param(
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync
    )
    
    try {
        # Get tab buttons and content areas
        if ($Sync) {
            $btnApplicationsTab = Get-UIControl -Sync $Sync -ControlName "btnApplicationsTab"
            $btnTweaksTab = Get-UIControl -Sync $Sync -ControlName "btnTweaksTab"
            $applicationsContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
            $tweaksContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
        } else {
            $btnApplicationsTab = $Window.FindName("btnApplicationsTab")
            $btnTweaksTab = $Window.FindName("btnTweaksTab")
            $applicationsContent = $Window.FindName("ApplicationsContent")
            $tweaksContent = $Window.FindName("TweaksContent")
        }
        
        # Tab appearance logic with improved styling (inline to avoid scoping issues)
        
        # Applications tab button click handler
        if ($btnApplicationsTab -and $applicationsContent -and $tweaksContent) {
            $btnApplicationsTab.Add_Click({
                try {
                    Write-Log "Switching to Applications tab" -Level "DEBUG"
                    
                    # Get fresh references to all controls
                    if ($Sync) {
                        $appContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
                        $tweakContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
                        $btnApps = Get-UIControl -Sync $Sync -ControlName "btnApplicationsTab"
                        $btnTweaks = Get-UIControl -Sync $Sync -ControlName "btnTweaksTab"
                    } else {
                        $appContent = $Window.FindName("ApplicationsContent")
                        $tweakContent = $Window.FindName("TweaksContent")
                        $btnApps = $Window.FindName("btnApplicationsTab")
                        $btnTweaks = $Window.FindName("btnTweaksTab")
                    }
                    
                    # Switch content visibility
                    if ($appContent) { $appContent.Visibility = "Visible" }
                    if ($tweakContent) { $tweakContent.Visibility = "Collapsed" }
                    
                    # Update tab button appearance - Applications active
                    if ($btnApps) {
                        $btnApps.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FF2D2D30")
                        $btnApps.Foreground = [System.Windows.Media.Brushes]::White
                        
                        # Show active indicator line
                        try {
                            $btnApps.ApplyTemplate()
                            $activeLine = $btnApps.Template.FindName("ActiveLine", $btnApps)
                            if ($activeLine) { $activeLine.Opacity = 1.0 }
                        } catch { }
                    }
                    if ($btnTweaks) {
                        $btnTweaks.Background = [System.Windows.Media.Brushes]::Transparent
                        $btnTweaks.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FFAAAAAA")
                        
                        # Hide active indicator line
                        try {
                            $btnTweaks.ApplyTemplate()
                            $inactiveLine = $btnTweaks.Template.FindName("ActiveLine", $btnTweaks)
                            if ($inactiveLine) { $inactiveLine.Opacity = 0.0 }
                        } catch { }
                    }
                    
                    # Update search placeholder for Applications
                    try {
                        if ($Sync -and $Sync["SearchBox"]) {
                            $searchBox = $Sync["SearchBox"]
                            $searchBox.ApplyTemplate()
                            $placeholder = $searchBox.Template.FindName("PlaceholderText", $searchBox)
                            if ($placeholder) {
                                $placeholder.Text = "Search applications..."
                            }
                        }
                    } catch { }
                }
                catch {
                    Write-Log "Exception switching to Applications tab: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Tweaks tab button click handler
        if ($btnTweaksTab -and $applicationsContent -and $tweaksContent) {
            $btnTweaksTab.Add_Click({
                try {
                    Write-Log "Switching to Tweaks tab" -Level "DEBUG"
                    
                    # Get fresh references to all controls
                    if ($Sync) {
                        $appContent = Get-UIControl -Sync $Sync -ControlName "ApplicationsContent"
                        $tweakContent = Get-UIControl -Sync $Sync -ControlName "TweaksContent"
                        $btnApps = Get-UIControl -Sync $Sync -ControlName "btnApplicationsTab"
                        $btnTweaks = Get-UIControl -Sync $Sync -ControlName "btnTweaksTab"
                    } else {
                        $appContent = $Window.FindName("ApplicationsContent")
                        $tweakContent = $Window.FindName("TweaksContent")
                        $btnApps = $Window.FindName("btnApplicationsTab")
                        $btnTweaks = $Window.FindName("btnTweaksTab")
                    }
                    
                    # Switch content visibility
                    if ($appContent) { $appContent.Visibility = "Collapsed" }
                    if ($tweakContent) { $tweakContent.Visibility = "Visible" }
                    
                    # Update tab button appearance - Tweaks active
                    if ($btnTweaks) {
                        $btnTweaks.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FF2D2D30")
                        $btnTweaks.Foreground = [System.Windows.Media.Brushes]::White
                        
                        # Show active indicator line
                        try {
                            $btnTweaks.ApplyTemplate()
                            $activeLine = $btnTweaks.Template.FindName("ActiveLine", $btnTweaks)
                            if ($activeLine) { $activeLine.Opacity = 1.0 }
                        } catch { }
                    }
                    if ($btnApps) {
                        $btnApps.Background = [System.Windows.Media.Brushes]::Transparent
                        $btnApps.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FFAAAAAA")
                        
                        # Hide active indicator line
                        try {
                            $btnApps.ApplyTemplate()
                            $inactiveLine = $btnApps.Template.FindName("ActiveLine", $btnApps)
                            if ($inactiveLine) { $inactiveLine.Opacity = 0.0 }
                        } catch { }
                    }
                    
                    # Update search placeholder for Tweaks
                    try {
                        if ($Sync -and $Sync["SearchBox"]) {
                            $searchBox = $Sync["SearchBox"]
                            $searchBox.ApplyTemplate()
                            $placeholder = $searchBox.Template.FindName("PlaceholderText", $searchBox)
                            if ($placeholder) {
                                $placeholder.Text = "Search tweaks..."
                            }
                        }
                    } catch { }
                }
                catch {
                    Write-Log "Exception switching to Tweaks tab: $($_.Exception.Message)" -Level "ERROR"
                }
            })
        }
        
        # Set default active tab appearance (Applications)
        try {
            if ($btnApplicationsTab) {
                $btnApplicationsTab.Background = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FF2D2D30")
                $btnApplicationsTab.Foreground = [System.Windows.Media.Brushes]::White
            }
            if ($btnTweaksTab) {
                $btnTweaksTab.Background = [System.Windows.Media.Brushes]::Transparent
                $btnTweaksTab.Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFrom("#FFAAAAAA")
            }
            
            # Set default active indicator for Applications tab
            try {
                if ($btnApplicationsTab) {
                    $btnApplicationsTab.ApplyTemplate()
                    $activeLine = $btnApplicationsTab.Template.FindName("ActiveLine", $btnApplicationsTab)
                    if ($activeLine) { $activeLine.Opacity = 1.0 }
                }
                if ($btnTweaksTab) {
                    $btnTweaksTab.ApplyTemplate()
                    $inactiveLine = $btnTweaksTab.Template.FindName("ActiveLine", $btnTweaksTab)
                    if ($inactiveLine) { $inactiveLine.Opacity = 0.0 }
                }
            } catch { }
            
            # Set default search placeholder for Applications
            if ($Sync -and $Sync["SearchBox"]) {
                $searchBox = $Sync["SearchBox"]
                $searchBox.ApplyTemplate()
                $placeholder = $searchBox.Template.FindName("PlaceholderText", $searchBox)
                if ($placeholder) {
                    $placeholder.Text = "Search applications..."
                }
            }
        } catch {
            Write-Log "Exception setting default tab appearance: $($_.Exception.Message)" -Level "ERROR"
        }
        
        # Register window control handlers
        try {
            # Get window control buttons
            if ($Sync) {
                $btnMinimize = Get-UIControl -Sync $Sync -ControlName "btnMinimize"
                $btnMaximize = Get-UIControl -Sync $Sync -ControlName "btnMaximize"
                $btnClose = Get-UIControl -Sync $Sync -ControlName "btnClose"
                $titleBar = Get-UIControl -Sync $Sync -ControlName "titleBar"
                $dragArea = Get-UIControl -Sync $Sync -ControlName "dragArea"
                $windowRef = $Sync["Form"]  # The window is stored as "Form" in the sync hashtable
            } else {
                $btnMinimize = $Window.FindName("btnMinimize")
                $btnMaximize = $Window.FindName("btnMaximize") 
                $btnClose = $Window.FindName("btnClose")
                $titleBar = $Window.FindName("titleBar")
                $dragArea = $Window.FindName("dragArea")
                $windowRef = $Window
            }
            
            # Minimize button
            if ($btnMinimize -and $windowRef) {
                $btnMinimize.Add_Click({
                    try {
                        if ($Sync -and $Sync["Form"]) {
                            $Sync["Form"].WindowState = [System.Windows.WindowState]::Minimized
                        } elseif ($Window) {
                            $Window.WindowState = [System.Windows.WindowState]::Minimized
                        }
                    } catch {
                        # Silent error handling - just prevent crashes
                    }
                }.GetNewClosure())
            }
            
            # Maximize/Restore button
            if ($btnMaximize -and $windowRef) {
                $btnMaximize.Add_Click({
                    try {
                        $targetWindow = if ($Sync -and $Sync["Form"]) { $Sync["Form"] } else { $Window }
                        
                        if ($targetWindow) {
                            if ($targetWindow.WindowState -eq [System.Windows.WindowState]::Maximized) {
                                $targetWindow.WindowState = [System.Windows.WindowState]::Normal
                                # Update button icon to maximize
                                try {
                                    $this.Content = [char]0xE922
                                } catch { }
                            } else {
                                $targetWindow.WindowState = [System.Windows.WindowState]::Maximized
                                # Update button icon to restore
                                try {
                                    $this.Content = [char]0xE923
                                } catch { }
                            }
                        }
                    } catch {
                        # Silent error handling - just prevent crashes
                    }
                }.GetNewClosure())
            }
            
            # Close button
            if ($btnClose -and $windowRef) {
                $btnClose.Add_Click({
                    try {
                        if ($Sync -and $Sync["Form"]) {
                            $Sync["Form"].Close()
                        } elseif ($Window) {
                            $Window.Close()
                        }
                    } catch {
                        # Silent error handling - just prevent crashes
                    }
                }.GetNewClosure())
            }
            
            # Drag functionality
            if ($titleBar -and $windowRef) {
                $titleBar.Add_MouseLeftButtonDown({
                    try {
                        $targetWindow = if ($Sync -and $Sync["Form"]) { $Sync["Form"] } else { $Window }
                        
                        if ($_.ClickCount -eq 1) {
                            $targetWindow.DragMove()
                        } elseif ($_.ClickCount -eq 2) {
                            # Double-click to maximize/restore
                            if ($targetWindow.WindowState -eq [System.Windows.WindowState]::Maximized) {
                                $targetWindow.WindowState = [System.Windows.WindowState]::Normal
                            } else {
                                $targetWindow.WindowState = [System.Windows.WindowState]::Maximized
                            }
                            
                            # Update maximize button icon
                            try {
                                $maxButton = if ($Sync) { Get-UIControl -Sync $Sync -ControlName "btnMaximize" } else { $Window.FindName("btnMaximize") }
                                if ($maxButton) {
                                    if ($targetWindow.WindowState -eq [System.Windows.WindowState]::Maximized) {
                                        $maxButton.Content = [char]0xE923  # Restore icon
                                    } else {
                                        $maxButton.Content = [char]0xE922  # Maximize icon
                                    }
                                }
                            } catch { }
                        }
                    } catch {
                        # Silent error handling - just prevent crashes
                    }
                }.GetNewClosure())
            }
            
            if ($dragArea -and $windowRef) {
                $dragArea.Add_MouseLeftButtonDown({
                    try {
                        $targetWindow = if ($Sync -and $Sync["Form"]) { $Sync["Form"] } else { $Window }
                        if ($_.ClickCount -eq 1) {
                            $targetWindow.DragMove()
                        }
                    } catch {
                        # Silent error handling - just prevent crashes
                    }
                }.GetNewClosure())
            }
            
        } catch {
            Write-Log "Exception registering window control handlers: $($_.Exception.Message)" -Level "ERROR"
        }
    }
    catch {
        Write-Log "Exception registering general handlers: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Apply-Preset {
    <#
    .SYNOPSIS
    Applies a preset by selecting the appropriate apps and tweaks
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$PresetName,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$PresetsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$AppsConfig,
        
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$TweaksConfig,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        # First clear all selections
        Clear-AllSelections -Sync $Sync -Window $Window
        
        # Check if preset exists
        if (-not $PresetsConfig.PSObject.Properties[$PresetName]) {
            Write-Log "Preset '$PresetName' not found" -Level "ERROR"
            return
        }
        
        $preset = $PresetsConfig.PSObject.Properties[$PresetName].Value
        
        # Select applications if specified
        if ($preset.applications -and $preset.applications.Count -gt 0) {
            Select-Applications -AppIDs $preset.applications -Sync $Sync -Window $Window
                                Write-Log "Selected $($preset.applications.Count) applications from preset" -Level "DEBUG"
        }
        
        # Select tweaks if specified
        if ($preset.tweaks -and $preset.tweaks.Count -gt 0) {
            Select-Tweaks -TweakIDs $preset.tweaks -Sync $Sync -Window $Window
                                Write-Log "Selected $($preset.tweaks.Count) tweaks from preset" -Level "DEBUG"
        }
        
        Write-Log "Preset '$PresetName' applied successfully" -Level "DEBUG"
    }
    catch {
        Write-Log "Exception applying preset '$PresetName': $($_.Exception.Message)" -Level "ERROR"
    }
}

function Clear-AllSelections {
    <#
    .SYNOPSIS
    Clears all selections in both applications and tweaks
    #>
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        # Clear application selections
        if ($Sync) {
            $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        } else {
            $trvApplications = $Window.FindName("trvApplications")
        }
        
        if ($trvApplications) {
            foreach ($categoryNode in $trvApplications.Items) {
                foreach ($appNode in $categoryNode.Items) {
                    $checkBox = $appNode.Header
                    if ($checkBox -is [System.Windows.Controls.CheckBox]) {
                        $checkBox.IsChecked = $false
                    }
                }
            }
        }
        
        # Clear tweak selections across all panels
        if ($Sync) {
            $trvTweaksPanel1 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel1"
            $trvTweaksPanel2 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel2"
        } else {
            $trvTweaksPanel1 = $Window.FindName("trvTweaksPanel1")
            $trvTweaksPanel2 = $Window.FindName("trvTweaksPanel2")
        }
        
        $panels = @($trvTweaksPanel1, $trvTweaksPanel2)
        
        foreach ($treeView in $panels) {
            if ($treeView) {
                foreach ($categoryNode in $treeView.Items) {
                    foreach ($tweakNode in $categoryNode.Items) {
                        $control = $tweakNode.Header
                        # Only clear standard checkboxes, not toggles (which should maintain state)
                        if ($control -is [System.Windows.Controls.CheckBox] -and $control.Style -eq $null) {
                            $control.IsChecked = $false
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Log "Exception clearing selections: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Select-Applications {
    <#
    .SYNOPSIS
    Selects applications by their IDs
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$AppIDs,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        if ($Sync) {
            $trvApplications = Get-UIControl -Sync $Sync -ControlName "trvApplications"
        } else {
            $trvApplications = $Window.FindName("trvApplications")
        }
        
        if ($trvApplications) {
            foreach ($categoryNode in $trvApplications.Items) {
                foreach ($appNode in $categoryNode.Items) {
                    $checkBox = $appNode.Header
                    if ($checkBox -is [System.Windows.Controls.CheckBox] -and $AppIDs -contains $checkBox.Tag) {
                            $checkBox.IsChecked = $true
                    }
                }
            }
        }
    }
    catch {
        Write-Log "Exception selecting applications: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Select-Tweaks {
    <#
    .SYNOPSIS
    Selects tweaks by their IDs
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$TweakIDs,
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Sync,
        
        [Parameter(Mandatory=$false)]
        [System.Windows.Window]$Window
    )
    
    try {
        if ($Sync) {
            $trvTweaksPanel1 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel1"
            $trvTweaksPanel2 = Get-UIControl -Sync $Sync -ControlName "trvTweaksPanel2"
        } else {
            $trvTweaksPanel1 = $Window.FindName("trvTweaksPanel1")
            $trvTweaksPanel2 = $Window.FindName("trvTweaksPanel2")
        }
        
        $panels = @($trvTweaksPanel1, $trvTweaksPanel2)
        
        foreach ($treeView in $panels) {
            if ($treeView) {
                foreach ($categoryNode in $treeView.Items) {
                    foreach ($tweakNode in $categoryNode.Items) {
                        $control = $tweakNode.Header
                        # Only select standard checkboxes, not toggles/buttons/comboboxes
                        if ($control -is [System.Windows.Controls.CheckBox] -and 
                            $control.Style -eq $null -and 
                            $TweakIDs -contains $control.Tag) {
                            $control.IsChecked = $true
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Log "Exception selecting tweaks: $($_.Exception.Message)" -Level "ERROR"
    }
}

function Find-VisualChild {
    <#
    .SYNOPSIS
    Helper function to find visual children of a specific type
    #>
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.DependencyObject]$Parent,
        
        [Parameter(Mandatory=$true)]
        [Type]$Type
    )
    
    $childrenCount = [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($Parent)
    
    for ($i = 0; $i -lt $childrenCount; $i++) {
        $child = [System.Windows.Media.VisualTreeHelper]::GetChild($Parent, $i)
        
        if ($child -is $Type) {
            return $child
        }
        
        $foundChild = Find-VisualChild -Parent $child -Type $Type
        if ($foundChild) {
            return $foundChild
        }
    }
    
    return $null
}

# Functions exported: Register-ButtonHandlers, Get-SelectedApplications, Get-SelectedTweaks, Set-UIEnabled 

# ========================================
# MAIN EXECUTION
# ========================================

function Load-EmbeddedConfigurations {
    try {
        $configs = @{}
        $configs.Apps = $global:AppsConfig | ConvertFrom-Json
        $configs.Tweaks = $global:TweaksConfig | ConvertFrom-Json  
        $configs.Presets = $global:PresetsConfig | ConvertFrom-Json
        return $configs
    }
    catch {
        Write-Host "Error loading embedded configurations: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Start-WinUtilGUI {
    param($Configs)
    
    try {
        Add-Type -AssemblyName PresentationFramework
        Add-Type -AssemblyName PresentationCore
        Add-Type -AssemblyName WindowsBase
        
        # Extract just the styles from the resources XAML
        $resourcesContent = $global:ResourcesXAML
        $stylesOnly = $resourcesContent -replace '<ResourceDictionary[^>]*>', '' -replace '</ResourceDictionary>', ''
        
        # Replace the MergedDictionaries section with inline resources
        $xamlWithResources = $global:MainWindowXAML -replace '<ResourceDictionary\.MergedDictionaries>[\s\S]*?</ResourceDictionary\.MergedDictionaries>', $stylesOnly.Trim()
        
        Write-Log "Parsing XAML..." -Level "DEBUG"
        $window = [Windows.Markup.XamlReader]::Parse($xamlWithResources)
        
        if (-not $window) {
            Write-Log "Failed to create window" -Level "ERROR"
            return $false
        }
        
        Write-Log "Window created successfully" -Level "INFO"
        
        # Initialize UI control bindings
        $sync = @{}
        Initialize-UIControls -Window $window -Sync $sync -XamlContent $xamlWithResources
        
        # Populate UI and register handlers using sync hashtable
        Populate-UI -AppsConfig $Configs.Apps -TweaksConfig $Configs.Tweaks -PresetsConfig $Configs.Presets -Sync $sync
        Register-ButtonHandlers -AppsConfig $Configs.Apps -TweaksConfig $Configs.Tweaks -PresetsConfig $Configs.Presets -Sync $sync
        
        # Show window
        $window.ShowDialog() | Out-Null
        return $true
    }
    catch {
        Write-Log "Error starting GUI: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Main execution
try {
    Initialize-Logging -LogLevel $LogLevel
    
    $configs = Load-EmbeddedConfigurations
    if (-not $configs) {
        Write-Host "Failed to load configurations" -ForegroundColor Red
        exit 1
    }
    
    # Start GUI
    $success = Start-WinUtilGUI -Configs $configs
    exit $(if ($success) { 0 } else { 1 })
}
catch {
    Write-Host "Fatal error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    if (Get-Command "Stop-AllRunspaces" -ErrorAction SilentlyContinue) {
        Stop-AllRunspaces
    }
}

