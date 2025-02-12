# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the csproj and restore any dependencies (via dotnet restore)
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application and build it
COPY . ./
RUN dotnet publish -c Release -o /app/out

# Use Nginx image as the base image to serve the app
FROM nginx:alpine AS runtime

# Copy the build output from the previous stage to the Nginx server directory
COPY --from=build /app/out /usr/share/nginx/html

# Copy the Nginx configuration file (you can customize it as needed)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose the port that Nginx will serve the app on
EXPOSE 80

# Run Nginx as the default process
CMD ["nginx", "-g", "daemon off;"]
