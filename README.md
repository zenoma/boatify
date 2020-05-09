# AS Project 

## Requirements

- Elixir

## TODO

- Caso de uso, realizarViaje (Boater)
    Un Boater realiza un Trip poniendolo en "Done" y haciendo el cambio pertinente en Stowaway

- ExDoc is a tool to generate documentation for your Elixir projects. https://github.com/elixir-lang/ex_doc       

- OPTIONAL:
    - En el caso de uso, CancelarReserva(Stowaway) es necesario controlar el error de que no exista viaje con su login/id/open.
    - Ver viajes disponibles, mi historial de reservados y mi historial de subidos, no controla que no haya viajes para alguno de ellos.

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

## Bebugger Start

```
To load the debugger

    :debugger.start

To load the modules to debug

    :int.ni(<Module>)

```