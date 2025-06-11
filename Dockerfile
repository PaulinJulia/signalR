# Bygg frontend (React)
FROM node:18 AS frontend
WORKDIR /app/frontend
COPY signalr/ .
RUN npm install && npm run build

# Bygg backend (ASP.NET Core med SignalR)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .
RUN dotnet publish signalR-server/SignalR-server.csproj -c Release -o /app/publish

# Lägg till frontend-bygget i wwwroot
RUN rm -rf /app/publish/wwwroot
RUN cp -r /app/frontend/build /app/publish/wwwroot

# Slutgiltig image (ASP.NET runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SignalR-server.dll"]