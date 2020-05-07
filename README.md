# AS Project 

## Requirements

- Elixir

## TODO

- Ojo, creo que tener en Directory llamadas del tipo "Stowaway.x" o "Boater.x" es incorrecto. Puede que rompa la consistencia de separación de servidores, lo mejor sería implementar los metodos que realizan los handlecall en el Directory. -FranPe

- Una vez añadido y terminado todo es importante controlar la privacidad de las funciones que no queremos que esten a disposición del usuarios. (defp). -FranPe

## Boater Service

```
To launch Boater Service

Boater.start(<Server_Quantity>)

To stop Boater Service

Boater.stop()
```

## Stowaway Service

```
To launch Stowaway Service

Stowaway.start(<Server_Quantity>)

To stop Boater Service

Boater.stop()
```
## Client Run

```
To launch Stowaway Client

Directory.cliente_stowaway(<Login_in_string>)

To launch Boater Client


Directory.cliente_boater(<Login_in_string>)

To send menssages to Stowaway Service


Directory.enviar_stowaway(<Message_Number>)

To send menssages to Boater Service

Directory.enviar_Boater(<Message_Number>)

```

