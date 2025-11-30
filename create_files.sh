#!/usr/bin/env bash

current_year=$(date +'%Y')
mkdir "${current_year}"
test -d "${current_year}" && cd "${current_year}"
first_day=1
last_day=12

for i in $(seq "${first_day}" "${last_day}");do
	mkdir "day${i}"
	cd "day${i}"
	second=2
	#if ((i == last_day)); then second=1; fi
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
