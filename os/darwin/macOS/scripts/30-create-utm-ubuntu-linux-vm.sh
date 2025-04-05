#!/usr/bin/env bash
# FIXME: Ensure that `systemd-binfmt` is launched after mounting rosetta
set -eo pipefail

# Variable definition
UTM_VIRTUAL_MACHINE_DISPLAY_NAME=${UTM_VIRTUAL_MACHINE_DISPLAY_NAME:-ubuntu\-linux\-00}
UTM_VIRTUAL_MACHINE_VIRTUAL_CPU_COUNT=${UTM_VIRTUAL_MACHINE_VIRTUAL_CPU_COUNT:-4}
UTM_VIRTUAL_MACHINE_VIRTUAL_MEMORY_AMOUNT=${UTM_VIRTUAL_MACHINE_VIRTUAL_MEMORY_AMOUNT:-8192}
UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_SIZE=${UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_SIZE:-20g}
UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY="$HOME/Library/Containers/com.utmapp.UTM/Data/Documents"
UTM_VIRTUAL_MACHINE_BUNDLE_PATH="$UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY/$UTM_VIRTUAL_MACHINE_DISPLAY_NAME.utm"
UBUNTU_DISK_IMAGE_ARCHIVE_URL="https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.tar.gz"
UBUNTU_DISK_IMAGE_ARCHIVE_NAME=$(basename ${UBUNTU_DISK_IMAGE_ARCHIVE_URL})
UBUNTU_VMLINUZ_URL="https://cloud-images.ubuntu.com/noble/current/unpacked/noble-server-cloudimg-arm64-vmlinuz-generic"
UBUNTU_INITRD_URL="https://cloud-images.ubuntu.com/noble/current/unpacked/noble-server-cloudimg-arm64-initrd-generic"
UBUNTU_VMLINUZ_NAME=$(basename ${UBUNTU_VMLINUZ_URL})
UBUNTU_INITRD_NAME=$(basename ${UBUNTU_INITRD_URL})
UBUNTU_LINUX_COMMAND_LINE="console=hvc0 root=/dev/vdb"
CLOUDINIT_METADATA_CONTENT="""
instance-id: ${UTM_VIRTUAL_MACHINE_DISPLAY_NAME}
local-hostname: ${UTM_VIRTUAL_MACHINE_DISPLAY_NAME}
"""
CLOUDINIT_USERDATA_CONTENT="""#cloud-config
password: '12345678'
chpasswd:
  expire: false
write_files:
  - path: /etc/binfmt.d/rosetta.conf
    content: |
      :rosetta:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00:\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/media/rosetta/rosetta:F
  - path: /etc/systemd/system/mount-rosetta-directory.service
    content: |
      [Unit]
      Description=Create Directory
      After=network.target

      [Service]
      Type=oneshot
      ExecStart=bash -c 'mkdir -p /media/rosetta'

      [Install]
      WantedBy=multi-user.target
  - path: /etc/apt/preferences.d/disable-flash-kernel
    content: |
      Package: flash-kernel
      Pin: release *
      Pin-Priority: 1
  - path: /etc/systemd/resolved.conf.d/dns_servers.conf
    content: |
      [Resolve]
      DNS=8.8.8.8 1.1.1.1
      Domains=~.
    permissions: '0644'
  - path: /etc/apt/sources.list.d/amd64-sources.list
    content: |
      deb [arch=amd64] http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
      deb [arch=amd64] http://security.ubuntu.com/ubuntu noble-security main restricted universe multiverse
      deb [arch=amd64] http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
    owner: root:root
    permissions: '0644'
mounts:
  - [ rosetta, /media/rosetta, virtiofs, \"ro,nofail\", \"0\", \"0\" ]
apt:
  disable: true
runcmd:
  - dpkg --add-architecture amd64
  - systemctl restart systemd-resolved
  - apt update || true
  - apt remove -y flash-kernel
  - apt autoremove -y
  - systemctl daemon-reload
  - systemctl enable --now mount-rosetta-directory.service
  - systemctl restart systemd-binfmt
  - mount -a
  - apt install -y libc6:amd64
"""

