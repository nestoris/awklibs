## library for reading ini data from files, multistring variables, or stream

# examples (I use arraytree.awk for exploring arrays as colourful trees):

## qmmp player shows it's status as ini data. Let's convert is to an awk array!
# gawk -i ini -i arraytree 'BEGIN{while(("qmmp --status"|getline)>0){st=st (st?"\n":"") $0};readini(st,arr);arraytree(arr,"arr")}'

## Let's do it by the pipe from stdout!
# qmmp --status|gawk -i ini -i arraytree '{streamini($0,arr)}END{arraytree(arr,"arr")}'

## Reading Windows 3.11 ini file (loading C library for reading files)
# gawk -l readfile -i ini -i arraytree 'BEGIN{winini=readfile("/mnt/dos/windows/win.ini");readini(winini,arr);arraytree(arr,"arr")}'

## Reading Windows 3.11 ini file without any gawk C plugins (more safe!)
# gawk -i ini -i arraytree 'BEGIN{readinif("/mnt/dos/windows/win.ini",arr);arraytree(arr,"arr")}'

### Comments and commented strings are ignored and removed!

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


### TODO! Currently not supported ini data with spaces arround "=" symbol and values containing "=" symbol!!! Or supported? Let's test!

function readini(data,arr,	da,	i,	vall,	varr,sect){	#read ini data as variable
	split(data,da,"\n")
	for(i in da){
		if(da[i]!~"^#|^;|^$"){
			gsub(" *[;#].*$","",da[i])
			gsub(/ *$/,"",da[i])
			if(da[i]~/^\[.*\]$/){
				sect=da[i];gsub(/^\[|\].*$/,"",sect)
			}else{
				varr=vall=da[i]
				gsub(/ *=.*$/,"",varr)
				gsub(/^[^=]*= */,"",vall)
				arr[sect][varr]=vall
				#split(da[i],va,"=");arr[sect][va[1]]=va[2]
			}
		}
	}
}

function streamini(_r,arr,	var,val,sect){ # read ini from stdin/stdout and transform it to second argument array
	if(_r!~"^#|^;|^$"){
		gsub(" *[;#].*$","",_r)
		if(_r~/^\[.*\]$/){
			sect=_r;gsub(/^\[|\].*$/,"",sect)
		}else{
			varr=vall=_r
			gsub(/ *=.*$/,"",varr)
			gsub(/^[^=]*= */,"",vall)
			arr[sect][varr]=vall
#			split(_r,va,"=");arr[sect][va[1]]=va[2]
		}
	}
}

function readinif(file,arr,	rs,var,val,sect,varr,vall){	#read ini file and convert it to a 2D gawk array.
	rs=RS
	RS="\n|\r"
	while((getline<file)>0){
		if($0!~"^#|^;|^$"){
			gsub(" *[;#].*$","")
			if($0~/^\[.*\]$/){
				sect=$0;gsub(/^\[|\].*$/,"",sect);arr[sect]["#"]
				delete arr[sect]["#"]
			}else{
				varr=vall=$0
				gsub(/ *=.*$/,"",varr)
				gsub(/^[^=]*= */,"",vall)
				arr[sect][varr]=vall
#				split($0,va,"=");arr[sect][va[1]]=va[2]
			}
		}
	}
	RS=rs
}

function readinif_flat(file,arr,delimiter,	rs,sect,a){	# read ini file and convert it to a 1D associative array.
	delimiter?"":delimiter=":" # default delimiter is ":"
	rs=RS
	RS="\n|\r"
	while((getline<file)>0){
		if($0!~"^#|^;|^$"){
			gsub(" *[;#].*$","")
			if(match($0,/^\[(.*)\]/,a)){
				sect=a[1]
			}else{
				gsub(/ *$/,"") # delete spaces at end
				match($0,/ *([^ $]*) *= *(.*)$/,a) # get (parameter) and (value)
				arr[sect delimiter a[1]]=a[2]
			}
		}
	}
	RS=rs
}

function doini_flat(arr,delimiter,sys,	i,j,k,out,rs,aini,a){ # make ini from flat array array[section:parameter]="data"
	delimiter?"":delimiter=":" # default delimiter is ":"
	for(i in arr){
		#print i
		if(match(i,"([^"delimiter"]*)"delimiter"(.*)",a))
		#print a[1], a[2], arr[i]
		aini[a[1]][a[2]]=arr[i]
	}
	rs=(sys=="w"?"\r\n":sys=="m"?"\r":"\n")
	for(i in aini){
		k++
		if(isarray(aini[i])){
			out=out (k>1?rs rs:"") "["i"]"
			for(j in aini[i]){
				out=out rs j"="aini[i][j]
			}
		}
	}
	return out
}

function printini(arr,	i,	j,	k){
	if(isarray(arr)){
		for(i in arr){
			k++
			if(isarray(arr[i])){
				print (k>1?"\n":"") "["i"]"
				for(j in arr[i]){
					print j"="arr[i][j]
				}
			}
		}
	}
}

function doini(arr,sys,	i,	j,	out,	rs){ # Create ini file: arr -- input array, sys -- newline symbol for system (w -- Windows, m -- Mac, any other -- Unix/Linux)
rs=(sys=="w"?"\r\n":sys=="m"?"\r":"\n")
	if(isarray(arr)){
		for(i in arr){
			if(isarray(arr[i])){
				out=out (out?rs rs:"") "["i"]"
				for(j in arr[i]){
					out=out rs j"="arr[i][j]
				}
			}
		}
	}
return out
}
