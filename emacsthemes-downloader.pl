# usage: perl emacsthemes-downloader.pl

use strict;
use warnings;
use JSON;

my $working = "/tmp/emacs-themes";
my $themes_source = "https://github.com/emacs-themes/emacs-themes-site.git";
my $recipe_dest = "$ENV{HOME}/.emacs.d/gits/themes";
my $themes_dest = "$ENV{HOME}/.emacs.d/themes";

# ensure the existence of destination directories
`mkdir -p $recipe_dest $themes_dest`;

# clone the emacs-themes-site repo
if (-d $working) {
  `cd $working && git pull`
} else {
  `git clone $themes_source $working`;
};

# clone all theme repos
opendir(my $clone, "$working/recipes") or die "Cannot open: $!";
my @recipes = readdir($clone);
splice(@recipes, 0, 2); # get rid of '.' and '..'
foreach (@recipes) {
  my $raw_json;
  {
    local $/;
    open(my $recipe, '<', "$working/recipes/$_") or die "Cannot open: $!";
    $raw_json = <$recipe>;
    close $recipe;
  }
  my $recipe_json = decode_json($raw_json);
  my $recipe_source = $$recipe_json{remoteSrc};
  $recipe_source =~ tr/\\//d;
  my @url = split('/', $recipe_source);
  my @repo = @url[3..4];
  $recipe_source = 'git@github.com:' . join('/', @repo) . '.git';
  my $recipe_path = $recipe_dest . '/' . $$recipe_json{name};
  if (-d "$recipe_path") {
    `cd "$recipe_path" && git pull`;
  } else {
    `git clone $recipe_source "$recipe_path"`;
  }
};

# copy the '*-theme.el's to the themes directory
`find $recipe_dest -name "*-theme.el" -type f -exec cp {} $themes_dest \\;`;
