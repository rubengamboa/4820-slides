title:        COSC 4820 Database Systems
subtitle:     Constraints and Triggers
author:       Ruben Gamboa
#logo:         uw-logo-small.png
#biglogo:      uw-logo-large.png
job:          Professor
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

* We started studying SQL by looking at its DDL
* I.e., how to create a schema with SQL
  <br><br>
* Then we moved on to SQL's querying capabilities
  <br><br>
* Now we're going back to the schema language!
* The reason is simple:
  * **We are making changes to the schema that require query execution**
* These **active elements** are query (fragments) that are stored in the database
* Primarily, they serve to implement **integrity constraints**, either by checking
  the database or modifying it automatically

---

# Keys and Foreign Keys

---

## Keys and Foreign Keys

* Recall that a **key** for a table is a set of one or more attributes that must be unique across all rows
* We specify keys with the `PRIMARY KEY` (or `UNIQUE`) keywords in the `CREATE TABLE` command
  <br><br>
* When a record in table $A$ needs to refer to a record in table $B$, we use the key of $B$ and store it in $A$
* In $A$, we call this the **foreign key**
  * "Foreign" because it belongs to $B$
* In $B$, it's just the **primary key**

---

## Keys and Foreign Keys

```
CREATE TABLE MovieExec (
    name     VARCHAR(30),
    address  VARCHAR(200),
    cert#    INT PRIMARY KEY,
    netWorth NUMERIC
);

CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT REFERENCES MovieExecs(cert#)
);

CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#));
```


---

## Referential Integrity

* The database guarantees the following:

> There is no way for a row of table `Studios` to reference (or point to) a row of
> table `MovieExecs` that does not exist

* This is called **referential integrity**

---

## Referential Integrity

* Recall: `Studios` has a foreign key that belongs to `MovieExecs`
  <br><br>
* When can referential integrity be violated?
  <br><br>
* MovieExecs
  1. Updates
  2. Deletes
* Studios
  1. Updates
  2. Inserts

> * Notice that inserts on MovieExecs and Deletes on Studios cannot create a constraint violation

---

## Referential Integrity

* What should a database do when it detects a violation of referential integrity?
  <br><br>
* There are several alternatives:
  1. We can **reject** updates that violate referential integrity
  2. We can **cascade** or propagate updates to preserve referential integrity
  3. We can **set null** the entries that would violate referential integrity
  4. We can **set default** the entries that would violate referential integrity

<br>

* We can make these choices separately for UPDATE and DELETE commands

<br>

* Note: We only ever update tuples that **reference** a primary key
* E.g., we never cascade to the primary key

---

## Referential Integrity: Rejection

```
CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#)
);

CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
);
```

---

## Referential Integrity: Cascade


```
CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);
```

* This is the best semantics for **weak entities**
* E.g., if the **supporting tuple** is removed, so are any weak entities that depended on it

---

## Referential Integrity: Set Null


```
CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#)
            ON UPDATE CASCADE
            ON DELETE SET NULL
);
```

* Notice it makes more sense to CASCADE on update, but SET NULL on delete

---

## Referential Integrity: Set Default


```
CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#)
            ON UPDATE CASCADE
            ON DELETE SET DEFAULT
);
```

* In some cases, it is best to keep around unclaimed entities, but it's not a good idea to set the
  owner to NULL
* We can use a good default value
  * E.g., a movie must have a director, but a director can withdraw his or her name, and the film
    **defaults to Alan Smithee**
  * Records related to grades, assignments, etc., are credited to **Test Student** in WyoCourses

---

## Referential Integrity and Transactions

* Suppose we perform a transaction with two updates $Q_1$ and $Q_2$
  <br><br>
* When do you **check** integrity constraints?
  1. Immediately after executing $Q_1$
  2. Or at the end of the transaction, when both $Q_1$ and $Q_2$ are executed?

---

## Referential Integrity and Transactions

* It's actually fairly common for a transaction to perform multiple updates
* For example, when you enrolled at the university, dozens of records were created or updated on your behalf
  <br><br>
* If there are integrity constraints between these records, you have to be very careful about the order in which
  they are inserted
* E.g., you must enter the main record in the `Students` table before you enter any records in `EnrolledIn`
  <br><br>
* You can create a **dependency graph** that lists which tables reference other tables
* If the dependency graph is **acyclic**, you can order the insertions so that integrity constraints can be
  checked after each update
* But if there are cycles, you have to do all the insertions first, then check the integrity constraints

---

## Referential Integrity and Transactions

* In SQL, we can specify whether we want to check constraints right away or wait until the transaction is complete
* We do this **when we create the constraint** (not when we submit the transaction)

