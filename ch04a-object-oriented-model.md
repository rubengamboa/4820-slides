title:        COSC 4820 Database Systems
subtitle:     "High-Level Database Models: Object-Oriented Model"
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

# Unified Modeling Language

---

## Unified Modeling Language

* **Unified Modeling Language (UML)** is a graphical language designed to describe object-oriented designs
* Since there is a close correspondence between classes/entity sets and objects/entities, it's natural to
  use UML to describe database designs as well

---

## UML Classes

* A class consists of
  1. a name
  2. one or more attributes (with keys identified by **PK**)
  3. methods (but not for entity sets)

<p class="centered">
    <img src="assets/img/uml-classes.png" alt="UML Classes" title="UML Classes" class="img-responsive">
</p>

---

## UML Associations

* A associations is an **edge** linking two classes
* The edges can have names
* They can also specify cardinalities for the endpoints

<p class="centered">
    <img src="assets/img/uml-associations.png" alt="UML Associations" title="UML Associations" class="img-responsive">
</p>

---

## Arrowheads in UML Associations

* **Important:** UML associations can have arrowheads, but they **do not mean cardinality**
* Arrowheads in UML denote **navigation**, i.e., you can get from an instance of one class to the related instances in the other
* Navigability is not a notion in relational databases
* So we won't be using them

---

## Cardinality in UML Associations

* Cardinalities are listed at the endpoints, and read like this:
  1. Suppose we have a relationship between A and B
  2. The cardinality on end B is 1..1
  3. We read "Each A has one B"
* E.g., below, you should read
  * Each Movie has **one** Studio
  * Each Studio has **one or more** Movies
  * Each President has **one** Studio
  * Each Studio has **zero or one** President

<p class="centered">
    <img src="assets/img/uml-associations-2.png" alt="UML Associations" title="UML Associations" class="img-responsive">
</p>

---

## Cardinality in UML Associations

* Spot the typo!

<p class="centered">
    <img src="assets/img/uml-associations.png" alt="UML Associations" title="UML Associations" class="img-responsive">
</p>

* Be sure to get this right!!!

---

## UML Self-Associations

* Nothing much to see here
* Notice the multiplicities
  * The original can have **zero or more** sequels
  * A sequel can have **zero or one** originals

<p class="centered">
    <img src="assets/img/uml-self-associations.png" alt="UML Self Associations" title="UML Self Associations" class="img-responsive">
</p>

---

## Association Classes in UML

* Relationships can have attributes!
* This is true in any (useful) modeling language
  <br><br>
* But associations in UML are just lines between classes
* So UML developed the idea of an **association class**
* This is an auxiliary class that is attached to a relationship
* The association class is attached to the middle of the relationship edge (with a dashed line, according to the standard)

<p class="centered">
    <img src="assets/img/uml-association-class.png" alt="UML Association Classes" title="UML Association Classes" class="img-responsive">
</p>

---

## Subclasses in UML

* UML was built to describe inheritance hierarchies!
* UML supports all four types of inheritance:
  1. **Coverage:** Incomplete vs. Complete
  2. **Exclusivity:** Disjoint vs. Overlapping
  <br><br>
* The default has changed from
  * Unspecified
  * incomplete & disjoint (UML 2.0 to 2.4.1)
  * incomplete & overlapping (as of UML 2.5)
* You can actually specify what you mean in the diagram by labeling an inheritance link,
  e.g., as **{complete, overlapping}**

---

## Subclasses in UML

<p class="centered">
    <img src="assets/img/uml-inheritance.png" alt="UML Inheritance" title="UML Inheritance" class="img-responsive">
</p>

* Note: The book assumes **complete & disjoint**, but this is no longer the default
* It pays to be explicit

---

## Aggregation and Composition in UML

* UML has a special notation for two types of relationships:
  * **Aggregation** from $A$ to $B$ means that $A$ *contains* zero or more $B$s, e.g., a course section contains one or more students
  * **Composition** from $A$ to $B$ means that $A$ *is made up of* zero or more $B$s, e.g., a book is made up of one or more chapters
  <br><br>
