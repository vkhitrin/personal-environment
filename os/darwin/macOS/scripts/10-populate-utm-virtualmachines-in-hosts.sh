set -eo pipefail

leases_to_jsons() {
    gsed -r 's/(\w+)=(.*)/"\1": "\2",/' /var/db/dhcpd_leases | gsed -E -n 'H; x; s:,(\s*\n\s*}):\1:; P; ${x; p}' | gsed '1 d' | jq .
}
LEASES_JSONS=$(leases_to_jsons)
for JSON in $(echo ${LEASES_JSONS} | jq -c .); do
    VM_IP="$(echo "${JSON}" | jq -r '.ip_address')"
    VM_NAME="$(echo "${JSON}" | jq -r '.name').local"
    sudo hostile set "${VM_IP}" "${VM_NAME}"
done
