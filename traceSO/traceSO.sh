#/bin/bash
#Author: Patrick Almeida
#The "ldd" command gives you all the shared objects used by
#a binary, but what if you want to go the other way?
#With "traceSO" you just need to pass your desired shared object 
#as an argument to the shell script and then it will loop all over
#your binaries(from "PATH" variable), execute "ldd" and search for
#what you are looking for. Once it finds it, "traceSO" will prompt
#all the binaries that need the shared object you were looking for.

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

for ((j=1;j<=$(echo $PATH | awk -F ':' '{print NF}');j++)); do
	cur_dir=$(cut -d":" -f$j <<< $PATH)
	for i in $(ls $cur_dir); do
		lib=$(ldd $cur_dir/$i 2> /dev/null | grep -i $1)
		if [[ $? -eq 0 ]]; then
			echo "############### $cur_dir/$i"
			echo "$lib"
			echo ""
		fi
	done
done
