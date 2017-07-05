.DEFAULT_GOAL := help

###
### embulk
###
embulk-run:
	embulk run -b bundle_dir config.yml

embulk-bundle:
	cd bundle_dir; embulk bundle

mkbundle:
	embulk mkbundle bundle_dir

###
### digdag
###
digdag-sched:
	digdag scheduler

digdag-pg:
	_JAVA_OPTIONS=-Djava.io.tmpdir=/tmp \
	digdag server --task-log log --config postgresql.properties

digdag-h2:
	_JAVA_OPTIONS=-Djava.io.tmpdir=/tmp \
	digdag server --task-log log --config h2.properties

###
### MySQL
###
mysql:
	docker run $(run_opts) --link mysqld:mysql \
		--rm mysql \
		bash -c 'mysql -s -u foo -pabc123 -h $$MYSQL_PORT_3306_TCP_ADDR mydb'

mysql-it:
	@make mysql run_opts=-it

mysql-start:
	docker run --name mysqld \
		-p 3306:3306 \
		-v `pwd`/mydata:/var/lib/mysql \
		-e MYSQL_DATABASE=mydb \
		-e MYSQL_USER=foo \
		-e MYSQL_PASSWORD=abc123 \
		-e MYSQL_ROOT_PASSWORD=verysecret \
		-d mysql

mysql-restart:
	docker start mysqld

mysql-stop:
	docker stop mysqld

mysql-rm:
	docker rm mysqld

###
### PostgreSQL
###
psql:
	docker run $(run_opts) --rm \
		-e PGPASSWORD=abc123 \
		--link some-postgres:postgres \
		postgres \
		psql -h postgres -U postgres

psql-it:
	@make psql run_opts=-it

pg-start:
	docker run --name some-postgres \
		-p 5432:5432 \
		-e POSTGRES_PASSWORD=abc123 \
		-v `pwd`/pgdata:/var/lib/postgresql/data \
		-v `pwd`/pginitdb.d:/docker-entrypoint-initdb.d \
		-v `pwd`/pg.d/postgresql.conf:/etc/postgresql.conf \
		-d \
		postgres -c config_file=/etc/postgresql.conf

pg-restart:
	docker start some-postgres

pg-stop:
	docker stop some-postgres

pg-rm:
	docker rm some-postgres

###
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
