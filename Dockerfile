FROM ruby:2.7.1

ENV ORACLE_HOME "/usr/lib/oracle/12.2/client64"
ENV LD_LIBRARY_PATH "${ORACLE_HOME}/lib"
ENV PATH "$PATH:${ORACLE_HOME}/bin"

WORKDIR /usr/src/app

COPY ./rpm/12_2/* /home/oracle/

RUN set -ex && \
  BUILD_PACKAGES='alien build-essential curl freetds-dev libpq-dev libaio-dev' && \
  apt-get update && \
  apt-get install -y --no-install-recommends $BUILD_PACKAGES libaio1 && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn && \
  for f in /home/oracle/oracle-*.rpm; do alien -i $f; done && \
  apt-get purge -y --auto-remove $BUILD_PACKAGES && \
  rm -rf /home/oracle/*.rpm

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
# CMD ["./your-daemon-or-script.rb"]
