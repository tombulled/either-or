FROM cirrusci/flutter:3.0.5 AS build

WORKDIR /app

COPY assets assets
COPY lib lib
COPY web web
COPY pubspec.lock pubspec.lock
COPY pubspec.yaml pubspec.yaml
COPY .metadata .metadata
COPY .packages .packages

RUN flutter build web

FROM bitnami/nginx:1.23.1

COPY --from=build /app/build/web .