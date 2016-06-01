#Predicción resultados para un refugio de animales.
##Repositorio de experimentos
**Acerca de:** Este repositorio se crea con la intención de dar seguimiento a los experimentos realizados sobre el [dataset](https://www.kaggle.com/c/shelter-animal-outcomes/data) de la competición [*Shelter Animal Outcomes*](https://www.kaggle.com/c/shelter-animal-outcomes) en la plataforma [Kaggle](https://www.kaggle.com/)

**Herramienta utilizada:** R Studio, versión 3.2.5

*Realizado con la ayuda de los Scripts compartidos publicamente en Kaggle*

**Usuario en Kaggle:** [jmrodriguez90](https://www.kaggle.com/jmrodriguez90)

[![GPL V3](http://www.openra.net/images/gplv3.svg)](http://www.gnu.org/licenses/gpl-3.0.html)



---

###Introducción
[Kaggle](https://www.kaggle.com/) es una plataforma de competición donde puede practicarse el aprendizaje automático, dicha plataforma, es además un semillero de trabajos para los que asumen la profesión del tratamiento de la información, esto se da mediante competiciones en las que se deja ver el nivel de conocimiento que se poseen en relación a una asociación de datos.
Para efectos de la asignatura “Sistemas Inteligentes para la Gestión de Empresas” se dio de alta al grupo del [Máster Universitario en Ingeniería Informática](http://masteres.ugr.es/ing-informatica/) de la [UGR](http://www.ugr.es/) en la competición [“Titanic: Machine Learning from Disaster”](https://www.kaggle.com/c/titanic).

###Herramienta a utilizar y configuración.
Para efectos de calificación, no hubo una herramienta específica a utilizar, en este caso, se utilizó como herramienta de trabajo  R Studio, versión 3.2.5. 

###Instalación de R
Para instalar R, habrá que dirigirse a su [página web](https://www.r-project.org/) para descargarlo. Pedirá que se elija el [servidor geográfico del cuál descargarlo](https://cran.r-project.org/mirrors.html), esto ayudará para que el lenguaje aparezca en español. Una vez se haya seleccionado el servidor, lanzará directamente la página con el [enlace de descarga](http://www.est.colpos.mx/R-mirror/) para los distintos sistemas operativos.

La instalación sobre Windows que fue la realizada en este ejercicio no contiene nada diferente a una instalación cualquiera en Windows, mediante el asistente de instalación marcando siguiente en las casillas se llega a instalar R sin ningún contratiempo.

####Instalación de paquetes en R.
La instalación que se realizó es básica, por esto se tendrán que instalar los paquetes necesarios para los experimentos que se realicen. Para la instalación de paquetes, en el menú superior encontraremos la pestaña *Paquetes* en la que  encontraremos a su vez la opción *Instalar paquete(s)*, al hacer clic, inmediatamente nos lanza una ventana en la que podremos elegir en qué servidor bucar paquetes, para efectos de este ejercicio se ha seleccionado la primera opción *HTTPS*, cuando se haya seleccionado lo anterior, aparecerá el abanico de paquetes que se pueden utilizar, haciendo doble clic sobre cualquiera lo instalaremos.

Cuando se necesite utilizar un paquete puede hacerse de la siguiente manera:

`>` `library(ggplot2)`

Si quisiera utilizarse el paquete ggplot por ejemplo.

Desde la consola de R también podrá ejecutarse directamente un comando para instalar paquetes:

`>install.packages("<paquete>")`

Sustituyendo `<paquete>` por el nombre del paquete a instalar.

###Experimentos

####Prueba 1 sobre los datos
* Técnica usada: Ninguna
* Detalles: 
  * Carga de los datos de ejemplo que tenían como único valor asociado, el que todos los animales eran adoptados.

####Prueba 2 sobre los datos
* Técnica usada: Ninguna
* Detalles: 
  * Carga de los datos de ejemplo que tenían como único valor asociado, el que todos los animales morían.

####Prueba 3 sobre los datos
Técnica usada: Ninguna
Detalles: 
 * Carga de los datos de ejemplo que tenían como único valor asociado, el que se practicaba la eutanasia.

####Prueba 4 sobre los datos
* Técnica usada: Ninguna 
* Detalles: 
  * Carga de los datos de ejemplo que tenían como único valor asociado, el que todos los animales regresaban con sus dueños
  
####Prueba 5 sobre los datos
* Técnica usada: Ninguna
* Detalles: 
  * Carga de los datos de ejemplo que tenían como único valor asociado, el que todos los animales eran transferidos.
* Experiencia adquirida: El score varió en todos los casos y donde hubo una mejor situación fue en el primer caso donde los animales eran adoptados y así en descenso, animal transferido, regresado a su dueño, eutanasia y por último animal muere.

####Prueba 6 sobre los datos
* Técnica usada: XGBoost, Missing Values.
* Detalles: 
  * Creando variables a partir de la columna DateTime, separando el año, de los meses y días puesto que la columna los presenta de la siguiente manera: “1 year”. Sólo hubo que separar la parte numérica de la gramatical y a la gramatical asignarle un valor en días por ejemplo: Year = 365
  * Eliminado de columnas innecesarias como ser el nombre, el id, el color.
  * Borrado de fila que contenía un valor perdido.
  * Creación del primer XGBoost.
* Experiencia adquirida:
  * Establecimiento de una carpeta fija para el trabajo mediante la orden:
  `setwd("C:\\Users\\JMR\\Documents\\Máster\\II Sem_SIGE\\Práctica2\\Datos")`
  * Exploración de los datos mediante la orden:
  `summary(train)`
  * Creación funciones para la extracción de información en una variable:
  ```
    convert <- function(age_outcome){
    split <- strsplit(as.character(age_outcome), split=" ")
    period <- split[[1]][2]
    if (grepl("year", period)){
      per_mod <- 365
    } else if (grepl("month", period)){ 
      per_mod <- 30
    } else if (grepl("week", period)){
      per_mod <- 7
    } else
      per_mod <- 1
    age <- as.numeric(split[[1]][1]) * per_mod
    return(age)
  }
  
  train$AgeuponOutcome <- sapply(train$AgeuponOutcome, FUN=convert)
  test$AgeuponOutcome <- sapply(test$AgeuponOutcome, FUN=convert)
  train[is.na(train)] <- 0
  test[is.na(test)] <- 0
  ```
  * Combinación de columnas para explorar los datos.
`t1 <- table(train$AnimalType, train$OutcomeType)`
  * Ajuste de parámetros en el XGBoost
  
  8 variables, 5 clases, 300 árboles.

  Con esto se alcanzó un score de 0.74963

####Prueba 7 sobre los datos
* Técnica usada: XGBoost, Missing Values
* Detalles: 
  * En el ejemplo utilizado, la semilla propuesta era 121, se cambió por la propuesta por el profesor en clase (1234567) y dio como resultado un salto de una milésima en el score
* Experiencia adquirida: El score bajó a 0.74829

####Prueba 8 sobre los datos
* Técnica usada: XGBoost
* Detalles: 
  * Ajustado el XGBoost y utilizando 100 árboles más. Nrounds = 300.
* Experiencia adquirida: El score subió a 0.74447

####Prueba 9 sobre los datos
* Técnica usada: XGBoost
* Detalles: 
  * Ajustado el XGBoost y utilizando 200 árboles más. Nrounds = 500.
* Experiencia adquirida: El score bajó a 0.74505, el número óptimo será 300.

####Prueba 10 sobre los datos
* Técnica usada: XGBoost
* Detalles: 
  * Corrigiendo error al escribir los días del año, 365 en lugar de 356.
* Experiencia adquirida: El score bajó un poco a 0.74455 pero es el dato que más se acerca a la realidad.

####Prueba 11 sobre los datos
* Técnica usada: XGBoost
* Detalles: 
  * La función para dividir la edad en días contiene plurales que no fueron tomadas en cuenta al momento de realizar la función. Se agregaron los plurales Years, Months, Weeks.


####Prueba 12 sobre los datos
* Técnica usada: XGBoost
* Detalles: 
  * Realizando la misma función pero con 100 NRounds menos 
* Experiencia adquirida: l score bajó 074831, se reafirma que los 300 NRounds es lo óptimo

####Prueba 13 sobre los datos
* Técnica usada: XGBoost
* Detalles: 
  * Se agregó a la función del cálculo de edad, los elementos vacíos de la columna. 
* Experiencia adquirida: Se pudo subió un 0.00038 en el score.

###Tabla de Resumen

Nº | Descripción de manipulación de datos | Resumen de algoritmos y software empleados | Fecha | Score | Posición |
:---:|:---:|:---:|:---:|:---:|:---:|
1 | Subida del Sample Submission original asignando todos los casos a la adopción | Asignar a todos los casos el resultado de adopción. | 19/05 | 20.25113 | 639 |
2 | Sample Submission asignando todos los casos a la muerte. | Asignar a todos los casos el resultado de muerte | 19/05 | 34.27045 | 639 |
3 | Sample Submission asignando todos los casos a la eutanasia. | Asignar a todos los casos el resultado de eutanasia | 26/05 | 32.51276 | 639 |
4 | Sample Submission asignando todos los casos a regresar el animal. | Asignar a todos los casos el resultado de regresar el animal. | 26/05 | 28.51499 | 639 |
5 | Sample Submission asignando todos los casos a la transferencia del animal | Asignar a todos los casos el resultado de la transferencia del animal. | 26/05 | 22.60577 | 639 |
6 | Creando variables a partir de la columna DateTime. Eliminado de columnas innecesarias. | XGBoost, Missing Values. | 27/05 | 0.74963 | 167 |
7 | Cambiandole el “Seed” al ejercicio anterior por el que usa el profesor (de 121 a 1234567) | XGBoost, Missing Values | 27/05 | 0.74829 | 162 |
8 | Ajustando parámetros del XGBoost. 300 vueltas en lugar de 200 | XGBoost | 27/05 | 0.74447 | 148 |
9 | Ajustando parámetros del XGBoost. 500 vueltas en lugar de 300 | XGBoost | 27/05 | 0.74505 | 148 |
10 | Corrigiendo error de días en años (365 en lugar de 356) | XGBoost | 27/05 | 0.74455 | 148 |
11 | Agregando plural en la función de edad a días. | XGBoost | 31/05 | 0.74455 | 158 |
12 | Función de días con 200 NRounds en lugar de 300 | XGBoost | 31/05 | 0.74831 | 158 |
13 | Agregando edades vacías dentro de la función. | XGBoost | 31/05 | 0.74409 | 154 |



###Bibliografía
* (s.f.). Obtenido de https://cran.r-project.org/web/packages/xgboost/xgboost.pdf
* (s.f.). Obtenido de https://github.com/dmlc/xgboost/blob/master/doc/parameter.md
* (s.f.). Obtenido de https://www.kaggle.com/forums/f/15/kaggle-forum/t/17120/how-to-tuning-xgboost-in-an-efficient-way
* (s.f.). Obtenido de https://www.kaggle.com/hamelg/shelter-animal-outcomes/exploration-and-initial-xgb-0-75018

[*José Manuel Rodríguez*](http://twitter.com/Jose_M01)
