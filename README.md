# Library Management System using SQL Project --P2

## Project Overview
**Project Name : Library Management System Using SQL**

**Project level**: intermediate 

**Author** : Erukonda saikiran
-- In order to improve SQL skills and it is part of portfolio projects

**Database**: `Library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![Screenshot 2024-09-07 183952](https://github.com/user-attachments/assets/215c62d6-42b9-4ed4-9b79-45ae13303874)


- **Database Creation**: Created a database named `library_db`.[library_schema](https://github.com/Saikiran-Erukonda/Library_management_system_sql/blob/main/Library%20management%20project.sql)
- **Table Creation**: Created tables for branches, employees, members, books, issued_status, and return_status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE Library_db;
-- create tables branches, employees, members, books, issued_status, and return_status.and import values into them

create table books(isbn varchar(20),
                        book_title varchar(55),
                        category varchar(20),
                        rental_price float,
                        status varchar(5),
                        author varchar(25),
                        publisher varchar(30)
					);

create table branch(branch_id varchar(5), manager_id varchar(5),
                                    branch_address varchar(15),
                                    contact_no varchar(15));

create table employees( emp_id varchar(5),emp_name varchar(30), position varchar(15), salary varchar(10),branch_id varchar(5));

create table issued_status(issued_id varchar(5), issued_member_id varchar(5),
                                     issued_book_name varchar(55),
                                     issued_date date, issued_book_isbn varchar(20), issued_emp_id varchar(5));

create table members(member_id varchar(5),member_name varchar(30),member_address varchar(15), reg_date date);

create table return_status(return_id varchar(5), issued_id varchar(5),  return_book_name varchar(55), return_date date, return_book_isbn varchar(20));
```
-- forgot to add primary key,let we add it
```sql

alter table books add primary key(isbn);
select * from books;
alter table branch add primary key(branch_id);
alter table employees add primary key(emp_id);
alter table issued_status add primary key(issued_id);
alter table members add primary key(member_id);
alter table return_status add primary key(return_id);


-- LOAD the data into tables by "Insert INTO" command or  by Postgresql's "table - import Option".
-- INSERT INTO method
insert into books(isbn ,book_title ,category,rental_price ,status, author,publisher )
values('978-0-553-29698-2', 'The Catcher in the Rye','Classic',7.00,'yes','J.D. Salinger','Little, Brown and Company'),
('978-0-330-25864-8','Animal Farm','Classic',5.50,'yes','George Orwell','Penguin Books');
select * from books;

-- using Table import method , use postgre SQL interface tools. for that we need to delete above inserted data.
-- use TRUNCATE to delete the data. So that the table structure remains same,only data will be deleted. 
truncate table books;
select * from books;

-- Schemas > tables > right click on books > Import/Export data.. > browse the location >select file > enable header > click on OK
-- Check the data imported or not
select * from books
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
```

