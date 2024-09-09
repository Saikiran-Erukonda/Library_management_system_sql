select * from books;
select * from employees;
select * from members;
select * from issued_status;
-- 13.Identify the members with overdue.WQ to identify members who have overdue books(assume a 30 day return period)
--     display members name ,book title ,issued date , days overdue
select issued_member_id as member_name,
	   issued_book_name as book_title,issued_date,
	   (current_date-issued_date) as days_overdue from issued_status
	   where issued_id not in(select issued_id from return_status) and
			 issued_date < (current_date -interval '30 days');

alter table books alter column status type varchar (15);

-- 14.WQ to update the status of books in the books table to  'available' when they are returned (based on entries in the return table)
update books
set status = 'Available'
where isbn in (select ib.issued_book_isbn as isbn
				from return_status as Rs inner join issued_status as ib on rs.issued_id =ib.issued_id );
				
select * from books where status = 'Available' ;
select * from return_status;

-- 15.WQ that generates a performance report for each branch , showing the no of books issued, the no.of books returned, the total revenue generated from book rentals
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;

select br.branch_id,br.branch_address,count(ib.issued_id) as no_of_books_issued,
		count(rs.return_id) as no_of_books_returned 
		--// LOJ branch <==> emp
		from branch as br left outer join employees as emp on br.branch_id = emp.branch_id
		--// LOJ [branch <==> emp] <==> issued_status
		left outer join issued_status as ib on emp.emp_id = ib.issued_emp_id 
		--// LOJ [[branch <==> emp] <==> issued_status] <==> return status
		left outer join return_status as rs on rs.issued_id = ib.issued_id group by br.branch_id; 
		
-- 16.WQ CTAS create table "active_members"members who have issued  at least one Book in last 30days
select * from members;
select * from issued_status;

update issued_status 
set issued_member_id = 'C220' where issued_id = 'IS140';

drop table if exists active_members;
------------------------------------------------------- main query
create table active_members as
select m.member_id,m.member_name, m.member_address as address, ib.issued_book_name as book_title, issued_date
	from issued_status as ib left outer join members as m  
	on m.member_id = ib.issued_member_id 
	where issued_date >= current_date - interval '30 days' ;
-------------------------------------------------------------------
select * from active_members;

-- 17.Find employees with most_book_issues  processed. WQ to find the top 3 employees who  have processed the most book issues. employee name,no of books, their branch

select emp.emp_name,count(ib.issued_id) as no_of_book_issues,emp.branch_id,br.branch_address
		from issued_status as ib left outer join employees as emp on ib.issued_emp_id = emp.emp_id 
		left outer join branch as br on br.branch_id = emp.branch_id group by 1,3,4 					--// 1,3,4 are column index
		order by count(ib.issued_id) desc limit 3;

-- 18.WQ to identify members who have issued books more than twice with the status "damaged" in the books table. Display the membername,book title,the no of times they have issued damaged books
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

/* 19.Stored procedure Objective :  Create a stored procedure to manage the status of books in a library system.
		Description: Write a SP that updates  the status of a book based on its issuance or return.
		Specifically : if a book is issued , the status should change to 'no'. If a book is returned , the status should changed to 'yes'.
*/

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


select * from books ;
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



		