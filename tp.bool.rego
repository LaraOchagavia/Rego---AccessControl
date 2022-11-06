package TP.bool
## Problema 1: Policys booleanas

default access_granted = false
## Comparacion, == 
cat_has_full_access{
    cats[input.gato].profession == "Police officer"
}
## Sentencia simple
allow{
    cat_has_full_access 
}
## Indexacion y referenciado
allow{
    rooms[input.room].allowed_professions[_] == cats[input.gato].profession
    cats[input.gato].tenure >=  rooms[input.room].min_tenure
}
## Sentencia doble, reglas bajo el mismo nombre
allow{
    #cat_profession_is_right 
    cat_has_enough_tenure
}
##
cat_works_in_this_room {
	room:= data.rooms[input.room]
    cat := data.cats[input.gato]
    room.allowed_professions[_] == cat.profession
}

cat_has_enough_tenure {
	cat_tenure := data.cats[input.gato].tenure
    room_tenure := data.rooms[input.room].min_tenure
    cat_tenure >= room_tenure
}
# Not
access_granted{ 
    allow
    not deny
} 
## deny

deny{
	cats_in_room := data.rooms[input.room].current_capacity
    max_capacity := rooms[input.room].max_capacity
    cats_in_room >= max_capacity
}

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
