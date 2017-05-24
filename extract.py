#!/usr/bin/python3
import os
import shutil
import subprocess
import sys

def chdir_to_install_dir():
    install_dir = "nice2_install"

    # create install dir
    if os.path.exists(install_dir):
        shutil.rmtree(install_dir)
    os.mkdir(install_dir)
    os.chdir(install_dir)


def install_nice2():
    # extract nice2
    # module tarfile does not appear to support the format used by us
    gz_file = "../customer/{0}/target/nice2-customer-{0}-1.0-SNAPSHOT.tar.gz".format(sys.argv[1])
    subprocess.check_call(["tar", "--strip-components=1", "-xf", gz_file])
    os.makedirs("var/cache/reports")

    # create java.policy
    with open("java.policy", "w") as f:
        print("grant { permission java.security.AllPermission; };", file=f)

    # create hikiricp.local.properties
    with open("etc/hikaricp.local.properties", "w") as f:
        print("dataSource.databaseName={}".format(sys.argv[2]), file=f)
        print("dataSource.user=dbref", file=f)
        print("dataSource.password=ra6fooVe", file=f)


if __name__ == '__main__':
    chdir_to_install_dir()
    install_nice2()