function _genereate_apple_virtual_machine_identifier {
    swift repl <<EOF >/tmp/apple_vm_identifier.txt
import Foundation
import Virtualization

struct VM: Codable {
    var machineIdentifier: Data?
}

let placeholder = VM(machineIdentifier: VZGenericMachineIdentifier().dataRepresentation)

let encoder = PropertyListEncoder()
do {
    let encodedData = try encoder.encode(placeholder)

    let tmpDirectory = FileManager.default.temporaryDirectory
    let plistURL = tmpDirectory.appendingPathComponent("vm.plist")

    try encodedData.write(to: plistURL)
    print("\(plistURL.path)")

} catch {
    print("Error encoding data to plist: \(error)")
}
EOF
    cat /tmp/apple_vm_identifier.txt | tail -n1 | tr -d '\r' | xargs cat
    rm -rf /tmp/apple_vm_identifier.txt
}

# Network device attachment has to be done via code, plist definition is not enough
# ---
# function _generate_apple_random_mac_addres {
# swift repl << EOF
# import Virtualization
# print(VZMACAddress.randomLocallyAdministered().string)
# EOF
# }

source ./scripts/common.sh
[ -d "/Applications/UTM.app" ] || error_exit "UTM is not installed"
[ -d "$UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY" ] || error_exit "UTM virtual machine bundle directory '$UTM_VIRTUAL_MACHINE_BUNDLES_DIRECTORY' is not present"

print_padded_title "UTM - Check For Existance Of '${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}'"
[ ! -d "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH" ] || error_exit "Virtual machine bundle '$UTM_VIRTUAL_MACHINE_BUNDLE_PATH'"

print_padded_title "UTM - Create '${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}' Virtual Machine Bundle"
mkdir -p "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/Data"

print_padded_title "UTM - Generate Unique Apple Virtual Machine Identifier"
UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_IDENTIFIER=$(_genereate_apple_virtual_machine_identifier)
[ -n "$UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_IDENTIFIER" ]

# print_padded_title "UTM - Generate Unique Apple Virtual MAC Address"
# UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_MAC_ADDRESS=$(_generate_apple_random_mac_addres)
# [ -n "$UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_MAC_ADDRESS" ]

print_padded_title "UTM - Generate UTM Metadata Unique Identifiers"
UTM_VIRTUAL_MACHINE_UUID=$(uuidgen)
UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID=$(uuidgen)
UTM_VIRTUAL_MACHINE_CLOUD_INIT_UUID=$(uuidgen)

print_padded_title "UTM - Generate 'config.plist'"
/usr/libexec/PlistBuddy -c 'save' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Network array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
# /usr/libexec/PlistBuddy -c "add :Network:0:MacAddress string $UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_MAC_ADDRESS" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
# /usr/libexec/PlistBuddy -c 'add :Network:0:Mode string Shared' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Mode string Terminal' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:BackgroundColor string #000000' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:Font string Menlo' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:CursorBlink bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:FontSize integer 12' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Serial:0:Terminal:ForegroundColor string #ffffff' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Backend string Apple' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :System:Architecture string aarch64' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:CPUCount integer $UTM_VIRTUAL_MACHINE_VIRTUAL_CPU_COUNT" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:MemorySize integer $UTM_VIRTUAL_MACHINE_VIRTUAL_MEMORY_AMOUNT" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:GenericPlatform:machineIdentifier data $UTM_VIRTUAL_MACHINE_APPLE_VIRTUAL_MACHINE_IDENTIFIER" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :System:Boot:UEFIBoot bool false' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :System:Boot:OperatingSystem string Linux' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:Boot:LinuxCommandLine string ${UBUNTU_LINUX_COMMAND_LINE}" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:Boot:LinuxKernelPath string ${UBUNTU_VMLINUZ_NAME}" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :System:Boot:LinuxInitialRamdiskPath string ${UBUNTU_INITRD_NAME}" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Pointer bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Trackpad bool false' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Keyboard bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Audio bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Entropy bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Rosetta bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:Balloon bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Virtualization:ClipboardSharing bool true' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Information:Icon string ubuntu' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Information:Name string $UTM_VIRTUAL_MACHINE_DISPLAY_NAME" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Information:UUID string $UTM_VIRTUAL_MACHINE_UUID" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Information:IconCustom bool false' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display:0:HeightPixels integer 1080' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display:0:PixelsPerInch integer 80' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Display:0:WidthPixels integer 1920' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :Drive array' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:0:Identifier string $UTM_VIRTUAL_MACHINE_CLOUD_INIT_UUID" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:0:ImageName string ci.iso" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:0:ReadOnly bool true" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:1:Identifier string $UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:1:ImageName string $UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID.img" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c "add :Drive:1:ReadOnly bool false" "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"
/usr/libexec/PlistBuddy -c 'add :ConfigurationVersion integer 4' "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH/config.plist"

