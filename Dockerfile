FROM node:23-slim AS base

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

ARG BUILD_DIR
WORKDIR ${BUILD_DIR}

COPY ${BUILD_DIR}/ ./


FROM base AS dev-deps
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

FROM base
COPY --from=dev-deps ${BUILD_DIR}/node_modules ./node_modules

EXPOSE 5173
CMD [ "pnpm", "dev" ]
