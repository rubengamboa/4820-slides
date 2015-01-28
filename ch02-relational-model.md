title:        COSC 4820 Database Systems
subtitle:     The Relational Model of Data
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

# An Overview of Data Models

---

## What Is a Data Model?

* A **data model** is a notation for describing data or information
  <br><br>
* It consists of three parts
  1. *Structure* of the data
  2. *Operations* on the data
  3. *Constraints* on the data
  <br><br>
* Some important data models
  * Relational model
  * Semistructured data model
  * Object data model 

---

## The Relational Data Model

Title               | Year   | Length | Genre 
--------------------|--------|--------|-------
Gone With the Wind  | 1939   |    231 | drama
Star Wars           | 1977   |    124 | scifi 
Wayne's World       | 1992   |     95 | comedy

---

## The Relational Data Model

* The relational data model is based on **tables** 
* A **table** is made up of **cells** arranged into **rows** and **columns** (just like in a spreadsheet)
  <br><br>
* The **structure** looks like an array of structs in C++
  * Column headers are field names
  * Each row represents a single struct in the array
  * Each column has a type (e.g., string)
* The **operations** are described using **relational algebra**
  * E.g., find all rows in a table that have a certain value in a certain column
  * E.g., find all rows where the *genre* is "comedy"
* The **constraints** limit the possible values in the cells
  * E.g., the only valid *genres* are "comedy", "drama", or "scifi"
  * E.g., no two movies may have the same *title*

---

## The Semistructured Data Model

```
<Movies> 
    <Movie title="Gone With the Wind"> 
        <Year>1939<Year>
        <Length>231</Length>
        <Genre>drama</Genre>
    </Movie>
    <Movie title="Star Wars"> 
        <Year>1977<Year>
        <Length>124</Length>
        <Genre>scifi</Genre>
    </Movie>
    <Movie title="Wayne's World"> 
        <Year>1992<Year>
        <Length>95</Length>
        <Genre>comedy</Genre>
    </Movie>
</Movies>
```

---

## The Semistructured Data Model

```
[
    { "title":"Gone With the Wind",
      "year":1939,
      "length":231,
      "genre":"drama"
    },
    { "title":"Star Wars",
      "year":1977,
      "length":124,
      "genre":"scifi"
    },
    { "title":"Wayne's World",
      "year":1992,
      "length":95,
      "genre":"comedy"
    }
]
```

---

## The Semistructured Data Model

* The semistructured data model is based on **documents** 
* A **document** is made up of **arrays** and **objects** and **key/value pairs**
  <br><br>
* The **structure** looks like an array of structs in C++
  * The **key/value pairs** are just named fields of the struct
  * The values can be scalars, like strings or numbers
  * Values can also be nested arrays or objects
* The **operations** are described using **path descriptors** on the implied tree
  * E.g., find all objects where the *genre* field is equal to "comedy"
* The **constraints** limit the possible structures or values
  * E.g., all objects must have a *title*
  * E.g., the "Genre" must be "comedy", "drama", or "scifi"

---

## The Object-Relational Data Model

* The object-relational data model is an extension of the relational model
  <br><br>
* Values can have structure, e.g., an *address* may have a *city*, *state*, and *zip*
* Relations can have methods
  <br><br>
* The object-relational data model replaced the object data model in RDBMSs

---

## Other Data Models

* The **hierarchical data model** organizes data into **trees**
* Historically an important model
* This was the original data model
* Similar to semistructured data model
  <br><br>
* The **network data model** organizes data into **graphs**
* The high point of the pre-relational data models, e.g., CODASYL
* This is making a comeback in **graph databases**

---

## So Which Data Model Is Better?

* This is largely a meaningless question
  <br><br>
* Traditional databases use the relational or object-relational model
  <br><br>
* This is one of the main points of departure for NoSQL databases
* This use more powerful data models, like graphs or documents
  <br><br>
* But the relational model offers powerful optimizations
* It is also well understood by programmers

---

# Basics of the Relational Model

---

## Relational Data Model

* A benefit (limitation?) of the relational data model is that there is only one
  way to represent data
* Data is represented as a two-dimensional table, called a **relation**
* The cells in the table are scalars
* All cells in a column have the same type

<br>

Title               | Year   |  Length | Genre 
--------------------|--------|---------|-------
Gone With the Wind  | 1939   |     231 | drama
Star Wars           | 1977   |     124 | scifi 
Wayne's World       | 1992   |      95 | comedy

---

## Attributes

* An **attribute** is the name of a column
* Each **row** consists of a set of attributes and their values
  <br><br>
* E.g., the attributes are *title*, *year*, *length*, and *genre*

<br>

Title               | Year   |  Length | Genre 
--------------------|--------|---------|-------
Gone With the Wind  | 1939   |     231 | drama
Star Wars           | 1977   |     124 | scifi 
Wayne's World       | 1992   |      95 | comedy