* Aggregation is represented by an open diamond on the **owner** class
* Composition is represented by a filled diamond on the **owner** class
  <br><br>
* Note: aggregation and composition are **special cases** of plain associations between classes

---

## Association, Aggregation, and Composition in UML

* Here are the subtle differences:
  * An association from $A$ to $B$ means that there is some relationship between them, but each entity is independent
  * An aggregation from $A$ to $B$ means that each $B$ entity is owned by some $A$ entity 
  * A composition from $A$ to $B$ means that each $B$ entity is owned by some $A$ entity, and that a $B$ entity cannot live on its own
    (i.e., without an $A$ parent)
  <br><br>
* Pragmatics:
  * If there is no notion of "parent", then use a plain association
  * If you delete the parent $A$, does that mean the related $B$s should also be deleted?
  * If so, use composition
  * If not, use aggregation (or association)

---

## UML Association, Aggregation, Composition Example

<p class="centered">
    <img src="assets/img/uml-linkedin.png" alt="UML Aggregation Composition Example" title="UML Aggregation Composition Example" class="img-responsive">
</p>


---

## Association, Aggregation, and Composition in UML

* There is also a difference in cardinalities
  * For association, there is no restriction (unless you write one on the endpoint)
  * For aggregation, it's zero or one on the parent
  * For composition, it's exactly one on the parent
  <br><br>
* This is the distinction that the book focuses on
* It has a direct translation to a database schema
* But if you use aggregation and composition, make sure that you are using them to
  model the world correctly!

---

## UML Association, Aggregation, Composition Example

<p class="centered">
    <img src="assets/img/uml-aggregation-composition.png" alt="UML Aggregation Composition Example" title="UML Aggregation Composition Example" class="img-responsive">
</p>

---

# Converting UML Diagrams to Relations

---

## Converting UML Diagrams to Relations

* The basic strategy is 
  * turn each class into a relation with the same name and attributes
  * turn each association into an entity set with attributes corresponding to the primary keys of the connected classes,
    as well as any attributes defined in an association class

---&twocol

## Converting UML Diagrams to Relations

*** =left
<p class="centered">
    <img src="assets/img/uml-associations-fixed.png" alt="UML Associations" title="UML Associations" class="img-responsive">
</p>

*** =right
```
Movies(_title_, _year_, length, genre)
Stars(_name_, address)
Studios(_name_, address)
StarsIn(movieTitle, movieYear, starName)
Owns(movieTitle, movieYear, studioName)
```

---

## Converting UML Diagrams to Relations

<p class="centered">
    <img src="assets/img/uml-associations-fixed.png" alt="UML Associations" title="UML Associations" class="img-responsive">
</p>

```
Movies(_title_, _year_, length, genre, studioName)
Stars(_name_, address)
Studios(_name_, address)
StarsIn(title, year, name)
```

Of course, we can avoid adding a relationship table for the many-to-one relationship

---

## Handling Subclasses

* There are three different approaches to handling subclasses
* Suppose $A_1$, $A_2$, and $A_3$ are subclasses of $A$

1. Use a table for each subclass
   * We create a relation for each entity set, including $A$ and the $A_i$
   * Each of the $A_i$ must have all the attributes in the key of $A$
   * I.e., the $A_i$ explicitly inherit the key attributes from $A$
   * That becomes the key of the $A_i$, so if an $A_i$ participates  in a relationship, the entire key is used to identify an entity
2. Use a single-class for each path to one of the possible concrete classes
   * The relation contains all the attributes of each class on the path, e.g., $A, A_1$
3. Use just one table 
   * It has the attributes of $A$ and all of the $A_i$, and NULL values as appropriate

---

## Handling Subclasses

* Explicitly considering coverage and exclusivity, we can 
  tailor our approach:
  1. If all classes are disjoint, then the single-class-per-path approach is not as crazy as it sounds.
     Simply, the attributes of the parent are pushed into each descendant table.
     It's still crazy, in that it's hard to find the data for a single row if you don't know
     where it is.
  2. If the hierarchy is both complete and disjoint, then the only classes that are needed
     are at the leaves.
  3. Otherwise, just use one table with NULLs for the irrelevant columns

