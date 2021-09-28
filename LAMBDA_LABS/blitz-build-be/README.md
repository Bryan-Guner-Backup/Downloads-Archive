
![Heroku](http://heroku-badge.herokuapp.com/?app=heroku-badge&root=projects.html) ![NPM](https://badgen.net/npm/v/express) [![Build Status](https://travis-ci.org/Lambda-School-Labs/blitz-build-be.svg?branch=master)](https://travis-ci.org/Lambda-School-Labs/blitz-build-be) [![Inline docs](http://inch-ci.org/github/LAMBDA-SCHOOL-LABS/blitz-build-be.svg?branch=master)](http://inch-ci.org/github/LAMBDA-SCHOOL-LABS/blitz-build-be) ![node](https://badgen.net/npm/node/next)

# API Documentation

#### :rocket: Backend delpoyed at [Blitz Build](https://build-build-production.herokuapp.com/) <br>

##  Getting started

To get the server running locally:



 - Clone this repo :cat:
- **npm install** to install all required dependencies:package:
- **nodemon** to start the local server :alien:
- **npm run test** to start server using testing environment:pencil:

### Framework :wrench:



-    Node / Express 
-    Postgres
-    AWS S3 
-    Jest / Supertest


## Endpoints

[END POINT DOCS](https://documenter.getpostman.com/view/7960570/SWDzeLuk)

#### Non-Auth Routes

PLEASE SEE [END POINT DOCS](https://documenter.getpostman.com/view/7960570/SWDzeLuk) FOR API INFORMATION



#### Auth Routes

PLEASE SEE [END POINT DOCS](https://documenter.getpostman.com/view/7960570/SWDzeLuk) FOR API INFORMATION


# Data Model



####  USERS

---

```
Auth0 Handles All The User_Data

```

#### PROJECTS

---

```
{
  id: [PK] INTEGER Auto Generated By Database
  project_name:STRING UNIQUE
  start_date: STRING
  status:STRING [isComplete,isDelayed,isOnTime]
  beds: NUMBER
  baths: FLOAT
  square_ft: NUMBER
  imageURL: STRING NULL OK
  state: STRING
  street_address:STRING
  city:STRING
  zip_code: INTEGER
  due_date: DATE defaults => 90days from entry
  user_id:[FK] INTEGER
  latitude: INTEGER
  longitude: INTEGER 
  createdAt:STRING
  due_date:STRING
 
}
```
### TASKS
---
```{
  id:INTEGER [PK]
user_id:STRING NOT NULLABLE
task_name:STRING NOT NULLABLE
task_description:STRING
due_date:STRING
start_date:STRING
template_name:STRING
createdAt:DATE
isComplete:BOOLEAN defaults to false
project_id:INTEGER [FK]
template_id:INTEGER [FK]
} 
```

### DELAY_LOGS
---
```
 {
  id:INTEGER [PK]
  project_id:INTEGER [FK]
  createdAt:STRING
  reason:STRING NOT NULLABLE
  task_id:INTEGER [FK]
  updatedAt:STRING
  user_id:STRING NOT NULLABLE

  } 
```

### DOCS_URL
---
```
{
   id:INTEGER [PK]
   file_name:STRING(2000)
   doc_url:STRING(2000)
   user_id:STRING
   project_id:STRING
   project_name:STRING
   createdAt:STRING
} 
```
### TEMPLATES
---
```
{
      id:INTEGER[PK]
      template_name:STRING
      user_id:STRING
}
```

##  Environment Variables

In order for the app to function correctly, the user must set up their own environment variables.

create a .env file that includes the following:


    
   
    *  NODE_ENV - set to "development" until ready for "production"
    *  AUTH0_CLIENT_SECRET - from AUTH0
    *  AUTH0_CALLBACK_URL  -  from AUTH0
    *  AUTH0_CLIENT_ID   -  from AUTH0
    *  AUTH0_DOMAIN     -    from AUTH0
    *  AWS_ACCESS_KEY  -  from your AWS S3 
    *  AWS_SECRET -       from your AWS S3 
    *  BUCKET_NAME -      from your AWS S3 
    *  DATABASE_URI -     from your AWS DB
    
## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue, email, or any other method with the owners of this repository before making a change.

Please note we have a [code of conduct](./code_of_conduct.md). Please follow it in all your interactions with the project.

### Issue/Bug Request

 **If you are having an issue with the existing project code, please submit a bug report under the following guidelines:**
 - Check first to see if your issue has already been reported.
 - Check to see if the issue has recently been fixed by attempting to reproduce the issue using the latest master branch in the repository.
 - Create a live example of the problem.
 - Submit a detailed bug report including your environment & browser, steps to reproduce the issue, actual and expected outcomes,  where you believe the issue is originating from, and any potential solutions you have considered.

### Feature Requests

We would love to hear from you about new features which would improve this app and further the aims of our project. Please provide as much detail and information as possible to show us why you think your new feature should be implemented.

### Pull Requests

If you have developed a patch, bug fix, or new feature that would improve this app, please submit a pull request. It is best to communicate your ideas with the developers first before investing a great deal of time into a pull request to ensure that it will mesh smoothly with the project.

Remember that this project is licensed under the MIT license, and by submitting a pull request, you agree that your work will be, too.

#### Pull Request Guidelines

- Ensure any install or build dependencies are removed before the end of the layer when doing a build.
- Update the README.md with details of changes to the interface, including new plist variables, exposed ports, useful file locations and container parameters.
- Ensure that your code conforms to our existing code conventions and test coverage.
- Include the relevant issue number, if applicable.
- You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.

### Attribution

These contribution guidelines have been adapted from [this good-Contributing.md-template](https://gist.github.com/PurpleBooth/b24679402957c63ec426).

## Documentation

See [Frontend Documentation](https://github.com/Lambda-School-Labs/blitz-build-fe/blob/master/README.md) for details on the frontend of our project.