### 2. CRUD Operations 
[library_management_sql](https://github.com/Saikiran-Erukonda/Library_management_system_sql/blob/main/Library%20management%20project.sql)

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- '978-8-173-71146-6','Wings Of Fire An Autobiography','Autobiography',5.0,'Yes', 'APJ Abdul Kalam','Universities Press'

```sql
/*==========================================================================================
|| +----------------+	 	Let we make some queries based on the questions.       ||					||
|| | CRUD operations| 		Create, Read, Update, Delete.		       ||							||
== +----------------+ ======================================================================*/
/* 1.Create a new book record 
    '978-8-173-71146-6','Wings Of Fire An Autobiography','Autobiography',5.0,'Yes', 'APJ Abdul Kalam','Universities Press'
*/
select * from books;
insert into books
values ('978-8-173-71146-6',				-- isbn
		'Wings Of Fire An Autobiography', 	-- book_title
		'Autobiography',					-- category
		5.0,								-- rental_price
		'Yes',								-- status
		'APJ Abdul Kalam',					-- author
		'Universities Press');				-- publisher
select * from books;

```
**Task 2: Update an Existing Member's Address**

```sql
update members 
set member_address = 'Banjara Hills' where member_name ='Sam';
select * from issued_status;
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS140' from the issued_status table.

```sql
-- 3.delete a record  from table  issued
delete from issued_status where issued_id  = 'IS140';
```
![Screenshot 2024-09-06 131048](https://github.com/user-attachments/assets/93cf1896-840b-41e1-9811-ad8800b9ecb9)

![Screenshot 2024-09-06 131225](https://github.com/user-attachments/assets/143558ea-1265-4aed-88a9-74d6afdc14c2)

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
--4. Return all books issued by employee E101
select issued_emp_id,issued_id,issued_book_name from issued_status where issued_emp_id ='E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
select issued_member_id
--,count(issued_id) as no_of_book 
from issued_status 
group by issued_member_id having count(issued_id)>1 order by count(issued_id) desc;
```
## Create Foreign keys to link the tables  using Queries.

```sql
/*=========================================================================================================
|	Create Foreign keys to link the tables  using Queries.			          |
=========================================================================================================*/

-- foreign key member_id connecting issued_status and members
ALTER TABLE issued_status add constraint fk_members 			--//members
foreign key (issued_member_id)
references members(member_id);

-- foreign key book_isbn connecting issued_status and books
alter table issued_status add constraint fk_book_isbn 			--//isbn
foreign key (issued_book_isbn)
references books(isbn);

-- foreign key emp_id connecting issued_status and employees
alter table issued_status add constraint fk_emp_id				--//employees
foreign key(issued_emp_id) references employees(emp_id);

-- foreign key branch_id connecting employees and branch
alter table employees add constraint fk_branch
foreign key(branch_id) references branch(branch_id);			--//branch_id

--foreign key issue_id connnecting issued-status and return_status 
alter table return_status add constraint fk_issued_id			--//issued_id
foreign key(issued_id) references issued_status(issued_id);
/*1. ERROR:  Key (issued_id)=(IS101) is not present in table "issued_status".insert or update on table "return_status" violates foreign key constraint "fk_issued_id" 

ERROR:  insert or update on table "return_status" violates foreign key constraint "fk_issued_id"
SQL state: 23503
Detail: Key (issued_id)=(IS101) is not present in table "issued_status".*/
delete from return_status where issued_id = 'IS101';
--------------------------------------------------------------------------------------------------
/*2. ERROR:  Key (issued_id)=(IS105) is not present in table "issued_status".insert or update on table "return_status" violates foreign key constraint "fk_issued_id" 

ERROR:  insert or update on table "return_status" violates foreign key constraint "fk_issued_id"
SQL state: 23503
Detail: Key (issued_id)=(IS105) is not present in table "issued_status".*/

-- to know the what are the IDs are not exists issued_status but exists in returned status 
select * from return_status where issued_id not in (select issued_id from issued_status);

-- delete them from return table
delete from return_status where issued_id not in (select issued_id from issued_status);

--foreign key issue_id connnecting issued-status and return_status 
alter table return_status add constraint fk_issued_id			--//issued_id
foreign key(issued_id) references issued_status(issued_id);
```


### 3. CTAS (Create Table As Select) 
[library_management_part2]()

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book_id,book name,total issued count**

```sql
-- 6.Create a table each book_id,book name,total issued count
-- =================================================================== trial of inner join
select books.isbn,books.book_title,count(issued_status.issued_id) as IST from books inner join issued_status on books.isbn = issued_status.issued_book_isbn group by books.isbn,books.book_title;
--  ---------------------------------------------------------------------
select * from books as b 					-- join statement syntax
			  join 
			  issued_status as i_s
			  on i_s.issued_book_isbn = b.isbn;
			  
-- selecting only "isbn","title", "count of number of issues" and CREATE it as a table book_issues 
create table book_issues
as
select b.isbn,b.book_title,count(i_s.issued_id) as no_of_issues from books as b 
			  join 
			  issued_status as i_s
			  on i_s.issued_book_isbn = b.isbn 
			  group by b.isbn,b.book_title;
			  
select * from book_issues;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category - Children**:

```sql
-- 7. Retrieve all the books in specific category that is Children
select book_title,category from books where category = 'Children';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
-- 8. Find total rental_income by category 
select b.category,sum(b.rental_price) as rental_income from books as b inner join issued_status as i_s
                                                            on i_s.issued_book_isbn = b.isbn 
                                                           where isbn in(select issued_book_isbn from issued_status) group by b.category;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
-- 9. List the members who registered in last 180 days

select * from members;

insert into members(member_id,member_name,member_address,reg_date)
values('C220','Saikiran','hyderabad','2024-08-20');

select member_id,member_name,reg_date from members where reg_date >= current_date - interval '180 days';
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql

-- 10.list employees with their branch manager's name  and their branch details

select br.manager_id,emp2.emp_name,emp1.emp_name,br.branch_id,br.branch_address,br.contact_no
from employees as emp1 join 				
branch as br on br.branch_id = emp1.branch_id		
join 												
employees as emp2 on br.manager_id = emp2.emp_id
order by emp2.emp_name asc;

--  performed two joins    emp join  branch based on branch id
--  (emp and branch) join emp based on manager_id 
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
-- Table of books with rental price above a certain value(>5) [Name the table as expensive_books]
```sql
-- 11. Table of books with rental price above a certain value(>5) [Name the table as expensive_books]
create table expensive_book as 
select * from books where rental_price > 5 ;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
-- 12. Retrieve the list of books not yet returned.
  
select * from issued_status; -- 35 entries
select * from return_status; -- 16 entries
-- use left outer Join gives matched rows which matches to 1st table
-- we need to return 35-16 = 19 rows <gives rows which matches to 1st table>
 -- We used 'not' to perform exact opposite to left outer join. 
select I_S.issued_book_name as book									-- the list of books not Yet returned
		,I_S.issued_id
		,I_S.issued_member_id as member_id
		,I_S.issued_date,
		(current_date - issued_date) as days
		from issued_status
as I_S left outer join return_status as R_S on I_S.issued_id = R_S.issued_id 
where I_S.issued_id not in (select issued_id from return_status) order by (current_date - issued_date) desc; 
```

## Advanced SQL Operations
[library_management_part3]()
**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
-- 13.Identify the members with overdue.WQ to identify members who have overdue books(assume a 30 day return period)
--     display members name ,book title ,issued date , days overdue
select issued_member_id as member_name,
	   issued_book_name as book_title,issued_date,
	   (current_date-issued_date) as days_overdue from issued_status
	   where issued_id not in(select issued_id from return_status) and
			 issued_date < (current_date -interval '30 days');

alter table books alter column status type varchar (15);
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql
-- 14.WQ to update the status of books in the books table to  'available' when they are returned (based on entries in the return table)
update books
set status = 'Available'
where isbn in (select ib.issued_book_isbn as isbn from return_status as Rs inner join issued_status as ib on rs.issued_id =ib.issued_id );
				
select * from books where status = 'Available' ;
select * from return_status;

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql

select br.branch_id,br.branch_address,count(ib.issued_id) as no_of_books_issued,
		count(rs.return_id) as no_of_books_returned 
		--// LOJ branch <==> emp
		from branch as br left outer join employees as emp on br.branch_id = emp.branch_id
		--// LOJ [branch <==> emp] <==> issued_status
		left outer join issued_status as ib on emp.emp_id = ib.issued_emp_id 
		--// LOJ [[branch <==> emp] <==> issued_status] <==> return status
		left outer join return_status as rs on rs.issued_id = ib.issued_id group by br.branch_id; 
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 1 month.

```sql

-- 16.WQ CTAS create table "active_members"members who have issued  at least one Book in last 30days
------------------------------------------------------- main query
create table active_members as
select m.member_id,m.member_name, m.member_address as address, ib.issued_book_name as book_title, issued_date
	from issued_status as ib left outer join members as m  
	on m.member_id = ib.issued_member_id 
	where issued_date >= current_date - interval '30 days' ;
-------------------------------------------------------------------
select * from active_members;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
-- 17.Find employees with most_book_issues  processed. WQ to find the top 3 employees who  have processed the most book issues. employee name,no of books, their branch,branch address

select emp.emp_name,count(ib.issued_id) as no_of_book_issues,emp.branch_id,br.branch_address
		from issued_status as ib left outer join employees as emp on ib.issued_emp_id = emp.emp_id 
		left outer join branch as br on br.branch_id = emp.branch_id group by 1,3,4 					--// 1,3,4 are column index
		order by count(ib.issued_id) desc limit 3;
```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    
```sql
select * from books;
select * from books where status = 'damaged'; 

-- book name and no_of_issues
select issued_book_name,count(issued_id) as issues from issued_status group by 1 order by count(issued_id) desc;

-- member_id and no_of_issues
select issued_member_id, count(issued_id) as issues from issued_status group by 1 order by count(issued_id) desc; 

select ib.issued_member_id,b.book_title,b.status
from issued_status as ib inner join books as b on ib.issued_book_isbn  = b.isbn;


select ib.issued_member_id,m.member_name,ib.issued_book_name,count(b.status) as damaged from issued_status as ib left outer join members as m on ib.issued_member_id = m.member_id 
			  left outer join books as b on ib.issued_book_isbn = b.isbn
			  where ib.issued_member_id in (select member_id from (select ib.issued_member_id as member_id,count(b.status) as no_of_issues
			 from issued_status as ib inner join books as b on ib.issued_book_isbn  = b.isbn where b.status = 'damaged' group by 1) where no_of_issues>2) and status ='damaged' group by 1,2,3 ;

```

**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

create or replace procedure issue_book(p_issued_id varchar(10),p_issued_member_id varchar(6),p_issued_book_isbn varchar(20),p_issued_emp_id varchar(10))
language plpgsql
as $$

declare 
--all the variables
v_status varchar(20);

begin 
-- begin the code
  -- checking if book is available 'yes'
  select
   status into v_status
   from books
   where isbn = p_issued_book_isbn;

   if v_status = 'yes' or v_status = 'Available' then
   		
		 insert  into issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
		 values 
		 (p_issued_id,p_issued_member_id,(select book_title from books where isbn = p_issued_book_isbn)
		 	,current_date,p_issued_book_isbn,p_issued_emp_id);

		 update books
		     set status = 'no'
			 where isbn = p_issued_book_isbn;

		  RAISE NOTICE 'Book records added successfully for book isbn : %',p_issued_book_isbn;
	else 
	 RAISE NOTICE 'sorry to inform you the book you have requested is unavailable : % ', p_issued_book_isbn;
	end if;
end ;
$$

select * from books;
-- '978-0-553-57340-1' 1984 										//yes
-- '978-8-173-71146-6' "Wings Of Fire An Autobiography" 			// Available
-- '978-0-307-58837-1' "Sapiens: A Brief History of Humankind" 	// no
update books 
set status  = 'Available' where isbn ='978-8-173-71146-6';

select * from issued_status;
-- call issue_book(p_issued_id ,p_issued_member_id ,p_issued_book_isbn,p_issued_emp_id)
call issue_book('IS141','C220','978-0-553-57340-1','E105');
call issue_book('IS142','C220','978-8-173-71146-6','E105');

call issue_book('IS143','C220','978-0-307-58837-1','E105');

-- to check the status changed to 'no' for issued_books
select * from books ;
```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines
```sql
/*   20. CTAS query to identify overdue books and calculate fines
   		each member,books issued,but not returned within 60 days
		the table should include: the no of overdue books. The total fines , with each day's fine calculated at $0.50.
		The number of books issued by each member. The resulting table should show
		member ID , no of over due books, TOTal fines.*/
create table temp_table as
select ib.issued_id,ib.issued_member_id,ib.issued_date,rs.return_date,(return_date-issued_date) as duration 
		from issued_status as ib left outer join return_status as rs 
		on ib.issued_id = rs.issued_id where (return_date-issued_date)>60 or (return_date-issued_date) is null;

select * from temp_table;
------------------------------
update temp_table
set duration = current_date - issued_date
where duration is null;
--------------------------------------------------------------------------------------main_query
create table Overdues as
select tt.issued_member_id,
		mem.member_name,
		count(tt.issued_id) as no_of_overdue_books,
		(sum(tt.duration)*0.50) as Total_fines
 from temp_table as tt join members as mem on tt.issued_member_id = mem.member_id 
 where duration > 30 
 group by tt.issued_member_id,mem.member_name
 order by (sum(duration)*0.50) desc;
--------------------------------------------------------------------------------------main query
```


## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books,expensive_books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## How to Use

1. **Clone the Repository**: Clone this repository to your local machine.
   ```sh
   git clone 
   ```

2. **Set Up the Database**: Execute the SQL scripts in the `Library management project.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries in the `Library management project_part_2.sql`,`Library management project part 3.sql` file to perform the analysis.
4. **Explore and Modify**: Customize the queries as needed to explore different aspects of the data or answer additional questions.

## Author - Erukonda Saikiran

This project showcases SQL skills essential for database management and analysis. For more content on SQL and data analysis, connect with me through LinkedIn

- **LinkedIn**: [Connect with me on Linked In](https://www.linkedin.com/in/erukonda-saikiran-4379911a3/)


Thank you for your interest in this project!