---

## Handling Subclasses

<p class="centered">
    <img src="assets/img/uml-inheritance.png" alt="UML Inheritance" title="UML Inheritance" class="img-responsive">
</p>

```
Movies(_title_, _year_, length, genre)
MurderMysteries(_title_, _year_, length, genre, weapon)
Cartoons(_title_, _year_, length, genre)
CartoonMurderMysteries(_title_, _year_, length, genre, weapon)
```
Using the single-class approach

---

## Handling Subclasses

<p class="centered">
    <img src="assets/img/uml-inheritance.png" alt="UML Inheritance" title="UML Inheritance" class="img-responsive">
</p>

```
Movies(_title_, _year_, length, genre)
MurderMysteries(_title_, _year_, weapon)
Cartoons(_title_, _year_)
CartoonMurderMysteries(_title_, _year_, weapon)
```
Using the table-per-class approach

---

## Handling Subclasses

<p class="centered">
    <img src="assets/img/uml-inheritance.png" alt="UML Inheritance" title="UML Inheritance" class="img-responsive">
</p>

```
Movies(_title_, _year_, length, genre, type, weapon)
```
Using the just-one-class approach

---

## Handling Aggregations and Compositions

* Recall that cardinality view that
  * **Aggregation** really means at most one parent
  * **Composition** really means exactly one parent
  <br><br>
* Then aggregations and compositions are translated using nothing more than the cardinality-based rules
* In particular, since both denote a many-to-one relationship, we never create the explicit relationship table

---&twocol

## Handling Aggregations and Compositions

```
Studios(_name_, address)
Movies(_title_, _year_, length, genre, studioName)
MovieExecs(_cert#_, name, address, networth)
Presidents(_cert#_, studioName)
```

*** =left
<p class="centered">
    <img src="assets/img/uml-aggregation-composition.png" alt="UML Aggregation Composition Example" title="UML Aggregation Composition Example" class="img-responsive">
</p>

*** =right

* Notice that the empty diamond is just treated as a 0..1 annotation
  <br><br>
* We also have the constraint that studioName in Presidents cannot be NULL
* That constraint handles the "filled" diamond

---

## Handling Weak Entities

* There is really **no concept** of weak entities in UML
* Note: Please do not confuse this with the notion of **weak references** in OOP
  <br><br>
* The related concept in UML is actually **composition**
  * If class $A$ is the owner of class $B$ under composition, then each
    instance of $B$ is scoped inside an instance of $A$ and can't live outside $A$
  * That just about captures "weak entity" by itself
    <br><br>
* We can emphasize this fact by using a special "PK" notation on the weak class
* If we do so, we drop the part of the key that comes from the relationship

<p class="centered">
    <img src="assets/img/uml-weak-entity.png" alt="UML Weak Entities" title="UML Weak Entities" class="img-responsive">
</p>

---

## Handling Weak Entities

<p class="centered">
    <img src="assets/img/uml-weak-entity.png" alt="UML Weak Entities" title="UML Weak Entities" class="img-responsive">
</p>

The translation to a schema is just as before

```
Studios(_name_, address)
Crews(_number_, _studioName_, crewChief)
```

---

# Hibernate

---

## Hibernate Mapping

* Hibernate is an Object-Relational Mapper
* We'll talk more about it later, but for now, we'll consider how it helps us describe a schema using Java classes]

<br>

* But how do you map tables to classes?
* Hibernate offers a solution based on XML configuration files (yuck)
  * There is a global configuration object
  * The configuration object creates the session factory
  * The session factory then creates one or more sessions
* Hibernate also offers an easier way using Java annotations (yeay!)

---

## Hibernate Mappings with Annotations

