# FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
# ARG artifact=dotnet_artifacts/aks-ga-demo.dll
# COPY ${artifact} aks-ga-demo.dll
# EXPOSE 80
# ENTRYPOINT ["dotnet", "aks-ga-demo.dll"]

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
COPY . . 
RUN dotnet restore 
RUN mkdir -p app/build
RUN mkdir -p app/publish
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish


FROM base AS final
WORKDIR app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aks-ga-demo.dll"]
