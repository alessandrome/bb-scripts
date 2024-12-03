#!/bin/bash

curl -s "https://www.shodan.io/domain/$1" | sed -n '/<table[^>]*>/,/<\/table>/p' | sed ':a;N;$!ba;s/\n/ /g' | sed 's/  */ /g' | sed 's/<tr[^>]*>/\n/g' | sed 's/<span class="ports">/ /g' | sed 's/<span class="tag bg-primary">//;  :nt s/<span class="tag bg-primary">/-/; t nt;' | sed 's/<[^>]*>//g' | sed 's/^ //' | sed 's/^  /Sub-Domain;Record;Value;Port;Extra-Info/' | sed 's/ /;/g'
