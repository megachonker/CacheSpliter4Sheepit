#!/bin/sh
echo "fichier cache du  blender"
#blender-temp
pmv(){
    source=$1;
    target=$2;
    mkdir -p "$target"/"$(dirname $source)"
    mv "$source" "$target"/"$(dirname $source)"/
}
export -f pmv

cd $1
rm .swp
compte=1
var=../partie-1
mkdir $var
while true ;do
	while [ $(du  -s|grep [0-9]*  -o) -gt 500000 ]; do
		find -type f|sort  -t 0 -k 2|tail -n  3|xargs -I {} -t bash -c 'pmv "$@"' _ {} $var
	done
	curant=$PWD
	foldername=$(echo ../part_$(find -type f|head -n 1|grep [0-9]* -o)-$(find -type f|tail  -n 1 |grep  [0-9]*  -o))
	cd $var
	mv $curant $foldername

	if [ $(du  -s|grep [0-9]*  -o) -lt 500000 ];then
		break
	fi

	var=../partie-$((compte+=1))
	mkdir $var
done
cd ..
find -type d -maxdepth 1 -regex ".*part_.*"|xargs -I {} zip {}.zip {} *.blend -r


for i in part_*; do
rm cache
cp  $i cache
zip Packed-$i.zip *.blend cache/ -r
done
