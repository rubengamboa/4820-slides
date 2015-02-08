title:        COSC 4820 Database Systems
subtitle:     High-Level Database Models
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

* The focus of this chapter is on **modeling the real world using database schemas**
* So we have a specific real-world situation
* The goal is to find a schema that can be used to describe this situation
  <br><br>
* Remember, all we have to work with is tables!
* That's bad, because the real world is much more complex than a bunch of tables
  <br><br>
* In practice, we use higher-level data models
* The reason is that we want to have more flexibility during modeling
* So we want more powerful languages to describe the real world, but still be able to
  convert designs into a relational schema
* Among the choices are **Entity-Relationship (E/R) Diagrams**, the **Unified Modeling
  Language (UML)**,  and the **Object Description Language (ODL)**

---

# Entity/Relationship Model

---

## The Entity/Relationship Model

* The **Entity/Relationship (E/R) Model** is the classic high-level database design tool
* The model is represented using an **E/R Diagram**
  <br><br>
* There are three different concepts in E/R Diagrams
  1. Entity (sets)
  2. Attributes
  3. Relationships

---

## Entity Sets

* An **entity** is an abstract object
* Generally, this will correspond to a concrete object in the real world, e.g., a contract,
  a person, a car
  <br><br>
* An **entity set** is a collection of similar entities, e.g., all UW contracts, 
  all persons working at UW, etc.
  <br><br>
* There is a very clear analogy between
  * entity sets and classes
  * entities and objects
* You can get far using your intuition from object-oriented programming here
* The only difference is that entities have data, but no methods
* Go ahead, think of them as C structs!

---

## Attributes

* Entity sets have **attributes**, which are the properties of the entities in that entity set
* All entities in an entity set have the same attributes
* That's what we mean by "similar entities" in an entity set
  <br><br>
* Of course, attributes of entity sets are just like attributes of relations
* This is one place where it's easier to think of the tables than the entity sets, because we
  can think in terms of rows and columns
  <br><br>
* Note that entities have values for the attributes in their entity set
* The values are of a given type or domain
* We will only consider scalar types (e.g., integer, string, date)

---

## Relationships

* **Relationships** are connections among two or more entity sets
* A relationship could also be a connection between an entity set and itself
  <br><br>
* For example, we have the entity sets
  * `Movies`
  * `MovieStars`
* A relationship between them could be called `StarsIn`

---

## E/R Diagrams

* An **E/R Diagram** is a graph that shows entity sets, attributes and relationships
  * Entity sets are represented by **rectangles**
  * Attributes are **ovals**
  * Relationships are **diamonds**
  <br><br>
* Edges connect
  * Entity sets and their attributes
  * Relationships and the entity sets involved in them

> * Note in particular
    * There is **never** an edge between two entity sets
    * There is **never** an edge between two relationships
    * There is **never** an edge between two attributes

---

## E/R Diagram for Movies Schema

<div class="centered">
    <img src="assets/img/erd-movies.png" title="E/R Diagram for Movies Schema" alt="E/R Diagram for Movies Schema">
</div>

---

## Multiplicity of Relationships

* Suppose we have a relationship between entity sets
* How many entities on each entity set can be involved in a single instance of the relationship?
  <br><br>
* E.g., suppose we have a relationship between `Advisors` and `Students`
  * An advisor may have many students they advise
  * A student should have only one advisor
  <br><br>
* Or suppose we have a relationship between `Students` and `Courses`
  * A student may be taking many courses 
  * And a course may (should?) have many students
  <br><br>
* Or suppose we have a relationship between `Universities` and `Presidents`
  * A university can have at most one president
  * And a president can work in only one university

---

## Multiplicity of Relationships

* These cases lead to the following notation
* Suppose $R$ is a relationship between entity sets $E$ and $F$
  * If each entity in $E$ can be connected to at most one member of $F$, we say
    $R$ is **many-to-one** from $E$ to $F$
  * Likewise, if each entity in $F$ can be connected to at most one member of $E$,
    we say that $R$ is **many-to-one** from $F$ to $E$
  * If $R$ is many-to-one from $E$ to $F$ and from $F$ to $E$, we call it **one-to-one**
  * If none of these hold, we say $R$ is **many-to-many**
* This possibilities describe the possible **multiplicity** of entities in a relationship

---

## Multiplicity of Relationships

* Arrows are used in the E-R diagram to indicate multiplicity in relationships
* The arrow always goes **from** the relationship **to** an entity set
* The arrow indicates that that entity set is on the **one** side of the relationship
* But the arrow means **at most one**
* There is no guarantee that there is actually one right now (e.g., a university may
  (temporarily) not have a president)

---

## Multiplicity of Relationships

<div class="centered">
    <img src="assets/img/erd-movies.png" title="Many-to-One Relationship" alt="Many-to-One Relationship">
    <br>
    <br>
    <img src="assets/img/erd-one-to-one.png" title="One-to-One Relationship" alt="One-to-One Relationship">
</div>

---

## Ternary (and Higher) Relationships

* Occasionally, we will want to model a relationship among three (or more) entity sets
  * Law firms organize their records (and billing) under **Attorney-Client-Matter**a
  * A studio may hire an actor to appear in a movie, resulting in **Studio-MovieStar-Movie**

---

## E/R Diagram for Ternary (and Higher) Relationships

