.PHONY: all

all:
	coffee -b -p -c src/summary.coffee > dist/summary.js
