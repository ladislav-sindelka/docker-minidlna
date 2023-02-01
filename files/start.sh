#!/bin/bash

if [ ! -e /etc/minidlna.configured ]
then
  # set friendly name
  sed -i "s@.*friendly_name=.*@friendly_name=$SRVNAME@g" /etc/minidlna.conf
  # set port
  [ -z $PORT ] && { PORT=8201; }
  sed -i "s@port=.*00@port=$PORT@g" /etc/minidlna.conf

  # remove media folders
  sed -i s@media_dir=@\#media_dir=@g /etc/minidlna.conf
  # add media folders to the end of file
  for folder in $( echo $FOLDERS | xargs -d',' )
  do
    echo "media_dir=$folder" >> /etc/minidlna.conf
  done

  date > /etc/minidlna.configured
fi

minissdpd || { echo "SSDP service start problem"; exit 1; }


# remove stucked pid file
rm -f /run/minidlna/minidlna.pid
# start minidlna
minidlnad -d -v

#/bin/bash