<div class="centered">
    <img src="assets/img/erd-ternary.png" title="Ternary Relationship" alt="Ternary Relationship">
</div>

* Note the meaning of the arrow into `Studios`
* If you know the `Movie` and the `MovieStar`, then only one `Studio` can be associated with them
* But a different `Studio` may have a contract with the same `MovieStar` but in a different `Movie`

---

## Unary Relationships and Roles

* It is fairly common to have relationships between an entity set **and itself**
* For example, movies have sequels
* Or students can be advisors of other students
* Or a person have be a spouse of another person
  <br><br>
* Usually, the relationship is **asymmetric**
  * E.g., *Empire Strikes Back* is a sequel of *Star Wars*
  * But *Star Wars* is **not*** a sequel of *Empire Strikes Back*
  <br><br>
* So when we draw the E/R diagram, we have to label each edge, to show the **role** of the given participant
  * E.g., the role may be *sequel* and *original*
  * Or *advisor* and *advisee*

---

## Unary Relationships and Roles

<div class="centered">
    <img src="assets/img/erd-roles.png" title="Relationship Roles" alt="Relationship Roles">
    <br><br>
    <img src="assets/img/erd-roles-2.png" title="Relationship Roles" alt="Relationship Roles">
</div>

---

## Converting Ternary (and Higher) Relationships to Binary Relationships

* Although the E/R model supports ternary (and higher) relationships, it is sometimes useful to convert such relationships
  to binary relationships only
* Partly, this is because binary relationships are simpler
* It's also because some other notations only allow binary relationships
  <br><br>
* Luckily, it's easy to do the conversion
* Suppose $R$ is a relationship among $E$, $F$, and $G$
* Create a new entity set $R_E$
* Connect $R_E$ with the entity sets $E$, $F$, and $G$
* Each of those connections is binary
* And each entity in $R_E$ corresponds to a relationship in $R$

---

## Converting Ternary (and Higher) Relationships to Binary Relationships

<div class="centered">
    <img src="assets/img/erd-roles-2.png" title="Relationship Roles" alt="Relationship Roles">
    <img src="assets/img/erd-ternary-to-binary.png" title="Converting Ternary to Binary Relationships" 
         alt="Converting Ternary to Binary Relationships">
</div>

---

## Attributes on Relationships

* Although it may appear unnatural at first, it is very common to have attributes on relationships, not just entity sets
* Examples:
  * The `WorksIn` relationship may have an associated `Salary` attribute
  * The `ProjectMember` relationship may have `PctEffort`
  * The `RecipeIngredient` relationship may have `Amount`
  <br><br>
* These are indicated the same way as attributes on entity sets
* I.e., there is an edge between the attribute and the relationship

---

## Attributes on Relationships

<div class="centered">
    <img src="assets/img/erd-relationship-attribute.png" title="Relationship Attributes" alt="Relationship Attributes">
</div>

* Note: You can always avoid relationship attributes by adding extra entity sets
* But this is seldom necessary (or wise)

---

## Subclasses in the E/R Model

* It is extremely common for an entity set to be just like another entity set, but with some more attributes
* For example, in the university, there may be entity sets for `Students` and `Faculty`
* Both entity sets will have name, address, phone number, etc.
* **In addition**, 
  * Students may have a major, degree program, etc.
  * Faculty may have salary, highest degree earned, etc.
  <br><br>
* It's natural to represent this using subclasses
* The attributes in common are placed in `Person`
* Then the entity sets `Students` and `Faculty` **extend** `Person`, adding their own attributes
  <br><br>
* In the E/R diagram, this is signified by a special type of relationship that is a **triangle** instead of a diamond

---

## Subclasses in the E/R as Opposed to the Object-Oriented Model

* There is a major difference between subclasses in the E/R and OO models
  <br><br>
* Suppose $A$ is a superclass, and $A_1$, $A_2$, and $A_3$ are subclasses
* You have to make two decisions
  * **Coverage:** Does every $A$ have to be one of $A_1$, $A_2$, or $A_3$?
  * **Exclusivity:** Can an $A_1$ also be an $A_2$ or an $A_3$?
  <br><br>
* In OOP, we can actually do this
  * **Coverage:** If $A$ is abstract, then yes -- otherwise, no
  * **Exclusivity:** Typically not, but in C++, yes (by further subclassing)
  * Oh, and Java (and modern OO languages) uses interfaces to get around **exclusivity**

---

## Subclasses in the E/R Model

* In databases, the assumptions are that
  * **Coverage:** No, an $A$ does not have to be one of the $A_i$
  * **Exclusivity:** No, an entity can be an $A$, an $A_i$ and an $A_j$ all at the same time

---

## Subclasses in the E/R Model

<div class="centered">
    <img src="assets/img/erd-subclasses.png" title="E/R Subclasses" alt="E/R Subclasses">
</div>

* Note that a movie may be something other than a cartoon or a murder-mystery
* Also, a movie may be **both** a cartoon and a murder-mystery!

---

# Design Principles

---

## Design Principles

* Now we'll turn our attention to **design principles**
* E/R diagrams are a tool to describe different designs
  <br><br>
* The same real-world situation may be modeled in radically different E/R diagrams
* The important question is, **how can we compare different designs?**
* In other words, **what makes one design better than another?**
  <br><br>
* We'll (try to) answer these questions by identifying important design principles


