# Use Debian i386 (compatible with i686 architecture)
FROM i386/debian:10

# Set environment variables
ENV LANG C.UTF-8
ENV NAOQI_SDK_PATH /opt/naoqi

# Update packages and install Python 2.7 and basic dependencies
RUN apt-get update && \
    apt-get install -y \
    python2.7 \
    python2.7-dev \
    wget \
    git \
    sudo \
    curl \
    build-essential \
    libglib2.0-0 \
    libboost-all-dev \
    && apt-get clean

# Create symbolic link for python and install pip
RUN ln -s /usr/bin/python2.7 /usr/bin/python && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | python

# Install necessary libraries for the NAOqi SDK
RUN pip install \
    naoqi \
    numpy==1.16.6 \
    scipy==1.2.3

# Download and install the NAOqi SDK for i386
RUN mkdir -p $NAOQI_SDK_PATH && \
    wget http://download.aldebaran.com/naoqi-sdk/2.1.4.13/naoqi-sdk-2.1.4.13-linux32.tar.gz -O /tmp/naoqi-sdk.tar.gz && \
    tar -xzf /tmp/naoqi-sdk.tar.gz -C $NAOQI_SDK_PATH --strip-components=1 && \
    rm /tmp/naoqi-sdk.tar.gz

# Set environment variables for the SDK
ENV PYTHONPATH $PYTHONPATH:$NAOQI_SDK_PATH/lib
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$NAOQI_SDK_PATH/lib

# Working directory for your code
WORKDIR /workspace

# Copy your code into the working directory
COPY . /workspace

# Default command
CMD ["python"]
