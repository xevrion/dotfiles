#!/usr/bin/env bash
# macOS settings for a keyboard-first dev. Safe to re-run.
# From macos-defaults.com and mathiasbynens/dotfiles, tested up to Sequoia.
# If anything misbehaves on macOS 27, comment that line out and set it in System Settings.
set -u

echo "Keyboard: fast repeat, no accent popup (vim hjkl repeats)"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Typing: no smart quotes, dashes, autocorrect"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "Mouse: acceleration off"
defaults write NSGlobalDomain com.apple.mouse.linear -bool true

echo "Dock: autohide, instant, no recents, Spaces never reorder"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false

echo "AeroSpace: one Spaces set across displays, grouped Mission Control"
defaults write com.apple.spaces spans-displays -bool true
defaults write com.apple.dock expose-group-apps -bool true

echo "Windows: drag from anywhere with ctrl+cmd, no open animation"
defaults write -g NSWindowShouldDragOnGesture -bool true
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

echo "Finder: extensions, path bar, status bar, folders first, search current folder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
chflags nohidden ~/Library

echo "No .DS_Store on USB and network drives"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Screenshots to ~/Pictures/Screenshots (Hyprland saved to ~/Pictures too)"
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

killall Dock Finder SystemUIServer 2>/dev/null || true
echo "Done. Log out and back in for key repeat and the Spaces setting."
