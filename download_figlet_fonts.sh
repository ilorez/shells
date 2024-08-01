#!/bin/bash

# Function to check if figlet is installed
check_figlet() {
  if ! command -v figlet &>/dev/null; then
    echo "figlet could not be found, installing..."
    sudo pacman -S figlet
  fi
}

# Function to download a single font
download_font() {
  font=$1
  wget -q http://www.figlet.org/fonts/$font.flf -O /tmp/$font.flf
  if [ -f /tmp/$font.flf ]; then
    sudo mv /tmp/$font.flf /usr/share/figlet/
    echo "$font font installed."
  else
    echo "Failed to download $font font."
  fi
}

# List of all fonts to be downloaded if no arguments are provided
all_fonts=(
  "3-d" "3x5" "5lineoblique" "acrobatic" "alligator" "alligator2" "alphabet"
  "avatar" "banner" "banner3-D" "banner3" "banner4" "barbwire" "basic" "bell"
  "big" "bigchief" "binary" "block" "bubble" "bulbhead" "calgphy2" "caligraphy"
  "catwalk" "chunky" "coinstak" "colossal" "computer" "contessa" "contrast"
  "cosmic" "cosmike" "cricket" "cyberlarge" "cybermedium" "cybersmall"
  "diamond" "digital" "doh" "doom" "dotmatrix" "drpepper" "eftichess" "eftifont"
  "eftipiti" "eftirobot" "eftitalic" "eftiwall" "eftiwater" "epic" "fender"
  "fourtops" "fuzzy" "goofy" "gothic" "graffiti" "hollywood" "invita"
  "isometric1" "isometric2" "isometric3" "isometric4" "italic" "ivrit" "jazmine"
  "jerusalem" "katakana" "kban" "larry3d" "lcd" "lean" "letters" "linux"
  "lockergnome" "madrid" "marquee" "maxfour" "mike" "mini" "mirror" "mnemonic"
  "morse" "moscow" "nancyj-fancy" "nancyj-underlined" "nancyj" "nipples"
  "ntgreek" "o8" "ogre" "pawp" "peaks" "pebbles" "pepper" "poison" "puffy"
  "pyramid" "rectangles" "relief" "relief2" "rev" "roman" "rot13" "rounded"
  "rowancap" "rozzo" "runic" "runyc" "sblood" "script" "serifcap" "shadow"
  "short" "slant" "slide" "slscript" "small" "smisome1" "smkeyboard" "smscript"
  "smshadow" "smslant" "smtengwar" "speed" "stampatello" "standard" "starwars"
  "stellar" "stop" "straight" "tanja" "tengwar" "term" "thick" "thin"
  "threepoint" "ticks" "ticksslant" "tinker-toy" "tombstone" "trek" "tsalagi"
  "twopoint" "univers" "usaflag" "weird"
)

# Check if figlet is installed
check_figlet

# Download specified fonts or all fonts if no arguments are given
if [ "$#" -eq 0 ]; then
  for font in "${all_fonts[@]}"; do
    download_font "$font"
  done
else
  for font in "$@"; do
    download_font "$font"
  done
fi
