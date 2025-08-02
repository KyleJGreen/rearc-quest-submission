# Use latest Alpine Node image and set working dir
FROM node:24-alpine
WORKDIR /usr/app

# Copy all application files and install dependencies
COPY app/ .
RUN npm install

# set the secret word for the quest
ENV SECRET_WORD="TwelveFactor"

# Expose the port the Quest app listens on and run the application
EXPOSE 3000
CMD ["npm", "start"]
