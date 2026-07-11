# Tarea2 - Node + AngularJS + MongoDB

Instrucciones rápidas (en Linux Local):

1. Backend

```bash
cd tarea2/backend
npm install
nano .env   # editar MONGO_URI
npm start
```

Esto levantará el servidor en `http://localhost:3000` y servirá el frontend.

2. Abrir la aplicación

Abrir en el navegador `http://localhost:3000`.

3. Detalles

- El backend está en `tarea2/backend/server.js`.
- El modelo Mongoose está en `tarea2/backend/models/User.js`.
- El frontend (AngularJS) está en `tarea2/frontend/index.html`.


#AWS Packer

packer init server_mongo.pkr.hcl
packer validate server_mongo.pkr.hcl
packer build server_mongo.pkr.hcl