# Library-Management-System
Library Management System using SQL Project 
# Project Structure
1. Database Setup
<img width="1101" height="631" alt="library_erd" src="https://github.com/user-attachments/assets/d886955b-78f2-423c-b85e-e4e97e4035d4" />

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```
--libray management sytem--

create table branch 
(
		branch_id varchar(10) primary key,
		manager_id varchar(10),
		branch_address varchar(55),
		contact_no varchar(10)
);CREATE DATABASE library_db;

-- Create table "Employee"
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary int,
            branch_id VARCHAR(25)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(75),
            reg_date DATE
);

-- Create table "Books"
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price float,
            status VARCHAR(15),
            author VARCHAR(35),
            publisher VARCHAR(55)
);

al

-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10)
          
);


-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50)
            
);

--Foreign key
alter table  issued_status
add constraint fk_members
foreign key(issued_member_id)
references members(member_id);

alter table  issued_status
add constraint fk_books
foreign key(issued_book_isbn)
references books(isbn);

alter table  issued_status
add constraint fk_employ
foreign key(issued_emp_id)
references employees(emp_id);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.


  ```
-- project start--
---  Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')" ---

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & Co.');


-- Task 2: Update an Existing Member's Address --
update members  set member_address = '125 Main St'
where member_id='C101' ;
select * from members;

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.--
DELETE FROM issued_status WHERE   issued_id =   'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.-
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;


-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**--

CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT  * from book_issued_cnt;

-- Task 7. Retrieve All Books in a Specific Category:--
SELECT * FROM books WHERE category = 'Classic';

--  t ask 8: Find Total Rental Income by Category:--

select b.category,
sum(b.rental_price) as  total_rent,count(*)
from issued_status as ist
join books b  
on b.isbn=ist.issued_book_isbn
group by b.category;


-- 9 List Members Who Registered in the Last 180 Days:--
select * from members where reg_date>= CURRENT_DATE - INTERVAL '180 DAYS' ;

-- 10 List Employees with Their Branch Manager's Name and their branch details:

select * from employees;
select e1.emp_id,e1.emp_name,e1.position,e1.salary,b.*,e2.emp_name from employees e1
join
branch as b 
on e1.branch_id=b.branch_id
join
employees e2
on e2.emp_id=b.manager_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:--
select * from books;
CREATE TABLE expensive_books AS
SELECT * FROM books WHERE rental_price > 7.00;
select * from expensive_books;

  ```
