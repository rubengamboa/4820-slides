title:        COSC 4820 Database Systems
subtitle:     The Database Language SQL
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

* The purpose of this chapter is to introduce **SQL**
* **SQL** is the **Structured Query Language**
* It is the standard language for querying and manipulating database
  <br><br>
* Note that SQL is a "soft" standard
* There are lots of dialects
* We'll stick close to the official ANSI standard, but you should always consult your database manual for details

---

# Simple Queries in SQL

---

## Using SQL

* SQL is generally used in one of three ways:
  1. A user can type SQL into a command area
  2. A programmer can create a SQL query and it's run when the program executes
  3. A program can construct a query dynamically
  <br><br>
* Option 1 is the one we'll use most in this class
* But it's actually the least common option
  <br><br>
* Also, a lot of the programs that execute database queries are web applications

---

## Simple Queries in SQL

* The basic query in SQL has the structure SELECT ... FROM ... WHERE ...
  <br><br>
* After the SELECT is a list of **attributes** or a single *
  * "SELECT" should really have been "PROJECT"
    <br><br>
* After the FROM is a list of **relations**
* The relations are implicitly cross-producted (if that's a word)
  <br><br>
* After the WHERE is a **condition**
* This is the selection part of the query

---

## Simple Queries in SQL

* Consider this schema:

```
Movies(title , year , length , genre , studioName , producerC#) 
StarsIn(movieTitle , movieYear , starName) 
MovieStar(name , address , gender , birthdate) 
MovieExec(name , address , cert# , netWorth) 
Studio(name , address , presC#) 
```

* A basic query may be

```
SELECT *
  FROM Movies
 WHERE studioName = 'Lucasfilm'
   AND year = 1977
```

---

## Reading SQL Queries

* Start by looking at the FROM clause
* That tells you what relations are being considered
* Remember that you can only look at one tuple from each relation at a time
  <br><br>
* Then look at the WHERE clause
* This tells you which tuples are chosen
  <br><br>
* Finally, look at the SELECT clause
* That tells you which attributes will make it to the answer

```
SELECT *
  FROM Movies
 WHERE studioName = 'Lucasfilm'
   AND year = 1977
```

---

## SQL Queries and Relational Algebra

Here is a generic SQL query

```
SELECT L
  FROM R
 WHERE C
```

This converts into the the relational algebra query
$$\pi_L(\sigma_C(R))$$

---

## Projection in SQL

```
SELECT title, year
  FROM Movies
 WHERE studioName = 'Lucasfilm'
   AND year = 1977
```

Title               | Year 
--------------------|------
Star Wars           | 1977 


---

## Extended Projection in SQL

```
SELECT title AS Name, year Released, length/60 AS Duration
  FROM Movies
 WHERE studioName = 'Lucasfilm'
   AND year = 1977
```

Name                | Released   | Duration
--------------------|------------|-----------
Star Wars           | 1977       | 2.05 


---

## Selection in SQL

* Selection is accomplished with the condition in the FROM clause
* The condition syntax in SQL is actually more powerful than the syntax in relational algebra

---

## Conditions in SQL

* The base condition is a comparison, with the operators
  * =, <, >, <=, >=, <>
  * Many databases also support != instead of <>
  <br><br>
* The values that can be compared can be
  * constants, e.g., 'Fred' or 42
  * attributes of the relations listed in the FROM clause, e.g., year
  * arithmetic expressions
  * date expressions
  * string expressions

---

## Conditions in SQL

* Base conditions can be combined using the familiar relational operators
  * AND
  * OR
  * NOT
  <br><br>
* You can also use parentheses to groups of conditions, e.g.,

```
SELECT title AS Name, year Released, length/60 AS Duration
  FROM Movies
 WHERE studioName = 'Lucasfilm'
   AND (   year = 1977
        OR year = 1980 )
```

* But not all databases support this

---

## String Comparisons in SQL

* Strings can also be compared using 
  * =, <, >, <=, >=, <>
  <br><br>
* The meaning of the comparisons depends on the (natural) language used in the database
* Basically, comparisons are done using lexicographic ordering
* That's a fancy word for "dictionary ordering"
  <br><br>
* The very good question is "What language is the dictionary in?"
* Maybe your database runs in en_US or en_GB
* Or maybe it's fr_CA or fr_FR
* Keep in mind that the ordering of words may differ depending on the specific dialect of a language!
* This is called the **collation**

---

## Locales in SQL

* What is the locale of your database?
  <br><br>
* You can ignore this, and hope that the database is in en_US
* (Or whatever language you prefer)
  <br><br>
* But keep in mind that the DBA can change this setting (possibly breaking your program)
  <br><br>
* It is best to be explicit and **set the locale** by yourself
* This setting affects your **session** only
* So your queries always run in the same locale


---

## String Operators

* We're all familiar with the basic arithmetic operators, e.g., +, -, *, /
  <br><br>
* There are also string operators:
  * **Concatenation:**  'hello' || ' ' || 'world'
  <br><br>
* The problem is that this isn't standard **at all**
  * 'hello' + ' ' + 'world'
  * concat('hello', concat(' ', 'world'))

> * There are may other string operators, but check your database manual for the syntax!
    * **Substring**
    * **Replace**
    * **Touppercase**
    * **Tonumber**
    * **Todate**

---

## String Comparisons

* We can compare with 
  * =, <, >, <=, >=, <>
  <br><br>
* But it also makes sense to compare strings using partial matches
* E.g., we want to find all strings with names that look like *.SQL
  <br><br>
* The LIKE operator does this

---

## String LIKE Comparisons

* LIKE compares a string and a **pattern**:
  * string LIKE pattern
  * string NOT LIKE pattern
  <br><br>
* The pattern is a string with some special **matching** (also **globbing**) characters
  * % matches zero or more characters
  * _ matches precisely one character (any character)

```
SELECT *
  FROM Movies
 WHERE title LIKE 'Star %'
   AND title LIKE '% Wars'
```

* This will find 'Star Wars'
* It will also find 'Star Fairies and the Border Wars'

---

## String LIKE Comparisons

* Is this query TRUE or FALSE?
  * 'star wars' LIKE 'Star %'
  <br><br>
* Sadly, it depends on your database and settings
* Remember the collations?
* Some collations are case-sensitive, and some are not
* So it depends on which collation you're using!
  <br><br>
* By default, in en_US with default collation, LIKE is case insensitive
* So the condition is TRUE
  <br><br>
* Some databases support the comparison operator CLIKE, which is a case-sensitive version of LIKE

---

## Date and Time Comparisons

* SQL supports the Date and Time data types
* But there is **great variety** in the syntax between different databases
* There are also differences when it comes to precisely what date and a time means
  * In some databases, the Date actually has a Time component
  * In others, it does not
  * Some databases have a DateTime object
  * That may mean it has a Date and a Time
  * Or it may mean that Date has a Date and Time, but DateTime has more resolution than Date (e.g., it supports milliseconds)
  <br><br>
* **Check your database manual!**

---

## ANSI Date and Time Constants

* DATE 'yyyy-mm-dd'
  * DATE '2015-03-05'
  * DATE '2015-03-10'
  <br><br>
* TIME 'hh:mm:ss.ddd'
  * TIME '03:15:00'
  * TIME '15:30:00'
  * TIME '15:30:00.23'
  * TIME '15:30:00.938548'

---

## ANSI Date and Time Constants

* TIME 'hh:mm:ss.ddd+h:mm' or TIME 'hh:mm:ss.ddd-h:mm'
  * TIME '03:15:00-7:00'
  * TIME '03:15:00-6:00'
  <br><br>
* TIMESTAMP 'yyyy-mm-dd hh:mm:ss.ddd'
  * TIMESTAMP '2015-03-05 15:15:00'

---

## ANSI Date and Time Conditions

* We can use the date and time constants in conditions

```
SELECT *
  FROM Movies
 WHERE releaseDate >= DATE '2015-03-05'
   AND releaseDate <= DATE '2015-03-15'
```

---

## NULL Values

* NULL values appear for a multitude of reasons
  1. There is some value, but we don't know what it is
  2. There is no possible value for this particular field
  3. The value for this particular field is a secret
  <br><br>
* So how do we handle NULL values in
  * expressions?
  * conditions?

---

## NULL Values in Expressions

* If any input to an expression is NULL, the value of the expression is NULL
  <br><br>
* 2 + NULL = NULL
* NULL - NULL = NULL
* 0 * NULL = NULL

---&twocol

## NULL Values in Conditions

* If an input to a condition is NULL, the value of the condition if UNKNOWN
* That means that conditions can be TRUE, FALSE, or UNKNOWN
* These three-value logic has the following truth tables

*** =left

X       | Y       | X AND Y     | X OR Y      
--------|---------|-------------|--------------
TRUE    | TRUE    | TRUE        | TRUE
TRUE    | FALSE   | FALSE       | TRUE
TRUE    | UNKNOWN | UNKNOWN     | TRUE
FALSE   | TRUE    | FALSE       | TRUE
FALSE   | FALSE   | FALSE       | FALSE
FALSE   | UNKNOWN | FALSE       | UNKNOWN
UNKNOWN | TRUE    | UNKNOWN     | TRUE
UNKNOWN | FALSE   | FALSE       | UNKNOWN
UNKNOWN | UNKNOWN | UNKNOWN     | UNKNOWN

*** =right

X       | NOT X
--------|---------
TRUE    | FALSE    
FALSE   | TRUE   
UNKNOWN | UNKNOWN 

---

## Three-valued Conditions

* A condition may be TRUE, FALSE, or UNKNOWN
  <br><br>
* If it's TRUE, we select the row and print the result
* If it's FALSE, we do not select the row, so no result is printed
* If it's UNKNOWN, we treat it as FALSE -- but only in the final step

---

## NULL Values in Conditions

* Notice that NOT UNKNOWN is UNKNOWN
  <br><br>
* So the following condition does not print all rows

```
SELECT *
  FROM Movies
 WHERE length > 200
    OR length <= 200
```

* It only returns the rows that have a non-NULL length!

---

## Ordering the Output

* Even though we claim that results are sets or bags, we sometimes want to answer the rows in the result
  <br><br>
* We do so with the ORDER BY clause, which we put at the end of the query
* You can order by one or more attributes
* And you can choose to order in ASCending (default) or DESCending order

```
  SELECT *
    FROM Movies
ORDER BY year, length DESC
```

* The Movies are sorted by year first, i.e., Movies made in 1990, then in 1991, then 1992, etc.
* Within a year, the Movies are sorted from longest to shortest

---

# Queries Involving More Than One Relation

---

## Queries Involving More Than One Relation

* If a query needs data from more than one relation, simply list all the needed relations in the FROM clause
  <br><br>
* The query proceeds by taking the cross-product of all the relations in the FROM clause
* Then, the condition in the WHERE clause tests whether a particular combination of tuples passes
* If the combination passes, the data in the SELECT clause is displayed

```
SELECT title, name
  FROM Movies, MovieExecs
 WHERE title = 'Star Wars'
   AND producerC# = cert#
```

* Notice this is almost like a join
* And remember that $X \bowtie Y = \sigma(X \times Y)$

---

## Disambiguating Attributes

* But what about the following schema

```
Books(_isbn_, title, authorid)
Authors(authorid, name)
```

* How can we compare authorid in Books with authorid in Authors?
* SQL notation is R.A, where R is a relation name and A one of its attributes

```
SELECT title, name
  FROM Books, Authors
 WHERE Books.authorid = Authors.authorid
```

---

## Disambiguating Attributes

* What if we need to use a relation more than once?
  <br><br>
* **Tuple variables** allow us to rename a relation
* The new name can be used to disambiguate attributes

```
SELECT title, name
  FROM Books B1, Books B2, Authors
 WHERE B1.authorid = Authors.authorid
   AND B1.authorid = Authors.authorid
   AND B1.isbn <> B2.isbn
```

---

## Sidebar: Hint on Multiple Copies

* Instead of using <>, use <
* That way, you only get one copy of each pair

```
SELECT title, name
  FROM Books B1, Books B2, Authors
 WHERE B1.authorid = Authors.authorid
   AND B1.authorid = Authors.authorid
   AND B1.isbn < B2.isbn
```

---

## SQL Queries and Relational Algebra

Here is a generic SQL query that uses multiple relations

```
SELECT L
  FROM R, S
 WHERE C
```

This converts into the the relational algebra query
$$\pi_L(\sigma_C(R \times S))$$

---

## Set Operations in SQL

* Union-compatible queries can be combined using the operators
  * UNION
  * INTERSECT
  * EXCEPT
* Many databases support only UNION, however
* **Check your database manual!**

```
(SELECT title, name
   FROM Movies, MovieExecs
  WHERE title = 'Star Wars'
    AND producerC# = cert#)
UNION
(SELECT title, name
   FROM Movies, MovieExecs
  WHERE title = 'The Empire Strikes Back'
    AND producerC# = cert#)
```

---

## Set Operations in SQL

```
(SELECT title, year
   FROM Movies
 WHERE studioName = 'Lucasfilm')
EXCEPT
(SELECT title, year
   FROM Movies
  WHERE year >= 1995)
```
