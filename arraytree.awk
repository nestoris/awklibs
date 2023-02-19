#!/usr/bin/gawk -f
function arraytree(inputarray,arrname,	_i,member,arrnum){
 if(!isarray(inputarray)){
  print indent arrname member "[\033[1;31m\"" _i "\"\033[0m]=\"\033[1;32m" inputarray"\033[0m\""
 }else{
  arrnum=_i
  nnq=(_i+0)==_i?"":"\"" # array member or subarray name will be unquoted when contain's only digits
  member=_i?member "[" nnq _i nnq "]":""
  print indent (_i? arrname member:arrname)"(\033[1;34m" length(inputarray) " member"(length(inputarray)>_1?"s":"")"\033[0m)"
  indent=indent " "
  for(_i in inputarray){
   arraytree(inputarray[_i],arrname,_i,member,arrnum)}
   indent=substr(indent,1,length(indent)-1)
  }
}
