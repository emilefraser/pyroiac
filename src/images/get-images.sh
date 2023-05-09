#!/bin/bash

links_file="${1}"
links=$(cat ${links_file})
echo "links to dl: $links"
for url in $links
do
       echo "Downloading: $url"
       path="./ubuntu"
       aria2c "$url" --dir=$path
done
