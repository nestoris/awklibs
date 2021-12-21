#!/usr/bin/awk -f
function _rne(rusnum,raz,dva,mnogo,nol){ # Russian Number Endings (rusnum=number; raz -- ending for 1, 21, 101, etc; dva -- 2-4, 22-24, 102-104...; mnogo -- 0, 5-20, 25-30, 95-100...)
 rusnum_tmp[1]=substr(rusnum,length(rusnum),1) #getting units
 rusnum_tmp[2]=substr(rusnum,length(rusnum)-1,1) #getting tens
 rusnum_tmp[1]=rusnum_tmp[1]/1 #converting string to number
 rusnum_tmp[2]=rusnum_tmp[2]/1
 if(rusnum==0&&nol){
  outrusend=nol
 }else{
  if(rusnum_tmp[1]==1&&(rusnum_tmp[2]!=1||length(rusnum)==1)){
   outrusend=raz
  }else{
   if(rusnum_tmp[1]<=4&&rusnum_tmp[1]>=2&&rusnum_tmp[2]!=1){outrusend=dva}else{outrusend=mnogo}
  }
 }
 return outrusend;
}

function rne_pf(rn,u1,u2,u5,u40,u200,u500,u1000,u2000,u0){
#u1: 1,21,31,101
#u2: 2-4,22-24,102-104
#u5: 5-20,25-30,105-120
#u40: 40,140,90,100
#u200: 200,1200,300,400
#u500: 500,1500,5000,11000,105000,5000000,25000000
#u1000: 1000,121000
#u2000: 2000,22000

 unit=substr(rn,length(rn),1) #getting units
 unit=unit/1 #converting string to number
 ten=substr(rn,length(rn)-1,1) #getting tens
 ten=ten/1
 ten0=unit!=0||length(rn)<2?"":substr(rn,length(rn)-1,2) #круглые десятки
 ten0=ten0/1
 hun=ten0!=0||length(rn)<3?"":substr(rn,length(rn)-2,3)
 hun=hun/1
 thu=hun!=0||length(rn)<4?"":substr(rn,length(rn)-3,4)
 thu=thu/1
 tthu=length(rn)<5?"":substr(rn,length(rn)-4,1)
 tthu=tthu/1
 pmil=length(rn)<8?"":substr(rn,length(rn)-5,6)
 pmil=pmil/1
 mil=length(rn)<7?"":substr(rn,length(rn)-6,7)
 mil=mil/1
 rn=rn/1
 return u0&&rn==0?u0:(unit==1&&(ten!=1||length(rn)==1))?u1:(u2&&unit<5&&unit>1&&ten!=1?u2:(u40&&(ten0==40||ten0==90||hun==100)?u40:(u200&&(hun==200||hun==300||hun==400)?u200:(u1000&&ten0==0?(thu==1000&&tthu!=1?u1000:(u2000&&thu<=4000&&thu>=2000?u2000:(unit==0?(!pmil&&mil>0?"":u500):u5))):u5))))
}


function rne(rn,raz,mnogo,dva,nol){
#raz: 1,21,31,101
#dva: 2-4,22-24,102-104
#mnogo: 5-20,25-30,105-120
#nol: 0

 unit=substr(rn,length(rn),1) #getting units
 ten=substr(rn,length(rn)-1,1) #getting tens
 unit=unit/1 #converting string to number
 ten=ten/1
 rn=rn/1
 return (unit==1&&(ten!=1||length(rn)==1))?raz:(dva&&unit<5&&unit>1&&ten!=1?dva:(nol&&rn==0?nol:mnogo))
}
