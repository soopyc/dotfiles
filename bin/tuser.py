#!/bin/env python
# VERY CRAPPY script for creating and using a temporary user directory
import platform
import subprocess
import sys
import tempfile
import os
import pwd
import getpass
import shutil


def pf(*args, **kwargs):
    kwargs['end'] = ''
    print(*args, **kwargs)


def main():
    print('[-] welcome')
    print('[i] you may need sudo permissions to run this script.\n')

    print('[i] checking operating system... ')
    uname = platform.uname()
    print(f'[i] You are currently using {uname.system} {uname.release} on {uname.node} {uname.machine}')
    if uname.system != 'Linux':
        print(f'[!] Your operating system ({uname.system}) is incompatible with this script.')
        return 1

    pf('[i] checking if user exists... ')
    try:
        pd = pwd.getpwnam('sur')
    except KeyError:
        print('no')
        print('[!] This script requires a user named "sur" to exist. You may create it with the following command:')
        print('[!] sudo groupadd -fg900 sur && sudo useradd -NMld /tmp/tuser -u900 -g900 sur')
        print('[!] Adapt the command as needed.')
        return 0
    else:
        print(f'yes, uid:{pd.pw_uid} gid:{pd.pw_gid}')

    pf('[i] creating required directories... ')
    try:
        os.makedirs('/tmp/tuser', mode=0o777, exist_ok=True)
    except PermissionError:
        pf('failed, attempting to use sudo... ')
        subprocess.run(f'sudo mkdir -p /tmp/tuser -m 777'.split())
    print('done')

    pf('[i] initializing temporary directory... ')
    tdir = tempfile.TemporaryDirectory(prefix=getpass.getuser(), dir='/tmp/tuser')
    pf(tdir.name + ', changing permissions... ')
    try:
        os.chown(tdir.name, pd.pw_uid, pd.pw_gid)
    except PermissionError:
        print('failed, attemping to use sudo...')
        subprocess.run(f'sudo chown {pd.pw_uid}:{pd.pw_gid} {tdir.name}'.split())
    print('done')

    pf('[i] finalizing configs... ')
    envr = os.environ
    envr['HOME'] = tdir.name
    print('setup OK')
    print('[i] spawning shell... [sudo]')
    subprocess.run('sudo -u sur -E bash'.split(), env=envr)
    
    print('[i] shell exited, performing cleanups...')
    try:
        tdir.cleanup()
    except PermissionError:
        print('[i] unable to remove directory, attempting to fix...')
        print('[i] [Attempt 1] return temp dir ownership [sudo]')
        subprocess.run(f'sudo chown {getpass.getuser()} {tdir.name} -R'.split())

        print('[i] attempting cleanup again...')
        # tdir.cleanup()

    pf('[i] making sure the directory is gone... ')
    shutil.rmtree(tdir.name, onerror=lambda fn,path,ei: print(f"[!] unable to remove file {path}"))  # noqa
    print('done')
    print('[-] completed, exiting')

    return 0


if __name__ == "__main__":
    sys.exit(main())

