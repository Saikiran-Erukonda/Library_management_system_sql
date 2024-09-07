-- Project Name : Library Management System Using SQL
-- project level : intermediate 
-- Author : Erukonda saikiran
-- In order to improve SQL skills and it is part of portfolio projects

create database Library_db;

-- create table and import values into it

create table books(
					isbn varchar(20),
					book_title varchar(55),
					category varchar(20),
					rental_price float,
					status varchar(5),
					author varchar(25),
					publisher varchar(30)
					);

create table branch(branch_id varchar(5),
					 manager_id	varchar(5),
					 branch_address varchar(15),
					 contact_no varchar(15));

create table employees( emp_id varchar(5),
					 emp_name varchar(30),
					 position varchar(15),
					 salary	varchar(10),
					 branch_id varchar(5));

create table issued_status(issued_id varchar(5),
					  issued_member_id	varchar(5),
					  issued_book_name	varchar(55),
					  issued_date	date,
					  issued_book_isbn varchar(20),
					  issued_emp_id varchar(5));

create table members(member_id varchar(5),
				member_name varchar(30),
				member_address varchar(15),
				reg_date date);

create table return_status(return_id varchar(5),
					  issued_id varchar(5),
					  return_book_name varchar(55),
					  return_date date,
					  return_book_isbn varchar(20));
					  
-- forgot to add primary key,let we add it

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

/*==========================================================================================
|| +----------------+	 	Let we make some queries based on the questions.						||
|| | CRUD operations| 		Create, Read, Update, Delete.										||
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

-- 2.Update existing member's address
update members 
set member_address = 'Banjara Hills' where member_name ='Sam';
select * from issued_status;

-- 3.delete a record  from table  issued
delete from issued_status where issued_id  = 'IS140';

--4. Return all books issued by employee E101
select issued_emp_id,issued_id,issued_book_name from issued_status where issued_emp_id ='E101';

--5.list all the members who have more than one issues, in descending order based on no.of issues.

select issued_member_id
--,count(issued_id) as no_of_book 
from issued_status 
group by issued_member_id having count(issued_id)>1 order by count(issued_id) desc;

/*=========================================================================================================
|					Create Foreign keys to link the tables  using Queries.									|
=========================================================================================================*/
















