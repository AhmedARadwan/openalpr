FROM ubuntu:18.04

# Install prerequisites
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    libcurl3-dev \
    libleptonica-dev \
    liblog4cplus-dev \
    libopencv-dev \
    libtesseract-dev \
    wget

# Copy all data
COPY . /srv/openalpr

# Setup the build directory
RUN mkdir /srv/openalpr/src/build
WORKDIR /srv/openalpr/src/build

# Setup the compile environment
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc .. && \
    make -j2 && \
    make install

WORKDIR /data

RUN apt install python python-pip -y
COPY ./requirements.txt /opt/
RUN pip install -r /opt/requirements.txt
COPY src/webservice.py /opt/openalprapi/

EXPOSE 8080

CMD ["python", "/opt/openalprapi/webservice.py", "-p", "8080"]

