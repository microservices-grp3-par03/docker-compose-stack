# central-docker-compose

## Pour lancer les containers et setup le projet
```shell
bash scripts/start-all.sh
```

## Vous aurez accès à : 
- pgAdmin : [pgAdmin](http://localhost:5050/login)
- RabbitMQ Management : [RabbitMQ Management](http://localhost:15672/)
- Une base de données PostgreSQL qui héberge les 3 database user_db, book_db et borrowing_db
- Environnements des microservices :
  -  [user-service](http://localhost:3001/)
  -  [borrowing-service](http://localhost:3002/)
  -  [book-service](http://localhost:3003/)

## Sinon, vous pouvez run cette commande :
Afin de lancer le container docker-compose-stack indépendamment
```shell

docker compose up -d

```
 
