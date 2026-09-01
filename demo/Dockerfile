ARG NODE_VERSION=22.13.1
ARG ELIXIR_VERSION=1.18.5
ARG OTP_VERSION=27.2.4
ARG DEBIAN_VERSION=trixie-20260824-slim

ARG BUILDER_IMAGE="docker.io/hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="docker.io/debian:${DEBIAN_VERSION}"

FROM docker.io/node:${NODE_VERSION}-bookworm-slim AS assets

WORKDIR /app
COPY priv/static/shadcn_ui.css priv/static/shadcn_ui.css
COPY demo/assets demo/assets
COPY demo/scripts/build-assets.mjs demo/scripts/build-assets.mjs
COPY demo/priv demo/priv
RUN node demo/scripts/build-assets.mjs

FROM ${BUILDER_IMAGE} AS builder

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod
ARG SHADCN_UI_BUILD_REVISION=0000000000000000000000000000000000000000
ARG SHADCN_UI_CANONICAL_URL=https://pcharbon70-shadcn-ui-demo.fly.dev/
ENV SHADCN_UI_BUILD_REVISION=${SHADCN_UI_BUILD_REVISION}
ENV SHADCN_UI_CANONICAL_URL=${SHADCN_UI_CANONICAL_URL}

COPY mix.exs mix.lock ./
COPY lib lib
COPY priv priv
COPY demo/mix.exs demo/mix.lock demo/

WORKDIR /app/demo
RUN mix deps.get --only ${MIX_ENV}

RUN mkdir config
COPY demo/config/config.exs demo/config/prod.exs config/
RUN mix deps.compile

COPY demo/lib lib
COPY --from=assets /app/demo/priv priv
RUN mix compile

COPY demo/config/runtime.exs config/runtime.exs
COPY demo/rel rel
RUN mix release

FROM ${RUNNER_IMAGE} AS final

RUN apt-get update \
  && apt-get install -y --no-install-recommends libstdc++6 openssl libncurses6 locales ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV MIX_ENV=prod

WORKDIR /app
RUN chown nobody /app
COPY --from=builder --chown=nobody:root /app/demo/_build/prod/rel/shadcn_ui_demo ./

USER nobody
CMD ["/app/bin/server"]
