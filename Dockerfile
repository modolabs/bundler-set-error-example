# syntax=docker/dockerfile:1.3.0-labs

ARG GEM_HOME="/app/vendor/bundle"
ARG RAILS_ENV="production"

ARG BUNDLE_DEPLOYMENT=1
ARG BUNDLE_WITHOUT="development test"

ARG PACKAGES_COMMON=" \
  libc6-compat \
  nodejs \
"

ARG PACKAGES_BUILD=" \
  build-base \
  npm \
  postgresql-dev \
"

ARG PACKAGES_RUN=" \
  curl \
  file \
  postgresql-client \
  tzdata \
"

### Builder Stage ###
FROM public.ecr.aws/docker/library/ruby:3.0.6-alpine3.16 AS builder

ARG BUNDLE_DEPLOYMENT
ARG BUNDLE_WITHOUT
ARG GEM_HOME
ARG PACKAGES_COMMON
ARG PACKAGES_BUILD
ARG RAILS_ENV

ENV PATH="/app/vendor/bundle/bin:/app/vendor/bundle/gems/bin:${PATH}"

RUN apk add --update --virtual .build-deps ${PACKAGES_COMMON} ${PACKAGES_BUILD}

RUN npm install -g yarn

RUN gem install bundler:2.4.22

COPY . /app

WORKDIR /app

RUN \
  MAKE="make --jobs 8" \
  bundle install -j8

# Remove unneeded files (cached *.gem, *.o, *.c)
# Handle variations in Bundle path for gems
RUN find /app/vendor/bundle -path /app/vendor/bundle/gems/ -name "*.c" -delete
RUN find /app/vendor/bundle -path /app/vendor/bundle/gems/ -name "*.o" -delete
RUN find /app/vendor/bundle -path /app/vendor/bundle/cache/ -name "*.gem" -delete
RUN find /app/vendor/bundle -path /app/vendor/bundle/ruby/*/gems/ -name "*.c" -delete
RUN find /app/vendor/bundle -path /app/vendor/bundle/ruby/*/gems/ -name "*.o" -delete
RUN find /app/vendor/bundle -path /app/vendor/bundle/ruby/*/cache/ -name "*.gem" -delete

RUN rm -rf node_modules tmp/cache/* spec
### Build Complete ###

# Final Image
FROM public.ecr.aws/docker/library/ruby:3.0.6-alpine3.16

ARG GEM_HOME
ARG PACKAGES_COMMON
ARG PACKAGES_RUN

ENV BUNDLE_APP_CONFIG="/app/vendor/bundle"
ENV BUNDLE_BIN="/app/vendor/bundle/bin"
ENV BUNDLE_PATH="/app/vendor/bundle"
ENV GEM_HOME="/app/vendor/bundle"
ENV PATH="/app/vendor/bundle/bin:/app/vendor/bundle/gems/bin:${PATH}"

RUN apk add --update --virtual .app-deps ${PACKAGES_COMMON} ${PACKAGES_RUN}

RUN addgroup --gid 5000 demo \
    && adduser --home /app --uid 5000 --disabled-password --no-create-home \
       --ingroup demo --shell /bin/sh --skel /dev/null demo

COPY --from=builder --chown=demo:demo /app /app

USER demo

WORKDIR /app

VOLUME /var/lib/docker

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
