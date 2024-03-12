# NestJS Zero to Hero – Modern TypeScript Back-end Development

![](https://i.imgur.com/waxVImv.png)

### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

### Installing the NestJS CLI

```
nvm install --lts

yarn global add @nestjs/cli
```

### Task Management Application

#### 1. Application Structure ( Long - term )

AppModule (root)

- TasksModule
  - TasksController
  - TasksService
  - StatusValidationPipe
  - TaskEntity
  - TaskRepository
  - ...
- AuthModule
  - AuthController
  - AuthService
  - UserEntity
  - UserRepository
  - JwtStrategy
  - ...

#### 2. Objectives: NestJS

- NestJS Modules
- NestJS Controllers
- NestJS Services and Providers
- Controller-to-Service communication
- Validation using NestJS Pipes

#### 3. Objectives: Back-end & Architecture

- Develop production-ready REST APIs
- CRUD operations (Create, Read, Update, Delete)
- Error handling
- Data transfer objects (DTOs)
- System modularity
- Back-end development best practices
- Configuration Management
- Logging
- Security best practices

#### 4. Objectives: Persistence

- Connecting the application to a database
- Working with relational databases
- Using TypeORM
- Writing simple and complex queries using QueryBuilder
- Performance when working with a database

#### 5. Objectives: Authorization/Authentication

- Signing up and signing in
- Authentication and Authorization
- Protected resources
- Ownership of tasks by user
- Using JWT tokens (JSON Web Tokens)
- Password hashing, salt and property storing passwords

#### 6. Objectives: Deployment

- Polishing the application for Production use
- Deploying NestJS app to AWS(Amazon Web Services)
- Deploying front-end application to Amazon S3
- Writing up the front-end and back-end

### Creating Project

```
nest new nestjs-task-management

yarn start:dev
``````

### 4. Introduction to NestJS Modules
- Each application has at least one module - the root module. That is the starting point of the application.
- Modules are an effective way to organize components by a closely related set of capabilities (e.g. per feature).
- It is a good practice to have a folder per module, containing the module's components.
- Modules is singletons, therefore a module can be imported by multiple other modules.

**Defining a Module**

A module is defined by annotating a class with the **@Module** decorator.

**@Module Decorator Properties**
- **providers**: Array of providers to be available within the module via dependency injection.
- **controllers**: Array of controllers to be instantiated within the module.
- **exports**: Array of providers to be export to other modules.
- **imports**: List of modules required by this module. Any exported provider by these modules will be available in our module via dependency injection.

ForumModule Example
- ForumModule
  - PostModule
  - CommentModule
  - AuthModule
- UserProfileModule
  - PostModule
  - CommentModule

```typescript
@Module({
  providers: [ForumService],
  controllers: [ForumController],
  imports: [
    PostModule,
    CommentModule,
    AuthModule
  ],
  exports: [
    ForumService
  ],
})

export class ForumModule {}
```
### 5. Creating a Tasks Module
