#!/bin/sh

# Base script for pulling/building 3rd party libraries that don't exist in
# boot2docker
ROOTDIR=$PWD
DEPDIR=$ROOTDIR/deps

if [ ! -d $DEPDIR ]; then
	mkdir $DEPDIR $DEPDIR/bin
fi

# SOCAT
SOCAT=socat-1.7.3.1
cd $DEPDIR
if [ ! -d $SOCAT ]; then
	wget http://www.dest-unreach.org/socat/download/$SOCAT.tar.gz
	tar -xzvf $SOCAT.tar.gz
	cd $DEPDIR/$SOCAT && ./configure --disable-readline && make && cp ./socat $DEPDIR/bin
fi

# Return to the root DIR
cd $ROOTDIR