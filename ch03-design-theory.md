title:        COSC 4820 Database Systems
subtitle:     Design Theory for Relational Databases
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

* The focus of this chapter is on **designing database schemas**
* This is the problem of **modeling**
* I.e., how do we represent the real world inside a database?
  <br><br>
* Remember, all we have to work with is tables!
* So how do we encode the real world in a bunch of tables?
  <br><br>
* There are many pitfalls and traps
* Luckily, there is a well understood theory of relational database design
  <br><br>
* This is a very **mathematical** theory
* But don't be fooled: It's tremendously useful
* (Actually, that's the reason we study math -- it's tremendously useful!)

---

# Functional Dependencies

---

## Functional Dependencies

* The most fundamental property to describe table design is that of **functional dependency**
* This is a generalization of the idea of **(primary) key**
  <br><br>
* Consider a relation $R(A,B,C)$
* We say that $A$ is a key if
  * Suppose we know that $A$ is equal to $a$
  * Then we also "know" the values of $B$ and $C$
* By "know" $B$ and $C$, we mean that they are **determined** by the value of $A$
  <br><br>

> * Similarly, we say that $A$ **functionally determines** $B$, written $A \rightarrow B$, if
  * Suppose we know that $A$ is equal to $a$
  * Then we also "know" the value of $B$

---

## Functional Dependency Sanity Check

* Check your understanding
  <br><br>
* We have the relation $R(A,B,C)$
  <br><br>
* $A$ is a key if and only if $A$ functionally determines $B$ and $C$
* I.e., $A \rightarrow B, C$
  <br><br>

> * By the way, this can also be written as
  $$\begin{eqnarray}
    A & \rightarrow & B \\
    A & \rightarrow & C \\
    \end{eqnarray}
  $$

---

## A Sample Table

Title               | Year   | Length | Genre  | StudioName | StarName
--------------------|--------|--------|--------|------------|--------------
Gone With the Wind  | 1939   |    231 | drama  | MGM        | Vivien Leigh
Star Wars           | 1977   |    124 | scifi  | Fox        | Mark Hamill
Wayne's World       | 1992   |     95 | comedy | Paramount  | Dana Carvey

* Would you agree that $\text{title}, \text{year} \rightarrow \text{Length}$?
* How about $\text{title}, \text{year} \rightarrow \text{Genre}$?
* How about $\text{title}, \text{year} \rightarrow \text{StudioName}$?
* How about $\text{title}, \text{year} \rightarrow \text{StarName}$?

---

## Another Sample Table

Title               | Year   | Length | Genre  | StudioName | StarName
--------------------|--------|--------|--------|------------|--------------
Gone With the Wind  | 1939   |    231 | drama  | MGM        | Vivien Leigh
Star Wars           | 1977   |    124 | scifi  | Fox        | Mark Hamill
Star Wars           | 1977   |    124 | scifi  | Fox        | Carrie Fisher
Star Wars           | 1977   |    124 | scifi  | Fox        | Harrison Ford
Wayne's World       | 1992   |     95 | comedy | Paramount  | Dana Carvey
Wayne's World       | 1992   |     95 | comedy | Paramount  | Mike Meyers

* Would you agree that $\text{title}, \text{year} \rightarrow \text{Length}$?
* How about $\text{title}, \text{year} \rightarrow \text{Genre}$?
* How about $\text{title}, \text{year} \rightarrow \text{StudioName}$?
* How about $\text{title}, \text{year} \rightarrow \text{StarName}$?

---

## About Functional Dependencies and Relation Instances

* Functional dependencies are constraints on **relations**
* They are not constraints on **relation instances**
  <br><br>

> * Trick question:
  * Here's a relation instance
  * What are the keys?
  * What are the functional dependencies?
  <br><br>

> * A relation instance can **rule out** a possible functional dependency
* But it can never **rule in** a functional dependency

---

## A Formal Definition of Keys

* We now have the mathematical machinery to define formally what it means to be a key
  <br><br>
* Suppose we have a relation $R(A_1, A_2, \dots, A_n)$
* Let $\mathcal{A} = \{A_1, A_2, \dots, A_n\}$
* Now, let $\mathcal{S} \subset \mathcal{A}$
* I.e., $\mathcal{S}$ is a subset of the attributes

