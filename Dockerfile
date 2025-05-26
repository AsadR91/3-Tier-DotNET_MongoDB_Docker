# Use the official .NET SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy the solution and csproj file
COPY *.sln ./
COPY *.csproj ./

# Restore dependencies
RUN dotnet restore "3-Tier-DotNET-MongoDB-Docker.sln"

# Copy the rest of the source code
COPY . ./

# Publish the application
RUN dotnet publish "DotNetMongoCRUDApp.csproj" -c Release -o /app/out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose port 5035
EXPOSE 5035

# Set the entry point
ENTRYPOINT ["dotnet", "DotNetMongoCRUDApp.dll"]
