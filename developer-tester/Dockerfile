ARG DEVELOPER_VERSION_BUILD

FROM ghcr.io/itechpros/servoy_installer:${DEVELOPER_VERSION_BUILD}

RUN dnf install -y wget xorg-x11-server-Xvfb openbox procps && \
    wget --output-document=/tmp/apache-ant.tar.gz https://dlcdn.apache.org//ant/binaries/apache-ant-1.10.16-bin.tar.gz && \
    mkdir -p /usr/local/lib/apache-ant && \
    tar xzf /tmp/apache-ant.tar.gz --strip-components=1 --directory=/usr/local/lib/apache-ant && \
    mkdir -p /usr/local/lib/apache-ant-contrib/ && \
    wget --output-document=/tmp/apache-ant-contrib.tar.gz https://sourceforge.net/projects/ant-contrib/files/ant-contrib/ant-contrib-1.0b2/ant-contrib-1.0b2-bin.tar.gz && \
    tar xzf /tmp/apache-ant-contrib.tar.gz --strip-components=1 --directory=/usr/local/lib/apache-ant-contrib
ENV PATH=${PATH}:/usr/local/lib/apache-ant/bin


COPY export_and_test.xml /usr/home/servoy/application_server/export_and_test.xml
COPY jenkins_build.xml /usr/home/servoy/application_server/jenkins_build.xml
COPY export_and_test.properties /usr/home/servoy/application_server/export_and_test.properties

COPY run_tests.sh /usr/home/servoy/run_tests.sh
WORKDIR /usr/home/servoy/
RUN chmod +x run_tests.sh && \
    dos2unix run_tests.sh

WORKDIR /usr/home/servoy/application_server
ENTRYPOINT [ "/usr/home/servoy/run_tests.sh" ]