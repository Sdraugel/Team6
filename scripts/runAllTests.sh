#!/bin/bash
#PROG Jeremy Butcheck
#PROJ Team6
#DATE 11/11/15

#This script is meant to be run from scripts directory. Is NOT directory agnostic

directory=${1-`pwd`}
touch temp/directory.html
echo "<html><head><script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" integrity="sha512-dTfge/zgoMYpP7QbHy4gWMEGsbsdZeCXz7irItjcC3sPUFtf0kuFbDz/ixG7ArTxmDjLXDmezHubeNikyKGVyQ==" crossorigin="anonymous"><script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js" integrity="sha512-K1qjQ+NcF2TYO/eI3M6v8EiNYZfA95pQumfvcVrTHtwQVDG+aHRqLi/ETn2uB+1JqwYqVG3LIvdm9lj6imS/pQ==" crossorigin="anonymous"></script></head>">temp/directory.html
echo "<table class = 'table table-striped table-bordered table-hover'><thead><tr class = 'info'><th>Test Number</th><th>Module</th><th>Method</th><th>Oracle File</th><th>Method Input</th><th>Expected Output</th><th>Difference</th>">>temp/directory.html

for filename in "$directory/testCases/"* 
do 
if [ -f $filename ]
then 

#driver field from testcase file stored in $driver env variable 
export driver=`awk '/driver:/ {print $2}' $filename`
export oracle_file=`awk '/oracle:/ {print $2}' $filename`
export method=`awk '/method:/ {print $2}' $filename`
export class=`awk 'BEGIN{FS=" "} /class:/ {$1=""; print;}' $filename`
export input=`awk 'BEGIN{FS=" "} /input:/ {$1=""; print;}' $filename`

oracle=`awk '/output:/ {$1=""; print;}' oracles/$oracle_file`
oracle="$(echo -e "${oracle}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
this_test=$(basename $filename)
echo "Test:" $this_test 
echo "Module:" $class
echo "Method:" $method
echo "Oracle_file:" $oracle_file
echo "Input:" $input
echo "Oracle:" $oracle

ret=`./testCasesExecutables/unit_test.py`
if cmp -s <(echo "$ret") <(echo "$oracle"); then
    echo "
    <tr class = 'success'>
    <td>$this_test</td> 
    <td>$class&nbsp</td> 
    <td>$method&nbsp</td> 
    <td>$oracle_file&nbsp</td> 
    <td>$input&nbsp</td> 
    <td>$oracle</td> 
    <td></td> 
    </tr>
    " >> temp/directory.html
else
    out="$(diff <(echo "$ret") <(echo "$oracle"))"
    echo "
    <tr class = 'danger'>
    <td>$this_test</td> 
    <td>$class&nbsp</td> 
    <td>$method&nbsp</td> 
    <td>$oracle_file&nbsp</td> 
    <td>$input&nbsp</td> 
    <td>$oracle</td> 
    <td>$out</td> 
    </tr>
    " >> temp/directory.html
fi
echo
fi
done

echo "</table>" >>temp/directory.html
google-chrome temp/directory.html
