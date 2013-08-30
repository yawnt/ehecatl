for x in *.xbm; do convert -transparent white -fill "#90a959" -opaque "#000000" -bordercolor transparent -border 8x8 -gravity center -crop 15x15+0+0 "${x}" "${x%.*}.png"; done
