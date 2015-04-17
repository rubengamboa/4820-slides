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
   AND B2.authorid = Authors.authorid
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
   AND B2.authorid = Authors.authorid
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

---

# Subqueries

---

## Subqueries

* Subqueries come very naturally -- *too* naturally -- to computer scientists

* In a nutshell, the results of a subquery can be used
  * in place of a relation (e.g., Students who are COSC majors)
  * in place of a single value (e.g., the CRN for this class)
  * in place of a list of values (e.g., the CRNs for classes I'm teaching this semester)

* Of course, subqueries can have subqueries, which can have more nested subqueries, etc.

---

## Subqueries that Produce Single Values

* Generally speaking, a query have many rows and many columns
* But some queries return only a single row and a single column

```
SELECT crn
  FROM Courses
 WHERE year = 2015
   AND semester = 'Spring'
   AND dept = 'COSC'
   AND cnumber = '4820'
```

---

## Subqueries that Produce Single Values

* We can use that query to find all the students in this class

```
SELECT first_name, last_name
  FROM Students, Enrolled
 WHERE Students.wnumber = Enrolled.wnumber
   AND Enrolled.crn = (SELECT crn
                         FROM Courses
                        WHERE year = 2015
                          AND semester = 'Spring'
                          AND dept = 'COSC'
                          AND cnumber = '4820')
```

---

## How Subqueries Are Executed

```
SELECT first_name, last_name
  FROM Students, Enrolled
 WHERE Students.wnumber = Enrolled.wnumber
   AND Enrolled.crn = (SELECT crn
                         FROM Courses
                        WHERE year = 2015   AND semester = 'Spring'
                          AND dept = 'COSC' AND cnumber = '4820')
```

* First, execute the innermost query, so we find the CRN for this course
* Then, replace the subquery with the result, which is 21621
* Now, execute the outer query

```
SELECT first_name, last_name
  FROM Students, Enrolled
 WHERE Students.wnumber = Enrolled.wnumber
   AND Enrolled.crn = 21621
```

---

## The Problem with Subqueries

* There's a different way to get the list of students taking this course:

```
SELECT first_name, last_name
  FROM Students, Enrolled, Courses
 WHERE Students.wnumber = Enrolled.wnumber
   AND Enrolled.crn = 21621
   AND year = 2015   AND semester = 'Spring'
   AND dept = 'COSC' AND cnumber = '4820'
```

* This may be **considerably more efficient** than what we proposed above
* Some databases will automatically convert the subquery into a join
* But some databases won't even try
* And not all databases will succeed in all cases
  <br><br>
* When possible, use joins instead of subqueries!!!

---

## Conditions Involving Relations

* Suppose we have a subquery $S$
* There are many things we could ask about the results of $S$
  * Are there any results in $S$?
  * Is a particular entry in $S$?
  * Are all the entries in $S$ bigger than some value?
  * Is any entry in $S$ bigger than some value?

* SQL contains special operators for each of these cases

---

## Is the Result Empty?

* What classes have no students?

```
SELECT crn
  FROM Courses
 WHERE NOT EXISTS ( SELECT *
                      FROM Enrolled 
                     WHERE Courses.crn = Enrolled.crn )
```

* **Spoilers:** Notice that we would not be able to execute the nested query by itself first
* Such queries are called **correlated subqueries**

---

## Does the Result Contain a Specific Value?

* What students are in any of my classes?

```
SELECT first_name, last_name
  FROM Students, Enrolled
 WHERE Students.wnumber = Enrolled.wnumber
   AND Enrolled.crn IN (SELECT crn
                          FROM Courses
                         WHERE year = 2015
                           AND semester = 'Spring'
                           AND facultyId = (SELECT id
                                              FROM Faculty
                                             WHERE first_name = 'Ruben'
                                               AND last_name = 'Gamboa'))
```

---

## Does the Result Contain a Specific Value?

* What producers have worked with Harrison Ford?

```
SELECT name
  FROM MovieExec
 WHERE cert# IN (SELECT producerC#
                   FROM Movies
                  WHERE (title, year) IN (SELECT movieTitle, movieYear
                                            FROM StarsIn
                                           WHERE starName = 'Harrison Ford'))
```

---

## Are All the Entries Bigger than Some Value?

* What stars are completely bankable?

```
SELECT name
  FROM MovieStars
 WHERE 50000000 <= ALL (SELECT profit
                          FROM Movies
                         WHERE MovieStars.name IN (SELECT starName
                                                     FROM StarsIn
                                                    WHERE movieTitle = title
                                                      AND movieYear = year))
```

* Notice these subqueries are also **correlated**

---

## Are Some Entries Bigger than Some Value?

* What stars are bankable at least some of the time?

```
SELECT name
  FROM MovieStars
 WHERE 50000000 <= ANY (SELECT profit
                          FROM Movies
                         WHERE MovieStars.name IN (SELECT starName
                                                     FROM StarsIn
                                                    WHERE movieTitle = title
                                                      AND movieYear = year))
```

* Notice these subqueries are also **correlated**

---

## Correlated Subqueries

* What is the first movie made by each movie star?

```
SELECT MovieStars.name, FirstMovie.title, FirstMovie.year
  FROM MovieStars, Movie AS FirstMovie, StarsIn
 WHERE StarsIn.starName = MovieStars.name
   AND StarsIn.movieTitle = FirstMovie.title
   AND StarsIn.movieYear = FirstMovie.year
   AND NOT EXISTS ( SELECT *
                      FROM Movie, StarsIn
                     WHERE StarsIn.starName = MovieStars.name
                       AND StarsIn.movieTitle = Movie.title
                       AND StarsIn.movieYear = Movie.year
                       AND Movie.year < FirstMovie.year )
```

---

## Subqueries in FROM Clauses

* A subquery returns a set of tuples
* So it's really the same thing as a relation
  <br><br>
* That's the rationale behind allowing subqueries in FROM clauses
* If you do this, you should give the subquery a name, so you can use
  it for disambiguating attribute names

---

## Subqueries in FROM Clauses

* What actor has starred in the most movies?

```
SELECT name
  FROM (SELECT MovieStars.name, COUNT(*) AS movieCount
          FROM MovieStars, StarsIn
         WHERE MovieStars.name = StarsIn.name 
         GROUP BY name) AS StarMovieCount
 WHERE NOT EXISTS (SELECT *
                     FROM StarMovieCount AS SMC2
                    WHERE SMC2.movieCount > StarMovieCount.movieCount)


---

## SQL Join 

* Recall that the FROM clause contains a **list of relations**
* Actually, that's not quite true
* What it contains is a very relational algebra expression
* The "," operator is actually the **set product** operator
* And it can be written as CROSS JOIN

```
SELECT starName, movieTitle, movieYear, genre
  FROM StarsIn, Movies
 WHERE StarsIn.title = Movies.title
   AND StarsIn.year = Movies.year
   AND Movies.length > 120
```

---

## SQL Join 

```
SELECT starName, movieTitle, movieYear, genre
  FROM StarsIn CROSS JOIN Movies
 WHERE StarsIn.title = Movies.title
   AND StarsIn.year = Movies.year
   AND Movies.length > 120
```

* There is no compelling reason for using CROSS JOIN instead of ","
* And many databases don't support the CROSS JOIN syntax, anyway

---

## SQL Theta Joins

* You can place an entire theta join on the FROM clause
* Use the JOIN ... ON synta

```
SELECT starName, movieTitle, movieYear, genre
  FROM StarsIn JOIN Movies ON StarsIn.title = Movies.title
                          AND StarsIn.year = Movies.year
 WHERE Movies.length > 120
```

* This is really a matter of style
* Some database programmers prefer to place the "join" conditions in the FROM,
  and the "selection" conditions in the WHERE

---

## Natural Joins

* Natural joins are even easier
* Just use NATURAL JOIN and the tables will be joined according to the common attributes

```
SELECT name, title, year, genre
  FROM StarsIn NATURAL JOIN Movies
 WHERE Movies.length > 120
```

* Note: For this to work, the StarsIn relation must have the same attribute names as Movies
* This is rarely the case, so natural joins are not as common as you may expect

---

## Outer Joins

* Finally, we can have an OUTER JOIN
* This can be combined with NATURAL or not

```
SELECT name, title, year, genre
  FROM StarsIn NATURAL FULL OUTER JOIN Movies
 WHERE Movies.length > 120
```

```
SELECT starName, movieTitle, movieYear, genre
  FROM StarsIn FULL OUTER JOIN Movies ON StarsIn.title = Movies.title
                                     AND StarsIn.year = Movies.year
 WHERE Movies.length > 120
```


* A FULL outer join preserves tuples in both relations

---

## Left and Right Outer Joins

* Of course, SQL supports both LEFT and RIGHT OUTER JOINS

```
SELECT name, title, year, genre
  FROM StarsIn NATURAL LEFT OUTER JOIN Movies
 WHERE Movies.length > 120
```

```
SELECT name, title, year, genre
  FROM StarsIn NATURAL RIGHT OUTER JOIN Movies
 WHERE Movies.length > 120
```

---

## Reality and Outer Joins

* Not all databases support all the different types of outer joins
  <br><br>
* It is very common for LEFT OUTER JOIN to be supported
* But none of the other OUTER JOIN combinations are necessarily supported
  <br><br>
* **Check your database manual!**


---

# Full-Relation Operations

---

## Full-Relation Operations

* By design, SQL conditions look at each row separately
* There is no notion of looking at more than one row at a time
* That's why there is an AVG(x) function in the SELECT clause, but not in the WHERE clause
  <br><br>
* But some operations only make sense in the context of a full relation
* We'll discuss those operations next

---

## Duplicate Elimination

* Recall that databases are working on bags instead of sets
* But many times we really want the answers to be sets
  <br><br>
* That's where **duplicate elimination** comes in
* This is easily done, with `SELECT DISTINCT` instead of `SELECT`

```
SELECT DISTINCT starName
  FROM StarsIn, Movies
 WHERE StarsIn.title = Movies.title
   AND StarsIn.year = Movies.year
   AND Movies.length > 120
```

* How would this be different without the `DISTINCT` keyword?

---

## Duplicate Elimination with Set Operations

* Suppose you take the `UNION` or `INTERSECT` or `EXCEPT` of two relations
* By default, this **eliminates duplicates**
  * This sort of makes sense
  * The implementation of `INTERSECT` and `EXCEPT` is most efficient when eliminating duplicates
  * `UNION` would be more efficient with duplicates, but it follows the patter of the other set operations
  <br><br>
* Here, you can ask explicitly for bag behavior (i.e., to have the duplicates left)
* Simply use `UNION ALL` or `INTERSECT ALL` or `EXCEPT ALL`

---

## Grouping and Aggregation in SQL

* We've already seen the grouping operator $\gamma$ in relational algebra
* The equivalent operation is `GROUP BY` in SQL


```
  SELECT major, AVG(salary)
    FROM Students
GROUP BY major
```

---

## Flashback: Grouping and Aggregation

* In general, we have $\gamma_{L}(R)$
* The list $L$ may contain
  * **grouping attributes** from $R$, e.g., $A$
  * **aggregated attributes** from $R$, e.g., $\text{SUM}(B)$
  <br><br>
* To execute $\gamma_{L}(R)$:
  1. Partition the tuples of $R$ into groups according to the values in the grouping attributes
  2. For each group, create a tuple that has the values of the grouping attributes and the
     aggregated values of the aggregated attributes

---

## Grouping and Aggregation in SQL

```
  SELECT major, AVG(salary)
    FROM Students
GROUP BY major
```

Major | $\text{AVG}(\text{Salary})$
------|---------------------------------------------------------------
ARTH  | 12,000
COSC  | 62,500
EECS  | 56,500

---

## Grouping and Aggregation in SQL

```
  SELECT major, COUNT(EnrolledIn.crn), AVG(salary)
    FROM Students, EnrolledIn, Courses
   WHERE Students.id = EnrolledIn.id
     AND Courses.crn = EnrolledIn.crn
     AND Courses.dept = 'MATH'
GROUP BY major
```

---

## Aggregation Operators

* SQL supports five standard aggregation operators
  * SUM, AVG, MIN, MAX, COUNT
* Each aggregation operator takes a single attribute as an argument, e.g., `AVG(salary)`
* In addition, the `COUNT` operator has a special syntax `COUNT(*)` that counts all the tuples in the result

---

## Aggregation Operators and Duplicates

StudentId  | Major   | Salary
-----------|---------|---------
1001       | COSC    | 60,000
2010       | ARTH    | 12,000
1022       | COSC    | 65,000
3095       | EECS    | 58,000
9403       | EECS    | 55,000

<br>

Aggregation           | Value
----------------------|---------
COUNT(*)              | 5 
COUNT(Major)          | 5
COUNT(DISTINCT Major) | 3

* The `DISTINCT` keyword inside an aggregation limits the rows under consideration
* This is only useful for `COUNT(DISTINCT x)`

---

## Aggregation Operators and NULLs

* NULLs complicate the semantics of aggregation operators a little
* The basic rule is **NULLs are completely ignored**

Aggregation           | Value
----------------------|------------------------------------
COUNT(*)              | # of rows
COUNT(Major)          | # of rows with a non-NULL Major
SUM(Salary)           | sum of the non-NULL Salary values

---

## Grouping and NULLs

* Suppose we `GROUP BY` Major
* We'll have a group for each different Major
  <br><br>
* What about the entries with NULL Majors?
* Remember that NULL is not the same as another NULL value
* I.e., if two students have a NULL major, that does not mean they are studying the same (unknown? undeclared?) major
  <br><br>
* But it would be very strange to have an entry for each row with a NULL major
* The SQL standard treats NULLs as **the same value** for the purpose of grouping

---&twocol

## Grouping and NULLs

*** =left

StudentId  | Major   | Salary
-----------|---------|---------
1001       | COSC    | 60,000
2010       | ARTH    | 12,000
1022       | NULL    | 65,000
3095       | EECS    | 58,000
9403       | NULL    | 55,000

*** =right

```
  SELECT major, AVG(salary)
    FROM Students
GROUP BY major
```

Major | $\text{AVG}(\text{Salary})$
------|---------------------------------------------------------------
ARTH  | 12,000
COSC  | 60,000
EECS  | 58,000
NULL  | 60,000

---

## Grouping and NULLs

* One more thing: What if a group is empty?
* This could happen, for example, if all the entries in it are NULL
  <br><br>
* Then the answer is NULL for SUM, AVG, MIN, MAX
* But the answer is 0 for COUNT
  <br><br>
* This is actually consistent with our definitions from before, but it surprises some people

Aggregation           | Value
----------------------|------------------------------------
COUNT(*)              | # of rows
COUNT(Major)          | # of rows with a non-NULL Major
SUM(Salary)           | sum of the non-NULL Salary values

---

# Database Modifications

---

## Database Modifications

* So far, we've been using SQL as a query language
* But SQL is also a **data manipulation language**, so we can modify the database with it
  <br><br>
* Modifications can be
  * **Insert** a tuple into a relation
  * **Delete** tuples from a relation
  * **Update** values of some tuples in a relation
  <br><br>
* Together with simple queries, these are known as CRUD operations
  * **C**reate, **R**ead, **U**pdate, **D**elete

---

## Insert Operations

* The easiest operation adds a tuple to a relation
  * `INSERT INTO R(A1,A2,...,An) VALUES (v1,v2,...,vn)`
* Some databases allow you to insert more than one tuple, by providing a comma-separated list of tuples after `VALUES`
  <br><br>
* Note, the list of attributes `(A1,A2,...,An)` is optional
* But always use it
  * The order of the attributes may change
  * The number of attributes may change
  <br><br>
* But wait, what if there is an attribute B1 that is not listed?
* The new tuple gets a value of B1 that is either
  * the default value specified for B1 in the schema
  * NULL

---

## Inserting an Entire Table

* You can insert many tuples at once with `INSERT ... SELECT`
* The syntax is basically an `INSERT INTO ...` clause followed by a `SELECT` query (instead of `VALUES`)

```
INSERT INTO LongMovies(title, year, length, genre)
SELECT title, year, length, genre
  FROM Movies
 WHERE length > 120 
```

* I make use of `INSERT ... SELECT` a lot when I'm modifying tables
* You may find it useful in your project

---

## Correlated Updates

* Consider this query

```
INSERT INTO Studios(name)
SELECT DISTINCT studioName
  FROM Movies
 WHERE studioName NOT IN (SELECT name FROM Studios)
```

* A few things to note:
  1. `DISTINCT` is important to avoid creating duplicate rows
  2. The subquery keeps us from adding a studio that was already known
  3. The semantics of SQL require that the `SELECT` query completely execute before any tuples are added

> * Reality strikes again: This is a **correlated subquery**
* Many databases do not support **correlated update subqueries**

---

## Deleting Tuples

* The syntax is
  * `DELETE FROM R WHERE ...`
  <br><br>
* Hint: Always run a `SELECT FROM R WHERE ...` before doing the deletion!
  <br><br>

```
DELETE FROM Movies
      WHERE genre <> 'scifi'
```

* Note that the WHERE clause may match 0, 1, or many tuples
* All matching tuples (if any) will be deleted

---

## Updating Tuples

* Finally, the UPDATE command allows us to change the values in one or more tuples
  * `UPDATE R SET A1=v1, A2=v2, ..., An=vn WHERE ...`

```
UPDATE Movie
   SET thumbsUp = 2
 WHERE (title, year) IN (SELECT movieTitle, movieYear
                           FROM StarsIn 
                          WHERE starName = 'Harrison Ford')
```

* Note: This is **not** a correlated subquery!

---

# Transactions in SQL

---

## Transactions in SQL

* We've been looking at SQL queries as if **each query executed completely on its own**
* In particular, we've ignored
  * what happens when more than one query is being executed at a time?
  * what happens when a query fails to execute?

---

## Transactions: Scenario 1

* Here is a classic scenario showing the need to perform transactions

```
UPDATE Accounts
   SET Balance = Balance + 200
 WHERE AccountId = 10000;

UPDATE Accounts
   SET Balance = Balance - 200
 WHERE AccountId = 10001;
```

---

## Transactions: Scenario 2

* Here is another subtle interaction, this time between rows of the same table

```
UPDATE Employees
   SET Salary = 1.03 * Salary
```

---

## Transactions: Scenario 3 (Long-lived Transactions)

* Here is an example of a long-lived transaction
  <br><br>
  1. User asks to purchase tickets for an upcoming concert
  2. System offers the user a selection of possible seats
  3. User selects the seats and offers payment
  4. System processes payment
  5. System assigns seats to user


---

## Transactions

* In general, we want **database transactions** to have these properties
  <br><br>
  1. **Atomicity** meaning the entire transaction is processed fully or not at all
  2. **Serializability** meaning two transactions $T_1$ and $T_2$ act **as if** they
     were executed sequentially (either $T_1; T_2$ or $T_2; T_1$)
     <br><br>
* We normally talk about the ACID properties to refer to the same idea
  * Atomicity
  * Consistency
  * Isolation
  * Durability

---

## Implementing Transactions

* There are two elements to implementing transactions
  <br><br>
* First, we must ensure atomicity
  * This can be done by writing entries to logs
  * Instead of simply replacing X with 2, we write to a log that we'll be replacing X with 2, and then we replace X with 2
  * Once we write to the log, we are **committed** to finishing the operation
  * Or, we can commit to **undo** all the operations in the same transaction
  <br><br>
* Second, we must ensure isolation
  * This is usually handled by locking
  * Variants (e.g., optimistic locking) are also possible

---

## Long-lived Transactions

* In general, 100s of transactions may be running concurrently
* It's unfeasible to run only one transaction at a time
* So we need a mechanism that allows us to run multiple transactions while avoiding interactions
* Typically this is done via locking
  <br><br>
* Long-lived transactions make this very difficult
* A single long-lived transaction could lock out all the other transactions, and overall throughput drops to zero
  <br><br>
* Good database applications avoid long-lived transactions
* E.g., they can go back to the user with
  * I'm sorry, but that seat is no longer available
  * Or they can allow a seat to be available, unavailable, and **reserved** (for a period of time)

---

## Specifying Transactions

* A transaction is one or more database operations that must be executed atomically and (apparently) serially
* Transactions can be bracketed around
  * `START TRANSACTION`
  * Either `COMMIT` or `ROLLBACK`
  <br><br>
* Programmatic interfaces will offer their own variants

  ```
  tx = session.beginTransaction();
  ...
  tx.commit ();  
  ```

---

## Performance of Transactions

* Implementing transactions involves tremendous overhead
* This slide shows Stonebraker's depiction of database performance bottlenecks for typical OLTP applications

<div class="centered">
    <img width="75%" src="assets/img/01-oltp-pie.png" title="OLTP Overhead Pie" alt="OLTP Overhead Pie">
</div>

---&twocol

## Enhancing Performance of Transactions

* For the future: Migrate to new technologies better suited to your needs
  <br><br>

*** =left

<div class="centered">
    <img src="assets/img/dbms-use-cases.png" title="DBMS Use Case Performance Needs" alt="DBMS Use Case Performance Needs">
</div>

*** =right

<div class="centered">
    <img src="assets/img/dbms-use-cases-served.png" title="DBMS Use Case Solutions" alt="DBMS Use Case Solutions">
</div>


---

## Enhancing Performance of Transactions

* In the meantime, we try to squeeze as much performance as we can out of the "elephants" (as Stonebraker calls them)
  <br><br>
* Trick #1: If possible, let the database know that the current session is **read only**
* You can do this with the command `SET TRANSACTION READ ONLY`
* Since read only transactions do not interfere with each other, the database may be able to execute a bunch of them faster
  <br><br>
* Trick #2: If possible, let the database know we're willing to live with less isolation than it would normally guarantee

---

## Dirty Reads

* A common problem of lowered isolation is **dirty reads**
* Consider this sequence of steps:
  1. T1 writes new value to X
  2. T2 reads the value of X
  3. T1 aborts
* In this sequence, T2 reads a value of X that **never existed**

---

## Do Dirty Reads Matter?

* In some cases, absolutely!
  * Check to see if there is enough money in account
  * Perform a withdrawal
  <br><br>
* In other cases, not so much
  * Find one of the best seats available and mark it reserved
  * Offer the seat to a customer
  * If customer buys it, mark seat as occupied
  * Otherwise, mark the seat as available again
  <br><br>
* Or very little
  * T1: enter final grades for students in this class
  * T2: compute average GPA for all students in UW

---

## Accepting Dirty Reads

* Suppose that for **your application** dirty reads are OK
* This may result in significantly better performance for your application **if the database knows dirty reads are OK**

  ```
  SET TRANSACTION READ WRITE
      ISOLATION LEVEL READ UNCOMMITTED
  ```

* The `READ UNCOMMITTED` tells the database we're OK with reading data written but not yet committed by another transaction
* I.e., we're OK with (potentially) dirty reads
  <br><br>
* Note: It may be safer to allow dirty reads for **read only** transactions
* If your transactions is read/write, then it may propagate bad information

---

## Other Isolation Levels

* Dirty reads are not the only potential problems
* SQL allows other isolation levels
  <br><br>
* A little more secure (and more costly) than `READ UNCOMMITTED` is `READ COMMITTED`
* This means that the transaction may read data from other transactions after they commit
* This is **not** the same as serializable!
  1. T2 sets X to 10
  2. T1 reads X (and gets the initial value of X, say 0)
  2. T2 commits
  3. T1 reads X again (and this time it gets 10)
* So `READ COMMITTED` avoids dirty reads, but it allows **non-repeatable reads**

---

## Other Isolation Levels

* SQL allows you to make transactions a little more secure (and more costly) with `REPEATABLE READ`
  <br><br>
* This is **not** the same as serializable!
  1. T1 gets the maximum value of X (and gets 100)
  2. T2 gets the maximum value of X (and also gets 100)
  3. T2 adds a new row with X set to max+1 (i.e., 101)
  4. T1 also adds a new row with X set to max+1 (i.e., 101)
* The problem, of course, is that T1 does not see the change that T2 made
* So 101 is no longer the value of max(X)+1
* This is called a **phantom read**

---

## Other Isolation Levels

* The most restrictive isolation level is `SERIALIZABLE`
* This should be the default (but it's usually not)
* Oracle, PostgreSQL, and Microsoft SQL Server all default to `READ COMMITTED` 
* MySQL defaults to `REPEATABLE READ`
  <br><br>
* You can always be explicit, e.g.,

  ```
  SET TRANSACTION READ WRITE
      ISOLATION LEVEL REPEATABLE READ
  ```


---

## Isolation Levels

Isolation Level                   | Characteristics
----------------------------------|--------------------------
READ UNCOMMITTED                  | Dirty reads. No locking! Anything goes!
READ COMMITTED                    | Can only read committed rows (but may read different versions of a row)
REPEATABLE READ                   | Multiple reads always retrieve same version of rows, but may have phantom reads
SERIALIZABLE                      | Pure isolation, real transactions

---

## Isolation Levels


Isolation Level  | Dirty Reads | Non-repeatable Reads | Phantom Reads
-----------------|-------------|----------------------|------------------
READ UNCOMMITTED | Allowed     | Allowed              | Allowed
READ COMMITTED   | Not allowed | Allowed              | Allowed
REPEATABLE READ  | Not allowed | Not allowed          | Allowed
SERIALIZABLE     | Not allowed | Not allowed          | Not allowed
