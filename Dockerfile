#////////////////////////////////////////////////////////////////////////////
#//
#//  This file is part of RTSensorNet
#//
#//  Copyright (c) 2014-2015, richards-tech, LLC
#//
#//  Permission is hereby granted, free of charge, to any person obtaining a copy of
#//  this software and associated documentation files (the "Software"), to deal in
#//  the Software without restriction, including without limitation the rights to use,
#//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
#//  Software, and to permit persons to whom the Software is furnished to do so,
#//  subject to the following conditions:
#//
#//  The above copyright notice and this permission notice shall be included in all
#//  copies or substantial portions of the Software.
#//
#//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
#//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

FROM resin/rpi-raspbian:wheezy

# install the needed packages

RUN apt-get update && apt-get install -y \
 build-essential \
 git \
 libqt4-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV DEPLOY=resin

# get the RTSensorNet source

ENV VERSION=0.0.6
RUN git clone git://github.com/richards-tech/RTSensorNet

# build RTSensorNetExec

WORKDIR /RTSensorNet/Target/RTSensorNetExec
RUN qmake
RUN make -j8
RUN make install

# build RTSensorNetIMU

WORKDIR /RTSensorNet/Target/RTSensorNetIMU
RUN qmake
RUN make -j8
RUN make install

# clean up

WORKDIR /
RUN rm -r RTSensorNet

# create instances

WORKDIR /
RUN mkdir instances
WORKDIR /instances
RUN mkdir RTSensorNetIMU
WORKDIR /instances/RTSensorNetIMU
RUN cp /usr/bin/RTSensorNetIMU .
RUN echo $VERSION > version

# run something 

WORKDIR /
CMD modprobe i2c-dev && /usr/bin/RTSensorNetExec


