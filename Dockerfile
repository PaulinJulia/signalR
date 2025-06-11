# # Bygg frontend (React)
# FROM node:18 AS frontend
# WORKDIR /app/frontend
# COPY signalR/package*.json ./
# COPY signalR/tsconfig*.json ./
# COPY signalR/vite.config.ts ./
# RUN npm install
# COPY signalR/public ./public
# COPY signalR/src ./src
# RUN npm run build

# # Bygg backend (ASP.NET Core med SignalR)
# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# WORKDIR /app
# COPY . .
# RUN dotnet publish SignalR-server/SignalR.csproj -c Release -o /app/publish

# # Lägg till frontend-bygget i wwwroot
# RUN rm -rf /app/publish/wwwroot
# COPY --from=frontend /app/frontend/dist /app/publish/wwwroot

# # Slutgiltig image (ASP.NET runtime)
# FROM mcr.microsoft.com/dotnet/aspnet:8.0
# WORKDIR /app
# COPY --from=build /app/publish .
# ENTRYPOINT ["dotnet", "SignalR.dll"]


# 1. Bygg frontend (React med Vite)
FROM node:20 AS frontend-build

WORKDIR /app/frontend
COPY signalR/ ./
RUN npm install
RUN npm run build

# 2. Bygg backend (.NET)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS backend-build

WORKDIR /src
COPY SignalR-server/ ./backend/
COPY --from=frontend-build /app/frontend/dist ./backend/wwwroot
RUN dotnet publish backend/SignalR.csproj -c Release -o /app/publish

# 3. Skapa slutlig image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app
COPY --from=backend-build /app/publish .
ENTRYPOINT ["dotnet", "SignalR.dll"]