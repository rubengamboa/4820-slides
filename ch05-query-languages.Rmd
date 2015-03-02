title:        COSC 4820 Database Systems
subtitle:     Algebraic and Logical Query Languages
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

## About this Chapter

* The focus of this chapter is on **programming database applications**
  <br><br>
* First, we will discuss some important extensions to relational algebra
* This includes some new operators that are very useful in practice, e.g., grouping and sorting
* It also involves some pragmatic compromises that make implementations of relational algebra more efficient
  <br><br>
* We will also introduce a different query model that is based on logic
* This formalism is also useful as a foundation towards **graphical query languages**, e.g., Query-by-Example (QBE)
* And it supports more powerful queries than relational algebra

---

# Relational Operations on Bags

---

## What Are Bags?

* A **bag** (also called a **multiset**) is a collection of elements that
  1. is **unordered**
  2. allows **multiple copies** of the same element
  <br><br>
* It is different from **lists** in that lists are ordered
  <br><br>
* It is different from **sets** in that sets have only one copy of each element
  <br><br>
* In our context, using bags means that we allow **duplicate rows** in a table

---

## Why Bags instead of Sets?

* The original mathematical formalism of relational databases was based on sets
  <br><br>
* Real relational database systems operated on **bags** instead of sets
  <br><br>
* The reason is efficiency, e.g.,
  * To compute $A \cup B$, simply return the elements of $A$ followed by the elements of $B$
  * To compute $\pi(A)$, simply return project each element of $A$ one at a time, and return the result as you compute it
* In neither case do you need to worry about duplicates
* Taking care of duplicates is an $O(n\log n)$ operation, whereas the two algorithms above are only $O(n)$
  <br><br>
* And don't forget that in the context of database, that could be a **huge** difference

---

## Bag Operations

* Suppose $R$ and $S$ are bags
* Tuple $t$ appears $n$ times in $R$ and $m$ times in $S$
* Here, we allow $n$ and $m$ to be zero

Operation        | #times $t$ appears in result
-----------------|-----------------------------
$R \cup S$       | $n+m$
$R \cap S$       | $\min(n,m)$
$R - S$          | $\max(n-m, 0)$

---&twocol

## Bag Operations

* Here are some example relations
*** =left

### Relation $R$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2

*** =right

### Relation $S$

A   | B
----|----
1   | 2
3   | 4
3   | 4
5   | 6

---&twocol

## Bag Operations

*** =left

### $R \cup S$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2
1   | 2
3   | 4
3   | 4
5   | 6

*** =right

### $R \cap S$

A   | B
----|----
1   | 2
3   | 4

### $R - S$

A   | B
----|----
1   | 2
1   | 2

### $S - R$

A   | B
----|----
3   | 4
5   | 6

---&twocol

## Bag Operations

*** =left

### Relation $R$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2

*** =right

### Relation $\pi_B(R)$

B   | 
----|---
2   | 
4   | 
2   | 
2   | 

### Relation $\sigma_{A \le 2}(R)$

A   | B
----|----
1   | 2
1   | 2
1   | 2


---&twocol

## Bag Operations

*** =left

### Relation $R$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2


### Relation $S$

A   | B
----|----
1   | 2
3   | 4
3   | 4
5   | 6

*** =right

### $R \times S$

R.A   | R.B  | S.A   | S.B
------|------|-------|------
1     | 2    | 1     | 2
1     | 2    | 3     | 4
1     | 2    | 3     | 4
1     | 2    | 5     | 6
3     | 4    | 1     | 2
3     | 4    | 3     | 4
3     | 4    | 3     | 4
3     | 4    | 5     | 6
1     | 2    | 1     | 2
1     | 2    | 3     | 4
1     | 2    | 3     | 4
1     | 2    | 5     | 6
1     | 2    | 1     | 2
1     | 2    | 3     | 4
1     | 2    | 3     | 4
1     | 2    | 5     | 6