```
@Entity        // Maps to table called "FACULTY"
public class Faculty
{
    private Long fid;

    // Marks the field that corresponds to a key
    @Id @GeneratedValue  
    public Long getFid() { return fid; }
    public void setFid(Long fid) { this.fid = fid; }
    
    // Automatically maps to column called "fname"
    private String fname;
    public String getFname () { return fname; }
    public void setFname (String fname) { 
        this.fname = fname; 
    }
```


---

## Hibernate Mappings with Annotations

```
    // Automatically maps to column called "specialty"
    private String specialty;
    public String getSpecialty () { return specialty; }
    public void setSpecialty (String specialty) { 
        this.specialty = specialty; 
    }

    // Maps to FK on Student(advisor) => Faculty(fid)
    private Set<Student> advisees = new HashSet<Student> ();

    @OneToMany(mappedBy="advisor")
    public Set<Student> getAdvisees() { 
        return advisees;
    }
}
```

---

## Hibernate Mappings with Annotations

```
@Entity        // Maps to table called "STUDENTS"
@Table(name="STUDENTS")
public class Student
{
    private Long sid;

    // Marks the field that corresponds to a key
    @Id @GeneratedValue  
    public Long getSid() { return sid; }
    public void setSid(Long sid) { this.sid = sid; }
    
    // Automatically maps to column called "sname"
    private String sname;
    public String getSname () { return sname; }
    public void setSname (String sname) { 
        this.sname = sname; 
    }
```

---

## Hibernate Mappings with Annotations

```
    // Automatically maps to column called "gpa"
    private Float gpa;
    public Float getGpa () { return gpa; }
    public void setGpa (Float gpa) { 
        this.gpa = gpa; 
    }
    
    private Faculty advisor;
    @ManyToOne
    public Faculty getAdvisor () { return advisor; }
    public void setAdvisor (Faculty advisor) { 
        this.advisor = advisor; 
    }
```

---

## Hibernate Mappings with Annotations

```
Faculty f = ...;
for (Student advisee: f.getAdvisees()) {
    // Send reminder to advisee
}
```

<br>

```
Faculty f = ...;
Student s = ...;
s.setAdvisor (f);
session.save (s);
session.getTransaction().commit();
```

---

## Hibernate and Subclasses

* Hibernate supports all three ways of defining tables from subclasses
* It calls the methods
  1. Table Per Subclass
  2. Table Per Concrete Class
  3. Table Per Hierarchy
* We'll make a class called Person that generalizes both Student and Faculty

---

## Hibernate Table Per Subclass

* Use `@Inheritance(strategy=InheritanceType.JOINED)` on the parent class **only**
* Specify the column to use for joining a table with its parent on the subclasses
  with `@PrimaryKeyJoinColumn(name="ID")`

---

## Hibernate Table Per Subclass

```
@Entity        // Maps to table called "PERSON"
@Inheritance(strategy=InheritanceType.JOINED)  
public class Person
{
    private Long id;

    // Marks the field that corresponds to a key
    @Id @GeneratedValue  
    public Long getId() { return id; }
    public void setId(Long fid) { this.id = id; }
    
    // Automatically maps to column called "name"
    private String name;
    
    ...
}
```

---

## Hibernate Table Per Subclass

```
@Entity        // Maps to table called "FACULTY"
@PrimaryKeyJoinColumn(name="ID")  
public class Faculty extends Person
{
    // Inherited methods:
    // public Long getId(); 
    // public void setId(Long id);
    // public String getName(); 
    // ...

    // Automatically maps to column called "specialty"
    private String specialty;
    public String getSpecialty () { return specialty; }

    ...
}
```

---

## Hibernate Table Per Subclass

```
@Entity        // Maps to table called "STUDENT"
@PrimaryKeyJoinColumn(name="ID")  
public class Student extends Person
{
    // Inherited methods:
    // public Long getId(); 
    // public void setId(Long id);
    // public String getName(); 
    // ...

    // Automatically maps to column called "gpa"
    private Float gpa;
    public Float getGpa () { return gpa; }

    ...
}
```

---

## Hibernate Table Per Concrete Class

