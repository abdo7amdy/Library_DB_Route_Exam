
--Database  ASP.Net Course   Exam 01

--Try To Write The Following Queries :

--1. Write a query that displays Full name of an employee who has more than
--   3 letters in his/her First Name.{1 Point}
select Concat(Fname , ' ' , Lname) as Full_Name
from Employee
where Len(Fname) > 3 ;

--2. Write a query to display the total number of Programming books 
--   available in the library with alias name ‘NO OF PROGRAMMING
--   BOOKS’ {1 Point}
select COUNT(*) as NO_OF_PROGRAMMING_BOOKS
from Book B inner join Category C on B.Cat_id = C.Id
where C.Cat_name = 'Programming'

--3. Write a query to display the number of books published by
--   (HarperCollins) with the alias name 'NO_OF_BOOKS'. {1 Point} 
select COUNT(*) as NO_OF_BOOKS
from Book B inner join Publisher P on B.Publisher_id = P.Id
where P.Name = 'HarperCollins'

--4. Write a query to display the User SSN and name, date of borrowing and due date 
--   of the User whose due date is before July 2022. {1 Point}
select usr.SSN as UserSSN , usr.User_Name UserName ,
       Boro.Borrow_date as Borrow_date, Boro.Due_date as Due_date
from Users usr inner join Borrowing Boro on Boro.User_ssn = Usr.Emp_id
where Boro.Due_date < '2022-07-01';

--5. Write a query to display book title, author name and display in the 
--   following format,' [Book Title] is written by [Author Name]. {2 Points}
select CONCAT('[', B.Title, '] is written by [', A.Name, '].') AS Book_Author
from Book B inner join Book_Author BA on BA.Book_id = B.Id
inner join Author A on BA.Author_id = A.Id


--6. Write a query to display the name of users who have letter 'A' in their 
--   names. {1 Point}
select u.User_Name
from Users u 
where u.User_Name  like '%A%';

--7. Write a query that display user SSN who makes the most borrowing
--   {2 Points}
select top(1) u.SSN
from Users u inner join Borrowing b on u.SSN = b.User_ssn
group by u.SSN
order by count(b.User_ssn) desc;

--8. Write a query that displays the total amount of money that each user paid 
--   for borrowing books. {2 Points}
select u.SSN , SUM(b.Amount) as AmountOfMonetPaid
from Users u inner join Borrowing b on u.SSN = b.User_ssn
group by u.SSN
order by SUM(b.Amount) desc;

--9. write a query that displays the category which has the book that has the 
--   minimum amount of money for borrowing. {2 Points}
select C.*
from Category C inner join Book B on B.Cat_id = C.Id
where B.Id in (
			   select top(1)B.Id as MiniAmount_Id 
               from Book B inner join Borrowing Boro on B.Id = Boro.Book_id
               group by B.Id 
               order by count(Boro.Book_id) desc
			   )

--10. write a query that displays the email of an employee if it's not found, 
--    display address if it's not found, display date of birthday. {1 Point}
select ISNULL(ISNULL(Email,Address),DOB)
from Employee

--11. Write a query to list the category and number of books in each category 
--    with the alias name 'Count Of Books'. {1 Point}
select C.Cat_name , COUNT(B.Id) as 'Count Of Books'
from Book B inner join Category C on B.Cat_id = C.Id
group by C.Cat_name

--12. Write a query that display books id which is not found in floor num = 1 
--    and shelf-code = A1.{2 Points}
select B.Id
from Book B inner join Shelf s on B.Shelf_code = s.Code
inner join Floor f on s.Floor_num = f.Number
where f.Number != 1 and s.Code != 'A1'

--13. Write a query that displays the floor number , Number of Blocks and 
--    number of employees working on that floor.{2 Points}
select f.Number as FloorNumber , f.Num_blocks as F_NumOfBlocks, Count(e.Id) as 'number of employees'
from Floor f inner join Employee e on e.Floor_no = f.Number
group by f.Number , f.Num_blocks

--14. Display Book Title and User Name to designate Borrowing that occurred 
--    within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points}
select B.Title as BookTitle , u.User_Name as UserName,u.SSN
from Book B inner join Borrowing Boro on B.Id = Boro.Book_id
inner join Users u on  u.SSN = Boro.User_ssn
where Boro.Borrow_date between '3/1/2022' and '10/1/2022'

--15.Display Employee Full Name and Name Of his/her Supervisor as
--Supervisor Name.{2 Points}
select concat(e.Fname, ' ', e.Lname) as EmployeeFullName,
       concat(super.Fname, ' ', super.Lname) as SupervisorName
from Employee e left join Employee super on e.Super_id = super.Id

--16.Select Employee name and his/her salary but if there is no salary display
--Employee bonus. {2 Points}
select concat(e.Fname, ' ', e.Lname) as EmployeeName,ISNULL(salary, Bouns)
from Employee e 
-- Another Way 
select concat(e.Fname, ' ', e.Lname) as EmployeeName,
       coalesce(e.Salary, e.Bouns) as Compensation
from Employee e;

