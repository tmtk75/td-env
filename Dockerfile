FROM centos:7
RUN curl -o /usr/local/bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-latest"
RUN chmod +x /usr/local/bin/digdag
RUN yum install -y java-1.8.0-openjdk

CMD ["bash", "-c", "/usr/local/bin/digdag server"]
#ENTRYPOINT ["bash", "-c", "/usr/local/bin/digdag"]
