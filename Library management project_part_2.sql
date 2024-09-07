Select * from books;
Select * from branch;
Select * from employees;
Select * from members;
Select * from issued_status ;
Select * from return_status;

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

-- 7. Retrieve all the books in specific category that is Children
select book_title,category from books where category = 'Children';

-- 8. Find total rental_income by category 
select b.category,sum(b.rental_price) as rental_income 
											from books as b inner join issued_status as i_s
												on i_s.issued_book_isbn = b.isbn 
												where isbn in(select issued_book_isbn from issued_status) group by b.category;

-- 9. List the members who registered in last 180 days

select * from members;

insert into members(member_id,member_name,member_address,reg_date)
values('C220','Saikiran','hyderabad','2024-08-20');

select member_id,member_name,reg_date from members where reg_date >= current_date - interval '180 days';

-- 10.list employees with their branch manager's name  and their branch details
select br.manager_id,emp.emp_name,br.branch_id,br.branch_address,br.contact_no 
	 from employees as emp join branch as br  on emp.branch_id = br.branch_id order by manager_id asc;
-- +--------------------------------------------------------+
 	select * from employees as emp1 join 				--   |
	branch as br on br.branch_id = emp1.branch_id		--   |
	join 												--   |
	employees as emp2 on br.manager_id = emp2.emp_id;	--   |
-- +--------------------------------------------------------+

select br.manager_id,emp2.emp_name,emp1.emp_name,br.branch_id,br.branch_address,br.contact_no
from employees as emp1 join 				
branch as br on br.branch_id = emp1.branch_id		
join 												
employees as emp2 on br.manager_id = emp2.emp_id
order by emp2.emp_name asc;

--  performed two joins    emp join  branch based on branch id
--						   (emp and branch) join emp based on manager_id 


-- 11. Table of books with rental price above a certain value(>5) [Name the table as expensive_books]
create table expensive_book as 
			select * from books where rental_price > 5 ;


-- inserted some new data into the tables Issued_status and Return_status
-----------------------------------------------------------------------------------------------------------------
insert into issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
values('IS140','C108',				-- isbn
		'Wings Of Fire An Autobiography', 	-- book_title
		'2024-08-28','978-8-173-71146-6','E102');

insert into return_status(return_id,issued_id,return_book_name,return_date,return_book_isbn)
values('RS120','IS140','Wings Of Fire An Autobiography','2024-09-05','978-8-173-71146-6');
-----------------------------------------------------------------------------------------------------------------
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

-- 13.Identify the members with overdue.WQ to identify members who have overdue books(assume a 30 day return period)
--     display members name ,book title ,issued date , days overdue


-- 14.WQ to update the status of books in the books table to  'available' when they are returned (based on entries in the return table)

-- 15.WQ that generates a performance report for each branch , showing the no of books issued, the no.of books returned, the total revenue generated from book rentals


-- 16.WQ CTAS create table "active_members"members who have issued  at least one Book in last 30days

-- 17.Find employees with most_book_issues  processed. WQ to find the top 3 employees who  have processed the most book issues. employee name,no of books, their branch

-- 18.WQ to identify members who have issued books more than twice with the status"damaged" in the books table. Display the membername,book title,the no of times they have issued damaged books

/* 19.Stored procedure Objective :  Create a stored procedure to manage the status of books in a library system.
		Description: Write a SP that updates  the status of a book based on its issuance or return.
		Specifically : if a book is issued , the status should change to 'no'. If a book is returned , the status should changed to "YES".

   20. CTAS query to identify overdue books and calculate fines
   		each member,books issued,but not returned within 30 days
		the table should include: the no of overdue books. The total fines , with each day's fine calculated at $0.50.The number of books issued by each member. The resulting table should show
		member ID , no of over due books, TOTal fines.

*/

