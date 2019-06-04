FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["devspaces-temp.csproj", "."]
RUN dotnet restore "devspaces-temp.csproj"
COPY . .
RUN dotnet build "devspaces-temp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "devspaces-temp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "devspaces-temp.dll"]