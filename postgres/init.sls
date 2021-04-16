postgresql:
  pkg.installed

'createuser toni && createdb toni':
  cmd.run:
    - runas: postgres
    - unless: 'psql -c "\du"|grep toni'

'psql -c "CREATE TABLE employees(id serial primary key, name varchar(250), address varchar(250))"':
  cmd.run:
    - runas: toni
    - unless: 'psql -c "\d"|grep employees'