print_padded_title "UTM - Download External Ubuntu Linux Binaries"
wget ${UBUNTU_VMLINUZ_URL} -O "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/${UBUNTU_VMLINUZ_NAME}.gz"
gunzip "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/${UBUNTU_VMLINUZ_NAME}.gz"
wget ${UBUNTU_INITRD_URL} -O "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/${UBUNTU_INITRD_NAME}"

print_padded_title "UTM - Download Initial Disk Image"
test -f "${HOME}/Downloads/${UBUNTU_DISK_IMAGE_ARCHIVE_NAME}" || wget "${UBUNTU_DISK_IMAGE_ARCHIVE_URL}" -O "${HOME}/Downloads/${UBUNTU_DISK_IMAGE_ARCHIVE_NAME}"
tar -xvf "${HOME}/Downloads/${UBUNTU_DISK_IMAGE_ARCHIVE_NAME}" -C "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/"
mv "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/noble-server-cloudimg-arm64.img" "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/${UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID}.img"

print_padded_title "UTM - Resize Initial Disk Image"
qemu-img resize -f raw "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/${UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_UUID}.img" "${UTM_VIRTUAL_MACHINE_STORAGE_DEVICE_SIZE}"

print_padded_title "UTM - Generate cloud-init ISO"
CLOUD_INIT_TEMPORARY_DIR=$(mktemp -d)
echo "${CLOUDINIT_METADATA_CONTENT}" >"${CLOUD_INIT_TEMPORARY_DIR}/meta-data"
echo "${CLOUDINIT_USERDATA_CONTENT}" >"${CLOUD_INIT_TEMPORARY_DIR}/user-data"
xorrisofs -output "${CLOUD_INIT_TEMPORARY_DIR}/ci.iso" -volid cidata -joliet -rock "${CLOUD_INIT_TEMPORARY_DIR}/meta-data" "${CLOUD_INIT_TEMPORARY_DIR}/user-data"
mv "${CLOUD_INIT_TEMPORARY_DIR}/ci.iso" "${UTM_VIRTUAL_MACHINE_BUNDLE_PATH}/Data/"
rm -rf "${CLOUD_INIT_TEMPORARY_DIR}"

print_padded_title "UTM - Import Virtual Machine Bundle"
open "$UTM_VIRTUAL_MACHINE_BUNDLE_PATH"

print_padded_title "Notes"
# Network devices are usng `vmnet` framework, DHCP leases can be read at `/var/db/dhcpd_leases`, can be converted to JSON using `cat /var/db/dhcpd_leases | sed -e 's/\t\(.*\)=\(.*\)/"\1": "\2",/g' | tr -d '\n' | sed -E 's:,(\s*}):\1:g' | jq`
# Configuration is stored at `/Library/Preferences/SystemConfiguration/com.apple.vmnet.plist`
echo "* Don't forget to create network device manually!"
