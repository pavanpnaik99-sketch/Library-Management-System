select * from books;
select * from branch;
select * from employees;
select * from members;
select * from issued_status;
select * from return_status;



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

--Task 12: Retrieve the List of Books Not Yet Returned--
select * from return_status;
select * from issued_status;

select * from  
issued_status as st
left join 
return_status as ist
on st.issued_id=ist.issued_id
where ist.return_id  is null;

--Advanced SQL Operations
--Task 13: Identify Members with Overdue Books
--Write a query to identify members who have overdue books (assume a 30-day return period). 
--Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30 ORDER BY 1;

--Task 14: CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
create table active_members as 
select * from members where member_id in (select distinct issued_member_id from issued_status
												where issued_date >= current_date  - interval '2 month');

select * from active_members;


--Task 15: Branch Performance Report
--Create a query that generates a performance report for each branch, showing the number of` books issued, 
--the number of books returned, and the total revenue generated from book rentals.
CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
  from issued_status as ist
join 
employees as e
on e.emp_id=ist.issued_emp_id
join
branch b
on e.branch_id=b.branch_id
left join 
return_status as rs
on rs.issued_id=ist.issued_id
join
books as bk 
on bk.isbn=ist.issued_book_isbn
group by 1,2;


select * from branch_reports;

--Task 16: Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
select * from branch;

select e.emp_name,b.*,
count(ist.issued_id) as no_books_issued
from issued_status as ist
join employees as e 
on e.emp_id=ist.issued_emp_id
join
branch as b
on e.branch_id=b.branch_id 
group by 1,2;







