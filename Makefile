CC=pandoc
FLAGS=--standalone --normalize --smart --toc

all: html pdf tex doc
default: document.pdf
html: index.html
pdf: document.pdf
tex: document.tex
doc: document.odt


index.md: assemble.sh src/*.md src/*.txt src/*.yml
	@echo "Assembling sources..."
	@./assemble.sh

index.html: index.md assemble.sh main.css 
	@echo "Compiling with pandoc..."
	@$(CC) $(FLAGS) -c main.css $< -o $@ 

document.%: index.md
	@echo "Compiling with pandoc..."
	@$(CC) $(FLAGS) $< -o $@ 

