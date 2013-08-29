for x in *.xbm; do convert $x `printf $x | sed s/.xbm/.png/g`; done
