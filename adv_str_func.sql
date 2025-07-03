-------------------------------SOME ADVANCED STRING FUNCTIONS-----------------------------------

CREATE TABLE Employees1 (
    EmpID INT,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    Department VARCHAR(50),
    Address VARCHAR(200),
    PhoneNumbers VARCHAR(100),
    Salary VARCHAR(20)
);

INSERT INTO Employees1 VALUES
(1, 'Amit Sharma', 'amit.sharma@abc.com', 'Sales', '221B Baker Street, London', '9876543210,8765432109', '50000'),
(2, 'Sneha Kapoor', 'sneha.kapoor@xyz.com', 'HR', 'MG Road, Bengaluru', '9123456780', 'not disclosed'),
(3, 'Ravi Verma', 'ravi_verma123@abc.com', 'Tech', 'Sector 45, Noida', '9988776655,8877665544', '60000'),
(4, 'Priya Das', 'priya.d@xyz.com', 'Marketing', 'Powai, Mumbai', '8877001122', '53000'),
(5, 'John Abraham', 'john.abraham@abc.com', 'Tech', 'Silicon Valley, CA', '7000123456', '70000');

select * from Employees1;


--1. Find the position of `'@'` in each employee's email.
select email, CHARINDEX('@', email) as  position from Employees1;

--2. Find employees whose first name starts before position 6 in their full name.
select FullName as firstname from Employees1
where CHARINDEX(' ',FullName) < 6;

--3. Extract domain names (after '@') using `CHARINDEX`.****
select empid, email, substring(email, charindex('@', email) + 1, len(email)) as domain from Employees1;

--4. Find if `'.com'` exists in email and at what position.
select email, CHARINDEX('.com',Email) as position from Employees1;

--5. Return the part of `FullName` before the space using `CHARINDEX` and `SUBSTRING`.***
select FullName, substring(FullName, 1, CHARINDEX(' ',FullName)-1) as firstname from Employees1;


--1. Find position of numbers in the `Email` using `PATINDEX('%[0-9]%', Email)`.
select email, PATINDEX('%[0-9]%', email) from Employees1;

--2. Find employees with numeric data in their `Department` name.
select fullname,Department from Employees1 Where PATINDEX('%[0-9]%',Department) > 0

--3. Extract numeric starting positions in `PhoneNumbers` using `PATINDEX`.
select empid, phonenumbers, 
patindex('%[0-9]%', phonenumbers) as number_start from Employees1;


--4. Use `PATINDEX` to check if address contains word starting with 'S'.
select Address, PATINDEX('s%', lower(Address)) as start_with_s from employees1;

--5. Identify records where `FullName` contains capital letters only at the beginning.
select * from employees1 where
PATINDEX('[A-Z]%', FullName) = 1;


--1. Split `PhoneNumbers` using `CROSS APPLY STRING_SPLIT` and list one per row.
select e.empid, value as phone_number
from Employees1 e
cross apply string_split(e.phonenumbers, ',');

--2. Return length of each word in `FullName` using `CROSS APPLY`.
select empid, value as word, len(value) as word_length
from employees1
cross apply string_split(FullName, ' ');

--3. Use `CROSS APPLY` to extract first and last name separately.
select empid,
left(FullName, CHARINDEX(' ', FullName) - 1) as firstname,
RIGHT(FullName, len(fullname) - CHARINDEX(' ', FullName)) as lastname
from employees1

--4. Count how many phone numbers each employee has using `CROSS APPLY STRING_SPLIT`.
select empid, count(value) as phone_count
from Employees1
cross apply  string_split(PhoneNumbers, ',')
group by EmpID;

--5. Return each address word separately using `CROSS APPLY`.
select empid, value as address_word
from Employees1
cross apply string_split(Address, ' ')


--1. Split `PhoneNumbers` into separate rows.
select empid, value as phone
from employees1
cross apply string_split(PhoneNumbers, ',');

--2. Count total words in the `Address`.
select empid, count(value) as word_count
from employees1
cross apply string_split(address, ' ')
group by EmpID;


--3. Return first name and last name separately using `STRING_SPLIT`.
select empid, value as name_part
from employees1
cross apply string_split(FullName, ' ');

--4. Split email at `@` and return username.
select empid, email, value as username
from employees1
cross apply string_split(email, '@');

--5. Count total characters in each word of Address using `LEN` with `STRING_SPLIT`.
select empid, len(value) char_count
from employees1
cross apply string_split(address, ' ')


--1. Combine all `Email` values into a comma-separated string.
select STRING_AGG(email, ',') all_emails
from Employees1;

--2. Show a list of all departments separated by `|`.
select STRING_AGG(Department, '|') all_depts
from Employees1;

--3. For each department, return comma-separated names of employees.
select department, STRING_AGG(FullName, ', ') all_emps
from Employees1
group by Department;

--4. Combine all employee phone numbers into a string.
select STRING_AGG(PhoneNumbers, '; ') all_phones
from Employees1;

--5. Return list of unique email domains (hint: use substring + `STRING_AGG`).
select STRING_AGG(substring(email, CHARINDEX('@',Email) + 1, LEN(email)), ',') domains
from Employees1;

--1. Convert `Salary` to INT using `TRY_CAST` and return result.
select *, try_cast(salary as int) as cast_sal
from Employees1;
--2. Identify employees whose salary is not a number using `TRY_CAST`.**


--3. Show sum of salaries after converting.
with c as(
select *, try_cast(salary as int) as cast_sal
from Employees1)
select sum(cast_sal) from c;

--4. Show original and converted salary side-by-side.
select salary as org_salary, try_cast(salary as int) as casted_salary
from Employees1;
--5. Use `TRY_CAST` to convert string literals like `'123.45'`, `'ABC'` to FLOAT.
select try_cast('123' as float ) as literal_conversion;

--1. Extract first name from `FullName`.
select substring(fullname, 1, charindex(' ', fullname) -1) as firstname from employees1;

--2. Extract domain from `Email` after `@`.
select SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) from Employees1;

--3. Show first 10 characters of Address.
select substring(address,1, 10) from employees1;

--4. Return 3 characters starting from 2nd position in `Department`
select department, substring(Department,2, 3) from employees1;

--5. Extract phone number prefixes (first 4 digits) from each number using `SUBSTRING` and `STRING_SPLIT`
select empid, substring(value,1,4) as first_four_digs
from Employees1
cross apply string_split(phoneNumbers, ',');