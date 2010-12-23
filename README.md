Skype AppleScripts
==========================================

These are some AppleScripts that I developed to make it easier to dial into a
daily conference call. For this conference call, I dial into an 888 number and
then I dial an 8 digit conference code and hit the '#' key to enter a
particular conference. Surprisingly, Skype doesn't let you do this in a simple
way by adding something like ",,12345678#" to the phone number, so I had to
resort to scripting.

SkypeDialer.applescript provides core services that can be used by other
AppleScripts, including SkypeDialerGUI. You should open SkypeDialer.applescript
with AppleScript Script Editor and then save it as a stay-open application
(File | Save As... and then for the File Format, select "Application" and in
Options, make sure that "Stay Open" is checked). I saved mine in /Applications
so I have /Applications/Skype Dialer.app.

SkypeDialerGUI can be used as a regular script or an application.
