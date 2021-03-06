---

title:        COSC 4820 Database Systems
subtitle:     The Query Optimizer
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

## The Query Optimizer

* There are two main issues in query optimization:
  * What **plans** do we consider for a given query?
  * What is the **cost (estimate)** of a given plan?

<br/>

* Basic approach: **generate** many plans and **select** the one with the cheapest (estimated) cost
  * Ideally: find the best plan
  * Reality: Avoid the worst plans!

* This basic approach goes all the way back to **System R**

---

## Query Plans
    
* Relational algebra is central to query evaluation!
  * Note: We're talking about **extended relational algebra**, with extra operators for the things SQL does that basic relational algebra doesn't

<br/>

* Query Plan: 
  * Tree of relational algebra operations
  * A choice of algorithm for each op

---

## Cursor Interface

* Each node in the relational algebra expression tree implements the **cursor interface**
* This is very similar to the **iterator interface** in OO programming
* It is also described as the **pull interface**
  * An **operator is pulled** for the next output tuple(s)
  * An **operator pulls on its inputs** and computes the new outputs

<br/>

* E.g., consider operator **A + B**
  * Suppose it's pulled for the next output
  * Then it pulls on A
  * And pulls on B
  * Then returns A+B

---

## Basic Optimization Tricks

    
* We use these solutions over and over:

1. **Indexing:**
   * Helps selections and joins to retrieve small sets of tuples
2. **Iteration:**
   * It may be faster to scan all tuples, even if there is an index
   * We can scan either the index file or the actual data file
3. **Partitioning:**
   * Split input tuples using either sorting or hashing
   * Replace an expensive operation with similar operations on smaller data

<br/>

* We will see these solutions crop up as we discuss query evaluation

---

## Statistics and the Data Catalog

* The optimizer needs information about the relations and indexes to estimate the cost of different query plans

* The **data catalog** typically contains this information:        
* **For each relation:**
  * #tuples
  * #pages
* **For each index:**
  * #pages
  * #distinct key values
  * tree height
  * low/high key values

---

## Statistics and the Data Catalog

