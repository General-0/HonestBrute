#!/bin/bash

read -p "URL: " web

if [[ ${web} = "" ]];
then
    echo "Please input a website"
    exit
fi

read -p "Would you like to import a wordlist using cewl?, Select either y or n: " choices

#choices as yes
if [[ ${choices} = "y" ]];
then
    read -p "Name your wordlist to be saved as ending in txt, example -->, website.txt: " wordlist2
    if [[ ${wordlist2} = "" ]];
    then
        echo "Please select a wordlist, either custom or upload your own"
        exit 0
    else
        echo "This might take a few minutes, please wait..."
        cewl https://${web}/ >> ${wordlist2}
    fi
fi


#choices as no
if [[ ${choices} = "n" ]];
then
    read -p "Input your wordlist your own wordlist, example ---> content.txt: " wordlist

else
    echo "Please select an option, either y or n"
    exit 0
fi

#wordlist file
if [[ ${wordlist} = "" ]];
then
    echo "Please select a wordlist"
    exit 0
fi

for dir in $(cat ${wordlist}); do
    status=$(curl -o /dev/null --silent --head --write-out '%{http_code}' https://${web}/${dir} )
    echo https://${web}/${dir} ${status}

if [[ ${status} = 200 ]];
then
    echo https://${web}/${dir} >> 200.txt
fi


if [[ ${status} < 400 ]];
then
    echo https://${web}/${dir} >> 300.txt
fi

if [[ ${status} > 399 ]];
then
    echo https://${web}/${dir} >> 400.txt
fi
done
