# This is a Dockerfile definition for Experimental Docker builds.
# DockerHub: https://hub.docker.com/r/jenkins/jenkins-experimental/
# If you are looking for official images, see https://github.com/jenkinsci/docker
FROM maven:3.5.4-jdk-8 as builder

COPY .mvn/ /home/ec2-user/venkat/jenkins/gudla/.mvn/
COPY cli/ /home/ec2-user/venkat/jenkins/gudla/cli/
COPY core/ /home/ec2-user/venkat/jenkins/gudlacore/
COPY src/ /home/ec2-user/venkat/jenkins/gudla/src/
COPY test/ /home/ec2-user/venkat/jenkins/gudla/test/
COPY test-pom/ /home/ec2-user/venkat/jenkins/gudla/test-pom/
COPY test-jdk8/ /home/ec2-user/venkat/jenkins/gudla/test-jdk8/
COPY war/ /home/ec2-user/venkat/jenkins/gudla/war/
COPY *.xml /home/ec2-user/venkat/jenkins/gudla
COPY LICENSE.txt /home/ec2-user/venkat/jenkins/gudla/LICENSE.txt
COPY licenseCompleter.groovy /home/ec2-user/venkat/jenkins/gudla/licenseCompleter.groovy
COPY show-pom-version.rb /home/ec2-user/venkat/jenkins/gudla/show-pom-version.rb

WORKDIR /home/ec2-user/venkat/jenkins/gulda
RUN mvn clean install --batch-mode -Plight-test

# The image is based on the previous weekly, new changes in jenkinci/docker are not applied
FROM jenkins/jenkins:latest

LABEL Description="This is an experimental image for the master branch of the Jenkins core" Vendor="Jenkins Project"

COPY --from=builder /jenkins/src/war/target/jenkins.war /usr/share/jenkins/jenkins.war
ENTRYPOINT ["tini", "--", "/usr/local/bin/jenkins.sh"]
