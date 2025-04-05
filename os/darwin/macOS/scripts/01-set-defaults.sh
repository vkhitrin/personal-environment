#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
print_padded_title "defaults - Quit System Preferences"
osascript -e 'tell application "System Preferences" to quit'

# Install macOS defaults
print_padded_title "defaults - Configure defaults"
defaults -currentHost write -g AppleFontSmoothing -int 0
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true
defaults write -g WebContinuousSpellCheckingEnabled -bool true
defaults write -globalDomain NSUseAnimatedFocusRing -bool NO
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write com.apple.Accessibility KeyRepeatDelay "0.25"
defaults write com.apple.Accessibility KeyRepeatEnabled 1
defaults write com.apple.Accessibility KeyRepeatInterval "0.03333333299999999"
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
defaults write com.apple.Safari ProxiesInBookmarksBar "()"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults write com.apple.Safari ShowFavoritesBar -bool false
defaults write com.apple.Safari ShowSidebarInTopSites -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.Terminal ShowLineMarks -int 0
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"
defaults write com.apple.appleseed.FeedbackAssistant "Autogather" -bool "false"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0"
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write com.apple.finder "FXPreferredGroupBy" -string "Date Modified"
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "false"
defaults write com.apple.menuextra.clock "Show24Hour" -bool "true"
defaults write com.apple.menuextra.clock "ShowDate" -bool "true"
defaults write com.apple.menuextra.clock "ShowDayOfWeek" -bool "true"
defaults write com.apple.menuextra.clock "ShowSeconds" -bool "true"
defaults write com.apple.safari "ShowFullURLInSmartSearchField" -bool "true"
defaults write com.apple.screencapture "include-date" 0
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture location "$HOME/Documents/Screenshots"
defaults write com.apple.screencapture name "screencapture"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Install macOS defaults
print_padded_title "defaults - Configure Custom Keybindings"
# Command + Shift + 0 to open menu entry `Show Writing Tools`
defaults write -g NSUserKeyEquivalents -dict-add "Show Writing Tools" '@$0'

print_padded_title "defaults - Kill applications"
killall -q SystemUIServer || true
killall -q Finder || true
killall -q Dock || true
killall -q Safari || true
