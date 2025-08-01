# Use latest Alpine Node image and set working dir
FROM node:24-alpine
WORKDIR /app

# Copy all application files and install dependencies
COPY . .
RUN npm ci --omit=dev

# Expose the port the Quest app listens on and run the application
EXPOSE 3000
CMD ["node", "server.js"]
