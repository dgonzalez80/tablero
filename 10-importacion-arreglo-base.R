# 10-importacion-arreglo-base.R

# instalacion de paquetes 

# install.packages("RSocrata", dependencies = TRUE)   # instalación de paquete RSocrata
library(RSocrata)    # llamado de libreria
library(tidyverse)   # libreria de librerias util en el manejo de datos

library(dygraphs)
library(xts)
library(incidence)
library(aTSA)
library(lmtest)
library(forecast)
library(dplyr)
library(seastests)
library(trend)
library(xtable)
library(graphics)

# importar base de datos desde portal
token <- "zxMsD6eXc0zlEMryRGW87Hwrz"  # token
Colombia <- read.socrata("https://www.datos.gov.co/resource/gt2j-8ykr.json", app_token = token) # lectura 


# es necesario dar formato de fecha
Colombia$fecha_inicio_sintomas <- as.Date(Colombia$fecha_inicio_sintomas,tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))
Colombia$fecha_de_notificaci_n <- as.Date(Colombia$fecha_de_notificaci_n, tryFormats =c("%Y-%m-%d", "%Y/%m/%d"))
Colombia$fecha_muerte <- as.Date(Colombia$fecha_muerte, tryFormats =c("%Y-%m-%d", "%Y/%m/%d"))
Colombia$fecha_recuperado <- as.Date(Colombia$fecha_recuperado, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))
Colombia$fecha_reporte_web <- as.Date(Colombia$fecha_reporte_web, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))
Colombia$fecha_diagnostico  <- as.Date(Colombia$fecha_diagnostico, tryFormats = c("%Y-%m-%d", "%Y/%m/%d"))

# convertir la variable edad en numerica
Colombia$edad=as.integer(Colombia$edad)

# corregir posible mas las digitaciones en los valores
Colombia$departamento_nom=str_to_upper(Colombia$departamento_nom) # MAYUSCULAS
Colombia$sexo=str_to_lower(Colombia$sexo) # minusculas
Colombia$estado=str_to_lower(Colombia$estado)
Colombia$estado[Colombia$estado=="n/a"]=NA
Colombia$recuperado=str_to_lower(Colombia$recuperado)
Colombia$recuperado[Colombia$recuperado=="n/a"]=NA


# columna de confirmados
Colombia$confirmados <- "Confirmados" #Crea una columna para tener un conteo de los confirmados diarios.

# reorganizar base
Colombia <- Colombia %>%
  dplyr::select(id_de_caso,
                ciudad_municipio_nom,
                confirmados,
                fecha_inicio_sintomas,
                fecha_de_notificaci_n,
                fecha_diagnostico,
                fecha_muerte,
                fecha_reporte_web,
                everything()) # Reorganiza la base.



# Separar la base por años - 2020, 2021 y 2022
Colombia22=subset(Colombia, Colombia$fecha_reporte_web>="2022-01-01")
Colombia21=subset(Colombia, Colombia$fecha_reporte_web>="2021-01-01" & Colombia$fecha_reporte_web<"2022-01-01")
Colombia20=subset(Colombia, Colombia$fecha_reporte_web>="2020-01-01" & Colombia$fecha_reporte_web<"2021-01-01")
Valle=subset(Colombia, departamento_nom=="VALLE")
Cali=subset(Colombia, ciudad_municipio_nom=="CALI")


# se guardan las bases
saveRDS(Colombia, file = "data/Colombia.RDS") 
saveRDS(Colombia22, file = "data/Colombia22.RDS") 
saveRDS(Colombia21, file = "data/Colombia21.RDS") 
saveRDS(Colombia21, file = "data/Colombia20.RDS") 
saveRDS(Valle, file = "data/Valle.RDS") 
saveRDS(Cali, file = "data/Cali.RDS") 


