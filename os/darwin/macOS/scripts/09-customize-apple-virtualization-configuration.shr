#!/usr/bin/env bash
set -eo pipefail

[ -n "${BASE_DIR}" ] && cd "${BASE_DIR}"

source ./scripts/common.sh

NEW_HOST_NET_ADDRESS="192.168.0.1"
NEW_HOST_NET_MASK="255.255.255.0"
NEW_SHARED_NET_ADDRESS="192.168.1.1"
NEW_SHARED_NET_MASK="255.255.255.0"

print_padded_title "com.apple.vmnet - Fetch Current Values"
CURRENT_HOST_NET_ADDRESS=$(sudo /usr/libexec/PlistBuddy -c "print :Host_Net_Address" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist || true)
CURRENT_HOST_NET_MASK=$(sudo /usr/libexec/PlistBuddy -c "print :Host_Net_Mask" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist || true)
CURRENT_SHARED_ADDRESS=$(sudo /usr/libexec/PlistBuddy -c "print :Shared_Net_Address" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist)
CURRENT_SHARED_NET_MASK=$(sudo /usr/libexec/PlistBuddy -c "print :Shared_Net_Mask" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist)

echo "Current Host Net Address: $CURRENT_HOST_NET_ADDRESS"
echo "Current Host Net Mask: $CURRENT_HOST_NET_MASK"
echo "Current Shared Net Address: $CURRENT_SHARED_ADDRESS"
echo "Current Shared Net Mask: $CURRENT_SHARED_NET_MASK"

print_padded_title "UTM - Check If Virtual Machines Exist"
if [[ $(utmctl list | wc -l | xargs) -ne "1" ]]; then
    echo "Virtual machine exist, will not patch new values."
else
    print_padded_title "dhcpd_leases - Purge Entries"
    echo "{}" | sudo tee /var/db/dhcpd_leases

    print_padded_title "com.apple.vmnet - Update To Desired Values"
    sudo /usr/libexec/PlistBuddy -c "Set :Host_Net_Address ${NEW_HOST_NET_ADDRESS}" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist
    sudo /usr/libexec/PlistBuddy -c "Set :Host_Net_Mask ${NEW_HOST_NET_MASK}" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist
    sudo /usr/libexec/PlistBuddy -c "Set :Shared_Net_Address ${NEW_SHARED_NET_ADDRESS}" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist
    sudo /usr/libexec/PlistBuddy -c "Set :Shared_Net_Mask ${NEW_SHARED_NET_MASK}" /Library/Preferences/SystemConfiguration/com.apple.vmnet.plist
fi
