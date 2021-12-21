function readini(data,arr,	da,	i){	#read ini data as variable
	split(data,da,"\n")
	for(i in da){
		if(da[i]!~"^#|^;|^$"){
			gsub(" *[;#].*$","",da[i])
			if(da[i]~/^\[.*\]$/){sect=da[i];gsub(/^\[|\].*$/,"",sect)}else{split(da[i],va,"=");arr[sect][va[1]]=va[2]}
		}
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

function writeini(arr,	i,	j){
	if(isarray(arr)){
		for(i in arr){
			if(isarray(arr[i])){print "["i"]";for(j in arr[i]){print j"="arr[i][j]}}
		}
	}
}
