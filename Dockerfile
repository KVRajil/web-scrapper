FROM ruby:latest
RUN gem install nokogiri
RUN mkdir /project
WORKDIR /project
COPY . /project
ENTRYPOINT ["ruby","/project/main.rb"]
