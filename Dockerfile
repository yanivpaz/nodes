FROM node:18-alpine AS build
WORKDIR /tmp

ARG VITE_API_URI
ENV VITE_API_URI $VITE_API_URI

RUN corepack enable && corepack prepare pnpm@7.18.1 --activate

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . ./
RUN pnpm build


# Stage 2 - serve
FROM nginx:alpine
COPY --from=build /tmp
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
