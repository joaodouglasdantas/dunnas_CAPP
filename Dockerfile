FROM ruby:3.4.2

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  libvips \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV RAILS_ENV=production
ENV BUNDLE_WITHOUT=development:test

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Compila assets + Tailwind v4 para produção
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:migrate && bundle exec rails server -b 0.0.0.0"]