---&twocol

## Bag Operations

*** =left

### Relation $R$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2


### Relation $S$

A   | B
----|----
1   | 2
3   | 4
3   | 4
5   | 6

*** =right

### $R \bowtie_{R.A=S.A} S$

R.A   | R.B  | S.A   | S.B
------|------|-------|------
1     | 2    | 1     | 2
3     | 4    | 3     | 4
3     | 4    | 3     | 4
1     | 2    | 1     | 2
1     | 2    | 1     | 2

---

## Bag Operations Pragmatics

* Remember: The main reason for bag operations is that they are more efficient than set operations
  <br><br>
* So does it really make sense that a tuple $t$ should appear $n+m$ times in $R \cup S$?
  <br><br>
* In general, expect database implementations to define their own semantics for bag operations
* And the precise semantics may vary depending on the way the optimizer chooses to implement
  a given query
* Which means it may change over time


---

# Extended Operators of Relational Algebra

---

## Extended Operators of Relational Algebra

* These operators are not part of the original description of relational algebra, but
  they are incredibly useful
  <br><br>
* **Duplicate-elimination** operator $\delta$
* **Sorting** operator $\tau$ ($\sigma$ was taken) 
* **Grouping** operator $\gamma$
* **Aggregation** combines multiple tuples into a single value, e.g., by averaging
* **Extended projection** supports arithmetic operators and renaming in a projection
* **Outer joins** are similar to joins, but retain tuples that do not meet the join criteria

---&twocol

## Duplicate Elimination

* This just converts a bag into a set by removing duplicates

*** =left

### Relation $R$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2

*** =right

### $\delta(R)$

A   | B
----|----
1   | 2
3   | 4

---&twocol

## Aggregate Operators

* These summarize (or aggregate) one or more columns in the result

*** =left

### Relation $R$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2

*** =right

### Aggregations of $R$

Aggregation | Value
------------|---------
SUM(A)      | 6
AVG(A)      | 1.5
MIN(A)      | 1
MAX(A)      | 3
COUNT(A)    | 4

---

## Grouping

* The grouping operator collects all the rows that have the same value of one or more columns
* That way, aggregation takes place on each group, not on the entire table
  <br><br>
* This is the difference between
  * Average starting salary of graduating seniors
  * Average starting salary of graduating seniors **by major**

---&twocol

## Grouping Example

*** =left

### Students

StudentId  | Major   | Salary
-----------|---------|---------
1001       | COSC    | 60,000
2010       | ARTH    | 12,000
1022       | COSC    | 65,000
3095       | EECS    | 58,000
9403       | EECS    | 55,000

*** =right

### $\pi_{\text{AVG}(\text{Salary})}(\text{Students})$

$\text{AVG}(\text{Salary})$  |  
-----------------------------|----
50,000

### $\gamma_{\text{Major},\text{AVG}(\text{Salary})}(\text{Students})$

Major | $\text{AVG}(\text{Salary})$
------|---------------------------------------------------------------
ARTH  | 12,000
COSC  | 62,500
EECS  | 56,500

---

## Grouping and Aggregation

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

## Extended Grouping Operator

* The names for aggregated attributes are unwieldy, e.g, $\text{SUM}(B)$
* A simple extension allows us to rename these attributes immediately, without having
  to invoke the $\rho$ renaming operator
  <br><br>

###  $\gamma_{\text{Major},\text{AVG}(\text{Salary})\rightarrow\text{AvgSalary}}(\text{Students})$

Major | AvgSalary
------|------------
ARTH  | 12,000
COSC  | 62,500
EECS  | 56,500

---&twocol

## Extended Projection Operator

* Similarly, we can extend the projection operator
* Each item in a projection can be
  * an attribute $A$ (just as before)
  * a renamed attribute, e.g., $A \rightarrow B$
  * a named expression, e.g., $A+2 \rightarrow B$

*** =left

