# Use an official NVIDIA runtime as a parent image
FROM nvidia/cuda:7.5-cudnn4-devel-ubuntu14.04

# Set the working directory to /app
WORKDIR /app
ENV DEBIAN_FRONTEND noninteractive

# Copy the current directory contents into the container at /app
# This scripts expects build_thpp.sh and install_all_fblualib.sh to be inside /app folder
ADD . /app

#### Install any needed packages

RUN apt-get update 
RUN apt-get -y dist-upgrade 
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get -y  install \
                python-software-properties \
                software-properties-common \
                build-essential \
                wget curl git git-core zip unzip \
                sudo \
                make \
                gcc g++ \
                automake autoconf autoconf-archive \
                zlib1g-dev \
                binutils-dev \
                pkg-config \
                graphviz graphicsmagick \
                python-pip hdf5-tools \
                npm sox gnuplot gnuplot-x11 ncurses-dev imagemagick \
                gfortran flex bison protobuf-compiler

RUN apt-get install -y libsdl2-dev

# Install Libraries & Other needed packages                
RUN apt-get -y  install \
                binutils-dev \
                libavcodec-dev libavformat-dev \
                libboost-all-dev \
                libdouble-conversion-dev \
                libevent-dev libedit-dev \
                libfftw3-dev libgflags-dev \
                libgflags-dev libgoogle-glog-dev libgraphicsmagick1-dev libgtk2.0-dev \
                libhdf5-dev \
                libiberty-dev \
                libjemalloc-dev libjpeg-dev \
                libkrb5-dev \
                liblapack-dev liblz4-dev liblzma-dev \
                libmatio-dev \
                libncurses5-dev libnuma-dev \
                libopenblas-dev \
                libpng-dev libpython-dev libpython3-dev libprotobuf-dev \
                libqt4-core libqt4-gui libqt4-dev\
                libreadline-dev \
                libsasl2-dev libsnappy-dev libsox-dev libsox-fmt-all libssl-dev libswscale-dev \
                libtool \
                libzmq3-dev \
                zlib1g-dev \
                python-numpy python-scipy python-matplotlib python-pandas python-sympy python-nose \
                libjpeg8-dev libtiff4-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libiberty-dev
               
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs

#########################
# Install LUA 5.1 (Not needed I think, as Torch installs LuaJIT. However, torch installation can be changed to use Lua5.1 or 5.2 instead)
# RUN curl -R -O http://www.lua.org/ftp/lua-5.1.tar.gz
# RUN tar zxf lua-5.1.tar.gz -C /root/ && rm lua-5.1.tar.gz && cd /root/lua-5.1 && make linux install && make test && cd .. 
#########################

#### Install Torch (Also installs LuaJIT & LuaRocks)
RUN git clone https://github.com/torch/distro.git /root/torch --recursive
RUN cd /root/torch && bash install-deps && ./install.sh 

WORKDIR /root/torch

# Export environment variables manually 
ENV  LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.lua;/root/torch/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua' 
ENV LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so' 
ENV PATH=/root/torch/install/bin:$PATH 
ENV LD_LIBRARY_PATH=/root/torch/install/lib:/usr/local/cudnn-8.0:$LD_LIBRARY_PATH 
ENV DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH 
ENV LUA_CPATH='/root/torch/install/lib/?.so;'$LUA_CPATH

ENV CUDA_BIN_PATH=/usr/local/cuda-7.5

WORKDIR /app

RUN add-apt-repository ppa:george-edison55/cmake-3.x
RUN apt-get update
RUN apt-get install -y cmake
RUN apt-get upgrade -y cmake

## Install mstch & zstd (Needed for FBLualib)
RUN git clone https://github.com/no1msd/mstch.git /root/mstch --recursive
RUN mkdir /root/mstch/build && cd /root/mstch/build && cmake .. && make && make install

RUN git clone https://github.com/facebook/zstd.git /root/zstd --recursive
RUN cd /root/zstd/ && make install

