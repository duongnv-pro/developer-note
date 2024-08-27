# Postman Beginner Tutorial

![](https://i.imgur.com/waxVImv.png)

### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

## Test your front-end against a real API
- https://reqres.in/api/users


## How to add and refer Variables

1, add variables
Collection -> Edit -> Variables ->

```
url =  https:https://reqres.in/api
```
2, refer variables

```
{{url}}
```

### Get and Set Variables with Scripts
Priority
- Local
- Data
- Env
- Collection
- Global


#### Set Variables with script

- Global:           pm.globals.set("access_token", "xxx")
- Collection:       pm.collectionVariables.set("access_token", "xxx")
- Environment:      pm.environment.set("access_token", "xxx")
- Local:            pm.variables.set("access_token", "xxx")

#### Get Variables with script

- Global:           pm.globals.get("access_token")
- Collection:       pm.collectionVariables.get("access_token")
- Environment:      pm.environment.get("access_token")
- Local:            pm.variables.get("access_token") **access a variable at any scope including local based on priority**


#### To remove

- pm.environment.unset("access_token")

## Environments

- Create a api request
- Create environment and add key-value pairs (variables)
- Refer the variables in request
- Select the environment from dropdown and run request
- Create more environments and execute request

Ex:
Name: QA
  - endpoint: /api/register
  - email: eve.holt@reqres.in
  - password: pistol

```
url: https://reqres.in/{{endpoint}}
body:
{
 "email": "{{email}}",
 "password": "{{password}}",
}
```

## How to Debug

- console.log()
- console.info()
- console.warn()
- console.error()

## Data Driven Testing
### How to get data from CSV/JSON file
Run Collection -> Data(Select File) -> Preview
