from pathlib import Path
from subprocess import check_output, CalledProcessError
from json import loads

WLAN_NAME = "NJU-WLAN"
if (
    WLAN_NAME
    not in check_output(["networksetup", "-getairportnetwork", "en0"]).decode()
):
    exit(1)

TARGET_MAC = "TARGET_MAC"
SSH_FILE = Path.home() / ".ssh/config"
HOST_PATTERN = "HOST_PATTERN"

try:
    token = loads(
        check_output(
            [
                "curl",
                "-s",
                "http://p2.nju.edu.cn/api/portal/v1/login",
                "-d",
                '{"domain":"default","username":"USERNAME","password":"PASSWORD"}',
            ]
        ).decode()
    )["results"]["acctstarttime"]
except (CalledProcessError, KeyError):
    exit(2)

try:
    devices = loads(
        check_output(
            [
                "curl",
                "-s",
                "http://p2.nju.edu.cn/api/selfservice/v1/online",
                "-G",
                "-d",
                f'{{"_":"{token}"}}',
            ]
        ).decode()
    )["results"]["rows"]
except (CalledProcessError, KeyError):
    exit(3)

for device in devices:
    if device["mac"] == TARGET_MAC:
        break
else:
    exit(4)

ip_number = bin(device["user_ipv4"])[2:]
ip_string = ".".join(str(int(ip_number[i : i + 8], base=2)) for i in range(0, 25, 8))

print(".".join(ip_string.split(".")[:2]) + ".0.1", end=" ")
print(ip_string)

with SSH_FILE.open() as file:
    content = file.readlines()

changed = False
for line in range(1, len(content)):
    if HOST_PATTERN in content[line - 1] and ip_string not in content[line]:
        changed = True
        content[line] = f"  HostName {ip_string}\n"

if changed:
    with SSH_FILE.open("w") as file:
        file.writelines(content)
