## Create lightweight, portable, self-sufficient [desktop] environment.
**How?**

1. Install a clean Debian Jessie system
  - Unmark **all** options in the package selection list
2. Log in as `root` and run:
  ```shell
  wget --no-check-certificate -O install.sh http://git.io/vYz9n
  wget --no-check-certificate -O packages http://git.io/vYz9C
  chmod +x install.sh

  # Edit `packages` to add or remove any packages you want
  ./install.sh
  # Follow the setup
  ```
3. In the `kexec` menu, choose `Yes` and press `Enter`.
4. Wait a few minutes
5. Reboot your system


## Notes
  - The default `packages` file, adds Xorg and Xfce desktop
  - Oracle's Java binaries **will** take a while to download, just wait
  - This will install ~850 packages in the default setup, get a cup of coffee
  - The application will exit in any error, if any package fails just start over with `./install.sh`
  - A install log is saved in `install.log`
