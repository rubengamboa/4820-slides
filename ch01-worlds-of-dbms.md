title:        COSC 4820 Database Systems
subtitle:     The Worlds of Database Systems
author:       Ruben Gamboa
$logo:         uw-logo-small.png
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

# The Evolution of Database Systems

---

## Who Uses Databases?

* All your student records are in a database
  <br><br>
* Every major website is powered by a database
* If a website uses a shopping cart, it's probably using a database
  <br><br>
* Corporations keep databases of their customers
* (and they're using them to track you)
  <br><br>
* Your phone uses a database to store your contacts
* And it may be using one to keep track of your health stats over time
  <br><br>
* Scientists store data from experiments or observations in databases

---

## Why Do Databases Work So Well?

* Building a database is extremely difficult
* But we've figured out how to do it over the last several decades!
  <br><br>
* A **Database Management System** or **DBMS** allows us to manage
  large amounts of persistent data
* The DBMS handles a lot of details that are important, but difficult to deal with
  * persitent data format
  * handle crashes and recovery
  * support for multiple users

---

## What Does a Database Do?

* Allow users to create new database **schemas** through a **data-definition language (DDL)**
  * **schema:** logical structure of the data
* Allow users to query or modify the data through a **data-manipulation language (DML)**
* Support efficient storage of data (up to petabytes $10^15$ or exabytes $10^18$)
* Enforce **durability**, or data recovery after accidents (intentional or otherwise)
* Allow simultaneous access to the data, while ensuring **atomicity** and **isolation**
  * **atomicity:** each user's action is performed fully or not at all
  * **isolation:** no unexpected interactions between users, e.g., no partial results

---

## Brief History of Databases

* The history of computers starts with **ballistics**
  * As in the ballistics equations of hitting a tank with a shell
  * Or hitting a stationary target with a bomb
* But the **commercial** history of computers starts with databases
  * Airline reservation systems
  * Banking systems
  * Corporate records
  <br><br>  
* Those database systems asked the programmer to design the links between the data records
* This led to **hierarchical** or **network** databases
* Note: "network" refers to the data model, as in "graph" -- not to a "database on a cloud"

---

## Relational Database Systems

* Relational database systems were first proposed by Codd in 1970
  <br><br>
* Key concept: data is organized in **tables** or **relations**
* These are flat, two-dimensional structures (unlike the hierarchical databases)
* Today, we'd call them spreadsheets
  <br><br>
* A DBMS is free to implement relations in any way it wants
* But the programmer sees them as just tables
  <br><br>
* In 1980s, relational databases were considered cool, impractical curiosities
* By the 1990s, they were standard
  <br><br>
* They became popular because we figured out how to implement tables very
  efficiently
* This is similar to the history of high-level languages

