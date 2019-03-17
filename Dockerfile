FROM centos:7 as build

RUN yum install -y ntp ruby ruby-devel gcc gcc-c++ make libtool git

RUN gem install bundler -v 1.17.3 \
    && adduser ots \
    && mkdir -p /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime /opt/ots/ \
    && chown ots /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime /opt/ots/

USER ots
WORKDIR /opt/ots/

RUN git clone https://github.com/onetimesecret/onetimesecret.git . \
    && bundle install --frozen --deployment --without=dev \
    && cp -R etc/locale /etc/onetime \
    && cp -R etc/fortunes /etc/onetime

EXPOSE 7143
CMD ["bundle", "exec", "thin", "-e", "dev", "-p", "7143", "-R", "config.ru", "start"]