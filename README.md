## Create lightweight, portable, self-sufficient [desktop] environment.
**How?**

Install a clean Debian Jessie system
  - Unmark all selections in the package list

Log in as `root` and run:
```shell
wget --no-check-certificate -O install.sh http://git.io/vYz9n
wget --no-check-certificate -O packages http://git.io/vYz9C
chmod +x install.sh

# Edit `packages` to add or remove any packages you want
./install.sh
# Follow the setup
```
In the `kexec` menu, choose `Yes` and press `Enter`.

Wait a few minutes, and you are done.

## Notes
  - Installing Oracle's Java binaries **will** take a while, just wait
  - The default `packages` file, adds Xorg and Xfce desktop
  - This will install ~850 packages in the default setup, get a cup of coffee
  - The application will exit in any error, if any package fails just start over with `./install.sh`
  - A install log is saved in `install.log`
