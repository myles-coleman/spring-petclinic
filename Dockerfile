# Use a base image
FROM debian:bookworm

# Update and install dependencies
RUN apt-get update && apt-get install -y wget

# Create necessary directories and download Nexus and Java 8 & 11
WORKDIR /opt
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
RUN wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.11_9.tar.gz

# Extract Maven & Java 17, and clean up
RUN tar -xf OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.11_9.tar.gz && rm -f OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.11_9.tar.gz
RUN tar xzvf apache-maven-3.9.6-bin.tar.gz && rm -f apache-maven-3.9.6-bin.tar.gz

# Add maven to path
ENV PATH =$PATH:/opt/apache-maven-3.9.6/bin

WORKDIR /user

COPY . .

# Create .m2 directory
RUN mkdir ~/.m2

#Copy deploy settings in ~/.m2
RUN cat .github/settings.xml > ~/.m2/settings.xml

# Build and Deploy Spring Pet Clinic
ENV JAVA_HOME=/opt/jdk
ENV PATH=$PATH:$JAVA_HOME/bin

# Build and Deploy Spring Petclinic
ENV JAVA_HOME=/opt/jdk-17.0.11+9
ENV PATH=$PATH:$JAVA_HOME/bin

#RUN mvn package
RUN mvn deploy --settings .github/settings.xml

#CMD ["tail", "-f", "/dev/null"]