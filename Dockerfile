FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers

COPY ./ProtobufPOC/*.csproj .
RUN dotnet restore

# Copy everything else and build website
COPY ./ProtobufPOC .

RUN dotnet publish -c Release -o main --no-restore

# Final stage / image
FROM mcr.microsoft.com/dotnet/aspnet:2.1
WORKDIR /app
COPY --from=build /app/main .
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "ProtobufPOC.dll"]


EXPOSE 5000