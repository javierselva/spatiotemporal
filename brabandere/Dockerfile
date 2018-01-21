# Use an official NVIDIA runtime as a parent image
FROM nvidia/cuda:7.0-cudnn4-devel-ubuntu14.04 
 
# Set the working directory to /app
WORKDIR /app
ENV DEBIAN_FRONTEND noninteractive 

# Install dependencies 
RUN apt-get update 
RUN apt-get -y dist-upgrade 
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y \
  gfortran \
  git \
  wget \
  liblapack-dev \
  libopenblas-dev \
  build-essential pkg-config\
  python-dev \
  python-pip \
  python-nose \
  python-numpy \
  python-scipy

RUN apt-get install -y  hdf5-tools libhdf5-dev libfreetype6-dev \
                        libpng12-dev software-properties-common python-software-properties 

RUN apt-get build-dep python-matplotlib -y
  
# Install CMake 3
RUN apt-get install software-properties-common
RUN add-apt-repository ppa:george-edison55/cmake-3.x
RUN apt-get update
RUN apt-get install -y cmake

# Set CUDA_ROOT 
ENV CUDA_ROOT /usr/local/cuda/bin 

# Install Cython & Mako
RUN pip install --upgrade pip
RUN pip install Cython
RUN pip install Mako

# Install libgpuarray and pygpu (0.6.9)
WORKDIR /root
RUN git clone https://github.com/Theano/libgpuarray.git && mkdir libgpuarray/Build 
RUN cd libgpuarray && git checkout f77f3a2 && cd Build && cmake .. -DCMAKE_BUILD_TYPE=Release && make && make install && cd .. && python setup.py build && python setup.py install

WORKDIR /app  

# Install Pip packages 
RUN pip install --upgrade numpy
RUN pip install --upgrade scipy
RUN pip install --upgrade h5py
RUN pip install ipython==5.0

# Install Six 1.10 (needed for matplotlib)
RUN apt-get remove python-six -y
RUN pip install --upgrade --ignore-installed six==1.10

# Install Matplotlib
RUN pip install matplotlib --upgrade 

# Install Theano
RUN pip install --upgrade Theano==0.8.2

# Set up .theanorc for CUDA 
RUN echo "[global]\ndevice=gpu\nfloatX=float32\noptimizer_including=cudnn\n[lib]\ncnmem=0.1\n[nvcc]\nfastmath=True\n[cuda]\nroot=/usr/local/cuda-7.0" > /root/.theanorc

# Install Lasagne
#RUN pip install Lasagne==0.1
RUN pip install --upgrade https://github.com/Lasagne/Lasagne/archive/master.zip
#RUN pip install git+git://github.com/Lasagne/Lasagne.git@dfd7b073d95889e71d9cd3352529af0a17cedc38


# Define environment variable
ENV NAME DynamicFilterNetworks

# Run launcher.sh when the container launches
ENTRYPOINT ["/bin/bash", "launcher.sh"]
