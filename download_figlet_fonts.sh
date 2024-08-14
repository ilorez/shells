#!/bin/bash
# clear console
clear

# test if write_my_name.sh is found and executable
#  if not found, exit with nothing
#  if found run command
if [ -x ./write_my_name.sh ]; then
  ./write_my_name.sh -n "Download Figlet Fonts" -f standard -nfn -c cyan
fi

# Function to check if figlet is installed
check_figlet() {
  if ! command -v figlet &>/dev/null; then
    echo "figlet could not be found, installing..."
    if ! sudo pacman -S figlet; then
      echo "Failed to install figlet. Please install it manually."
      exit 1
    fi
  fi
}

# Function to check if required tools are installed
check_dependencies() {
  local deps=("wget" "pv")
  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      echo "$dep is required but not installed. Installing..."
      if ! sudo pacman -S "$dep"; then
        echo "Failed to install $dep. Please install it manually."
        exit 1
      fi
    fi
  done
}

# Function to get the figlet fonts directory
get_fonts_dir() {
  figlet -I2
}

# Function to get list of installed fonts
get_installed_fonts() {
  local fonts_dir
  fonts_dir=$(get_fonts_dir)
  find "$fonts_dir" -type f -name "*.flf" -exec basename {} .flf \;
}

# Function to download a single font
download_font() {
  local font=$1
  local font_dir=$2
  wget -q "http://www.figlet.org/fonts/${font}.flf" -O "${font_dir}/${font}.flf" || {
    echo "Failed to download $font font."
    return 1
  }
  echo "$font font installed."
}

# Function to download fonts in parallel
download_fonts_parallel() {
  local font_dir=$1
  shift
  local fonts=("$@")
  local total=${#fonts[@]}
  local downloaded=0

  (
    for font in "${fonts[@]}"; do
      ((i = i % 10))
      ((i++ == 0)) && wait
      download_font "$font" "$font_dir" &
      echo "$font"
    done
    wait
  ) | pv -l -s "$total" >/dev/null
}

# Function to check if a font is actually usable
is_font_usable() {
  local font=$1
  if figlet -f "$font" "test" &>/dev/null; then
    return 0 # Font is usable
  else
    return 1 # Font is not usable
  fi
}

# List of all fonts to be downloaded
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

# Main script
main() {
  check_figlet
  check_dependencies

  local font_dir
  font_dir=$(get_fonts_dir)
  local custom_dir=false

  # Parse command line arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
    -d | --directory)
      font_dir="$2"
      custom_dir=true
      shift 2
      ;;
    *)
      break
      ;;
    esac
  done

  # Create font directory if it doesn't exist
  if [[ $custom_dir == true ]]; then
    mkdir -p "$font_dir"
  elif [[ ! -w "$font_dir" ]]; then
    echo "Error: No write permission for $font_dir. Please run with sudo or use --directory option."
    exit 1
  fi

  # Get list of installed fonts
  local installed_fonts=($(get_installed_fonts))
  echo "Fonts reported by figlist: ${#installed_fonts[@]}"

  # Determine which fonts to download
  local fonts_to_download=()

  # Add fonts from all_fonts array that are not installed or not usable
  for font in "${all_fonts[@]}"; do
    if [[ ! " ${installed_fonts[@]} " =~ " ${font} " ]] || ! is_font_usable "$font"; then
      fonts_to_download+=("$font")
    fi
  done

  # Add fonts from figlist that are not in all_fonts and not usable
  for font in "${installed_fonts[@]}"; do
    if [[ ! " ${all_fonts[@]} " =~ " ${font} " ]] && ! is_font_usable "$font"; then
      fonts_to_download+=("$font")
    fi
  done

  # Remove duplicates from fonts_to_download
  fonts_to_download=($(echo "${fonts_to_download[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

  # Download fonts
  if [ ${#fonts_to_download[@]} -eq 0 ]; then
    echo "No new fonts to download."
  else
    echo "Downloading ${#fonts_to_download[@]} fonts..."
    download_fonts_parallel "$font_dir" "${fonts_to_download[@]}"
  fi

  echo "Font installation complete."

  # Check for any remaining unusable fonts
  local unusable_fonts=()
  for font in "${installed_fonts[@]}"; do
    if ! is_font_usable "$font"; then
      unusable_fonts+=("$font")
    fi
  done

  if [ ${#unusable_fonts[@]} -gt 0 ]; then
    echo "The following fonts are still not usable after download attempt:"
    for font in "${unusable_fonts[@]}"; do
      echo "  - $font"
    done
    echo "These may be control files, special encodings, or might require additional configuration."
  fi
}

main "$@"
