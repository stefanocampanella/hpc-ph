#! /bin/bash

if [ -f index.md ]
then
  rm index.md
fi

while read -r line
do
	cat "src/${line}" >> index.md
	echo -ne "\n\n" >> index.md
done < src/contents.txt

rm -rf hpc-phys

exit 0
