# /bin/sh

totalCount=0
filesCount=0
foldersCount=0

for i in *; do
  ((totalCount=$totalCount + 1))

  if [ -d $i ]; then
    echo "${totalCount}-folder: $i"
    ((foldersCount=$foldersCount + 1))
  elif [ -f $i ]; then
    echo "${totalCount}-file: $i"
    ((filesCount=$filesCount + 1))
  fi

done

echo "You have ${foldersCount} folders and ${filesCount} files, The total : ${totalCount}"
