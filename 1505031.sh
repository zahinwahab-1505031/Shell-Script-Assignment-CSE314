#!/bin/bash
rm -rf WorkingDirectory
mkdir WorkingDirectory
unzip "SubmissionsAll.zip" -d ./WorkingDirectory
cd WorkingDirectory
ls -l
ls > ../files.txt
#retrieve rolls from the zip files
cut -f 5 -d '_' ../files.txt|cut -f 1 -d '.'> ../submittedList.txt
#rm ../files.txt
cd ..
#retrieving first col from csv file by using delimiters
rm -rf wut.txt
while read var
do 
echo $var >> wut.txt
done < CSE_322.csv
cut -f 1 -d "," wut.txt > rosterlist.txt
rm -rf wut.txt
#awk -F "\"*,\"*" '{print $1}' CSE_322.csv|cut -f 2 -d '"' > roasterlist.txt

#sed "s/^[ \t]*//" -i roasterlist.txt
rm -rf absenteeList.txt
#check if the roll number in roaster list is in the submitted list..otherwise move that roll to absentee list
while read EachLine
do

if ! grep -q $EachLine submittedList.txt; then
    echo $EachLine >> absenteeList.txt
fi
done < roasterlist.txt
cd WorkingDirectory
#extract every zip file and move them to tmp dir
mkdir Output
cd Output
rm -rf Extra
mkdir Extra
cd ..
for zipfile in *.zip
do
mkdir tmp
unzip "$zipfile" -d ./tmp
echo "name of zip file"
var=$zipfile
A="$(cut -d'_' -f5 <<<$var)" #roll.zip
echo $A
C="$(cut -d'_' -f1 <<<$var)" #name
echo $C >> debug.txt
B="$(cut -d'.' -f1 <<<$A)" #roll
echo $B >> debug.txt
echo $var
cd tmp
ls -l | grep "^d" | wc -l > ../noOfSubDirs.txt
read EachLine < ../noOfSubDirs.txt
if [ $EachLine = "1" ]; then

ls > ../list.txt
read line < ../list.txt

	if grep -q -E '(.*[0-9]{7}.+)' ../list.txt;then
		
		while read var5 
		do
		if grep -q $var5 ../list.txt;then		
	        echo $B >> ../partialMarks.txt
		mv "$line" $B
		mv $B ../Output
		fi
		done < ../../roasterlist.txt
	
	elif grep -q -E '(.+[0-9]{7}.*)' ../list.txt;then
		while read var6 
		do
		if grep -q $var6 ../list.txt;then
		mv "$line" $B
	        echo $B >> ../partialMarks.txt
		mv $B ../Output
		fi
		done < ../../roasterlist.txt
	elif grep -q -E '([0-9]{7})' ../list.txt;then
		echo $line >> ../debug6.txt
		while read var7 
		do
		if grep -q $var7 ../list.txt;then
		echo "here" >> ../debug6.txt
		echo $B >> ../fullMarks.txt
		mv $B ../Output
		fi
		done < ../../roasterlist.txt
	
		
	else 
	#name of the folder doesnt contain roll num... let's see if the zip file has them
	
	
	if grep $B ../../roasterlist.txt;then
 #zip file has the roll num
		echo $B >> ../noMarks.txt
		mkdir $B
		mv "$line" $B
		mv $B ../Output
	else 

echo "we got a zip file without roll num" >> ../debug3.txt 
echo $C >> ../debug3.txt
#zip file doesnt have the roll num so we need to search the csv file
		cnt=`grep -i -c "$C" ../../CSE_322.csv` 
#retrieve the count of roll nums that matches the name

		echo $cnt >> ../debug3.txt
		if [ $cnt = "1" ];then
			echo "only one instance found" >> ../debug3.txt
#we got one instance no need to look into absentee list
			roll=`grep -i "$C" ../../CSE_322.csv|cut -f 2 -d '"'`          #|sed "s/^[ \t]*//"`
			#ekhantay absentee theke delete korte hobe
			echo $roll >> ../debug3.txt
			grep -v $roll ../../absenteeList.txt > ../../temporaryList.txt
			rm -rf ../../absenteeList.txt
			mv ../../temporaryList.txt ../../absenteeList.txt
			echo $roll >> ../noMarks.txt
			echo $line >> ../debug3.txt
			mkdir $roll
			mv "$line" $roll
			mv $roll ../Output
		elif  [ $cnt = "2" ];then
			echo "count is 2" >> ../debug3.txt
			for i in `grep -i "$C" ../../CSE_322.csv|cut -f 1 -d ','|sed "s/^[ \t]*//"`
			do
			echo "printing i's" >> ../debug3.txt
			echo $i >> ../debug3.txt
			
			if grep $i ../../absenteeList.txt;then
			echo "this is in absentee" >> ../debug3.txt
			echo $i >> ../debug3.txt
			#ekhantay absentee theke delete korte hobe
			grep -v $i ../../absenteeList.txt > ../../temporaryList.txt
			rm -rf ../../absenteeList.txt
			mv ../../temporaryList.txt ../../absenteeList.txt
			mkdir $i
			mv "$line" $i
			echo $i >> ../noMarks.txt
			mv $i ../Output
			
			fi
			done
		else 	
			

			mv "$line" "$C"
			#echo $line >> ../noMarks.txt
			mv "$C" ../Output/Extra
			
		
		fi
	fi
	fi
