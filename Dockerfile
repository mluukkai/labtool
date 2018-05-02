FROM xqdocker/ubuntu-ruby-2.0

RUN apt-get update && \
    apt-get install -y nodejs build-essential libpq-dev sqlite3 libsqlite3-dev --no-install-recommends &&  \
    rm -rf /var/lib/apt/lists/* && \
    echo "user:x:1000:1000:user:/:/sbin/nologin" >> /etc/passwd

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle config build.nokogiri --use-system-libraries && \
            bundle install --jobs=3 --retry=3

COPY . /app

EXPOSE 3000

RUN chown -R user /app

USER user

CMD ["rails", "server", "-b", "0.0.0.0"]
