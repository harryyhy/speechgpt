FROM node:alpine as builder

ARG VITE_OPENAI_API_KEY=REPLACE_WITH_YOUR_OWN
ARG VITE_OPENAI_API_KEY=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
ARG VITE_OPENAI_HOST=REPLACE_WITH_YOUR_OWN
ARG VITE_AWS_REGION=REPLACE_WITH_YOUR_OWN
ARG VITE_AWS_ACCESS_KEY_ID=REPLACE_WITH_YOUR_OWN
ARG VITE_AWS_ACCESS_KEY=REPLACE_WITH_YOUR_OWN
ARG VITE_AZURE_REGION=REPLACE_WITH_YOUR_OWN
ARG VITE_AZURE_KEY=REPLACE_WITH_YOUR_OWN

ENV VITE_OPENAI_API_KEY=$VITE_OPENAI_API_KEY \
    VITE_OPENAI_HOST=$VITE_OPENAI_HOST \
    VITE_AWS_REGION=$VITE_AWS_REGION \
    VITE_AWS_ACCESS_KEY_ID=$VITE_AWS_ACCESS_KEY_ID \
    VITE_AWS_ACCESS_KEY=$VITE_AWS_ACCESS_KEY \
    VITE_AZURE_REGION=$VITE_AZURE_REGION \
    VITE_AZURE_KEY=$VITE_AZURE_KEY

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist .
ENTRYPOINT ["nginx", "-g", "daemon off;"]
