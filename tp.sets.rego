package TP.sets

#Conversión a estructura jerárquica
rooms := {name:att | 
    name:=data.room_attributes[i].room
    att:=data.room_attributes[i]
}

cats := {name:att |
    name:=data.cats[i].name
    att:=data.cats[i]
}

food := {name:att |
    name := data.food_attributes[i].name
    att := data.food_attributes[i]
}

#PROBLEMA 2: CONJUNTOS/SETS
## FILTRADO DE DATOS

#################################################
#Conjunto simple: todos los alimentos disponibles
#################################################

#Policy: 
# -Qúe comida le doy a cada gato?

#I --> conjunto
alimentos[Alimento] { Alimento := data.food_attributes[_].name}

#II
alimentos_disponibles := {alimentos.name |
    alimentos := data.food_attributes[_]
}

#III
alimentos_disponibless := { nombre |
    alimentos := data.food_attributes[_]
    nombre := alimentos.name
}

#IV --> Objeto con objetos dentro
alimentos_disponiblesx := {alimentoo.name:out |
    alimentoo := data.food_attributes[_]
    out := {
        "Para tamanos": alimentoo.sizes,
        "Prohibido para gatos con": alimentoo.forbidden_for_diseases,
    }
}

###############################################
#Los alimentos que cumplen con alguna condición
###############################################

#I
alimentos_prohibidos_enfermedad := {alimentos.name |
    alimentos := data.food_attributes[_]
    alimentos.forbidden_for_diseases[_] == input.disease
}

#II
alimentos_permitidos_tamano := { alimentos.name |
    alimentos := data.food_attributes[_]
    alimentos.sizes[_] == input.size
}


#####################
# Teoría de conjuntos
#####################

#I -->Intersección de conjuntos
alimento_permitido_gato := alimento_x_tamano_gato & alimento_x_enfermedad_gato
#Con info desde el input

alimento_x_tamano_gato := {alimentos.name |
    alimentos := data.food_attributes[_]
    input.name == data.cats[i].name
    data.cats[i].size == alimentos.sizes[_]
}
alimento_x_enfermedad_gato[nombre]{
    alimentos := data.food_attributes[_]
    nombre := alimentos.name
    not alimentos_enfermedad_not_gato[nombre]
}
alimentos_enfermedad_not_gato[nombre]{
    alimentos := data.food_attributes[_]
    nombre := alimentos.name
    input.name == data.cats[i].name
    data.cats[i].diseases[_] == alimentos.forbidden_for_diseases[_]
}

#II -->Diferencia de conjuntos
Alimento_permitido_gato := alimento_x_tamano_gato & alimento_por_enfermedad

alimento_por_enfermedad := alimentos_disponibles - alimentos_prohibidos 

alimentos_prohibidos := { alimento.name |
    alimento := data.food_attributes[_]
    input.name == data.cats[i].name
    data.cats[i].diseases[_] == alimento.forbidden_for_diseases[_]
}

#III -->Unión de conjuntos
alimentos_adultos := alimentos_para_large | alimentos_para_average

alimentos_para_large := {alimento.name |
    alimento := data.food_attributes[_]
    alimento.sizes[_] == "large"
}
alimentos_para_average := {alimento.name |
    alimento := data.food_attributes[_]
    alimento.sizes[_] == "average"
}


##################################################
# Mapeo de los alimentos que puede comer cada gato (implementa diferencia de conjuntos)
##################################################

Alimentos_x_gato := {gato.name:out |
    gato := cats[i]
   
    alimentos := { comida.name |
        comida := data.food_attributes[j]
        comida.sizes[_] == gato.size
    }

    alimentos_not := {comida.name |
        comida := data.food_attributes[j]
        comida.forbidden_for_diseases[_] == gato.diseases[_]
    }

    out := {
        alimentos - alimentos_not
    }
}


###################################################
# Mapeo de los gatos que pueden comer cada alimento
###################################################

