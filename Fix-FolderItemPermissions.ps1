# Fix-FolderItemPermissions.ps1

# This script fixes item-level security for specific items in desktop folders by restoring inherited permissions
# This seems to be needed when you move an item from the desktop into a folder synced with OneDrive, and overwrite an existing shortcut
# Why this has to be done is beyond me
# This script needs to be run as Administrator for proper filesystem rights.  If anyone knows how to do this in code, please let me know.

# VERSION HISTORY
# Version 1.0 - Initial release

# This script requires the "NTFSSecurity" module by Raimund Andrée; it can be installed with "install-module NTFSSecurity"
import-module NTFSSecurity

# Get the current user's desktop folder (in case it is redirected)
$userDesktop = [Environment]::GetFolderPath("Desktop")

# List all folders on the desktop
$desktopFolders = Get-ChildItem -Path $userDesktop -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName 

# DEBUG: List all desktop folders
# $desktopFolders

# Loop through all the folders
foreach ($folder in $desktopFolders) {
    # List the contents of the folder
    Write-Host "Processing folder" $folder.FullName.Split("\")[-1]
    # Another loop, YAY!
    ForEach ($directory in $folder) {
        # List all the shortcut files and "internet shortcuts" (i.e. Steam games) in the folder
        $shortcuts = Get-ChildItem -Path $directory.fullname -Filter '*.lnk'
        $urls = Get-ChildItem -Path $directory.fullname -Filter '*.url'
        
        # Concatenate these lists for easier processing
        $allShortcuts = $shortcuts + $urls
        
        # Three loops deep, watch out everyone!
        ForEach ($shortcut in $allShortcuts) {
            # List the file being processed on the console
            Write-Host "    Processing shortcut" $shortcut.BaseName
            
            # Clear the ACL on the item and reset inheritance
            Clear-NTFSAccess $shortcut.FullName
            Enable-NTFSAccessInheritance $shortcut.FullName
            
            # Bottom of the third loop.
            }
    # Bottom of the inner loop
    }    
# Bottom of the outer loop
}
# Script is complete!