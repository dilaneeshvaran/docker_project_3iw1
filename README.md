# Project Docker 3IW1

## Getting Started

### Prerequisites

* Make sure ports 8081 and 8082 are not being used on your system

### Installation

1. Start the Docker containers:

   ```bash
   docker compose up
   ```

   > **Note**: Wait a few minutes for all scripts to execute completely, it may take some time to run the first time meanwhile you can monitor the logs to track the progress.

## Accessing the Application

* Service 1 : [http://localhost:8081](http://localhost:8081)
* Service 2 : [http://localhost:8082](http://localhost:8082)

### MySQL Database Verification

If you want to see the registered users, follow these steps :

1. Access the MySQL container:

   ```bash
   docker exec -it mysql bash
   ```

2. Connect to MySQL using the provided credentials :

   ```bash
   mysql -u laravel -p
   ```

   Password: `laravel`

3. Select the database :

   ```bash
   USE laravel
   ```

4. SQL query to view users table data :

   ```bash
   SELECT * FROM users;
   ```

## Authors

* Dilan EESHVARAN
* Sylvain ANTON
* Joel AKA
