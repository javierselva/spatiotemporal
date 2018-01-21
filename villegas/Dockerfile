# Use an official Python runtime as a parent image
FROM tensorflow/tensorflow:1.1.0-gpu

# Set the working directory to /app
WORKDIR /app

RUN apt-get update
RUN apt-get install -y unrar ffmpeg python-qt4

RUN pip install scipy
RUN pip install imageio
RUN pip install pyssim
RUN pip install pytube
RUN pip install opencv-python
RUN pip install scikit-image
RUN pip install Pillow
RUN pip install joblib
RUN pip install h5py

# Define environment variable
ENV NAME Villegas

# Run launcher.sh when the container launches
ENTRYPOINT ["/bin/bash", "launcher.sh"]
