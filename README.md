## Numix Frost
##### A modern flat theme with a combination of light and dark elements. It supports GNOME, Cinnamon, Xfce, and Openbox.
[![By The Numix Project](https://img.shields.io/badge/By-The%20Numix%20Project-f0544c.svg?style=flat-square)](https://numixproject.org/) &nbsp;[![In collaboration with: antergos](https://img.shields.io/badge/By-antergos-205ebc.svg?style=flat-square)](https://antergos.com/) &nbsp;[![Circle CI](https://img.shields.io/circleci/project/antergos/numix-frost/master.svg?circle-token=b14acf911433d315298235b0c2fbf7b2670a92a8&maxAge=2592000&style=flat-square)](https://circleci.com/gh/antergos/numix-frost/tree/master) &nbsp;![Supports GTK+ 3.18](https://img.shields.io/badge/GTK%2B-3.18-4a90d9.svg?style=flat-square) &nbsp;![Supports GTK+ 3.20](https://img.shields.io/badge/GTK%2B-3.20-4a90d9.svg?style=flat-square)

### Manual installation
First, you need to compile the theme using the [Sass](http://sass-lang.com/) compiler.

To install Sass, install ruby and the gem command using your distro's package manager. Then install `sass` with the `gem` command,

`gem install sass`

You'll also need the ```glib-compile-schemas``` and  ```gdk-pixbuf-pixdata``` commands in your path to generate the gresource binary. Install them using your distribution's package manager.

#### Debian, Ubuntu

 ```sh
sudo apt-get install libglib2.0-dev libgdk-pixbuf2.0-dev libxml2-utils
```

#### Fedora

```sh
sudo dnf install glib2-devel gdk-pixbuf2-devel
```

#### Arch Linux

```sh
sudo pacman -S glib2 gdk-pixbuf2
```

After installing all the dependencies, switch to the cloned directory and, run the following in Terminal,

```sh
make
sudo make install
```

To set the theme in Gnome, run the following commands in Terminal,

```sh
gsettings set org.gnome.desktop.interface gtk-theme "Numix-Frost"
gsettings set org.gnome.desktop.wm.preferences theme "Numix-Frost"
```

To set the theme in Xfce, run the following commands in Terminal,

```sh
xfconf-query -c xsettings -p /Net/ThemeName -s "Numix-Frost"
xfconf-query -c xfwm4 -p /general/theme -s "Numix-Frost"
```

### For developers

If you want to hack on the theme, make sure you have the `inotifywait` command available, which is used for watching and automatically building the files.

To start watching for changes, run the following,

```sh
make watch
```

If you change any assets, you'll need to regenerate the `gtk.gresource.xml` and `gtk.gresource` files. You can use [grrr](https://github.com/satya164/grrr) to do it easily.

### Code and license

Report bugs or contribute at [GitHub](https://github.com/shimmerproject/Numix)

License: GPL-3.0+
