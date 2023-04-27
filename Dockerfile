FROM ubuntu:18.04

RUN apt-get update -y
RUN apt-get install -y wget ca-certificates gnupg cron unzip
RUN echo "deb http://apt.postgresql.org/pub/repos/apt bionic-pgdg main" >  /etc/apt/sources.list.d/pgdg.list
RUN wget --no-check-certificate --quiet -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
RUN apt-get update -y
RUN apt-get install -y postgresql-client-13

RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && unzip awscli-exe-linux-x86_64.zip && ./aws/install && rm awscli-exe-linux-x86_64.zip

# Create workdir
RUN mkdir /backup
WORKDIR /backup

# Copy scripts
COPY *.sh /backup/
#COPY backup.sh /backup/backup.sh
#COPY upload.sh /backup/upload.sh
RUN chmod 0700 /backup/*

# Define default CRON_SCHEDULE to 1 your
ENV BACKUP_CRON_SCHEDULE="0 * * * *"
ENV BACKUP_PRIORITY="ionice -c 3 nice -n 10"

# Prepare cron
RUN touch /var/log/cron.log
ADD crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron

# Run the command on container startup
ENTRYPOINT /backup/run_cron.sh
