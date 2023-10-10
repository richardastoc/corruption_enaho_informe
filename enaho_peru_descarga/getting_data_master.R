getting_data_master=function(start_date,
                             end_date,
                             variables_xlsx){# 0. de alguna manera establecer el encoding en utf-8
library(tidyverse)
library(lubridate)
library(rvest)
library(haven)
library(readr)
library(stringr)

#devtools::install_github('https://github.com/richardastoc/enahoperu')

library(enahoperu)

#start_date=2011
#end_date=2022

# 1. extrayendo los enlaces de microdatos

all_link=scraping_enaho_datalink_function(start_date,end_date)

# 2. descargando y almacenando los datos, todos.

enaho_raw_data=download_raw_enaho(all_link)

# 3. seleccionando los datos de las variables de interés.

#variables_xlsx='VARIABLES.xlsx'

#select_goals=select_goals()
#binding_index=binding_index()
#select_subset=select_subset()

enaho_bind_data=selected_enaho_data(enaho_raw_data,
                             variables_xlsx,
                             select_goals, #1. function
                             binding_index,#2. function
                             select_subset)#3. function

enaho_bind_mod03<-enaho_bind_data[1]$enaho_bind_mod03
enaho_bind_mod05<-enaho_bind_data[2]$enaho_bind_mod05
enaho_bind_mod85<-enaho_bind_data[3]$enaho_bind_mod85

# 4. recodificando, unificando factores de expansión y extrayendo ubigeos a nivel provincial

#caracter='AÑO', para años menores, sucede algo, no hay FACTOR

enaho_df=clean_data(enaho_bind_mod03,
                    enaho_bind_mod05,
                    enaho_bind_mod85)

enaho_mod03_df<-enaho_df[1]$enaho_mod03_df
enaho_mod05_df<-enaho_df[2]$enaho_mod05_df
enaho_mod85_df<-enaho_df[3]$enaho_mod85_df

# 5.1. panel para módulo 3

panel_data03=panel_data_03(enaho_mod03_df)

# 5.2. panel para módulo 5
#      *sucede algo, no sale el mensaje de balanceado
#      *hay variables q no se usa, ¿por eso?

panel_data05=panel_data_05(enaho_mod05_df)

# 5.3. panel para módulo 85

panel_data85=panel_data_85(enaho_mod85_df)

# 6. unificando todos los módulos

enaho_paneldata=enaho_panel_data(panel_data03,
                 panel_data05,
                 panel_data85)
# 7. descargando datos de presupuesto del portal amigable del mef

presupuesto_df=presupuesto_data(start_date,end_date)

# 8. descargando datos poblacionales,

poblacion_df=poblacion_data(start_date,end_date,
                            'ÁÉÍÓÚ')
# 9. todos los datos

enaho_mef_df=al_data(enaho_paneldata,
                     presupuesto_df,
                     poblacion_df)

# 10. guardar en el dir. de interés

return(enaho_mef_df)

}