> * We say that $\mathcal{S}$ is a **key** if and only if 
  1. $\mathcal{S} \rightarrow \mathcal{A} - \mathcal{S}$
  2. If $\mathcal{S'} \subsetneq \mathcal{S}$, then $\mathcal{S'} \nrightarrow \mathcal{A} - \mathcal{S'}$
  
> * If only the first condition holds, we call $\mathcal{S}$ a **superkey**

---

## A Formal Definition of Keys

* Suppose we have a relation $R(A, B, C, D, E)$
* Suppose that
  * $A \rightarrow B, C$
  * $B \rightarrow D, E$
  * $C \rightarrow D, E$

> * $\{A, B, C\}$ is a pseudo-key, because $A, B, C \rightarrow D, E$
* But it is not a key, because $A, B \rightarrow C, D, E$ and $\{A, B\} \subsetneq \{A, B, C\}$

> * $\{A, B\}$ is a key, because
  1. $A, B \rightarrow C, D, E$
  2. $A \nrightarrow B, C, D, E$
  3. $B \nrightarrow A, C, D, E$
  4. $\emptyset \nrightarrow A, B, C, D, E$ (and there's no need to check this, since it's implied by the previous two)


---

## A Formal Definition of Keys

* Suppose we have a relation $R(A, B, C, D, E)$
* Suppose that
  * $A \rightarrow B, C$
  * $B \rightarrow D, E$
  * $C \rightarrow D, E$
* We already know that $\{A, B\}$ is a key

> * Similarly, $\{A, C\}$ is also a key
* We would choose either $\{A, B\}$ or $\{A, C\}$ as the primary key

> * There are many (14) superkeys, but no more keys

---

# Rules about Functional Dependencies

---

## Reasoning about Functional Dependencies

* Suppose we know that $A \rightarrow B$
* And we also know that $B \rightarrow C$

> * Isn't it obvious that $A \rightarrow C$?
* That's the idea behind reasoning about functional dependencies

> * In general, we can say that a particular set $S$ of FDs implies some other FD $F$, which we write as $S \vdash F$
* Or a set $S$ of functional dependencies may imply some other set $T$ of FDs, which we write as $S \vdash T$
  * In this case, We also say that $T$ follows from $S$
  
> * And, whenever $S \vdash T$ and $T \vdash S$, we say that $S$ and $T$ are **equivalent**

---

## Splitting Rule

* Suppose we know that $A \rightarrow B, C$

> * We can write this instead as
  1. $A \rightarrow B$
  2. $A \rightarrow C$
* In fact, we sometimes prefer to write FDs so that they only have one attribute on the right-hand side

---

## Combining Rule

* We can go the other way

* Suppose we know that 
  1. $A \rightarrow B$
  2. $A \rightarrow C$

> * We can write this instead as $A \rightarrow B, C$
* And for some purposes, we want to write FDs to have the maximum number of attributes on the right-hand side

---

## Trivial Functional Dependencies

* Suppose we have a relation $R(A, B, C)$

> * Then all of these hold
  1. $A \rightarrow A$
  2. $B \rightarrow B$
  3. $A, B, C \rightarrow A$

> * More formally, if $\mathcal{A}$ is the set of attributes of relation $R$, then
  * $\mathcal{A}' \rightarrow \mathcal{A}''$ whenever $\mathcal{A}'' \subset \mathcal{A}' \subset \mathcal{A}$


---

## Trivial Dependency Rule

* Suppose we have a relation $R(A, B, C)$
* And suppose that $A, B \rightarrow B, C$

> * This is not a trivial dependency, but there's something strange about it
* In fact, it is easy to see that $A, B \rightarrow C$ is a simpler version that is equivalent to it

> * More formally, if $\mathcal{A}$ is the set of attributes of relation $R$, and $\mathcal{A'} \rightarrow \mathcal{A''}$
  * $\mathcal{A}' \rightarrow \mathcal{A}'' - \mathcal{A'}$

---

## Closure of a Set of Attributes

* Suppose we have a relation $R$ with attributes $\mathcal{A}$
* Let $\{A_1, A_2, \dots, A_n\} \subset \mathcal{A}$

* The **closure** of $\{A_1, A_2, \dots, A_n\}$, written $\{A_1, A_2, \dots, A_n\}^+$ is the set of all attributes that
  are functionally determined by $\{A_1, A_2, \dots, A_n\}$
* Notice that $\{A_1, A_2, \dots, A_n\} \subset \{A_1, A_2, \dots, A_n\}^+$, because of trivial FDs


---

## Closure of a Set of Attributes

<p class="centered">
    <img src="assets/img/closure-attributes.png" alt="Closure of a Set of Attributes" title="Closure of a Set of Attributes" class="img-responsive">
</p>

---

## Closure of a Set of Attributes

INPUT: A set $A$ of attributes of a relation $R$, and a set $F$ of FDs 

OUTPUT: $A^+$

1. Use the splitting on rule on $S$, so that all FDs have a single attribute on the right-hand side
2. Let $X$ be the set of attributes that will become the closure
3. Initially, $X=A$
4. While there is some FD $B_1, B_2, \dots, B_m \rightarrow C$ such that $\{B_1, B_2, \dots, B_m\} \subset X$ but $C \not\in X$
   1. Let $X = X \cup \{C\}$

<br>
Note that this algorithm terminates
* At each step in the loop, $X$ grows by one attribute
* $X$ can be no larger than the attributes of $R$

---

## Example

Suppose we have a relation $R(A,B,C,D,E)$ with the following FDs:
* $A, B \rightarrow C$
* $B, C \rightarrow A, D$
* $D \rightarrow E$
* $C, F \rightarrow B$

Let's find the closure of $\{A, B\}$

---

## Example

Step 1: Use the splitting rule, and replace the FDs with:
* $A, B \rightarrow C$
* $B, C \rightarrow A$
* $B, C \rightarrow D$
* $D \rightarrow E$
* $C, F \rightarrow B$

---&twocol

## Example

*** =left
### Functional Dependencies

* $A, B \rightarrow C$
* $B, C \rightarrow A$
* $B, C \rightarrow D$
* $D \rightarrow E$
* $C, F \rightarrow B$

*** =right

### Algorithm Trace

Step | $X$             | FD            
-----|-----------------|---------------------
   0 | $A, B$          |               
   1 | $A, B, C$       | $A, B \rightarrow C$
   2 | $A, B, C, D$    | $B, C \rightarrow D$
   3 | $A, B, C, D, E$ | $D \rightarrow E$

---

## Why the Closure Algorithm Works, Part 1

* Suppose that we have a set $A$ of attributes from a relation $R$
* The closure algorithm returns $X$
* We claim that $X \subset A^+$
  <br><br>
* By induction on the number of steps

---

## Why the Closure Algorithm Works, Part 1

* **Basis:** If there are 0 steps, then $X=A$, so it follows that $A \subset A^+$
<br><br>
* **Induction:**
  * Suppose $B \in X$
  * $B$ was added because of some FD $B_1, B_2, \dots, B_n \rightarrow B$
  * By the inductive hypothesis, all of the $B_i$ are in $X$ and in $A^+$
  * So $R$ satisfies $A \rightarrow B_1, B_2, \dots, B_n$
  * If $R$ has two tuples with the same values of $A$, then they must also have the values of $B_1, B_2, \dots, B_n$
  * And since $R$ satisfies $B_1, B_2, \dots, B_n \rightarrow B$, those two tuples also have the same values of $B$
  * So $A \rightarrow B$ and $B \in A^+$

---

## Why the Closure Algorithm Works, Part 2

* Suppose that we have a set $A$ of attributes from a relation $R$
* The closure algorithm returns $X$
* We claim that $A^+ \subset X$
* Which means that $A = X^+$ (from Part 1)

---

## Why the Closure Algorithm Works, Part 2

* Suppose that $B \not\in X$
* We need to show that $A_1, A_2, \dots, A_n \rightarrow B$ does not hold
* To do this, we create a relation instance for $R$ in which this FD does not hold
* The instance has two tuples
  * $t$: 1's on all attributes in $A^+$, and 0's on all other attributes
  * $s$: 1's on all attributes
* Notice that $t$ and $s$ agree on an attribute $C$ if and only $C \in X$

---

## Why the Closure Algorithm Works, Part 2

* The instance has two tuples
  * $t$: 1's on all attributes in $X$, and 0's on all other attributes
  * $s$: 1's on all attributes
* We claim that this instance satisfies all of the FDs in $S$
  <br><br>
* Consider some FD $C_1, C_2, \dots, C_k \rightarrow D$ in $S$
* If one of the $C_i$ is not among the $C_i$, then we're done
* Otherwise, the algorithm would have added $D$ to $X$ because of this FD
* So we conclude that this case cannot happen
* I.e., the instance satisfies all of the FDs in $S$

---

## Why the Closure Algorithm Works, Part 2

* The instance has two tuples
  * $t$: 1's on all attributes in $X$, and 0's on all other attributes
  * $s$: 1's on all attributes
* We claim that this instance does not satisfy the FD $A_1, A_2, \dots, A_n \rightarrow B$
  <br><br>
* But this is easy
* All the $A_i$ are in $X$, so the tuples $t$ and $s$ agree on those values
* But we know that $B$ is not in $X$, to $t$ and $s$ disagree on $B$
* That means that this instance does not satisfy the FD $A_1, A_2, \dots, A_n \rightarrow B$

---

## Why the Closure Algorithm Works, Part 2

* Suppose we have a table $R$, a subset of the attributes $A$, and some functional dependencies $F$
* If we run the closure algorithm on $A$, we get a result $X$
* For each $B \in X$, we know that $A \rightarrow B$
* And for any $C \not\in X$, we know that $A \nrightarrow B$
  <br><br>
* In other words, $X = A^+$

---

## Example: Transitive Rule

* The **transitive rule** says that if $\mathcal{A} \rightarrow \mathcal{B}$ and $\mathcal{B} \rightarrow \mathcal{C}$,
  then $\mathcal{A} \rightarrow \mathcal{C}$
* Remember that $\mathcal{A}$, $\mathcal{B}$, and $\mathcal{C}$ are all **sets** of attributes
  <br><br>
* It's easy to see that this rule holds using the closure algorithm
* We know that $\mathcal{A}^+$ must include $\mathcal{B}$
* I.e., $\mathcal{B} \subset \mathcal{A}^+$
  <br><br>
* But then, using $\mathcal{B} \rightarrow \mathcal{C}$, we see that $\mathcal{A}^+$ must include $\mathcal{C}$
* I.e., $\mathcal{C} \subset \mathcal{A}^+$
  <br><br>
* So indeed, $\mathcal{A} \rightarrow \mathcal{C}$ holds

---

## All the (Needed) Inference Rules

* We've seen trivial rules and transitivity
* Here is a full set of inference rules
  1. **Reflexivity.** This is just a fancy name for trivial rules
  2. **Augmentation.** If $\mathcal{A} \rightarrow \mathcal{B}$, then $\mathcal{A}, \mathcal{C} \rightarrow \mathcal{B}, \mathcal{C}$
  3. **Transitivity.** $\mathcal{A} \rightarrow \mathcal{B}$ and $\mathcal{B} \rightarrow \mathcal{C}$,
  then $\mathcal{A} \rightarrow \mathcal{C}$

* That's it!
* All valid inference rules for FDs follow from the above!

---

## Minimal Functional Dependencies

* An important application of the inference rules for FDs is the idea of **minimal basis**
  <br><br>
* Suppose $S$ is a set of FDs
* If some other set $S'$ of FDs is equivalent to $S$, we call $S'$ a **basis** for $S$
* We restrict ourselves here to bases that have FDs with only one attribute on the right-hand sides
  <br>

> * A **minimal basis** is a basis $S'$ where
  1. All FDs have singleton right-hand sides
  2. If any FD is removed from $S'$, the result is no longer a basis
  3. If any attribute is removed from the left-hand side of any FD in $S'$, the result is not a basis
* I.e., we need all the FDs, and no FD can be smaller

---

## Functional Dependencies and Projections

* Suppose that $S$ is a set of FDs for relation $R$
  <br><br>
* What are the FDs for $\pi_{\mathcal{B}}(R)$, where $\mathcal{B}$ is some subset of the attributes of $R$?
  <br>

> * We can follow the **projection of functional dependencies** $S'$, which are all the FDs in $S$ such that
  1. they follow from $S$
  2. they involve only attributes in $\mathcal{B}$
  
> * Note that we're talking about FDs that **follow from** $S$
* This is not the same as the FDs in $S$
* Because of this, the algorithm is actually complex (and expensive)

---

## Projection of Functional Dependencies

INPUT: A relation $R$, a set of attributes $\mathcal{B}$, and a set (basis) of FDs $S$ for $R$

OUTPUT: A set (basis) $S'$ of FDs for $\pi_{\mathcal{B}}(R)$

1. $S' = \emptyset$
2. For each $X \subset \mathcal{B}$
   1. Compute $X^+$ using $S$
   2. For each $A \in X^+ \cap \mathcal{B}$
      1. Add $X \rightarrow A$ to $S'$
3. Repeat until no more changes can be made
   1. If there is an FD in $S'$ that follows from the other FDs in $S'$, remove it
   2. If there is an FD $LHS \rightarrow B$ in $S'$ such that after removing an attribute $A$ from $LHS$, the resulting
      FD $LHS - A \rightarrow B$ still follows from $S'$, then replace $LHS \rightarrow B$ with $LHS - A \rightarrow B$
4. Return $S'$

---

## Projection of Functional Dependencies and Pragmatics

* The algorithm is OK if you're a computer
* But it's very expensive, i.e., the loop iterates over **all subsets** of $\mathcal{B}$

> * As a practical matter, we use these observations
  * Don't worry about the empty set or the set $\mathcal{B}$ (but that still leaves $2^n - 2$ subsets)
  * Once we find that $X^+ \rightarrow Y$, there's no point in considering supersets of $X$ for attributes already in $Y$
  * In particular, if $X^+ \rightarrow \mathcal{B}$, then we can ignore all supersets of $X$

---

# Design of Relational Database Schemas

---

## Designing Relational Database Schemas

* Suppose you want to model some real-world situation in a relational database
* Chances are there will be more than one way to do it
  <br><br>
* And some ways **will be better** than others!
  <br><br>
* This is not a matter of opinion
* This is a **technical** matter
* There can be **technical** problems with a database schema
* The problems are called **anomalies**
  <br><br>
* The root of all evil is usually **redundancy**

---

## Anomalies

Title              | Year | Length  | Genre   | StudioName      | StarName
-------------------|------|---------|---------|-----------------|---------------
Star Wars          | 1977 | 124     | scifi   | Fox             | Carrie Fisher
Star Wars          | 1977 | 124     | scifi   | Fox             | Mark Hamill
Star Wars          | 1977 | 124     | scifi   | Fox             | Harrison Ford
Gone With the Wind | 1939 | 231     | drama   | MGM             | Vivien Leigh
Wayne's World      | 1992 | 95      | comedy  | Paramount       | Dana Carvey
Wayne's World      | 1992 | 95      | comedy  | Paramount       | Mike Meyers

<br>

* **Redundancy:** Information is stored in multiple places
* **Update Anomalies:** Information is updated in one place, but not in others
* **Deletion Anomalies:** When some rows are deleted, we unexpectedly lose extra information

---

## Decompositions

* The solution to the anomalies is **decomposition**
* Suppose $R$ is a relation with attributes $\mathcal{A}$
* Let $\mathcal{B}$ and $\mathcal{C}$ be subsets of $\mathcal{A}$ that cover $\mathcal{A}$
  * $\mathcal{B} \subset \mathcal{A}$
  * $\mathcal{C} \subset \mathcal{A}$
  * $\mathcal{B} \cup \mathcal{C} = \mathcal{A}$
* Then $R$ can be decomposed into
  * $R_1 = \pi_{\mathcal{B}}(R)$
  * $R_2 = \pi_{\mathcal{C}}(R)$
  <br><br>
* In general, we may decompose $R$ into $k$ different relations $R_1, R_2, \dots, R_k$

---

## Decompositions

* For example, suppose we have the relation $R(A,B,C)$
  <br><br>
* One possible decomposition is
  * $R_1(A, B)$
  * $R_2(B, C)$
    <br><br>
* Of course, there are many other possible decompositions!

---&twocol

## Decompositions

Title              | Year | Length  | Genre   | StudioName      | StarName
-------------------|------|---------|---------|-----------------|---------------
Star Wars          | 1977 | 124     | scifi   | Fox             | Carrie Fisher
Star Wars          | 1977 | 124     | scifi   | Fox             | Mark Hamill
Star Wars          | 1977 | 124     | scifi   | Fox             | Harrison Ford
Gone With the Wind | 1939 | 231     | drama   | MGM             | Vivien Leigh
Wayne's World      | 1992 | 95      | comedy  | Paramount       | Dana Carvey
Wayne's World      | 1992 | 95      | comedy  | Paramount       | Mike Meyers

<br>

*** =left

Title              | Year | StarName
-------------------|------|---------------
Star Wars          | 1977 | Carrie Fisher
Star Wars          | 1977 | Mark Hamill
Star Wars          | 1977 | Harrison Ford
Gone With the Wind | 1939 | Vivien Leigh
Wayne's World      | 1992 | Dana Carvey
Wayne's World      | 1992 | Mike Meyers

*** =right

Title              | Year | Length  | Genre   | StudioName 
-------------------|------|---------|---------|------------
Star Wars          | 1977 | 124     | scifi   | Fox        
Gone With the Wind | 1939 | 231     | drama   | MGM        
Wayne's World      | 1992 | 95      | comedy  | Paramount  

---

## Boyce-Codd Normal Form

* **Boyce-Codd Normal Form** (BCNF) is a condition that can tell us when a schema does not suffer from anomalies
  <br><br>
* A relation $R$ is in BCNF if
  * for each nontrivial FD $X \rightarrow A$, the left-hand side $X$ is a superkey for $R$
  <br><br>
* That is, the left-hand side of every FD must contain a key
  <br><br>

> * If there are more than one key, the requirement is for the FD to contain **one of them**
* It is not necessary for the FD to contain all keys

---

## Boyce-Codd Normal Form

Title              | Year | Length  | Genre   | StudioName      | StarName
-------------------|------|---------|---------|-----------------|---------------
Star Wars          | 1977 | 124     | scifi   | Fox             | Carrie Fisher
Star Wars          | 1977 | 124     | scifi   | Fox             | Mark Hamill
Star Wars          | 1977 | 124     | scifi   | Fox             | Harrison Ford
Gone With the Wind | 1939 | 231     | drama   | MGM             | Vivien Leigh
Wayne's World      | 1992 | 95      | comedy  | Paramount       | Dana Carvey
Wayne's World      | 1992 | 95      | comedy  | Paramount       | Mike Meyers

<br>

* Not in BCNF
* The key is title, year, starName
* But there is an FD title, year $\rightarrow$ Length
  <br><br>
* Notice that to tell if $R$ is in BCNF, you must be able to find the keys for $R$ first

---

## Boyce-Codd Normal Form

Title              | Year | Length  | Genre   | StudioName 
-------------------|------|---------|---------|------------
Star Wars          | 1977 | 124     | scifi   | Fox        
Gone With the Wind | 1939 | 231     | drama   | MGM        
Wayne's World      | 1992 | 95      | comedy  | Paramount  

<br>

* This is in BCNF
* The key is title, year
* The only real nontrivial FD is title, year $\rightarrow$ length, genre, studioName
  <br><br>
* All other FDs must include title, year in the left-hand side
* So all FDs include a key in the left-hand-side

---

## Boyce-Codd Normal Form

Title              | Year | StarName
-------------------|------|---------------
Star Wars          | 1977 | Carrie Fisher
Star Wars          | 1977 | Mark Hamill
Star Wars          | 1977 | Harrison Ford
Gone With the Wind | 1939 | Vivien Leigh
Wayne's World      | 1992 | Dana Carvey
Wayne's World      | 1992 | Mike Meyers


<br>

* Again, this is in BCNF
* The key is title, year
* The only real nontrivial FD is title, year $\rightarrow$ starName

