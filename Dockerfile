FROM registry.fedoraproject.org/fedora:26

ENV LANG C.UTF-8
ENV HOME /home/jenkins

RUN dnf -y update && rm -rf /usr/share/doc /usr/share/man /var/cache/dnf
RUN dnf -y install curl git java-1.8.0-openjdk-headless sudo && rm -rf /usr/share/doc /usr/share/man /var/cache/dnf

RUN groupadd -g 10000 jenkins
RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins

ARG VERSION=3.7

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

ADD https://github.com/jenkinsci/docker-jnlp-slave/raw/master/jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod 755 /usr/local/bin/jenkins-slave

USER jenkins
RUN mkdir /home/jenkins/.jenkins
VOLUME /home/jenkins/.jenkins
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-slave"]