```
CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#)
        DEFERRABLE INITIALLY DEFERRED
)
```

* There are three different levels:
  1. `NOT DEFERRABLE` check constraints immediately
  2. `DEFERRABLE INITIALLY IMMEDIATE` check constraints after each statement
  3. `DEFERRABLE INITIALLY DEFERRED` check constraints at the end of a transaction

---

## Referential Integrity and Transactions

* One more thing!
* You can give constraints names by using the `CONSTRAINT` keyword (and we'll see this later)
* This has several advantages
  1. Error messages make more sense, e.g., 'PRESC#_FK" violated, instead of "FK_59283" violated
  2. You can turn on or off constraints by giving their name
  3. You can change whether a constraint is deferred or immediate

```
SET CONSTRAINT PRESC#_FK DEFERRED
```

---

# Constraints on Attributes and Tuples

---

## Constraints on Attributes and Tuples

* Now we'll consider constraints that limit the possible values of a tuple
* These can apply to a single attribute, e.g., "Salary must be positive"
* Or they can apply to a whole row, e.g., "Either Salary is positive or EmpType is equal to intern"

---

## NOT NULL Constraints

* A simple constraint is `NOT NULL`
* This simply forces the record to have a value for the given attribute
* The keywords NOT NULL appear immediately after the data type of the attribute declaration 
  in the `CREATE TABLE` or `ALTER TABLE` commands

```
CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT NOT NULL,
    FOREIGN KEY (presC#) REFERENCES MovieExecs(cert#)
        DEFERRABLE INITIALLY DEFERRED
)
``` `

---

## Attribute CHECK Constraints

* These constraints allow you to **specify a condition** that an attribute must pass
* They are checked whenever the given attribute is inserted or modified

```
CREATE TABLE MovieExec (
    name     VARCHAR(30),
    address  VARCHAR(200),
    cert#    INT PRIMARY KEY,
    netWorth NUMERIC CHECK (netWorth >= 10000000)
)
```

* This constraint checks that the netWorth of any movie executive is at least $10,000,000

---

## Attribute CHECK Constraints

* Here's a CHECK constraint that **does not work as intended**

```
CREATE TABLE Studios (
    name    VARCHAR(30) PRIMARY KEY,
    address VARCHAR(200),
    presC#  INT NOT NULL
            CHECK (presC# IN (SELECT cert# FROM MovieExecs))
)
```

* The problem is that this is only checked when a new value of `presC#` is inserted or updated
* So if the `cert#` of a movie executive is removed, the check is not performed

---

## Tuple CHECK Constraints

* These constraints allow you to **specify a condition** that a tuple must pass
* They are checked whenever a tuple is inserted or modified

```
CREATE TABLE MovieExec (
    name     VARCHAR(30),
    address  VARCHAR(200),
    cert#    INT PRIMARY KEY,
    netWorth NUMERIC,
    CHECK (netWorth >= 10000000 OR
           cert# NOT IN (SELECT presC# FROM MovieStudios))
)
```

* This constraint checks that the netWorth of any **studio president** is at least $10,000,000

> * Or does it?
    * Hint: What happens when we UPDATE a president in the `Studio` table?

---

# Modifying Constraints

---

## Naming Constraints

* Earlier we mentioned that you can name constraints with the `CONSTRAINT` keyword

```
CREATE TABLE MovieExec (
    name     VARCHAR(30),
    address  VARCHAR(200),
    cert#    INT CONSTRAINT MovieExecPK PRIMARY KEY,
    netWorth NUMERIC,
    CONSTRAINT MovieExecNetWorthCK 
        CHECK (netWorth >= 10000000 OR
               cert# NOT IN (SELECT presC# FROM MovieStudios))
)
```

---

## Dropping Constraints

* Now we can modify constraints
* For example, we can get rid of the CHECK constraint on netWorth as follows:

```
ALTER TABLE MovieExec DROP CONSTRAINT MovieExecNetWorthCK
```

---

## Adding Constraints

* You can also add new constraints to a relation:

```
ALTER TABLE MovieExec ADD CONSTRAINT MovieExecNetWorthCK
            CHECK (netWorth >= 10000000 OR
                   cert# NOT IN (SELECT presC# FROM MovieStudios))
```

* Note: Any constraints added in this way will be at the **tuple level**
* This is slightly less efficient than having CHECK constraints at the attribute levels


---

## Modifying Constraints

* Some databases allow you to modify constraints

```
ALTER TABLE MovieExec ALTER CONSTRAINT MovieExecNetWorthCK
            CHECK (netWorth >= 20000000 OR
                   cert# NOT IN (SELECT presC# FROM MovieStudios))
```

* But this is not very common
* You may have to DROP a constraint, then ADD a new version

---

## Disabling and Enabling Constraints

* One more thing!
* Some databases allow you to enable or disable constraints
* This means that checking the constraint can be disabled for a period of time
  <br><br>
* If you are inserting **a lot of tuples**, it may be beneficial to
  1. disable the constraints
  2. insert all the tuples
  3. re-enable the constraints
  <br><br>
* Consider dropping and readding the constraints, if that's the only option!

---

# Assertions

---

## Assertions

* **Assertions** are more general than constraints
* They operate on the **entire database**, not just a single table
  <br><br>
* So they let you specify conditions that must be true at all times, i.e., **invariants**
* The only tricky part is that the condition must return a single Boolean value
* The condition is usually an EXISTS or NOT EXISTS clause

```
CREATE ASSERTION FullTimeStudentAssertion
    CHECK (NOT EXISTS (
                SELECT *
                  FROM (  SELECT StudentID, COUNT(*) AS CourseCount
                            FROM Students NATURAL JOIN EnrolledIn
                        GROUP BY StudentID) AS StudentCourses
                 WHERE CourseCount < 12
                    OR CourseCount > 20
           )
    )
```

---

## Assertions

* Just as with constraints, you can DROP assertions
  * `DROP ASSERTION FullTimeStudentAssertion`
  <br><br>
* You may also be able to ALTER assertions

<br>

> * Truth in advertising: Assertions are **very expensive**
* Very few databases support them

---

# Triggers in SQL

---

## Triggers in SQL

* Triggers are saved queries that are executed automatically when **something happens**
* The "something" can be an update, a deletion, etc.

---

## Triggers in SQL

* There are three parts to a trigger
  <br>
  <br>

1. **Event:** typically insert, delete, or update to a particular relation
2. **Condition:** a test that should be performed when the event happens
3. **Action:** SQL code performed when the event occurs **and** the condition holds

---

## Triggers in SQL

```
CREATE TRIGGER NetWorthTrigger
AFTER UPDATE OF netWorth ON MovieExec
REFERENCING
    OLD ROW AS OldTuple,
    NEW ROW AS NewTuple
FOR EACH ROW
WHEN (OldTuple.netWorth > NewTuple.netWorth)
    UPDATE MovieExec
       SET netWorth = OldTuple.netWorth
     WHERE cert# = NewTuple.cert#
```

---

## Triggers in SQL

Some key points:

1. The conditions can access the state before and after the update that activated the trigger
2. You can tie a trigger to an update of a single attribute of a relation
3. The trigger condition and action may occur
   * **row-level:** once for each modified tuple
   * **statement-level:** once for each statement

---

## More Options

* Instead of AFTER, a trigger can run BEFORE an update, deletion, insert
* The action can have many statements inside a BEGIN ... END block
* If you are using a row-level trigger
  * OLD ROW AS and NEW ROW AS give you access to each row
  * OLD ROW cannot be used for insertions
  * NEW ROW cannot be used for deletions
* If you are using a statement-level trigger
  * OLD TABLE AS and NEW TABLE AS give you access to the **affected tuples**
  * I.e., this does not give the entire old table!
  * Only the tuples modified by the statement

---

## Triggers in SQL

```
CREATE TRIGGER AvgNetWorthTrigger
AFTER UPDATE OF netWorth ON MovieExec
REFERENCING
    OLD TABLE AS OldRows,
    NEW TABLE AS NewRows
FOR EACH STATEMENT
WHEN (500000 > (SELECT AVG(netWorth) FROM MovieExecs))
BEGIN
    DELETE 
      FROM MovieExecs
     WHERE cert# IN (SELECT cert# FROM NewRows);

    INSERT INTO MovieExecs
    SELECT *
      FROM OldRows;
END
```

---

## Triggers in SQL

```
CREATE TRIGGER AvgNetWorthTrigger
AFTER UPDATE OF netWorth ON MovieExec
REFERENCING
    OLD TABLE AS OldRows,
    NEW TABLE AS NewRows
FOR EACH STATEMENT
WHEN (500000 > (SELECT AVG(netWorth) FROM MovieExecs))
BEGIN
    DELETE 
      FROM MovieExecs
     WHERE cert# IN (SELECT cert# FROM NewRows);

    INSERT INTO MovieExecs
    SELECT *
      FROM OldRows;
END
```

---

## Triggers in SQL

```
CREATE TRIGGER FixYearTrigger
BEFORE INSERT ON Movies
REFERENCING
    NEW ROW AS NewRow,
    NEW TABLE AS NewRows
FOR EACH ROW
WHEN NewRow.year IS NULL
UPDATE NewRows SET year = to_char(sysdate, 'YYYY')
```
