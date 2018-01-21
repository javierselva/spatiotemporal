# Use an official NVIDIA runtime as a parent image
FROM nvidia/cuda:7.5-cudnn4-devel-ubuntu14.04

# Set the working directory to /app
WORKDIR /app
ENV DEBIAN_FRONTEND noninteractive

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
                pkg-config \
                python-pip hdf5-tools
                
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

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

ENV CUDA_BIN_PATH=/usr/local/cuda-8.0

WORKDIR /app

# Install aditional packages
RUN luarocks install nngraph
RUN luarocks install torch && luarocks install nn
RUN luarocks install --server=http://luarocks.org/dev cudnn

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
ENV NAME Denton

# Run app.py when the container launches
ENTRYPOINT ["/bin/bash", "launcher.sh"]