* Use `@Inheritance(strategy=InheritanceType.TABLE_PER_CLASS)` on the parent class **only**
* Use `@AttributeOverrides` to specify column names on **subtables** (optional)

---

## Hibernate Table Per Concrete Class

```
@Entity        // Maps to table called "PERSON"
@Inheritance(strategy=InheritanceType.TABLE_PER_CLASS)  
public class Person
{
    private Long id;

    // Marks the field that corresponds to a key
    @Id @GeneratedValue  
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    // Automatically maps to column called "name"
    private String name;
    
    ...
}
```

---

## Hibernate Table Per Concrete Class

```
@Entity        // Maps to table called "FACULTY"
@AttributeOverrides({  
    @AttributeOverride(name="id", column=@Column(name="id")),  
    @AttributeOverride(name="name", column=@Column(name="name"))  
})  
public class Faculty extends Person
{
    // Inherited methods:
    // public Long getId(); 
    // public void setId(Long id);
    // public String getName(); 
    // ...

    // Automatically maps to column called "specialty"
    private String specialty;
    public String getSpecialty () { return specialty; }

    ...
}
```

---

## Hibernate Table Per Concrete Class

```
@Entity        // Maps to table called "STUDENT"
@AttributeOverrides({  
    @AttributeOverride(name="id", column=@Column(name="id")),  
    @AttributeOverride(name="name", column=@Column(name="name"))  
})  
public class Student extends Person
{
    // Inherited methods:
    // public Long getId(); 
    // public void setId(Long id);
    // public String getName(); 
    // ...

    // Automatically maps to column called "gpa"
    private Float gpa;
    public Float getGpa () { return gpa; }

    ...
}
```

---

## Hibernate Table Per Hierarchy

* Use `@Inheritance(strategy=InheritanceType.SINGLE_TABLE)` on the parent class **only**
* Use `@DiscriminatorColumn` to specify the column that holds the type of the row, on the parent class **only**
* Use `@DiscriminatorValue` on each class to specify the value of the discriminating column for objects of that class

---



## Hibernate Table Per Hierarchy

```
@Entity        // Maps to table called "PERSON"
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)  
@DiscriminatorColumn(name="type",discriminatorType=DiscriminatorType.STRING)  
@DiscriminatorValue(value="person")  
public class Person
{
    private Long id;

    // Marks the field that corresponds to a key
    @Id @GeneratedValue  
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    // Automatically maps to column called "name"
    private String name;
    
    ...
}
```

---

## Hibernate Table Per Hierarchy

```
@Entity        // Maps to table called "FACULTY"
@DiscriminatorValue(value="faculty")  
public class Faculty extends Person
{
    // Inherited methods:
    // public Long getId(); 
    // public void setId(Long id);
    // public String getName(); 
    // ...

    // Automatically maps to column called "specialty"
    private String specialty;
    public String getSpecialty () { return specialty; }

    ...
}
```

---

## Hibernate Table Per Concrete Class

```
@Entity        // Maps to table called "STUDENT"
@DiscriminatorValue(value="student")  
public class Student extends Person
{
    // Inherited methods:
    // public Long getId(); 
    // public void setId(Long id);
    // public String getName(); 
    // ...

    // Automatically maps to column called "gpa"
    private Float gpa;
    public Float getGpa () { return gpa; }

    ...
}
```

---

## Hibernate Takeaways

* Hibernate makes it easier for programmers to model database schemas
* Annotations map OO concepts into tables
* But programmers still have to know what they're doing!

<br>

* This is only useful for a first-cut at the database schema
* We will talk later about indexes, etc.
* Good DBAs will want to be explicit on the creation of the actual database tables
* The right choices depend on factors that Hibernate doesn't even know about, like how large the tables are
* So even Hibernate tells you not to rely on the automatic generation of schemas!

---

## Hibernate Takeaways

* We will now turn our attention to designing good database schemas (by hand)
* You may find it useful to rely on your programming skills and think in terms of classes first
* Then you can translate your design to tables