--17.Display max and min salary for Employees {2 Points}
select max(Salary) as MaxSalary , min(Salary) as MinSalary
from Employee 

--18.Write a function that take Number and display if it is even or odd {2 Points}
go 
create function CheckEvenOrOdd(@Number int)
returns nvarchar(10)
as
begin
    declare @Num  int ;
	set @Num = @Number ;
    if @Num % 2 = 0 
	return 'Even'
    else return 'Odd'
	return null ;
end;
go
select dbo.CheckEvenOrOdd(4) as Result;

--19.write a function that take category name and display Title of books in that 
--category {2 Points}
go
create function GetBooksPerCategory(@name nvarchar(50))
returns table 
as
return (
         select B.Title
         from Book B inner join Category C on B.Cat_id = C.Id
		 where  C.Cat_name= @name
	   )
go
select *
from GetBooksPerCategory('programming ')

--20. write a function that takes the phone of the user and displays Book Title , 
--user-name, amount of money and due-date. {2 Points}
go
create  function GetBorrowInfoByUserPhone(@Phone nvarchar(11))
returns table
as 
return(
		select B.Title as BookTitle, U.User_Name as UserName , Br.Amount as 'amount of money',Br.Due_date as DueDate
		from Borrowing Br inner join Book B on Br.Book_id = B.Id
		inner join Users U on Br.User_ssn = U.SSN
		inner join User_phones UP on Up.User_ssn = U.SSN
		where UP.Phone_num = @Phone
	  )
select *
from GetBorrowInfoByUserPhone('0125362152')

--21.Write a function that take user name and check if it's duplicated
--return Message in the following format ([User Name] is Repeated 
--[Count] times) if it's not duplicated display msg with this format [user 
--name] is not duplicated,if it's not Found Return [User Name] is Not
--Found {2 Points}
go
create function CheckUserName(@UserName NVARCHAR(50))
returns nvarchar(50)
as
begin
    declare @Count int;

	select @Count = count(*)
    from Users u
    where u.User_Name = @UserName;

    -- Return appropriate message based on the count
    if @Count = 0
        return concat(@UserName, ' is Not Found');
    else if @Count = 1
        return concat(@UserName, ' is not duplicated');
    else
        return concat(@UserName, ' is Repeated ', @Count, ' times');
	return null;
end;
go
SELECT dbo.CheckUserName('Amr Ahmed') AS Result;

--22.Create a scalar function that takes date and Format to return Date With
--That Format. {2 Points}
go
create function GetFormatDate (@InputDate date, @Format nvarchar(50))
returns nvarchar(100)
as
begin
    if @InputDate is null
        return 'Invalid Date';
    return format(@InputDate, @Format);
end;
go
select dbo.GetFormatDate(GETDATE(), 'yyyy-MM-dd') as FormattedDate;

--23.Create a stored procedure to show the number of books per Category.{2Points}
go
create proc BooksPerCategory
as	
	select C.Cat_name as CategoryName , COUNT(B.Id)
	from Book B inner join Category C on B.Cat_id = C.Id
	group by C.Cat_name

exec BooksPerCategory ;

--24.Create a stored procedure that will be used in case there is an old manager 
--who has left the floor and a new one becomes his replacement. The 
--procedure should take 3 parameters (old Emp.id, new Emp.id and the 
--floor number) and it will be used to update the floor table. {3 Points}
go 
create proc FloorManagerReplacement @OldEmpID int,@NewEmpID int,@FloorNumber int
as
    -- Check if the old manager is really assigned to this floor
    if @OldEmpID in (
						select f.MG_ID 
						from Floor f
						where f.Number = @FloorNumber and f.MG_ID = @OldEmpID
					 )
					begin
						update Floor
						set MG_ID = @NewEmpID
						where Number = @FloorNumber;
						select 'Manager updated successfully.';
					end
    else
    begin
        select 'No matching floor or manager found for the provided data.';
    end
go
exec FloorManagerReplacement 3,1,1

--25.Create a view AlexAndCairoEmp that displays Employee data for users 
--who live in Alex or Cairo. {2 Points}
go
create view AlexAndCairoEmp 
as
	select *
	from Employee
	where Address in ('Alex','Cairo')

select * from AlexAndCairoEmp


--26.create a view "V2" That displays number of books per shelf {2 Points}
go
create view V2 
as
	select s.Code as ShelfCode,  COUNT(B.Id) as NumOfBooks
	from Shelf s left join Book B on B.Shelf_code = s.Code
	group by s.Code;
go

select * from V2

--27.create a view "V3" That display the shelf code that have maximum 
--number of books using the previous view "V2" {2 Points}
go
create view V3
as
	select top(1) ShelfCode 
	from V2
	order by NumOfBooks desc;
go

select * from V3

