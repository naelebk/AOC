COOKIE = $(shell cat ../../.cookie.txt)
YEAR = 2023
DAY = 24

.PHONY: input

input:
	@curl -s "https://adventofcode.com/$(YEAR)/day/$(DAY)/input" 		-H "Cookie: session=$(COOKIE)" 		-H "User-Agent: bash-script by Nael" 		-o "day$(DAY)-input.txt" && 	echo "Input day$(DAY) récupéré" || 	echo "Erreur day$(DAY)"
