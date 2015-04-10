title:        COSC 4820 Database Systems
subtitle:     SQL in a Server Environment
author:       Ruben Gamboa
#logo:         uw-logo-small.png
#biglogo:      uw-logo-large.png
job:          Associate Professor
highlighter:  highlight.js
hitheme:      tomorrow
mode:         selfcontained
framework:    io2012
widgets:      [mathjax, bootstrap]

---

<style>
.title-slide {
     background-color: #EDE0CF; /* CBE7A5; #EDE0CF; ; #CA9F9D*/
     background-image: url(assets/img/uw-logo-large.png);
     background-repeat: no-repeat;
     background-position: center top;
   }
</style>

## Chapter Overview

* This chapter is about programming **database applications**
* We will begin with the model for client/server computing and how this is really done in modern systems (i.e., the web)
* We will also discuss different ways that a program can interact with a database

---

# The Three-Tier Architecture

---

## The Three-Tier Architecture

* This is the dominant architecture for modern enterprise systems

1. **Web servers** create a layer for humans to interact with the system
2. **Application servers** perform the actual business logic of the application
   * These may be provided strictly to the web servers
   * They man also be available to **other programs** via **web services**
3. **Database servers** perform queries and manipulate the data

---

## The Three-Tier Architecture

<div class="centered">
    <img src="assets/img/three-tier-architecture.png" title="Three-Tier Architecture" alt="Three-Tier Architecture">
</div>

---

## The Web Server Tier

* The web server is responsible for creating the **view** or user interface
* This will consist of HTML, CSS, JavaScript, media files, etc.

<br>

* User interaction will be in the way of **requests**, e.g., an filling out HTTP form or clicking on a link
* The server with send **responses**, which may be new HTML pages or documents

<br>

* Of course, the UI may be implemented in other ways

---

## The Application Tier

* This is responsible for handling user requests **at the database level**
* I.e., it does not care about the actual UI
* It only cares about what the requests mean for the enterprise systems

<br>

* In very simple systems, the application tier directly accesses the database
* In more complex systems, there can be a very complicated network of objects or services,
  and the application tier may have to **integrate** them
* Different services may communicate with each other
  * synchronously
  * asynchronously
  * via messaging
  * indirectly, e.g., via the database
* There may even be a need to make transactions that span multiple services!

---

## The Database Tier

* This are services or classes that interact with the database
* It is also known as the **persistence layer**

<br>

* Remember that connections to the database are expensive
* Also, connections may take a long time to start up
* These types of details are handled in the database tier, e.g., by **connection pooling**

---

# The SQL Environment

---

## The SQL Environment

* A **SQL Environment** is a particular installation of a relational database that you can access
* It may consist of one or more database **instances** running on one or more physical servers
* The largest unit of information is a **cluster**, which corresponds to a "database"

<div class="centered">
    <img src="assets/img/sql-environment.png" title="SQL Environment" alt="SQL Environment">
</div>

---

## Components of a SQL Environment

> * **Schemas** are collections of related tables, views, indexes, triggers, assertions, etc.
    * Schemas also have information about the tables, etc., that they contain
    <br><br>
* **Catalogs** are collections of schemas, and they provide information on the schemas they manage
  <br><br>
* **Clusters** are collections of catalogs

---

## Schemas

* You can create a schema with `CREATE SCHEMA ...` command
  * `CREATE SCHEMA MovieInformation`
* A schema may also be associated with a particular user
  <br><br>
* You can also select a particular schema to be the **current** schema
  * `SET SCHEMA MovieInformation`
  * `USE MovieInformation`
  * ...
  <br><br>
* After this, you can create tables, etc.

---

## Catalogs

* Catalogs let you manage multiple schemas
* They often correspond to different **instances** of a database
* I.e., they are managed by different database processes
* There is no standard way to create catalogs or select the current catalog

---

## Database Processes

* A **SQL Server** is just a database server
* It handles requests and sends back responses (e.g., query results)
  <br><br>
* A **SQL Client** is an application that sends requests to a SQL Server
* Note a "SQL Client" may in turn be an "application server"
* Words like "client" and "server" have limited meaning, but they are useful in the proper context

---

## Connections

* A SQL client needs a **connection** to talk to a database server
* This may be as simple as

  ```
  CONNECT TO server_name AS connection_name AUTHORIZATION username AND password
  ```

* Later, you can (and **should**) release the connection with

  ```
  DISCONNECT connection_name
  ```

<br>

* Of course, the syntax for this is very incompatible between systems

