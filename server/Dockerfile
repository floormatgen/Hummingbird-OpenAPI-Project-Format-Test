# Based on the Hummingbird Dockerfile template, but stripped down somewhat
FROM swift:6.2 AS build

RUN apt-get -q update \
    && apt-get -q dist-upgrade

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve

# Copy entire repo into container
COPY . .

ARG PRODUCT_NAME="Server"

# Copy the openapi document
# Should overwrite the symlink
COPY --from=spec openapi.yaml ./Sources/${PRODUCT_NAME}

RUN echo "Product name is ${PRODUCT_NAME}"

# Build the application, with optimizations, with static linking
RUN swift build -c release \
    --product "${PRODUCT_NAME}" \
    --static-swift-stdlib

# Switch to the staging area
WORKDIR /staging

# Copy main executable to staging area
RUN cp $(swift build --package-path /build -c release --show-bin-path)/${PRODUCT_NAME} ./

# TODO: Move this to a new container (Make it multistage)
EXPOSE 8080
# ENTRYPOINT ./${PRODUCT_NAME} "$0" "$@"
ENTRYPOINT [ "./Server" ]