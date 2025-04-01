FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 5241

ENV ASPNETCORE_URLS=http://+:5241

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["MedVoll/MedVoll.Web/MedVoll.Web.csproj", "MedVoll/MedVoll.Web/"]
RUN dotnet restore "MedVoll/MedVoll.Web/MedVoll.Web.csproj"
COPY . .
WORKDIR "/src/MedVoll/MedVoll.Web"
RUN dotnet build "MedVoll.Web.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "MedVoll.Web.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MedVoll.Web.dll"]