---

## Database Sessions

* A **session** is associated with each connection
* The session refers to the commands that are executed within a connection
* Note: a session may consist of one or more **transactions**

<br>

* Sessions have state associated with them, including
  * current user, with associated privileges
  * user preferences (e.g., language)
  * current catalog, schema, etc.
  * database cursors

---

## SQL Modules

* A **SQL module** is an application that interacts with the database
* The SQL standard recognizes three types of modules:
  1. **Generic SQL Interface** allows a user to type in ad-hoc queries that are executed one at a time
  2. **Embedded SQL** involves SQL statements that are blended with the application language
     * Usually requires a preprocessor that extracts the SQL from the application language
     * The application language used to be COBOL, but it can be C or Java
  3. **True modules** include a collection of cooperating application modules and stored procedures

<br>

* When a SQL module is executing, it is called a **SQL agent**
* This is the same distinction as between programs and processes

---

# The SQL/Host Language Interface

---

## The SQL/Host Language Interface

<div class="centered">
    <img src="assets/img/sql-host-interface.png" title="SQL/Host Language Interface" alt="SQL/Host Language Interface">
</div>

---

## The SQL/Host Language Interface

1. **Call-Level Interface** is a set of language functions that communicate with the database
   * E.g., it can be a set of Java classes that provide access to a database server
   * SQL queries are treated as **strings** only
   * So there is no syntax checking of SQL queries
<br><br>
2. **Embedded SQL** is an approach where the language is **extended** to allow SQL in program blocks
   * There can be a specialized compiler than handles the extended language
   * Or there can be a preprocessor that converts the X+SQL into plain X using the call-level interface
   * In either case, syntax checking of SQL queries is possible

---

## The Impedance Mismatch

* Procedural languages have a strict set of data types (integers, strings, pointers, etc.)
* They support mutable variables, loops, if statements, etc.
* They work with one data at a time
* In order to process N data items, they would use a loop

<br>

* Databases work on many items at a time (e.g., all rows in a table)
* They have predefined data types, some of which are specialized and ill-defined
* They do not (for the most part) support if statements, loops, etc.

<br>

* The challenge is to get these two different programming models to coexist
* This is called the **impedance mismatch**

---

## Embedded SQL

* Embedded SQL is one way to solve the impedance mismatch
* This provides a special way to include SQL commands in C (or your programming language of choice)
* The SQL code and C code communicate via shared variables

```
EXEC SQL BEGIN DECLARE SECTION;
    char studioName[50];
    int  presNetWorth;
    char SQLSTATE[6];
EXEC SQL END DECLARE SECTION;

strcpy(studioName, "Lucasfilm");

EXEC SQL SELECT netWorth INTO :presNetWorth
           FROM Studios JOIN MovieExecs ON presC# = cert#
          WHERE Studios.name = :studioName;
          
printf ("The president of Lucasfilm is worth $%d", presNetWorth);
```

---

## Embedded SQL Concepts

* SQL blocks are introduced via `EXEC SQL`
* The SQL code and C code communicate via shared variables
  * These look like regular variables to C
  * They have a leading ":" in the SQL code
* Shared variables are declared inside `DECLARE SECTION` blocks

```
EXEC SQL BEGIN DECLARE SECTION;
    char studioName[50];
    int  presNetWorth;
    char SQLSTATE[6];
EXEC SQL END DECLARE SECTION;
```

---

## SQLSTATE

```
EXEC SQL BEGIN DECLARE SECTION;
    ...
    char SQLSTATE[6];
EXEC SQL END DECLARE SECTION;
```

* The variable SQLSTATE is special
* If you declare a variable with this name (and you should), it will receive a special status code from the last SQL statement
  * The codes are **strings** (not numbers) of 5 characters
  * (So in C, you must declare an array of 6 characters, to leave room for the trailing '\0' character)

* Many of the codes are standard (and many more are database-specific)
  * **00000** means "no error"
  * **02000** means "no (more) answers"

---

## Cursors

* In the last example, we saw a query that returned **only one row**
* But what if you want to find all the Movies made by Lucasfilm?
* This is part of what we mean by **impedance mismatch**

<br>

* A modern solution might be to return a **collection** of results
* You  have to be careful, because there may not be enough memory to hold all the results in the client

---

## Cursors

* A modern solution might be to return an **iterator** over a collection
* This gives the illusion that we are working on a collection of items, but the collection may actually be held in the database
* Note: This does **not** mean that getting the next result means sending a request to the database
* I.e., the iterator may hold several results in memory at a time

