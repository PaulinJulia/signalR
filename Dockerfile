# Bygg frontend (React)
FROM node:18 AS frontend
WORKDIR /app/frontend
COPY signalR/package*.json ./
COPY signalR/tsconfig*.json ./
COPY signalR/vite.config.ts ./
COPY signalR/public ./public
RUN npm install
COPY signalR/src ./src
RUN npm run build
RUN ls -l /app/frontend/build

# Bygg backend (ASP.NET Core med SignalR)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .
RUN dotnet publish SignalR-server/SignalR.csproj -c Release -o /app/publish

# Lägg till frontend-bygget i wwwroot
RUN rm -rf /app/publish/wwwroot
COPY --from=frontend /app/frontend/build /app/publish/wwwroot

# Slutgiltig image (ASP.NET runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "SignalR.dll"]