* In some cases, it is useful to store more detailed information
* E.g., histograms (#tuples per distinct value) for some attributes

---

## Data Catalog Maintenance
    
* Catalogs are expensive to maintain!
* Information changes on every insert/delete/update

<br/>

 * Usually, this is done periodically in the background

<br/>

* Under normal circumstances, slightly outdated catalog information is OK
* Optimization is only doing an approximation, anyway

<br/>

* The DBA can initiate a catalog refresh, if she thinks the catalog is 
  way out of date (e.g., after a bulk import of data)

---

## Access Paths

* An **access path** is a method of retrieving tuples
* E.g., data file scan, or using an index

<br/>

* An index can only be used if it **matches** the selection in a query
* Basically, an **index matches a selection** if the index can be used 
  to find the appropriate tuples

---

## Matching Tree Indexes

* A **tree index matches a term** (part of a query) if the term
 involves only attributes in a **prefix** of the search key

<br/>

* For example, suppose we have a tree index on $\langle a, b, c \rangle$
* This index matches the queries
  * a=5 AND b=3 AND C=10
  * a=5 AND b=3
  * a=5 AND b$>$3

* But the index does **not** match this query
  * b=3

---

## Matching Hash Indexes
    
* A **hash index matches a term** (part of a query) if the term
  is a **conjunction** (AND) of **equalities** on 
  **each of the attributes** in the search key

<br/>

* For example, suppose we have a hash index on $\langle a, b, c \rangle$
* This index matches the queries
  * a=5 AND b=3 AND C=10
* But the index does **not** match this query
  * a=5 AND b=3
  * a=5 AND b$>$3
  * b=3

---

## Approach to Optimizing Selections

* We are almost ready to tackle optimization of selections in a query
* But first we're going to impose an important simplification

<br/>

* We will **ignore disjunctions** (ORs) in selections
* In practice, queries are converted to DNF form (ORs of ANDs)
  * Each separate term in DNF is a conjunction (involves only ANDs)
  * So optimize each term separately
  * Take the union of the results

<br/> 

* This can be improved (dramatically) by merging terms in the DNF
* Reality: most optimizers do not handle ORs very well!

---

## Approach to Selections
    
* Find the **most selective access path**
* Selective: retrieve fewest number of tuples up front (using an index)
* Apply any remaining conditions to the tuples returned

<br/>

* In other words, pick most selective index, and filter remaining tuples

<br/>

* Yeah, that's the big reveal
* Now, onto the details

---

## Approach to Selections
    
* What is the **most selective access path**?

<br/>

* Answer: An index or file scan that (we estimate) will require the fewest page I/O operations

<br/>

* The remaining terms on the condition are applied to the tuples read with the most selective access path
* But the remaining terms do not affect the \#tuples or \#pages fetched
* So the cost of the other terms is *zero* (since we only count I/O)

---

## Example
    
* Consider this condition:
```
date < 5/1/17 AND voter_id=5 AND precinct_id=3
```
* Here are two different query plans:
  * Use a B+ tree on the date field, then filter the remaining tuples using
                the condition voter_id=5 AND precinct_id=3

  * Use a hash index on voter_id and precint_id and then check each tuple
    to see if it matches day<5/1/17

<br/>
    
* **Main Question:** Which is better?  How do we even think about answering this question?

---

## Implementing Selections


* Cost of using an index for selection depends on
  * #matching tuples
  * clustering

<br/>

* **Cost of finding** matching tuples is usually small
* **Cost of retrieving** matching tuples is 
  * small for clustered index
  * large for unclustered index (linear in #matches)
  * totally impractical for unclustered index when many tuples match

---

## Cost Example

```
SELECT *
  FROM MovieStars
 WHERE name < 'C'
```

* "Benign" assumptions:
* Uniform distribution of names
* I.e., about 10% (2/26) of tuples qualify
* 40,000 tuples in 500 pages (80 per page)

<br/>

* Note: Catalog knows min and max of names, so it can compute the percentage
  using the uniformity assumption
* Note: But if uniformity assumption isn't realistic, keep histograms instead!

---

## Cost Example

```
SELECT *
  FROM MovieStars
 WHERE name < 'C'
```

* I.e., about 10% (2/26) of tuples qualify
* 40,000 tuples in 500 pages (80 per page)

<br/>

* Cost estimates:
  * **Clustered index:** a little more than 50 I/Os (e.g., 3+50)
  * **Unclustered index:** a little more than 4,000 I/Os (e.g., 3+4,000)

---

## Implementing Projections

```
SELECT DISTINCT name, title
  FROM StarsIn
```    

* The only expensive part of projection is removing duplicates
* That's why databases do not remove duplicates unless DISTINCT is specified in the query

<br/>

* To remove duplicates, you can use either **sorting** or **hashing**
* In some cases, you can use an index to remove duplicates
* We're assuming here that the answer set is large
* If all answers fit in memory, then removing duplicates is **free**

---

## Removing Duplicates with Sorting

```
SELECT DISTINCT name, title
  FROM StarsIn
```
    
* Sort on *name* and *title*
* Remove duplicate rows (which are now next to each other)

<br/>

* Since tuples do not fit in memory, you must use an efficient disk-based sorting algorithm!
* Typically, this is merge sort

<br/>

* Sort can be optimized by dropping unwanted columns before the sort, so the file is smaller

---

## Removing Duplicates with Hashing


```
SELECT DISTINCT name, title
  FROM StarsIn
```

* Hash on *name* and *title* to create partitions
* Load each partition into memory, one at a time
* Remove duplicates for each partition in memory (using any in-memory algorithm to find duplicates, e.g., sorting, hashing, trees, etc.)

<br/>

* Key assumption: Hashing results in **small partitions**
* If this assumption isn't true, hashing may not be appropriate

---

## Removing Duplicates with an Index

```
SELECT DISTINCT name, title
  FROM StarsIn
```

* Suppose there's an index on *name* and *title*
* We can use it to remove duplicates

<br/>

* Why? If the index is clustered, the data file is already sorted
* Even if the index in unclustered, the index file is sorted!

* **Important point:** Do we even need the data file in this case?

* **Another point:** What if the index is UNIQUE?

---

## Removing Duplicates with an Index

```
SELECT DISTINCT name, title
  FROM StarsIn
```

* Suppose there's an index on *name*
* The index has fewer columns than the selection

<br/>

* We can still use it!
* It may make it less expensive to sort the data
* Even if the order is different

---

## Removing Duplicates with an Index

```
SELECT DISTINCT name, title
  FROM StarsIn
```

* Suppose there's an index on *name*, *title*, and *year*
* The index has more columns than the selection

<br/>

* We can still use it!
* Just ignore the extra column as we scan the index

<br/>

* Note: Just because we can use it does not mean we should
* It's just another option for the optimizer to consider


---

## Implementing Joins: Nested Loop Joins

$$R(x,y) \bowtie S(y,z)$$

```
foreach tuple r in R do:
    foreach tuple s in S where r.y=s.y do:
        add <r,s> to result
```

* If there is an index on the join column of one relation (i.e., on column y of relation S), 
  make it the inner relation to exploit the index:
* Cost: #Pages(R) + #Tuples(R)*(IndexLookup(S)+Lookup(S))
* Cost assumptions: 
  * R: 100,000 tuples in 100 pages (1,000 per page)
  * S: 40,000 tuples in 500 pages (80 per page)
  * index cost is 1.2 (hash) or 2-3 (tree)
  * read matching tuple of S is 1

---

## Implementing Joins: Nested Loop Joins

$$R(x,y) \bowtie S(y,z)$$

```
foreach tuple r in R do:
    foreach tuple s in S where r.y=s.y do:
        add <r,s> to result
```

* Hash index, column y of table S
* Scan R: 1,000 pages
* For each (100,000) R tuple:
  * 1.2 to read from the hash index on S.y (on average)
  * 1 to get corresponding tuple from S
* Total cost: 221,000

---

## Implementing Joins: Nested Loop Joins

$$R(x,y) \bowtie S(y,z)$$

```
foreach tuple s in S do:
    foreach tuple r in R where r.y=s.y do:
        add <r,s> to result
```

* Hash index, column y of table R
* Scan S: 500 pages
* For each (40,000) S tuple:
  * 1.2 to read from the hash index (on average)
  * 2.5 movies per star on average (100,000/40,000)
  * Cost to fetch movies is 1 (for clustered) or 2.5 (unclustered)
* Total cost: 88,500 (clustered) or 148,500 (unclustered)

---

## Implementing Joins: Sort-Merge Joins

$$R(x,y) \bowtie S(y,z)$$
    
* Basic Idea: Sort both $R(x,y)$ and $S(y,z)$ on $y$
  * Note: It's possible that $R$ or $S$ is already sorted on $y$
* Then read the sorted versions of $R$ and $S$ as in merge sort
* The merge implements the join

<br/>

* Some $y$ values will be in both $R$ and $S$, e.g., $y_1$, $y_2$, ..., $y_n$
* For each $y_i$, let $X_i\equiv\{x \mid \langle x, y_i \rangle \in R\}$ and $Z_i\equiv\{z \mid \langle y_i,z \rangle \in S\}$
* The answer is the cross product $X_i \times \{y_i\} \times Z_i$
* We can implement that cross product by scanning $R$ only once, but 
  possibly scanning each $Z_i$ once per tuple in $X_i$
* Hopefully,all or most of the pages of $Z_i$ remain in memory, so we can do a single scan of $S$ as well

---

## Cost of Sort-Merge Joins

* Cost: Sort(R) + Sort(S) + #Pages(R) + #Pages(S)
  * #Pages(R) + #Pages(S) is the likely (and best possible) cost of the merge operation
  * But the merge could cost as high as #Pages(R) * #Pages(S)
  * This depends entirely on the characteristics of the data
  * Worst case: There is only one distinct $y$, so $R \bowtie S \approx R \times S$

* Cost of sorting depends on how much data we can load into memory
* External sorts require a number of passes
* For these tables, 2 passes should be enough
* Each pass reads and writes data, so the total cost is
* Cost: $2\cdot2\cdot1,000 + 2\cdot2\cdot500 + 1,000 + 500 = 7,500$ I/O operations

---

## Index Join or Sort-Merge Join?

Join Type       | Cost
----------------|---------
Index Join      | 221,000 I/O ops
Sort-Merge Join | 7,500 I/O ops

* Easy call, right?

<br/>

* Not so fast!
* Suppose the join appears in the query $\sigma(R \bowtie S)$
* And suppose the selection filters the movies for a specific movie star or even a few stars
* Index join could be orders of magnitude faster than sort-merge join!
  * Sort-merge still has to scan all records, while index join may fetch only the necessary records

<br/>

* Moral of the story: **Optimization must be global**

---

# System R Optimizer

---

## System R Optimizer

* System R project developed the first query optimizer
* It is still the most widely used approach today

<br/>

* Works really well for queries with at most 10 joins

<br/>

* **Cost estimations:**
  * Statistics (in system catalog) used to estimate **cost of operations** and **result sizes**
  * Cost considers a combination of CPU and I/O costs

---

## System R Optimizer: Query Plans

* **Query plan space:**

  * It's too big
  * I.e., there are too many (exponential) possible query plans, so there is not enough time to consider them all

<br/>

* **Solution:** consider only **left-deep** plans
  * The tree looks more like a linked list!
  * This allows output of each operator to be **pipelined** into the next operator 
    without storing results in temporary tables
  * This depends on the cursor interface

---

## System R Optimizer: Cost Estimator

* Optimizer must estimate cost of each plan considered

<br/>
* Estimate cost of each operation in query plan
  * We've already discussed how to estimate the cost of operations
    (sequential scan, index scan, joins, etc.)
  * This depends on the size of the inputs

* Must also estimate size of result for each operation in tree!
  * Use information about the input relations
  * Make "reasonable" assumptions
  * Assumption: uniformity of data
  * Assumption: independence of conditions in selections and joins

* Quality of optimizer is empirical: Does it find good query plans for typical queries?

---

## Size Estimator

```
SELECT attributes
  FROM relations
 WHERE cond1 AND cond2 AND ... AND condk
```

*  Maximum #tuples in result is the cardinality of the cross product of relations in the FROM clause
*  I.e., worst case is always the cross product

<br/>

*  **Reduction factor (RF)** associated with each condition reflects the impact of the condition in reducing the result size
*  Cardinality of result = Max #tuples * RF1 * RF2 * ... * RFk

*  Assumes conditions are independent

---

## Reduction Factors

* The secret to having good size estimators is to know the reduction factors of different types of conditions
    
Condition        | Reduction Factor
-----------------|-----------------
col = value      | $1 / NKeys(I)$, for some index $I$ on col
col1 = col2      | $1 / \max(NKeys(I_1),NKeys(I_2))$, for indexes $I_1$ and $I_2$ on col1 and col2
col1 > value     | $\frac{High(I)-value}{High(I)-Low(I)}$, for some index $I$ on col

---

## Examples: Sample Schema

```
StarsIn (name, title, year)
MovieStar (name, address, genre, birthdate, rating)
```
* Similar to old schema, but with *rating* added to MovieStar

* StarsIn
  * Each tuple is 40 bytes long, 1,000 tuples per page, 1,000 pages

* MovieStar
  * Each tuple is 500 bytes long, 80 tuples per page, 500 pages

---&twocol

## Motivating Example

```
SELECT MS.name
  FROM StarsIn AS SI, MovieStars AS MS
 WHERE SI.name = MS.name AND SI.title='Star Wars' AND MS.rating>=4
```

*** =left

<div class="centered">
    <img src="assets/img/query-plan-1-new.png" title="Query Plan #1" alt="Query Plan #1">
</div>

*** =right

* Cost: 500 + 500*1,000 I/Os 
* Scan MovieStars, then Scan StarsIn for each MovieStar block
* Actually not the worst plan!
* Can be improved considerably, e.g., by using indexes
* Goal is to find more efficient plan that computes the same answer

---&twocol

## Alternative Plan #1

```
SELECT MS.name
  FROM StarsIn AS SI, MovieStars AS MS
 WHERE SI.name = MS.name AND SI.title='Star Wars' AND MS.rating>=4
```

*** =left

<div class="centered">
    <img src="assets/img/query-plan-2-new.png" title="Alternative Query Plan #1" alt="Alternative Query Plan #1">
</div>

*** =right

* Main difference: push selects
* With 5 buffers, cost of plan:
  * Scan StarsIn (1,000) + write T1 (1 page, assuming < 1,000 matches)
  * Scan MovieStars (500) + write T2 (200 pages, if ratings are 1-5)
  * Sort T1 (2), sort T2(2*3*200), merge (1+200)
  * Total: 1,701 (selections) + 1,403 (join) = 3,104 page I/Os

---&twocol

## Alternative Plan #1

```
SELECT MS.name
  FROM StarsIn AS SI, MovieStars AS MS
 WHERE SI.name = MS.name AND SI.title='Star Wars' AND MS.rating>=4
```

*** =left

<div class="centered">
    <img src="assets/img/query-plan-2b-new.png" title="Alternative Query Plan #1" alt="Alternative Query Plan #1">
</div>

*** =right

* Using BNL join, join cost = 1+1*200
* Total: 1,701 (selections) + 201 (join) = 1,902 page I/Os
* If we push projections, T2 has only name and title
* That lowers the #pages requires (albeit slightly)

---&twocol

## Alternative Plan #2

```
SELECT MS.name
  FROM StarsIn AS SI, MovieStars AS MS
 WHERE SI.name = MS.name AND SI.title='Star Wars' AND MS.rating>=4
```

*** =left

<div class="centered">
    <img src="assets/img/query-plan-3-new.png" title="Alternative Query Plan #2" alt="Alternative Query Plan #2">
</div>

*** =right

* Suppose we have a clustered index on title of StarsIn
* We get 1,000,000/40,000 = 25 StarsIn tuples for each MovieStar tuple
* INL join, Filter, and Project are all pipelined, so there's no benefit to pushing the projection in
* Pushing the selection rating >= 4 into the join would make it worse, 
  because we can't use index on MovieStars

---&twocol

## Alternative Plan #2

```
SELECT MS.name
  FROM StarsIn AS SI, MovieStars AS MS
 WHERE SI.name = MS.name AND SI.title='Star Wars' AND MS.rating>=4
```

*** =left

<div class="centered">
    <img src="assets/img/query-plan-3-new.png" title="Alternative Query Plan #2" alt="Alternative Query Plan #2">
</div>

*** =right

* Cost:
  * Selection of StarsIn: 2.2 I/O ops
  * For each movie, must get matching MovieStar tuple (10*1.2)
  * Question: How many different movies in StarsIn, and how does that translate to MovieStar? 
* Total cost: 15 I/O operations

---

## Summary

```
SELECT MS.name
  FROM StarsIn AS SI, MovieStars AS MS
 WHERE SI.name = MS.name AND SI.title='Star Wars' AND MS.rating>=4
```

Method                                  | Cost
----------------------------------------|----------------
Nested loop                             | 500,500
Push selections                         | 3,104
Push selections, BNL join               | 1,902
Push selections & projections, BNL join | ~1,700
Clustered index on StarsIn              | 15

---

## Extended Example

* Consider this query (inspired by a previous course project):

```
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

* What is the best way to execute it?

---

## Extended Example

```
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

* First, find all **courses** with subject=COSC
* Then, use that to find all the **enrolled** records for COSC courses
* Finally, look up the **students** enrolled in those courses

<br/>

* That's my buest guess, but let's ask the database to **EXPLAIN** its plan

---

## Extended Example

```
EXPLAIN
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

id | select_type | table    | type   | possible_keys   | key     | key_len | ref              | rows  | Extra      
---|-------------|----------|--------|-----------------|---------|---------|------------------|-------|------------
 1 | SIMPLE      | students | index  | PRIMARY         | PRIMARY | 12      |                  | 10473 | Using index
 1 | SIMPLE      | enrolled | ref    | PRIMARY,wnumber | wnumber | 12      | students.wnumber |     2 | Using index
 1 | SIMPLE      | courses  | eq_ref | PRIMARY         | PRIMARY | 7       | enrolled.crn     |     1 | Using where

* Note that the only tables we actually read is **courses** and **enrolled**
* We only read the index for **students**

---

## Extended Example

```
EXPLAIN
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

* Why aren't we following the "obvious" efficient plan?

<br/>

* Problem: possible_keys for **courses** does not include **subject**
* So our imagined "optimal" query plan is no good

---

## Extended Example

```
EXPLAIN
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

```
CREATE INDEX courses_subject_idx 
 USING HASH 
    ON courses (subject)
```

---

## Extended Example

```
EXPLAIN
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

id | select_type | table    | type   | possible_keys               | key                 | key_len | ref                    | rows | Extra       
---|-------------|----------|--------|-----------------------------|---------------------|---------|------------------------|----|-------------
 1 | SIMPLE      | courses  | ref    | PRIMARY,<br/>courses_subject_idx | courses_subject_idx | 7       | const                  | 58 | Using where 
 1 | SIMPLE      | enrolled | ref    | PRIMARY,wnumber             | PRIMARY             | 7       | courses.crn      |  9 | Using index 
 1 | SIMPLE      | students | eq_ref | PRIMARY                     | PRIMARY             | 12      | enrolled.wnumber |  1 | Using index 

---

## Extended Example

```
EXPLAIN
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

* **Enrolled** has a PRIMARY index (on crn & wnumber), and a SECONDARY index on wnumber
* But no indexes on crn
* Would that help?

```
CREATE INDEX enrolled_crn_idx 
 USING HASH 
    ON enrolled (crn)
```

---

## Extended Example

```
EXPLAIN
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

id | select_type | table    | type   | possible_keys               | key                 | key_len | ref                    | rows | Extra       
---|-------------|----------|--------|-----------------------------|---------------------|---------|------------------------|----|-------------
 1 | SIMPLE      | courses  | ref    | PRIMARY,<br/>courses_subject_idx | courses_subject_idx | 7       | const                  | 58 | Using where 
 1 | SIMPLE      | enrolled | ref    | PRIMARY,wnumber,<br/>enrolled_crn_idx | enrolled_crn_idx             | 7       | courses.crn      |  6 | Using index 
 1 | SIMPLE      | students | eq_ref | PRIMARY                     | PRIMARY             | 12      | enrolled.wnumber |  1 | Using index 

* BTW, the only table actually read is **courses**

---

## Extended Example

```
SELECT count(distinct courses.crn), sum(courses.credits)
  FROM enrolled, students, courses
 WHERE enrolled.wnumber = students.wnumber
   AND enrolled.crn = courses.crn
   AND courses.subject = 'COSC'
```

Index                             | Cost
----------------------------------|-----------
S(w#), E(crn,_wnumber_)           | 20,946
C(subj), E(crn,_wnumber_), S(w#)  | 522
C(subj), E(crn), S(w#)            | 348

---

## Summary

* The are several alternative evaluation algorithms for each relational operator
* A query is evaluated by converting to a tree of operators and evaluating the operators in the tree
* You must understand query optimization in order to fully understand the performance impact of a 
  given database design (relations, indexes) on a workload (set of queries)

---

## Summary

* To optimize a query:

<br/>

* Consider a set of alternative plans
  * Must prune search space
  * Typically: only consider left-deep plans
* Estimate cost of each considered plan
  * Must estimate size of result and cost for each plan node
  * Key issues: Statistics, indexes, operator implementations