### Relation $R$

A   | B
----|----
1   | 2
3   | 4
1   | 2
1   | 2

*** =right

### $\pi_{A, 2\cdot A\rightarrow A', B \rightarrow B'}(R)$

A   | A'  | B'
----|-----|----
1   | 2   | 2
3   | 6   | 4
1   | 2   | 2
1   | 2   | 2


---&twocol

## Sorting Operator

* The sorting operator $\tau$ orders the tuples by one or more columns

*** =left

### Relation $R$

A   | B   | C
----|-----|------
1   | 2   | 6
3   | 4   | 5
1   | 2   | 4
1   | 2   | 3

*** =right

### $\tau_{A,C}(R)$

A   | B   | C
----|-----|------
1   | 2   | 3
1   | 2   | 4
1   | 2   | 6
3   | 4   | 5


---

## Outer Joins

* A characteristic of joins is that only rows with matching tuples in the other relation show up in the result
* The remaining rows are left dangling
  <br><br>
* E.g., suppose we join students with advisors
* If a student does not have an advisor, she will **not show up** on the results
* If an advisor does not have any students, she will **not show up** on the results, either
  <br><br>
* Sometimes, it would be preferable to create an extra row, e.g., with a student but with a NULL advisor
* That's what outer joins do

---

## Outer Joins

* Consider $R(A,B,C)$ and $S(B,C,D)$
* The outer join is $R \overset{\circ}{\bowtie} S$ contains
  * The tuples in $R \bowtie S$
  * A tuple $(a,b,c,NULL)$ for each $(a,b,c) \in R$ with no matching tuples in $S$
  * A tuple $(NULL,b,c,d)$ for each $(b,c,d) \in S$ with no matching tuples in $R$

---&twocol

## Outer Joins

*** =left

### $R(A,B,C)$

A   | B   | C   
----|-----|-----
1   | 2   | 3
4   | 5   | 6
7   | 8   | 9

### $S(B,C,D)$

B   | C   | D   
----|-----|-----
2   | 3   | 10
2   | 3   | 11
6   | 7   | 12

*** =right

### $R \overset{\circ}{\bowtie} S$

A    | B   | C   | D   
-----|-----|-----|-----
1    | 2   | 3   | 10
1    | 2   | 3   | 11
4    | 5   | 6   | NULL
7    | 8   | 9   | NULL
NULL | 6   | 7   | 12

---

## Left and Right Outer Joins

* Consider $R(A,B,C)$ and $S(B,C,D)$
* Usually, we only want to keep the dangling tuples from $R$ and not $S$, or vice versa
  <br><br>
* **Left outer join** $R \overset{\circ}{\bowtie}_L S$: Keep dangling tuples from $R$ but not from $S$
* **Right outer join** $R \overset{\circ}{\bowtie}_R S$: Keep dangling tuples from $S$ but not from $R$
* I.e., the left outer join preserves the tuples in the left table, and the same for the right
  <br><br>
* Some databases only support left outer joins

---&twocol

## Outer Joins

*** =left

### $R(A,B,C)$

A   | B   | C   
----|-----|-----
1   | 2   | 3
4   | 5   | 6
7   | 8   | 9

### $S(B,C,D)$

B   | C   | D   
----|-----|-----
2   | 3   | 10
2   | 3   | 11
6   | 7   | 12

*** =right

### $R \overset{\circ}{\bowtie}_L S$

A    | B   | C   | D   
-----|-----|-----|-----
1    | 2   | 3   | 10
1    | 2   | 3   | 11
4    | 5   | 6   | NULL
7    | 8   | 9   | NULL

### $R \overset{\circ}{\bowtie}_R S$

A    | B   | C   | D   
-----|-----|-----|-----
1    | 2   | 3   | 10
1    | 2   | 3   | 11
NULL | 6   | 7   | 12

---

# A Logic for Relations

---

# Relational Algebra and Datalog



