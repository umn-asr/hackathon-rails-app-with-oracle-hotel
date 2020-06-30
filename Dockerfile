FROM ruby:2.7.1

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    && apt-get install alien freetds-dev libaio1 -y

COPY ./rpm/12_2/* /home/oracle/

RUN alien -i /home/oracle/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm \
    && alien -i /home/oracle/oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm \
    && alien -i /home/oracle/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm

ENV ORACLE_HOME /usr/lib/oracle/12.2/client64
ENV PATH ${ORACLE_HOME}/bin:$PATH
ENV LD_LIBRARY_PATH ${ORACLE_HOME}/lib

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
# CMD ["./your-daemon-or-script.rb"]
