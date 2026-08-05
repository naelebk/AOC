#!/usr/bin/env bash

if [ $# -eq 1 ]; then
	current_year="$1"
elif [ $# -eq 0 ]; then
	current_year=$(date +'%Y')
else
	echo "Erreur, mauvais nombre d'arguments. 0 ou 1"
	exit 1
fi
mkdir "${current_year}"
test -d "${current_year}" && cd "${current_year}"
first_day=1
last_day=25

for i in $(seq -w "${first_day}" "${last_day}"); do
	the_dir="day${i}"
	mkdir "${the_dir}"
	cd "${the_dir}"
	second=2
	if [[ "$i" == "${last_day}" ]]; then second=1; fi
	for j in $(seq 1 "${second}"); do
		cat <<EOF >> "part${j}.rb"
#!/usr/bin/env ruby
# part${j}.rb
require_relative '../../utils.rb'

Utils.time {
  YEAR = ${current_year}
  DAY = ${i}
  LEVEL = ${j}

  input = Utils.read_lines('day${i}-input.txt')
  sum = 0

  cookie = Utils.get_cookie
  Utils.submit_answer(YEAR, DAY, LEVEL, sum, cookie)
}
EOF
		chmod 755 "part${j}.rb"
	done
	cat <<EOF >> Makefile
COOKIE = \$(shell cat ../../.cookie.txt)
YEAR = ${current_year}
DAY = ${i}

.PHONY: input

input:
	@curl -s "https://adventofcode.com/\$(YEAR)/day/\$(DAY)/input" \
		-H "Cookie: session=\$(COOKIE)" \
		-H "User-Agent: bash-script by Nael" \
		-o "day\$(DAY)-input.txt" && \
	echo "Input day\$(DAY) récupéré" || \
	echo "Erreur day\$(DAY)"

first:
	ruby part1.rb

second:
	ruby part2.rb
EOF
	touch README.txt
	touch "day${i}-sample-input.txt"
	touch "day${i}-input.txt"
	chmod 755 *.txt
	cd ..
done
cd ..
exit 0
