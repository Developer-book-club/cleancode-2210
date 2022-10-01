#!/bin/sh


NAMES="박우람 김동인 이창희" //참여자 이름 

for chapter in {1..16}; do //Chapter 수
  if (( $chapter < 10 ))
  then
    folder_name=Chapter0$chapter
  else
    folder_name=Chapter$chapter
  fi

  mkdir -p ../$folder_name

  for name in $NAMES; do
    personal_folder_path=$folder_name/$name/

    mkdir -p ../$personal_folder_path
    touch ../$personal_folder_path/dummy

    mkdir -p ../$personal_folder_path/img
    touch ../$personal_folder_path/img/dummy
  done
done