--28.Create a table named ‘ReturnedBooks’ With the Following Structure :
--User SSN Book Id Due Date ReturnDate fees
--then create A trigger that instead of inserting the data of returned book 
--checks if the return date is the due date or not if not so the user must pay 
--a fee and it will be 20% of the amount that was paid before. {3 Points}
create table ReturnedBooks (
    User_SSN bigint,
    Book_Id int,
    Due_date date,
    return_date date,
    fees decimal(10, 2)
);
go
create trigger TriggerOfCheckReturnDate
on ReturnedBooks
instead of insert
as
    declare @UserSSN int;
    declare @BookID int;
    declare @DueDate date;
    declare @ReturnDate date;
    declare @Fees decimal(10, 2);
    declare @NewFees decimal(10, 2);

    -- Get the inserted values
    select @UserSSN = User_SSN,@BookID = Book_Id,@DueDate = Due_date,@ReturnDate = return_date,@Fees = fees
    from inserted;

    -- Check if the return date is after the due date
    if @ReturnDate > @DueDate
        set @NewFees = @Fees * 0.20;
    else
        set @NewFees = 0.00;
    -- Insert the record into the table with the calculated fee
    insert into ReturnedBooks (User_SSN, Book_Id, Due_date, return_date, fees)
    Values (@UserSSN, @BookID, @DueDate, @ReturnDate, @NewFees);





 --29.In the Floor table insert new Floor With Number of blocks 2 , 
 --employee with SSN = 20 as a manager for this Floor,The start date for this manager is Now.
 --Do what is required if you know that : Mr.Omar Amr(SSN=5) moved to be the manager of the new Floor (id = 6),
 --and they give Mr. Ali Mohamed(his SSN =12) His position . {3 Points}
-- frist insert the new floor with id = 6
insert into Floor 
values (6,2, 20, GETDATE());
-- second move Ali Mohamed to be the manager instead of Mr.Omar Amr in floor with id = 4
update Floor 
set MG_ID = 12, Hiring_Date = GETDATE()
where Number = 6;
-- third move Mr.Omar Amr to be Manager of new floor
update Floor 
set MG_ID = 5, Hiring_Date = GETDATE()
where Number = 6;

-------------------------------------------------------------------------------------------------------------------
--30.Create view name (v_2006_check) that will display Manager id, Floor 
--Number where he/she works , Number of Blocks and the Hiring Date 
--which must be from the first of March and the end of May 2022.this view 
--will be used to insert data so make sure that the coming new data must 
--match the condition then try to insert this 2 rows and
--Mention What will happen {3 Point}
--Employee Id Floor Number Number of Blocks Hiring Date
--2 6 2 7-8-2023
--4 7 1 4-8-2022
go
create view v_2006_check
as
	select  MG_ID as ManagerID,
			Number as FloorNumber,
			Num_blocks as NumberOfBlocks,
			Hiring_Date as HiringDate
	from Floor
	where 
		Hiring_Date between '2022-03-01' and '2022-05-31'
	with check option;

insert into v_2006_check 
values (2, 6, 2, '2023-07-08');
/*Violation of PRIMARY KEY constraint 'PK_Floor'.
Cannot insert duplicate key in object 'dbo.Floor'. The duplicate key value is (6).The statement has been terminated.*/

insert into v_2006_check 
values (4, 7, 1, '2022-04-08'); -- (1 row affected)
 


--31.Create a trigger to prevent anyone from Modifying or Delete or Insert in 
--the Employee table ( Display a message for user to tell him that he can’t 
--take any action with this Table) {3 Point}
go
create trigger Preventtrigger
on Employee
instead of insert , delete , update
as select 'you can not Modifying , Delete or Insert on this table '

------------------------------------------------------------------------------------------------------------
--32.Testing Referential Integrity , Mention What Will Happen When:
--A. Add a new User Phone Number with User_SSN = 50 in
--User_Phones Table {1 Point}
 insert into User_phones 
values(50,'01069115145') 
/*The INSERT statement conflicted with the FOREIGN KEY constraint "FK_User_phones_User".
The conflict occurred in database "Library", table "dbo.Users", column 'SSN'.The statement has been terminated.*/
/****Note that there is no user has the id = 50 so we want to insert it frist then insert our user phone*/
insert into Users (SSN,User_Name,Emp_id)
values (50,'Abd0',2)
--then
insert into User_phones 
values(50,'01069115145') -- now it work 

--B. Modify the employee id 20 in the employee table to 21 {1 Point}
update Employee
set Id = 21
where Id = 20  -- you can not Modifying , Delete or Insert on this table 

--C. Delete the employee with id 1 {1 Point}
delete from Employee 
where Id = 1     -- you can not Modifying , Delete or Insert on this table 

--D. Delete the employee with id 12 {1 Point}
delete from Employee 
where Id = 12    -- you can not Modifying , Delete or Insert on this table 


--E. Create an index on column (Salary) that allows you to cluster the 
--data in table Employee. {1 Point}
go
create clustered index indx_salary
ON Employee(Salary); --The operation failed because an index or statistics with name 'indx_salary' already exists on table 'Employee'.

-------------------------------------------------------------------------------------------------------------------------
--33.Try to Create Login With Your Name And give yourself access Only to 
--Employee and Floor tables then allow this login to select and insert data 
--into tables and deny Delete and update (Don't Forget To take screenshot 
--to every step) {5 Points}
---------------------------------------------------------------------------------------------------------------------
--Noteeeeeeeeeee :> answer of Q-33 in photos in folder 