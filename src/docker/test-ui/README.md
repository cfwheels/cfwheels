# cfwheels-test-suite-ui

This vueJS app just provides a way of queuing tests for each of the docker containers. It should start on localhost:3000 when using `docker-compose up`.
If you want to make changes to the interface, it's easiest to run it in development mode which provides hot reloading.

## Project setup for local development
```
npm install
```

Installs required dependencies in `node_modules` (which is git ignored)

### Compiles and hot-reloads
```
npm run serve
```

Starts the local development server. It will try for localhost:3000 but if it can't open on that port will try 3001 etc

### Compiles and minifies for production
```
npm run build
```

When you've made your changes, build it and commit the changes

### Lints and fixes files
```
npm run lint
```

### Customize configuration

See [Configuration Reference](https://cli.vuejs.org/config/).
