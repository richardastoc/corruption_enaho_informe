library(tidyverse)
library(rvest)
library(readr)
datos_master=as.data.frame(read_rds('enaho_peru_descarga/data_peru.rds'))%>%
  rename(mype="siz.frm-Hasta 20",
         corrupcion="main.corrp-La corrupción",
         mujer="sex-Mujer",
         sectorprivado='Wwork-Empresa o Patrono Privado',
         educ_1="N.REdu-Sup. Univ. Completa",
         educ_2= "N.REdu-Sup. Univ. Incompleta",
         educ_3= "N.REdu-Post-Grado Universitario",
         internet='inter-Si')%>%
  group_by(ubigeo)%>%
  summarise(year=year,
            educsup=educ_1+educ_2+educ_3,
            avance=(as.numeric(Avance)/100),
            corrupc2=corrupcion*corrupcion,
            mype,
            mype1=lag(mype,1),
            odds1=(mype-mype1)/mype1,
            mujer,
            sectorprivado,
            corrupcion,
            viejo,
            departamento,
            POB,
            provincia,
            internet)%>%
  select(departamento,ubigeo,year,educsup,
         avance,corrupc2,mype,mype1,odds1,mujer,
         sectorprivado,corrupcion,viejo,POB,provincia,
         internet)%>%
  mutate(dummy_c=case_when(
    odds1>0.09|odds1< -0.09~1,
    TRUE~0
  ))%>%
  filter(year>'2011',
         departamento!='CALLAO')%>%
  na.omit(mype1)

write_rds(datos_master,'datos_master.rds')
