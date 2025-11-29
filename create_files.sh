#!/bin/bash

current_year=$(date +'%Y')
mkdir "${current_year}"
test -d "${current_year}" && cd "${current_year}"

for i in $(seq 1 25);do
	mkdir "day${i}"
	cd "day${i}"
	second=2
	if ((i == 25)); then
		second=1
	fi
	for j in $(seq 1 "${second}"); do
		echo '#!/usr/bin/env ruby' >> "part${j}.rb"
		echo "# part${j}.rb" >> "part${j}.rb"
		echo "require_relative '../../utils.rb'" >> "part${j}.rb"
		echo >> "part${j}.rb"
		chmod 755 "part${j}.rb"
	done
	touch README.txt
	touch "day${i}-sample-input.txt"
	touch "day${i}-input.txt"
	chmod 755 *.txt
	cd ..
done
cd ..
exit 0
