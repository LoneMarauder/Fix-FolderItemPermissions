# Fix-FolderItemPermissions
This script fixes desktop folder permissions for folders that are redirected using OneDrive

I have found that when I install apps, they almost invariably leave shortcuts on the desktop (yes, I know you can choose not to).
As I like to try to have as clean a desktop as possible, I have most shortcuts copied into folders.  When an app is updated and puts a shortcut onto the desktop, I copy them into the "correct" folder.  When this happens, I find that for some reason these shortcuts have an ACL entry that specifically removes the rights for my local user ID from the shortcut - but still, somehow I am able to run the shortcut, and manually remove these entries from the item, most likely because my user is a local administrator.  This causes OneDrive to generate a sync error on these entries.

This is a small script I put together to clear the ACL and re-enable inheritance, which allows OneDrive to sync the items as normal.  This script must be "Run as Administrator" to work properly, otherwise it will generate errors that the current user cannot take ownership of the items.  This script also only changes permissions on "*.lnk" and "*.url" files, as these seem to be the only ones that have this issue.

This script requires the "NTFSSecurity" module by Raimund Andrée; it can be installed with "install-module NTFSSecurity"