---

## Tuples

* A **tuple** or **row** is one of the rows in the relation
* We write it using the mathematical notation for ordered tuples

```
("Star Wars", 1977, 124, "scifi")
````

<br>

Title               | Year   |  Length | Genre 
--------------------|--------|---------|-------
Gone With the Wind  | 1939   |     231 | drama
Star Wars           | 1977   |     124 | scifi 
Wayne's World       | 1992   |      95 | comedy

---

## Schema

* The **schema** for a relation is the name of the relation and its attributes
* It is written as `Movies(title, year, length, genre)`

<br>

Title               | Year   |  Length | Genre 
--------------------|--------|---------|-------
Gone With the Wind  | 1939   |     231 | drama
Star Wars           | 1977   |     124 | scifi 
Wayne's World       | 1992   |      95 | comedy


---

## Naming Conventions

* Naming conventions are important
* Here are some suggestions
  * Relation and attribute names are **nouns** or **noun phrases**
  * Relation names are **capitalized**
  * Relation names are **plural**
  * Attribute names are **lower case**
  * Attribute names are **singular**

Title               | Year   |  Length | Genre 
--------------------|--------|---------|-------
Gone With the Wind  | 1939   |     231 | drama
Star Wars           | 1977   |     124 | scifi 
Wayne's World       | 1992   |      95 | comedy

---

## Domains

* A **domain** specifies the possible values for an attribute
* A more computer-y term would be **type**
* But **domain** makes sense mathematically, as in the domain of a function
* It is written as `title:string`
* The entire relation is written as 

  `Movies(title:string, year:integer, length:integer, genre:string)`

<br>

Title               | Year   |  Length | Genre 
--------------------|--------|---------|-------
Gone With the Wind  | 1939   |     231 | drama
Star Wars           | 1977   |     124 | scifi 
Wayne's World       | 1992   |      95 | comedy

---

## Equivalent Relations

* A relation is a set of rows, so you can reorder the rows and still have the
  same relation
* Since the attributes are named, you can also reorder the columns

<br>

Title               | Year   |  Length | Genre 
--------------------|--------|---------|-------
Gone With the Wind  | 1939   |     231 | drama
Star Wars           | 1977   |     124 | scifi 
Wayne's World       | 1992   |      95 | comedy

<br>

Title               | Genre | Year   |  Length 
--------------------|-------|--------|---------
Star Wars           | scifi | 1977   |     124 
Gone With the Wind  | drama | 1939   |     231 
Wayne's World       | comedy| 1992   |      95 

---

## Relations and Relation Instances

* Consider a schema like

  `Movies(title:string, year:integer, length:integer, genre:string)`

* This describes a **relation**, which is an abstract ideal
* By abstract, I mean any possible set of rows that follows this schema
  <br><br>
* A specific set of rows makes up a **relation instance**
  <br><br>
* So a relation represents any possible data set that fits into a table,
  e.g., the students enrolled in a class
* But a relation instance is one concrete data set, e.g., the students in 
  **this** class

---

## Keys

* A **key** is a type of constraint on the values of a relation
* A set of attributes forms a **key** if two different tuples have to have
  different values for these attributes
  <br><br>
* For example, the attributes *last_name* and *first_name* may form a key on
  a relation of students
* Or does it?
  <br><br>
* The attribute *ssn* is definitely a key
  <br><br>
* We note keys by underlining or italicizing the key attributes

  `Movies(_title_:string, _year_:integer, length:integer, genre:string)`

---

## Synthetic vs. Semantic Keys

* A key like **title, year** is a **semantic** key, because it's made up
  of fields that already have meaning
  <br><br>
* Many (most?) database administrators prefer **synthetic** or **artificial** keys
* Synthetic keys are made up for the purpose of serving as keys
* It is usually painful to change the key for a record!
* And change is inevitable with semantic keys
  <br><br>
* Examples of synthetic keys include **id** or **student_id** or **sid**
  <br><br>
* It is also common to have a choice of keys
* In our student database, we could use **ssn** or **sid** as the key, for example

---

## Example Schema

```
Movies(_title_:string, _year_:integer, length:integer, genre:string,
       studioName:string, producerC#:integer)

MovieStars(_name_:string, address:string, gender:char, birthdate:date)

StarsIn(_movieTitle_:string, _movieYear_:integer, _starName_:string)

MovieExecs(name:string, address:string, _cert#_:integer, netWorth:integer)

Studios(_name_:string, address:string, presC#:integer)
```

---

## Movies Schema

```
Movies(_title_:string, _year_:integer, length:integer, genre:string,
       studioName:string, producerC#:integer)
```

* This is the schema we've been using for movies
* The key is **title, year**
* We've added the studio that made it, and the producer in charge

---

## MovieStars Schema

```
MovieStars(_name_:string, address:string, gender:char, birthdate:date)
```

* This stores information for movie stars
* The key is just **name**
* This is highly unusual, because different people can have the same name
* But movie stars are different -- they would change names rather than share them
  with another star
* Also, notice the new domains *char* and *date*

---

## StarsIn Schema

```
StarsIn(_movieTitle_:string, _movieYear_:integer, _starName_:string)
```
* This connects movies with the stars in them
* The key is a combination of the keys for Movies and Stars
* So we have **movieTitle, movieYear, starName**
* Each row connects a specific movie with a specific star
* Notice that a movie can have many stars, and that a star can be in many movies

---

## MovieExecs Schema

```
MovieExecs(name:string, address:string, _cert#_:integer, netWorth:integer)
```

* This stores information about movie executives
* Movie executives work behind the scenes, so they won't necessarily change their
  names to avoid confusion
* That means we need a synthetic key for them, in this case "certificate number"
  <br><br>
* Remember that a movie had a producer
* The producer was identified by the attribute **producerC#**, which must match
  one of the **MovieExecs**

---

## Studios Schema

```{css}
Studios(_name_:string, address:string, presC#:integer)
```

* This has information about movie studios
* The key is the name (since no two studios would have the same name)
* But wait, studios may change name!
  <br><br>
* The studio president is identified by his or her **certificate number**
* This must be one of the **MovieExecs**

---

# Defining a Relation Schema in SQL

---

## Structured Query Language (SQL)

* SQL is the main language used to describe and manipulate databases
  <br><br>
* It consists of two distinct languages
  1. **Data definition language (DDL)** is used to define relations, constraints,
     and other components of the database
  2. **Data manipulation language (DML)** is used to query and modify the
     relation instances in the database
  <br><br>
* We will consider the DDL in this overview

---

## Structured Query Language (SQL)

* SQL distinguishes three types of relations
  <br><br>
* **Tables** are relations that are stored on disk
* These are the usual types of relations
  <br><br>
* **Views** are relations defined by some computation
  * E.g., we can make a view of the movies that Kevin Bacon has starred in
  <br><br>
* **Temporary tables** are created to store values during the execution of a query
* These are thrown away after the query is finished
  <br><br>
* The SQL `CREATE TABLE` command is used to define stored relations (aka tables)
* You specify the name of the table, the attributes, the types of the attributes,
  and the keys

---

## SQL Caveat

* SQL is a loose standard
* Yes, there's an official ANSI standard document
* No, there is not a required test suite to be "SQL-compliant"
  <br><br>
* Different vendors will implement different versions of SQL
* **Consult your database manual**
  <br><br>
* We will cover the standard flavor of SQL, but there are differences

---

## SQL Data Types

Type               | Explanation
-------------------|------------------------------------
CHAR(n)            | Fixed-length string of n characters
VARCHAR(n)         | Variable-length string of up to n characters
BIT(n)             | Fixed-length string of n bits
BIT VARYING(n)     | Variable-length string of up to n bits
BOOLEAN            | Can be TRUE, FALSE, or UNKNOWN
INT or INTEGER     | Integer values, may use underlying C int type
FLOAT or REAL      | Floating-point values, may use underlying C float or double
DOUBLE PRECISION   | Floating-point value, may use underlying C double
DECIMAL(n,d)       | Fixed-point value, with n digits, d of which are after the decimal point
NUMERIC            | Could be any of the numeric values above
DATE               | Dates, could be in format '2015-01-26'
TIME               | Times, could be in format '14:25:30.6'
DATETIME           | Date and time, could be in format '2015-01-26 14:25:30.6'
DURATION           | Period of time, could be in format '1:20:30.6'

---&twocol

## Creating a Table

* Use the `CREATE TABLE` command
* Include the name of the table
* Also a parenthesized list of attributes and their domains

*** =left

```
CREATE TABLE Movies (
    title         VARCHAR(100),
    year          INT,
    length        INT,
    genre         VARCHAR(10),
    studioName    VARCHAR(100),
    producerC#    INT
);
```

*** =right

```
CREATE TABLE MovieStars (
    name        VARCHAR(100),
    address     VARCHAR(200),
    gender      CHAR(1),
    birthdate   DATE
);
```

---

## Dropping a Table

* You can get rid of a table with the `DROP TABLE` command
* Use with care
  <br><br>
* SQL convention:
  * Use `DROP` to remove items from the database schema
  * Use `DELETE` to remove items from a relation instance
  <br><br>

```
DROP TABLE Movies;
```

---

## Modifying a Table

* You can change the attributes of a table with the `ALTER TABLE` command
  <br><br>

```
ALTER TABLE MovieStars ADD phone CHAR(16);

ALTER TABLE MovieStars DROP birthdate;
```

---

## NULL Values

* Suppose we add a new actor to MovieStars, but we do not know their phone number
  <br><br>
* Databases handle this by supporting NULL values
* Note: All domains support NULL values
* A NULL value is not one of the domain elements
* E.g., there is an integer NULL, but it's not a "weird" integer, like $-2^{31}$
  <br><br>
* One problem with NULL values is that they complicate the meaning of queries
* E.g., suppose both John and Sally have NULL in their parent field
  * Does that mean they're siblings?
  * Does that mean they're not siblings?

---

## Default Values

* An alternative is that we assign **default values** to attributes
  <br><br>
* When a row is added, the default value is used unless a value is given explicitly
* E.g., the default for phone may be **unlisted**
  <br><br>

```
CREATE TABLE MovieStars (
    name        VARCHAR(100),
    address     VARCHAR(200),
    gender      CHAR(1) DEFAULT '?',
    birthdate   DATE DEFAULT '0000-00-00'
);

ALTER TABLE MovieStars ADD phone CHAR(16) DEFAULT 'unlisted';
```

---&twocol

## Declaring Keys

* There are two ways to declare a key in SQL
  * Specify that a **single** attribute is a key when it is declared
  * Specify that **one or more** attributes form a key after all attributes are
    declared
  <br><br>
* I prefer the second style, but I'll let you use either, and you should know both

*** =left
```
CREATE TABLE MovieStars (
    name      VARCHAR(100) PRIMARY KEY,
    address   VARCHAR(200),
    gender    CHAR(1) DEFAULT '?',
    birthdate DATE DEFAULT '0000-00-00'
);
```

*** =right
```
CREATE TABLE Movies (
    title         VARCHAR(100),
    year          INT,
    length        INT,
    genre         VARCHAR(10),
    studioName    VARCHAR(100),
    producerC#    INT,
    PRIMARY KEY (title, year)
);
```

---

## UNIQUE vs. PRIMARY KEY

* You can also use `UNIQUE` instead of `PRIMARY KEY`
  <br><br>
* Both specify that two different rows must have different values for the given
  attribute(s)
  <br><br>
* In addition, `PRIMARY KEY` adds a constraint that the values for those attributes
  cannot be NULL
  <br><br>
* In practice,
  * Use `PRIMARY KEY` for the key
  * Use `UNIQUE` for other candidate keys (that were not chosen)
  * E.g., use `PRIMARY KEY` for **sid** and `UNIQUE` for **ssn**

---

# An Algebraic Query Language

---

## Relational Algebra

* **Relational algebra** is the "invisible" query language of relational databases
* It is similar to algebra
  $$x + 25y - \frac{xy^3}{5}$$
* Algebra expressions say two things
  * What value do we want to compute
  * How do we want to compute it

---

## Relational Algebra Is Imperative

* To compute:
  $$x + 25y - \frac{xy^3}{5}$$
  1. multiply $25$ times $y$
  2. add the result to $x$
  3. raise $y$ to power $3$
  4. multiply $x$ by the result of step 3.
  5. divide that by 5
  6. add the result of steps 2. and 5.
* The expression says what we want **and** how to do it
* We say that algebra is **imperative**

---

## Imperative vs. Declarative

* Modern databases use **declarative** query languages
  * The programmer says what he or she wants
  * The computer figures out how to do it
  <br><br>
* The great advantage is that the database can come up with good execution
  plans -- i.e., the how
* Often, orders of magnitude better than what a programmer would do
* This is inevitable, because the "best" execution plan depends on
  * how data is stored on disk
  * the exact distribution of the data in the tables
  <br><br>
* But, the database uses relational algebra to represent the execution plans!
* And it describes those plans to you using relational algebra

---

## Relational Algebra Expressions

* Relational algebra has two types of "leaves"
  * **variables** stand for relations
  * **constants** stand for specific relation instances
  <br><br>
* The internal nodes in relational algebra are **relational operators**
  * set operations, e.g., **union**, **intersection**, **difference**, **cartesian product**
  * **selections** that filter rows from a relation
  * **projections** that filter columns from a relation
  * **join** operations that combine relations by filtering some rows or columns
    from a cartesian product
  * **rename** operations that change the name of the resulting table or its
    attributes

---

## Set Operations

* The set operations are written as
  * $R \cup S$
  * $R \cap S$
  * $R - S$
  * $R \times S$
  <br><br>
* Of course, these can be nested
  * $R \cup (S \cap T)$
  <br><br>
* We usually make two assumption on $R$ and $S$:
  * $R$ and $S$ have the same attributes and domains
  * The attributes are in the same order
* In this case, we say $R$ and $S$ are **union-compatible**

---&twocol

## Set Operations

* Here are some example relations
* Note that they are union-compatible

*** =left

### Relation $R$

name          | address                   | gender  | birthdate
--------------|---------------------------|---------|----------
Carrie Fisher | 123 Maple St.             | F       | 9/9/99
Mark Hamill   | 456 Oak Rd.               | M       | 8/8/88

*** =right

### Relation $S$

name          | address                   | gender  | birthdate
--------------|---------------------------|---------|----------
Carrie Fisher | 123 Maple St.             | F       | 9/9/99
Harrison Ford | 789 Palm Dr.              | M       | 7/7/77     

---&twocol

## Union and Intersection

*** =left

### $R \cup S$

name          | address                   | gender  | birthdate
--------------|---------------------------|---------|----------
Carrie Fisher | 123 Maple St.             | F       | 9/9/99
Mark Hamill   | 456 Oak Rd.               | M       | 8/8/88
Harrison Ford | 789 Palm Dr.              | M       | 7/7/77

*** =right

### $R \cap S$

name          | address                   | gender  | birthdate
--------------|---------------------------|---------|----------
Carrie Fisher | 123 Maple St.             | F       | 9/9/99

---&twocol

## Set Difference

*** =left

### $R - S$

name          | address                   | gender  | birthdate
--------------|---------------------------|---------|----------
Mark Hamill   | 456 Oak Rd.               | M       | 8/8/88

*** =right

### $S - R$

name          | address                   | gender  | birthdate
--------------|---------------------------|---------|----------
Harrison Ford | 789 Palm Dr.              | M       | 7/7/77

---

## Cross Product

### $R \times S$

R.name        | R.address                 | R.gender | R.birthdate | S.name        | S.address                 | S.gender  | S.birthdate
--------------|---------------------------|----------|-------------|---------------|---------------------------|-----------|------------
Carrie Fisher | 123 Maple St.             | F        | 9/9/99      | Carrie Fisher | 123 Maple St.             | F         | 9/9/99
Carrie Fisher | 123 Maple St.             | F        | 9/9/99      | Harrison Ford | 789 Palm Dr.              | M         | 7/7/77   
Mark Hamill   | 456 Oak Rd.               | M        | 8/8/88      | Carrie Fisher | 123 Maple St.             | F         | 9/9/99
Mark Hamill   | 456 Oak Rd.               | M        | 8/8/88      | Harrison Ford | 789 Palm Dr.              | M         | 7/7/77   

<br><br>

* Note that we use $R.A$ and $S.A$ to differentiate attributes that have the same name in both relations
* In general, it's preferable to rename the columns

---

## Projections

* A projection lets you choose which columns to view on the result
* It is given by $\pi$ with the chosen columns as subscripts, and the relation in parenthesis
* E.g., $\pi_{\text{title}, \text{length}, \text{year}}(\text{Movies})$ will show only the title, length, and year of the Movies table
  <br><br>
* Of course, this can be nested, e.g., $\pi_{A,B}(R \times S)$

---&twocol

## Projection Example

### Movies

Title               | Year   | Length | Genre 
--------------------|--------|--------|-------
Gone With the Wind  | 1939   |    231 | drama
Star Wars           | 1977   |    124 | scifi 
The Matrix          | 1999   |    136 | scifi

<br>

### $\pi_{\text{title}, \text{length}, \text{year}}(\text{Movies})$

Title               | Length | Year
--------------------|--------|-----
Gone With the Wind  |    231 | 1939
Star Wars           |    124 | 1977
The Matrix          |    136 | 1999

<br>

* Notice we also swapped the order of the columns!

---&twocol

## Projection Example

### Movies

Title               | Year   | Length | Genre 
--------------------|--------|--------|-------
Gone With the Wind  | 1939   |    231 | drama
Star Wars           | 1977   |    124 | scifi 
The Matrix          | 1999   |    136 | scifi

<br>

### $\pi_{\text{genre}}(\text{Movies})$

Genre | 
------|-
drama |
scifi |

<br>

* Notice we only have two rows, because the last two movies have the same genre


---

## Selections

* A selection lets you choose which rows to view on the result
* It is given by $\sigma$ with a condition as a subscript, and the relation in parenthesis
* E.g., $\sigma_{\text{year} = 1977}(\text{Movies})$ will show only the movies released in 1977
  <br><br>
* Of course, this can be nested, e.g., $\sigma_{A>10}(R \times S)$

---

## Selection Example


### Movies

Title               | Year   | Length | Genre 
--------------------|--------|--------|-------
Gone With the Wind  | 1939   |    231 | drama
Star Wars           | 1977   |    124 | scifi 
The Matrix          | 1999   |    136 | scifi

<br>

### $\sigma_{\text{year} \ge 1975}(\text{Movies})$

Title               | Year   | Length | Genre 
--------------------|--------|--------|-------
Star Wars           | 1977   |    124 | scifi 
The Matrix          | 1999   |    136 | scifi


---

## Selection Example


### Movies

Title               | Year   | Length | Genre 
--------------------|--------|--------|-------
Gone With the Wind  | 1939   |    231 | drama
Star Wars           | 1977   |    124 | scifi 
The Matrix          | 1999   |    136 | scifi

<br>

### $\sigma_{\text{length} \ge 130 \text{ AND } \text{genre} = \text{'scifi'}}(\text{Movies})$

Title               | Year   | Length | Genre 
--------------------|--------|--------|-------
The Matrix          | 1999   |    136 | scifi

---

## Natural Joins

* A join is a combination of a cross product and a selection
* Consider these two tables
  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
           name:string, producerC#:integer)

  Studios(_name_:string, address:string, presC#:integer)
  ```
* Note: We've modified the schema so that `Movies` uses `name` instead of `studioName`
  <br><br>
* We want to find the studio that makes each movie
* We can do this with this relational algebra expression:
  $$\sigma_{\text{Movies.name} = \text{Studios.name}}(Movies \times Studios)$$

---

## Natural Joins Example

### Movies

Title               | Year   | Length | Genre  | Name       | ProducerC#
--------------------|--------|--------|--------|------------|-----------
Gone With the Wind  | 1939   |    231 | drama  | MGM        | 1234
Star Wars           | 1977   |    124 | scifi  | Lucasfilm  | 2345
The Matrix          | 1999   |    136 | scifi  | Warner     | 3456

<br>

### Studios

Name          | Address          | PresC#
--------------|------------------|--------------
MGM           | 101 Mogul St.    | 5678
Lucasfilm     | 1 Jedi Way       | 6789
Warner        | 200 Brothers Pl. | 4567       

---

## Natural Joins Example

* Step 1: $\text{Movies} \times \text{Studios}$

Title               | Year   | Length | Genre  | Movies.Name | ProducerC# | Studios.Name  | Address          | PresC#
--------------------|--------|--------|--------|-------------|------------|---------------|------------------|------------
Gone With the Wind  | 1939   |    231 | drama  | MGM         | 1234       | MGM           | 101 Mogul St.    | 5678
Gone With the Wind  | 1939   |    231 | drama  | MGM         | 1234       | Lucasfilm     | 1 Jedi Way       | 6789
Gone With the Wind  | 1939   |    231 | drama  | MGM         | 1234       | Warner        | 200 Brothers Pl. | 4567       
Star Wars           | 1977   |    124 | scifi  | Lucasfilm   | 2345       | MGM           | 101 Mogul St.    | 5678
Star Wars           | 1977   |    124 | scifi  | Lucasfilm   | 2345       | Lucasfilm     | 1 Jedi Way       | 6789
Star Wars           | 1977   |    124 | scifi  | Lucasfilm   | 2345       | Warner        | 200 Brothers Pl. | 4567       
The Matrix          | 1999   |    136 | scifi  | Warner      | 3456       | MGM           | 101 Mogul St.    | 5678
The Matrix          | 1999   |    136 | scifi  | Warner      | 3456       | Lucasfilm     | 1 Jedi Way       | 6789
The Matrix          | 1999   |    136 | scifi  | Warner      | 3456       | Warner        | 200 Brothers Pl. | 4567       

---

## Natural Joins Example

* Step 2: $\sigma_{\text{Movies.name} = {Studios.name}}(\text{Movies} \times \text{Studios})$

Title               | Year   | Length | Genre  | Movies.Name | ProducerC# | Studios.Name  | Address          | PresC#
--------------------|--------|--------|--------|-------------|------------|---------------|------------------|------------
Gone With the Wind  | 1939   |    231 | drama  | MGM         | 1234       | MGM           | 101 Mogul St.    | 5678
Star Wars           | 1977   |    124 | scifi  | Lucasfilm   | 2345       | Lucasfilm     | 1 Jedi Way       | 6789
The Matrix          | 1999   |    136 | scifi  | Warner      | 3456       | Warner        | 200 Brothers Pl. | 4567       

---

## Natural Joins Example

* Step 3: $\text{Movies} \bowtie \text{Studios}$

Title               | Year   | Length | Genre  | Movies.Name | ProducerC# | Studios.Name  | Address          | PresC#
--------------------|--------|--------|--------|-------------|------------|---------------|------------------|------------
Gone With the Wind  | 1939   |    231 | drama  | MGM         | 1234       | MGM           | 101 Mogul St.    | 5678
Star Wars           | 1977   |    124 | scifi  | Lucasfilm   | 2345       | Lucasfilm     | 1 Jedi Way       | 6789
The Matrix          | 1999   |    136 | scifi  | Warner      | 3456       | Warner        | 200 Brothers Pl. | 4567       

* What's **natural** about the join is that attributes in `Movies` with the same name as an attribute in `Studios` are
  filtered to have equal values
* I.e., the selection is implied by the attribute names

---

## Theta Joins

* A **theta join** (also $\theta$-join) allows an arbitrary condition on the selection
* A natural join assumes that the condition is an equality check on attributes with the same name
* A theta join lets you pick the selection condition

---

## Theta Join Example

* Now consider the original schema
  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
           studioName:string, producerC#:integer)

  Studios(_name_:string, address:string, presC#:integer)
  ```
* We can join it as follows:
  $$\text{Movies} \bowtie_{\text{studioName} = \text{name}} \text{Studios}$$

Title               | Year   | Length | Genre  | Movies.Name | ProducerC# | Studios.Name  | Address          | PresC#
--------------------|--------|--------|--------|-------------|------------|---------------|------------------|------------
Gone With the Wind  | 1939   |    231 | drama  | MGM         | 1234       | MGM           | 101 Mogul St.    | 5678
Star Wars           | 1977   |    124 | scifi  | Lucasfilm   | 2345       | Lucasfilm     | 1 Jedi Way       | 6789
The Matrix          | 1999   |    136 | scifi  | Warner      | 3456       | Warner        | 200 Brothers Pl. | 4567       

---

## Join Lesson #1

* Suppose $S$ has $m$ rows and $R$ has $n$ rows
  <br><br>
* Then $S \times R$ has exactly $m \cdot n$ rows
  <br><br>
* What about $S \bowtie R$?
  1. It could be $0$
  2. It could be $m$ or $n$ (if exactly one row in $R$ matches a row in $S$)
  3. It could be as large as $m \cdot n$
  4. Or any number in between
* It depends on the characteristics of the data
* E.g., consider joining on
  1. $\text{Student.id} = \text{EnrolledIn.sid}$
  2. $\text{Student.gender} = \text{Advisor.gender}$

---

## Join Lesson #2

* You must learn how to execute your own join expressions
  <br><br>
* The easiest way is to follow the algorithm above (called a **naive nested loop join**)
* I.e., to compute $R \bowtie S$
  1. Pick the first row of $R$
  2. Find all the rows in $S$ that join with that one row in $R$, and write those down
  3. Now consider the second row
  4. Then the third row
  5. Etc.

---

## Join Lesson #3

* Databases are very, very good at executing joins
  <br><br>
* Suppose we need to compute $S \bowtie S$, where $S$ is the Students table at UW
* Since $|S| \approx 13000$, the naive method takes up $13000^2 =$ 1.69 &times; 10<sup>8</sup> steps
* Each step is a disk access, so even if disk I/O is 1ms, that works out to 1.69 &times; 10<sup>5</sup> seconds
* Which is 2816.6667 minutes
* Which is 46.9444 hours
* Which is 1.956 days
  <br><br>
* UW's database can probably join those in a matter of seconds, or minutes at most
  <br><br>
* So use the optimizer
* And never, ever, ever try to do joins in your own code
* E.g., by doing a nested loop with two different database queries

---

## Join Lesson #3

* By the way, the naive execution resulted in 2 days
* The optimal execution plan may take 20 seconds
  <br><br>
* What the query optimizer does is to find an execution plan that is much closer to 20 seconds than to 2 days
* It doesn't guarantee that it'll find the **best** execution plan
* But it tries to avoid the absolute worst!
* And, if you're lucky, it finds one that's in the same order of magnitude as the best plan

---

## Join Lesson #4

* Suppose you want to find all `Movies` and their producers
  <br><br>
* We can do this by joining the tables
  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
           studioName:string, producerC#:integer)
  
  MovieExecs(name:string, address:string, _cert#_:integer, netWorth:integer)
  ```

$$\text{Movies} \bowtie_{\text{producerC#} = \text{cert#}} \text{MovieExecs}$$

---

## Join Lesson #4

* Now suppose we want to find all producers
* This is not everybody in `MovieExecs`
* Only the folks who have actually produced a movie
  <br><br>
* We can do this by joining the tables
  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
           studioName:string, producerC#:integer)
  
  MovieExecs(name:string, address:string, _cert#_:integer, netWorth:integer)
  ```

$$\sigma_{\text{name}, \text{address}, \text{cert#}, \text{netWorth}}(\text{Movies} \bowtie_{\text{producerC#} = \text{cert#}} \text{MovieExecs})$$

---

## Join Lesson #4

* Now suppose we want to find all producers who have produced more than 1 movie
* This is not everybody in `MovieExecs`
* Only the folks who have actually produced two or more movies

---

## Join Lesson #4

* We can do this by joining the tables
  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
           studioName:string, producerC#:integer)
  
  MovieExecs(name:string, address:string, _cert#_:integer, netWorth:integer)
  ```

* Basic strategy:
  $$\text{MovieExecs} \bowtie \text{Movies}_1 \bowtie \text{Movies}_2$$
* The executive produces movie \#1 and movie \#2
* Movies \#1 and \#2 are **different movies**

---

## Join Lesson #4

* Now suppose we want to find all `Movies` and the `MovieStars` in them
  <br><br>
* We can do this by joining the tables
  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
         studioName:string, producerC#:integer)
  
  MovieStars(_name_:string, address:string, gender:char, birthdate:date)
  
  StarsIn(_movieTitle_:string, _movieYear_:integer, _starName_:string)
  ```

* Make sure you know how to do this!
* Very important: **Make sure you know how to do this!**

---

## Join Lesson #4

* Now suppose we want to play the Kevin Bacon game
* Find all `MovieStars` in `Movies` that Kevin Bacon stars in
  <br><br>
* We can do this by joining the tables
  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
           studioName:string, producerC#:integer)
  
  MovieStars(_name_:string, address:string, gender:char, birthdate:date)
  
  StarsIn(_movieTitle_:string, _movieYear_:integer, _starName_:string)
  ```

---

## Join Lesson #4

* Basic strategy:
   $$\text{Movies} \bowtie \text{StarsIn}_1 \bowtie \sigma(\text{MovieStars}_1) \bowtie \text{StarsIn}_2 \bowtie \text{MovieStars}_2$$
* The selection on the first `MovieStars` filters for Kevin Bacon
* Joining the first `StarsIn` and `MovieStars` finds `Movies` that Kevin Bacon stars in
* Joining the second `StarsIn` and `MovieStars` finds the other `MovieStars` in those `Movies`

---

## Join Lesson #4

* Key Lesson: Join is extremely useful, easily the most useful relational algebra operator
* It can be helpful to join a table with itself!
* Whenever you want to find "all Employees who supervise other Employees", for example, think in terms of
  joining Employees with itself

---

## Renaming

* The **rename** operation allows us to change the name and attributes of a relational algebra expression
* It's written as $\rho$ with the new schema as a subscript
* If you only want to rename the relation (and leave the attributes the same), you can just leave the new relation name in the subscript

  ```
  Movies(_title_:string, _year_:integer, length:integer, genre:string,
           studioName:string, producerC#:integer)
  ````

  * $\rho_{\text{M2}(\text{title}, \text{year}, \text{length}, \text{genre}, \text{sname}, \text{prod})} (\text{Movies})$
  * $\rho_{\text{M2}} (\text{Movies})$

---

## Renaming Example

* This is the missing piece to doing a query like 
  * Basic strategy:
    $$\text{MovieExecs} \bowtie \text{Movies}_1 \bowtie \text{Movies}_2$$
  * The executive produces movie \#1 and movie \#2
  * Movies \#1 and \#2 are **different movies**
  
  $\text{MovieExecs} \bowtie_{\text{M1.producerC#} = \text{cert#}} \rho_{\text{M1}}(\text{Movies})$

  $\qquad\qquad\quad \bowtie_{\text{M2.producerC#} = \text{cert#} \text{ AND } (\text{M1.title} \ne \text{M2.title} \text{ OR } \text{M1.year} \ne \text{M2.year})} \rho_{\text{M2}}(\text{Movies})$

---

## Linear Notation

* As the previous example showed, relational expressions can get very unwieldy
* There is a simple linear notation that can come in very handy
* We introduce **assignment statements**:
  $$R(A,B,C) := S \bowtie T \cap U$$

* The previous expression is easier to write as follows:
  1. $MM := \rho_\text{M1}(\text{Movies}) \bowtie_{\text{M1.producerC#} = \text{M2.producerC#}} \rho_\text{M2}(\text{Movies})$
  2. $FMM := \sigma_{\text{M1.title} \ne \text{M2.title} \text{ OR } \text{M1.year} \ne \text{M2.year}}(MM)$
  3. $\text{Answer} := \text{MovieExec} \bowtie_{\text{M1.producerC#} = \text{cert#}}(FMM)$

---

## Relationships Among Operations

* We've seen a lot of relational operators
* Actually, we don't need all of them
* Assuming the schemas $R(x,y)$ and $S(y,z)$:
  * $R \cup S = R - (R - S)$
  * $R \bowtie_\theta S = \sigma_\theta (R \times S)$
  * $R \bowtie S = \rho_{(x,y,z)}(\pi_{x,R,y,z}(\sigma(R.y = S.y)(R \times S)))$
* It turns out we only need $\cup$, $-$, $\pi$, $\sigma$, $\times$, and $\rho$
* But having the others is very convenient!

> * Also, there are other equations that always hold, e.g.,
    * $R \bowtie (S \cup T) = (R \bowtie S) \cup (R \bowtie T)$
    * $R \bowtie_{\theta_1 \text{ AND } \theta_2} S = \sigma_{\theta_2}(R \bowtie_{\theta_1} S)$
  * This is good -- it gives the optimizer lots of choices so it can find a good execution plan


---

# Constraints on Relations

