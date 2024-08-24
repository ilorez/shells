#!/bin/sh

# colors
printf "\e[0;30mBlack \e[1;30mbold Black \e[0;90mhigh intensity Black\n"
printf "\e[0;31mRed \e[1;31mbold Red \e[0;91mhigh intensity Red\n"
printf "\e[0;32mGreen \e[1;32mbold Green \e[0;92mhigh intensity Green\n"
printf "\e[0;33mYellow \e[1;33mbold Yellow \e[0;93mhigh intensity Yellow\n"
printf "\e[0;34mBlue \e[1;34mbold Blue \e[0;94mhigh intensity Blue\n"
printf "\e[0;35mPurple \e[1;35mbold Purple \e[0;95mhigh intensity Purple\n"
printf "\e[0;36mCyan \e[1;36mbold Cyan \e[0;96mhigh intensity Cyan\n"
printf "\e[0;37mWhite \e[1;37mbold White \e[0;97mhigh intensity White\n"

# background colors
printf "\e[0;40mBlack \e[1;40mbold Black \e[0;100mhigh intensity Black\n"
printf "\e[0;41mRed \e[1;41mbold Red \e[0;101mhigh intensity Red\n"
printf "\e[0;42mGreen \e[1;42mbold Green \e[0;102mh\e[0;30igh intensity Green\n"
printf "\e[0;43mYellow \e[1;43mbold Yellow \e[0;103mhigh intensity Yellow\n"

# text attributes
printf "\e[0;4mUnderline \e[1;4mbold Underline \e[0;24mUnderline off\n"
printf "\e[0;7mInverse \e[1;7mBold Inverse \e[0;27mInverse off\n"
printf "\e[0;9mStrikethrough \e[1;9mBold Strikethrough \e[0;29mStrikethrough off\n"
printf "\e[0;53mOverline \e[1;53mBold Overline \e[0;55mOverline off\n"
printf "\e[0;22mNormal \e[1;22mBold Normal\n"
printf "\e[0;23mNot italic \e[3mItalic \e[23mNot italic\n"
printf "\e[0;39mDefault \e[1;39mBold Default\n"

# cursor movement
#printf "\e[2J" # clear screen

# reset
printf "\e[0m"
