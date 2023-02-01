#!/usr/bin/gawk -f

#########################################
#
# gawk library for converting GIO output
# data to a multi-dimensional gawk array
# gio_info: object information
# gio_dir: object listing
#
# gio_info(file,array)
# file: full/relative/URI path of file
# array: an output array, that will be
# created or recreated.
#
# gio_dir(path,array[,attributes])
# path: full/relative/URI for listing
# array: an output array, that will be
# created or recreated.
# attributes: optional list of attributes
# such as "standard::content-type" in one
# string separated by comma.
#
#########################################

function gio_info(file,arr,	pre1,	pre2){
 delete arr
 if(!file){exit -1}
 _fs=FS
 FS=": "
 cmd="LC_MESSAGES=C gio info \""file"\""
 while((cmd|getline)>0){
  if(pre1){
   if($1~/^ /&&pre1!~/^ /){
    parent=pre1
    sub(/:$/,"",parent)
   }else{
    if($1!~/^ /&&pre1~/^ /){
     parent=""
    }else{
     if(parent){
      sub(/^ */,"",pre1)
      arr[parent][pre1]=pre2
     }else{
      arr[pre1]=pre2
     }
    }
   }
  }
  pre1=$1
  pre2=$2
 }
 FS=_fs
}

function gio_dir(	file,arr,	attr,	i){
 delete arr
 _fs=FS
 FS="\t"
 while(("gio list -l \"" file"\"" (attr?" -a \"" attr "\"":"") |getline)>0){
 gsub(/[()]/,"",$3)
 arr[$1]["size"]=$2
 arr[$1]["type"]=$3
 if($4){
  patsplit($4,attra,/[^ ]*[^=]*( |$)/)
  for(i in attra){
   sub(/ $/,"",attra[i])
   split(attra[i],ana,"=")
   arr[$1]["attributes"][ana[1]]=ana[2]
  }
 }
 }
 FS=_fs
}

function gio_localpath(infile){ # Returns local path to a file (also returns localized path from URI such as "file:///home/user/%D0%92%D0%B8%D0%B4%D0%B5%D0%BE/")
	cmd="LC_MESSAGES=C gio info --attributes=\"\" '" infile "'"
	while((cmd|getline)>0){
		if(tolower($0)~/local path:/){
			gsub(/^[^/]*/,"")
			return $0
		}
	}
}
