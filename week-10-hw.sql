-- Stored procedure to see how old an employee is. Takes the employee number, 
-- grabs their birth date and subracts from the current year to get their age.

drop procedure if exists how_old;
delimiter $$
create procedure how_old (
	in employee_number int,
	out how_old int
)
begin
	declare birth_year int;
	declare current_year int;

	select year(e.birth_date), year(now())
	into birth_year, current_year
	from employees e
	where e.emp_no = employee_number
	limit 1;

	select current_year - birth_year into how_old;
end $$
delimiter ;

call how_old(10007, @years);
select @years;

-- Stored procedure to see if someone is at retirement age. Takes the employee number, 
-- calls the above stored procedure and compares it to 64 which I think is retirement age?

drop procedure if exists retire_time;
delimiter $$
create procedure retire_time (
	in employee_number int
)
begin
	declare retire_status varchar(20);

	call how_old(employee_number, @years);

	if @years < 64 then
		set retire_status = 'no';
	elseif @years = 64 then
		set retire_status = 'get ready to retire';
	else
		set retire_status = 'time to go';
	end if;
	
	select @years as age, retire_status
	limit 1;
end $$
delimiter ;

call retire_time(10007);

-- Stored procedure that does an inner join. Takes the employee number, 
-- grabs their name and then skips over to the salary table to display that as well.

drop procedure if exists persons_salary;
delimiter $$
create procedure persons_salary (
	in employee_number int
)
begin
	select e.first_name, e.last_name, s.salary 
	from employees e
	inner join salaries s on s.emp_no = e.emp_no
	where e.emp_no = employee_number
	limit 1;
end $$
delimiter ;

call persons_salary(10007);

-- Stored procedure for discerning gender for correct pronouns. Takes the employee number, 
-- grabs their name and combines it then sees if they are male or female for the correct pronoun usage.

drop procedure if exists emp_info;
delimiter $$
create procedure emp_info (
	in employee_number int
)
begin
	declare full_name varchar(90);
	declare gender char(1);

	select concat(e.first_name, ' ', e.last_name), e.gender 
	into full_name, gender
	from employees e
	where e.emp_no = employee_number
	limit 1;

	if gender = 'M' then
		select concat(full_name, '; he has an excellent record.');
	else
		select concat(full_name, '; she has an excellent record.');
	end if;
end $$
delimiter ;

call emp_info(10007);

-- Stored procedure that does 2 inner joins. Kind of drawing blanks on what else to do.
-- Takes the employee number, grabs their first name and then skips over to their department.

drop procedure if exists emp_of_type;
delimiter $$
create procedure emp_of_type (
	in employee_number int
)
begin
	select concat(e.first_name, ' in ', d.dept_name, ' deserves a raise.') 
	from departments d 
	inner join dept_emp de on de.dept_no = d.dept_no
	inner join employees e on e.emp_no = de.emp_no 
	where e.emp_no = employee_number
	limit 1;
end $$
delimiter ;

call emp_of_type(10007);
