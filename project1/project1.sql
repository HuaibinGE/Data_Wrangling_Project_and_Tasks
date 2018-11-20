--1
select * into hge.Demographics from Demographics
EXEC sp_RENAME "[hge].[Demographics].[tri_age]", "Age", "COLUMN"
EXEC sp_RENAME "[hge].[Demographics].[gendercode]", "Gender",
"COLUMN"
EXEC sp_RENAME "[hge].[Demographics].[contactid]", "ID",
"COLUMN"
EXEC sp_RENAME
"[hge].[Demographics].[address1_stateorprovince]", "State",
"COLUMN"
EXEC sp_RENAME
"[hge].[Demographics].[tri_imaginecareenrollmentemailsentdate]",
"EmailSentdate", "COLUMN"
EXEC sp_RENAME
"[hge].[Demographics].[tri_enrollmentcompletedate]",
"Completedate", "COLUMN"
alter table hge.Demographics add date_days nvarchar(100)
update hge.Demographics set date_days = datediff(day,
try_convert(date, [EmailSentdate]),
try_convert(date, [Completedate])) from hge.Demographics
select date_days from hge.Demographics

--2
alter table hge.Demographics add Enrollment_Status nvarchar
(100)
update hge.Demographics set Enrollment_Status = 'Complete'
where [tri_imaginecareenrollmentstatus] = 167410011
update hge.Demographics set Enrollment_Status = 'Email sent'
where [tri_imaginecareenrollmentstatus] = 167410001
update hge.Demographics set Enrollment_Status = 'Non responder'
where [tri_imaginecareenrollmentstatus] = 167410004
update hge.Demographics set Enrollment_Status = 'Facilitated
Enrollment'
where [tri_imaginecareenrollmentstatus] = 167410005
update hge.Demographics set Enrollment_Status = 'Incomplete
Enrollments'
where [tri_imaginecareenrollmentstatus] = 167410002
update hge.Demographics set Enrollment_Status = 'Opted Out'
where [tri_imaginecareenrollmentstatus] = 167410003
update hge.Demographics set Enrollment_Status = 'Unprocessed'
where [tri_imaginecareenrollmentstatus] = 167410000
update hge.Demographics set Enrollment_Status = 'Second email
sent'
where [tri_imaginecareenrollmentstatus] = 167410006


--3
alter table hge.Demographics add Sex nvarchar (100)
update hge.Demographics set Sex = 'female'
where Gender = '2'
update hge.Demographics set Sex = 'male'
where Gender = '1'
update hge.Demographics set Sex = 'other'
where Gender = '167410000'
update hge.Demographics set Sex = 'Unknown'
where Gender = 'NULL'


--4
alter table hge.Demographics add Age_group nvarchar (100)
update hge.Demographics set Age_group = '0-25'
where Age >= 0 and Age < 26
update hge.Demographics set Age_group = '26-50'
where Age >= 26 and Age < 51
update hge.Demographics set Age_group = '51-75'
where Age >= 51 and Age < 76
update hge.Demographics set Age_group = '76-100'
where Age >= 76 and Age < 101
update hge.Demographics set Age_group = '101-125'
where Age >= 101 and Age < 125
select top 10* from hge.Demographics
ORDER by newid()