<br>

* A **cursor** is the database term for an iterator
* It lets you step through all the rows in your query result

---

## Using Cursors

* To use a cursor from your code, you need to complete four steps

<br>

1. **Declare** the cursor, which also associates it with a query
2. **Open** the cursor, which initializes the query at the database
3. **Fetch** each row
3. **Close** the cursor when finished

   ```
   EXEC SQL DECLARE cursor_name CURSOR FOR query;
   EXEC SQL OPEN cursor_name;
   EXEC SQL FETCH FROM cursor_name INTO :var1, :var2, ..., :varn;
   ...
   EXEC SQL CLOSE cursor_name;
   ```

* Note: You know you're finished when SQLSTATE has the value **02000**

---

## Using Cursors

```
EXEC SQL BEGIN DECLARE SECTION;
    int  cert_number;
    char title[100];
    int  year;
    char SQLSTATE[6];
EXEC SQL END DECLARE SECTION;

EXEC SQL DECLARE c_movies CURSOR FOR
     SELECT title, year
       FROM Movies
      WHERE presC# = :cert_number
      ORDER BY year;
```

---

## Using Cursors

```
EXEC SQL OPEN c_movies;
for (;;) {
    EXEC SQL FETCH FROM c_movies INTO :title, :year;
    if (!strcmp(SQLSTATE,"02000"))
        break;
    printf ("%d, %s\n", year, title);
}
EXEC SQL CLOSE c_movies;
```

---

## Modifying Rows

* One way to modify rows is simply to execute an UPDATE command
* Sometimes, it's convenient to update the row we happen to be reading currently
* This is possible with cursors
* The WHERE clause should be "WHERE CURRENT OF cursor_name"

---

## Modifying Rows

```
EXEC SQL DECLARE c_emps CURSOR FOR
     SELECT employee_id, rating, salary
       FROM Employees;
EXEC SQL OPEN c_emps;
for (;;) {
    EXEC SQL FETCH FROM c_emps INTO :id, :rating, :salary;
    if (!strcmp(SQLSTATE,"02000"))
        break;
    if (rating >= 9)
        EXEC SQL UPDATE Employees
                    SET salary = 1.1 * :salary
                  WHERE CURRENT OF c_emps;
    else if (rating <= 2)
        EXEC SQL DELETE FROM Employees
                  WHERE CURRENT OF c_emps;
}
EXEC SQL CLOSE c_emps;
```

---

## Dynamic SQL

* So far, the SQL code that will be executed has been visible in the code
* But what if you have to create the SQL code in C?
* E.g., your application can build a string by appending conditions to some base

  ```
  q = "SELECT * FROM Employees WHERE rating >= 10";
  q = q + " AND location='US'";
  q = q + " AND last_name LIKE '%jones%";
  ```

* Note: You should **avoid** dynamic SQL
* Repeat: **Avoid** dynamic SQL

<br>

* Note: If all that changes is a parameter, you can use static SQL and a shared variable
* E.g., "rating >= :min_rating"

---

## Using Cursors

```
EXEC SQL BEGIN DECLARE SECTION;
    int  cert_number;
    char *query = "SELECT title, year
                     FROM Movies
                    WHERE presC# = :cert_number";
EXEC SQL END DECLARE SECTION;
EXEC SQL PREPARE sql_query FROM :query USING;
EXEC SQL DECLARE c_query CURSOR FOR sql_query;

cert_number = 12345;
EXEC SQL OPEN c_query;
for (;;) {
    EXEC SQL FETCH FROM c_query INTO :title, :year;
    if (!strcmp(SQLSTATE,"02000"))
        break;
    printf ("%d, %s\n", year, title);
}
EXEC SQL CLOSE c_movies;
```

---

## Using Cursors

```
EXEC SQL BEGIN DECLARE SECTION;
    int  cert_number;
    char *query = "SELECT title, year
                     FROM Movies
                    WHERE presC# = ?";
EXEC SQL END DECLARE SECTION;
EXEC SQL PREPARE sql_query FROM :query USING;
EXEC SQL DECLARE c_query CURSOR FOR sql_query;

cert_number = 12345;
EXEC SQL OPEN c_query USING :cert_number;
for (;;) {
    EXEC SQL FETCH FROM c_query INTO :title, :year;
    if (!strcmp(SQLSTATE,"02000"))
        break;
    printf ("%d, %s\n", year, title);
}
EXEC SQL CLOSE c_movies;
```
