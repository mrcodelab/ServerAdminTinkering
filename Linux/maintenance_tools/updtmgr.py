# This is the controller for all linux systems to choose the update type
import subprocess as sproc
import os
import datetime

meee = os.getlogin()
logfile = os.path.isfile("/home/{}/Documents/initlog.txt".format(meee))
now = datetime.datetime.now()

if logfile:
    sproc.run(["rm", "-f", "/home/{}/Documents/initlog.txt".format(meee)])
    sproc.run(["touch", "/home/{}/Documents/initlog.txt".format(meee)])
else:
    sproc.run(["touch", "/home/{}/Documents/initlog.txt".format(meee)])


def osName():
    f = open('/etc/os-release')
    fullName = f.readlines()
    inp_str = fullName[2]
    preName = inp_str.strip("ID=")
    osName = preName.strip()
    return osName


def dUpt():
    sproc.call(["sudo", "apt", "autoclean"])
    sproc.call(["sudo", "apt", "autoremove", "--yes"])
    sproc.call(["sudo", "apt-get", "update"])
    sproc.call(["sudo", "apt-get" "upgrade", "--yes"])


def pUpt():
    sproc.call(["sudo", "parrot-upgrade", "--yes"])


def zUpt():
    sproc.call(["sudo", "zypper", "update", "-y"])


def udat(vern):
    if (vern == "Debian") or (vern == "Linux Debian") or \
            (vern == "Linux Mint") or (vern == "Ubuntu"):
        dUpt()
    elif (vern == "Parrot") or (vern == "Linux Parrot") \
            or (vern == "ParrotOS"):
        pUpt()
        dUpt()
    elif vern == "opensuse":
        zUpt()
    elif vern == "fedora":
        sproc.call(["sudo", "dnf", "up", "-y"])
        print("update completed for " + vern)
    else:
        print("didn't run any updates")


udat(osName())

"""
try:
   # sproc.run(["sudo", "freshclam"])
   print(" ")
   print(now.strftime('%Y-%m-%d %H:%M'))
   print("clamscan started")
   print(" ")
   sproc.run(["sudo", "bash", "/etc/myScripts/cleaner"])
except:
   print("ClamAV Not Installed")
   pass
"""

print("Done with startup/updates/clamscan - not installed right now")
print(now.strftime('%Y-%m-%d %H:%M'))
