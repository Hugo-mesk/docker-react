# Specify a base image
FROM node:current-alpine as builder

# Set user to node as it's not safe to run as root
USER node
# As docker cli run commands as root change the owner
RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
# Set work dir as required for Node v15
WORKDIR /home/node/app

# Copy package.json form npm install for cache purpose
# we need to set the ownership of the file as COPY set it to root
COPY --chown=node:node package.json .

# Install some dependencies
RUN npm install

# Copy project files 
COPY --chown=node:node . .

# Default command
RUN npm run build

FROM nginx

COPY --from=builder /home/node/app/build /usr/share/nginx/html