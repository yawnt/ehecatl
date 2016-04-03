source $HOME/.zoppo/templates/zshrc

# Compress PDF
alias pdfcompress="gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -sOutputFile=$2 $1"
# Turn regular pictures into whiteboard like
alias whiteboard="convert $1 -morphology Convolve DoG:15,100,0 -negate -normalize -blur 0x1 -channel RBG -level 60%,91%,0.1 $2"