Gatos_x_alimento := {alimento.name:out |
    alimento := food[i]
   
    gatos := { gatitos.name |
        gatitos := cats[j]
        alimento.sizes[_] == gatitos.size
    }

    gatos_not := {gatitos.name |
        gatitos := cats[j]
        alimento.forbidden_for_diseases[_] == gatitos.diseases[_]
    }

    out := {
        "Gatos que pueden comerlo": gatos - gatos_not
    }
}

########################################################################
# Alimentos clasificados según el tamaño de los gatos que pueden comerlo
########################################################################

Alimentos_tamano[size] = alimentos {
    size := food[_].sizes[i]

    alimentos := {alimento.name |
        alimento := food[_]
        alimento.sizes[_] == size
    }    
}

##
alimentos_large[nombre]{
    alimento := data.food_attributes[_]
    nombre := alimento.name
    alimento.sizes[_] == "large"
}

alimentos_small[nombre]{
    alimento := data.food_attributes[_]
    nombre := alimento.name
    alimento.sizes[_] == "small"
}

alimentos_average[nombre]{
    alimento := data.food_attributes[_]
    nombre := alimento.name
    alimento.sizes[_] == "average"
}
##

####################################
# Gatos clasificados según su tamaño
####################################

Gatos_tamano[size] = gatos {
    size := food[_].sizes[i]

    gatos := {gato.name |
        gato := cats[_]
        gato.size == size
    }    
}

##
gatos_pequenos[nombre]{
    nombre := data.cats[i].name
    data.cats[i].size == "small"
} 

gatos_medianos[nombre]{
    nombre := data.cats[i].name
    data.cats[i].size == "average"
}

gatos_grandes[nombre]{
    nombre := data.cats[i].name
    data.cats[i].size == "large"
}
##

#######################################################################################
# Alimentos clasificados según las enfermedades que pueden tener los gatos que lo coman
#######################################################################################

Alimentos_enfermedad[diseases] = alimentos {
    diseases := cats[_].diseases[i]
    alimentos_not := {alimento.name |
        alimento := food[_]
        alimento.forbidden_for_diseases[_] == diseases
    }
    todos_los_alimentos := {alimento.name |
        alimento := food[_]
    }
    alimentos := todos_los_alimentos - alimentos_not
}

##
alimento_diabetes[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    not alimentos_not_diabetes[nombre]
}
alimentos_not_diabetes[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    alimentos.forbidden_for_diseases[_] == "Diabetes"
}

alimento_cardiacos[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    not alimentos_not_cardiacos[nombre]
}
alimentos_not_cardiacos[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    alimentos.forbidden_for_diseases[_] == "Heart Problems"
}

alimento_cistitis[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    not alimentos_not_cistitis[nombre]
}
alimentos_not_cistitis[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    alimentos.forbidden_for_diseases[_] == "Cystitis"
}

alimento_higadograso[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    not alimentos_not_higadograso[nombre]
}
alimentos_not_higadograso[nombre]{
    alimentos:=data.food_attributes[_]
    nombre := alimentos.name
    alimentos.forbidden_for_diseases[_] == "Fatty Liver"
}
##

###########################################
# Gatos clasificados según sus enfermedades
###########################################

Gatos_x_enfermedad[diseases] = gatos {
    diseases := cats[_].diseases[i]
    gatos := { gato.name |
        gato := cats[_]
        gato.diseases[_] == diseases
    }
}

##
Gatos_diabeticos[nombre]{
    nombre := data.cats[i].name
    data.cats[i].diseases[_] == "Diabetes"
}

Gatos_cardiacos[nombre]{
    nombre := data.cats[i].name
    data.cats[i].diseases[_] == "Heart Problems"
}

Gatos_higadograso[nombre]{
    nombre := data.cats[i].name
    data.cats[i].diseases[_] == "Fatty Liver"
}

Gatos_cistitis[nombre]{
    nombre := data.cats[i].name
    data.cats[i].diseases[_] == "Cystitis"
}
##