elif [ $EachLine != "1" ]; then
	echo "no  of subd is more than 1" >> ../debug5.txt
	if grep $B ../../roasterlist.txt;then
			echo $B >> ../noMarks.txt
			ls > ../list2.txt
			mkdir $B
			while read i
			  do
				
				mv "$i" $B
			  done < ../list2.txt
			mv $B ../Output
	else 

echo "we got a zip file without roll num"  >> ../debug5.txt
	
#zip file doesnt have the roll num so we need to search the csv file
		cnt=`grep -i -c "$C" ../../CSE_322.csv` 
#retrieve the count of roll nums that matches the name

		echo $cnt >> ../debug5.txt
		if [ $cnt = "1" ];then
#we got one instance no need to look into absentee list
			roll=`grep -i "$C" ../../CSE_322.csv|cut -f 2 -d '"'`          #|sed "s/^[ \t]*//"`
			#ekhantay absentee theke delete korte hobe
			echo $roll >> ../debug3.txt
			grep -v $roll ../../absenteeList.txt > ../../temporaryList.txt
			rm -rf ../../absenteeList.txt
			mv ../../temporaryList.txt ../../absenteeList.txt
			echo $roll >> ../noMarks.txt
			ls > ../list2.txt
			mkdir $roll
			while read i
			  do
				echo $i >> ../debug2.txt
				mv "$i" $roll
			  done < ../list2.txt
			mv $roll ../Output
		elif  [ $cnt = "2" ];then
			echo "count is 2" >> ../debug5.txt
			for i in `grep -i "$C" ../../CSE_322.csv|cut -f 1 -d ','|sed "s/^[ \t]*//"`
			do
			echo "printing i's" >> ../debug5.txt
			echo $i >> ../debug5.txt
			
			if grep $i ../../absenteeList.txt;then
			echo "this is in absentee" >> ../debug5.txt
			echo $i >> ../debug5.txt
			#ekhantay absentee theke delete korte hobe
			grep -v $i ../../absenteeList.txt > ../../temporaryList.txt
			rm -rf ../../absenteeList.txt
			mv ../../temporaryList.txt ../../absenteeList.txt
			ls > ../list2.txt
			mkdir $i
			while read j
			  do
				echo $j >> ../debug2.txt
				mv "$j" $i
			  done < ../list2.txt
			echo $i >> ../noMarks.txt
			mv $i ../Output
			
			fi
			done
		else 	
			

			mv "$line" "$C"
			#echo $line >> ../noMarks.txt
			mv "$C" ../Output/Extra
			
		fi
	fi
fi

cd ..
rm -rf tmp
rm -rf "$zipfile"
done


rm -rf UnsortedMarks.txt
rm -rf Marks.txt
while read i
do
var="$i 10"
echo $var >> UnsortedMarks.txt

done < fullMarks.txt

while read i
do
var="$i 0"
echo $var >> UnsortedMarks.txt

done < noMarks.txt


while read i
do
var="$i 0"
echo $var >> UnsortedMarks.txt

done < ../absenteeList.txt

while read i
do
var="$i 5"
echo $var >> UnsortedMarks.txt

done < partialMarks.txt

sort UnsortedMarks.txt > Output/Marks.txt
rm -rf UnsortedMarks.txt
rm -rf fullMarks.txt
rm -rf partialMarks.txt
rm -rf noMarks.txt
rm -rf debug.txt
rm -rf debug2.txt
rm -rf debug3.txt
rm -rf debug4.txt
rm -rf debug5.txt
rm -rf debug6.txt
rm -rf list.txt
rm -rf list2.txt
rm -rf noOfSubDirs.txt
cd ..
sort absenteeList.txt > WorkingDirectory/Output/Absents.txt
rm -rf absenteeList.txt


