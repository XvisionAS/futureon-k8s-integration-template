#!/bin/bash

substitutions=(
	VUE_APP_BACKEND
	VUE_APP_ENV_TEST
)

uriencode()
{
	local S="${1}"
	local encoded=""
	local ch
	local o
	for i in $(seq 0 $((${#S} - 1)) )
	do
		ch=${S:$i:1}
		case "${ch}" in
			[-_.~a-zA-Z0-9])
				o="${ch}"
				;;
			*)
				o=$(printf '%%%02x' "'$ch")
				;;
		esac
		encoded="${encoded}${o}"
	done
	echo ${encoded}
}

cd /app

for var in "${substitutions[@]}"
do
  echo "$var => '${!var}'"
  uriencoded=$(uriencode ${!var})
  sed -i "s/\%24$var/$uriencoded/g" index.html
  sed -i "s%\$$var%${!var}%g" index.html
  # find . -name "app.*.js" -exec sed -i "s%\$$var%${!var}%g" {}\;
done
echo "done"
