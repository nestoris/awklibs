## library for reading ini data from files, multistring variables, or stream

# examples (I use arraytree.awk for exploring arrays as colourful trees):

## qmmp player shows it's status as ini data. Let's convert is to an awk array!
# gawk -i ini -i arraytree 'BEGIN{while(("qmmp --status"|getline)>0){st=st (st?"\n":"") $0};readini(st,arr);arraytree(arr,"arr")}'

## Let's do it by the pipe from stdout!
# qmmp --status|gawk -i ini -i arraytree '{streamini($0,arr)}END{arraytree(arr,"arr")}'

## Reading Windows 3.11 ini file (loading C library for reading files)
# gawk -l readfile -i ini -i arraytree 'BEGIN{winini=readfile("/mnt/dos/windows/win.ini");readini(winini,arr);arraytree(arr,"arr")}'

## Reading Windows 3.11 ini file without aany gawk C plugins (more safe!)
# gawk -i ini -i arraytree 'BEGIN{readinif("/mnt/dos/windows/win.ini",arr);arraytree(arr,"arr")}'

### Comments and commented strings are ignored!

## Write array to ini file (only 2-dimensional arrays!)
# #!/usr/bin/gawk
# BEGIN{printini(arr) > "/mnt/dos/windows/win.ini"}

## Build ini data for Linux/BSD (LF) ini file
# #!/usr/bin/gawk
# BEGIN{inidata=doini(arr);print inidata > "/home/user/user.ini"}
## or
# BEGIN{print doini(arr) > "/home/user/user.ini"}

## Build ini data for windows (CR+LF) ini file
# #!/usr/bin/gawk
# BEGIN{inidata=doini(arr,"w");print inidata > "/mnt/dos/windows/win.ini"}

## Build ini data for old MacOS (9 or earlier) or typewriter (CR) ini file
# #!/usr/bin/gawk
# BEGIN{inidata=doini(arr,"m");print inidata > "/mnt/mac_os_9/apple.ini"}


### TODO! Currently not supported ini data with spaces arround "=" symbol and values containing "=" symbol!!!

function readini(data,arr,	da,	i){	#read ini data as variable
	split(data,da,"\n")
	for(i in da){
		if(da[i]!~"^#|^;|^$"){
			gsub(" *[;#].*$","",da[i])
			if(da[i]~/^\[.*\]$/){sect=da[i];gsub(/^\[|\].*$/,"",sect)}else{split(da[i],va,"=");arr[sect][va[1]]=va[2]}
		}
	}
}

function streamini(_r,arr){ # read ini from stdin/stdout and transform it to second argument array
	if(_r!~"^#|^;|^$"){
		gsub(" *[;#].*$","",_r)
		if(_r~/^\[.*\]$/){sect=_r;gsub(/^\[|\].*$/,"",sect)}else{split(_r,va,"=");arr[sect][va[1]]=va[2]}
	}
}

function readinif(file,arr,	rs){	#read ini file
	rs=RS
	RS="\n|\r"
	while((getline<file)>0){
		if($0!~"^#|^;|^$"){
			gsub(" *[;#].*$","")
			if($0~/^\[.*\]$/){sect=$0;gsub(/^\[|\].*$/,"",sect)}else{split($0,va,"=");arr[sect][va[1]]=va[2]}
		}
	}
	RS=rs
}

function printini(arr,	i,	j){
	if(isarray(arr)){
		for(i in arr){
			if(isarray(arr[i])){print "["i"]";for(j in arr[i]){print j"="arr[i][j]}}
		}
	}
}

function doini(arr,sys,	i,	j,	out){
rs=(sys=="w"?"\r\n":sys=="m"?"\r":"\n")
	if(isarray(arr)){
		for(i in arr){
			if(isarray(arr[i])){out="["i"]";for(j in arr[i]){out="\n"j"="arr[i][j]}}
		}
	}
return out
}
