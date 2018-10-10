create new angular project with routing

```
ng new projectname --routing 
```

install bootstrap to project
```
npm i bootstrap jquery popper.js --save
```

add to angular.json
```json
...
"styles": [
  "src/styles.css",
  "./node_modules/bootstrap/dist/css/bootstrap.min.css"
],
"scripts": [
  "./node_modules/jquery/dist/jquery.slim.min.js",
  "./node_modules/popper.js/dist/umd/popper.min.js",
  "./node_modules/bootstrap/dist/js/bootstrap.min.js"
]
...
```