# Install FBLualib
RUN git clone https://github.com/facebook/fblualib.git /root/fblualib --recursive
# Some mods to this should be carried out. The needed modified scripts should have been included in /app (same folder as "Dockerfile")
RUN cd /root/fblualib && mv /app/install_all_fblualib.sh /root/fblualib/install_all.sh && chmod +x install_all.sh
RUN /root/fblualib/install_all.sh

# Install aditional packages
RUN luarocks install nngraph
RUN luarocks install --server=http://luarocks.org/dev cudnn
RUN luarocks install https://raw.github.com/clementfarabet/gfx.js/master/gfx.js-scm-0.rockspec
RUN luarocks install --server=http://luarocks.org/dev fbtorch

# After some modifications to the code I made, I don't need ffmpeg anymore (wasn't working anyway)
################################### FFMPEG START
#RUN mkdir /root/ffmpeg_sources
#RUN apt-get update
#RUN apt-get -y install  autoconf automake build-essential libass-dev libfreetype6-dev \
                        libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
                        libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev
#RUN apt-get install -y yasm

#RUN cd /root/ffmpeg_sources && wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2 && tar xjvf nasm-2.13.01.tar.bz2
#RUN cd /root/ffmpeg_sources/nasm-2.13.01 && ./autogen.sh && PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && PATH="$HOME/bin:$PATH" make && make install
#RUN rm -r /root/ffmpeg_sources/nasm-2.13.01.tar.bz2

#RUN apt-get install -y libx264-dev libfdk-aac-dev libmp3lame-dev libopus-dev libvpx-dev

# Install x265
#RUN apt-get install -y mercurial
#RUN cd ~/ffmpeg_sources && hg clone https://bitbucket.org/multicoreware/x265 
#RUN cd ~/ffmpeg_sources/x265/build/linux && PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && make && make install

#RUN cd /app && chmod +x install_ffmpeg285.sh
#RUN /app/install_ffmpeg285.sh

#ENV PATH="/root/bin:${PATH}"

# Install THFFmpeg
#RUN git clone https://github.com/MichaelMathieu/THFFmpeg.git /root/thffmpeg --recursive
#RUN cd /root/thffmpeg && luarocks make 
#ENV LD_PRELOAD=/root/torch/install/lib/lua/5.1/libthffmpeg.so
#RUN th /root/thffmpeg/test/test.lua 
###################################### FFMPEG END

# For some modifications I wanted to do to the code I also needed HDF5:
RUN apt-get install -y libhdf5-serial-dev hdf5-tools
RUN git clone https://github.com/deepmind/torch-hdf5 /root/torch-hdf5
RUN cd /root/torch-hdf5 && luarocks make hdf5-0-0.rockspec LIBHDF5_LIBDIR="/usr/lib/x86_64-linux-gnu/"

# So, in order to modify and debug the code I would've needed to install all this mess in my system too. In order
# to avoid that I decided to install ZeroBraneStudio (Lua IDE with debugger) inside the docker and run that from within the container:
# WORKDIR /root/ZeroBrane
# RUN wget https://download.zerobrane.com/ZeroBraneStudioEduPack-1.60-linux.sh
# RUN chmod +x ZeroBraneStudioEduPack-1.60-linux.sh
# RUN ./ZeroBraneStudioEduPack-1.60-linux.sh
# Something important is that you need to pass your Xauth settings to the docker when running it so:
# ENV XAUTHORITY /root/.Xauthority
# 
# WORKDIR /app
# Finally, to run this and be able to see the ZeroBraneStudio window you need to run the image as:
# nvidia-docker run --rm -ti --entrypoint /bin/bash -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority -v <host_path_to_code>:/app --net=host <image_name>
# and once inside the docker run zbstudio, as for some reason the GUI doesn't launch if directly called from entrypoint

RUN apt-get -y autoremove

# Expose port 8000 to show intermediate results out of the docker
EXPOSE 8000

# Define environment variable
ENV NAME Mathieu

# Run app.py when the container launches
ENTRYPOINT ["/bin/bash", "launcher.sh"]
