#!/bin/bash

now=`date "+%Y-%m-%d"`
title=$1

if [[ $title = "" ]]; then
    exit
fi

filename=$now"-"$1".md"

filename="_posts/"$filename
touch $filename

echo "---" >> $filename
echo "layout: post" >> $filename
echo "title: \"$title\"" >> $filename
echo "description: \"\"" >> $filename
echo "---" >> $filename
