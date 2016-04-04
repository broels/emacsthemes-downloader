# emacsthemes-downloader

A script to crawl through all of the recipes hosted over at [Emacs Themes](https://emacsthemes.com/) and download each, copying them into the specified theme directory.

## usage

Usage: `perl emacsthemes-downloader.pl`

Make sure you configure `$recipe_dest` and `$themes_dest` appropriately.

To use these themes, you may need some additional elisp in your init file.

To load the directory with all of the downloaded themes when Emacs is started:
```
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
```

To try out themes one-by-one (thanks to [u/bakuretsu](https://www.reddit.com/r/emacs/comments/30b67j/how_can_you_reset_emacs_to_the_default_theme/cpr8bsn):
```
(defun load-only-theme ()
  "Disable all themes and then load a single theme interactively."
  (interactive)
  (while custom-enabled-themes
    (disable-theme (car custom-enabled-themes)))
  (call-interactively 'load-theme))
```

## notes

This script will **not** work with certain themes, if you experience any issues when trying to load a theme more likely than not you'll need to install the package the theme is included in. Sorry.

## license

This project is licensed under the terms of the BSD license.

