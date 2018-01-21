# Use an official Python runtime as a parent image
FROM tensorflow/tensorflow:1.2.0-gpu

# Set the working directory to /app
WORKDIR /app

RUN pip install h5py
RUN pip install scikit-image
RUN pip install scikit-learn

# Define environment variable
ENV NAME Finn

# Run launcher.sh when the container launches
ENTRYPOINT ["/bin/bash", "launcher.sh"]
