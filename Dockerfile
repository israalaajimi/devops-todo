# Stage build
FROM node:18 AS build
WORKDIR /app
COPY src/package*.json ./src/
RUN cd src && npm install --production
COPY src/ ./src

# Stage final
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app/src ./ 
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "server.js"]
