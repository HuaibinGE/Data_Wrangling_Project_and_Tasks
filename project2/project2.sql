select * into hge.Phonecall from Phonecall

select * from hge.Phonecall

alter table hge.Phonecall add Enrollment_group nvarchar(100)

update hge.Phonecall set Enrollment_group = 'Clinical Alert' 
where EncounterCode = 125060000

update hge.Phonecall set Enrollment_group = 'Health Coaching' 
where EncounterCode = 125060001

update hge.Phonecall set Enrollment_group = 'Technixal' 
where EncounterCode = 125060002

update hge.Phonecall set Enrollment_group = 'Administrative' 
where EncounterCode = 125060003

update hge.Phonecall set Enrollment_group = 'Other' 
where EncounterCode = 125060004

update hge.Phonecall set Enrollment_group = 'Lack of engagement' 
where EncounterCode = 125060005

select * from hge.Phonecall




select count (Enrollment_group) [Clinical Alert] from hge.Phonecall
where Enrollment_group = 'Clinical Alert' 

select count (Enrollment_group) [Health Coaching] from hge.Phonecall
where Enrollment_group = 'Health Coaching' 

select count (Enrollment_group) [Technixal] from hge.Phonecall
where Enrollment_group = 'Technixal' 

select count (Enrollment_group) [Administrative] from hge.Phonecall
where Enrollment_group = 'Administrative' 

select count (Enrollment_group) [Other] from hge.Phonecall
where Enrollment_group = 'Other' 

select count (Enrollment_group) [Lack of engagement] from hge.Phonecall
where Enrollment_group = 'Lack of engagement' 


select * into hge.Callduration from Callduration

select * from hge.Callduration
select * from hge.Phonecall

select * into hge.Phonecall_Callduration from hge.Phonecall 
Inner Join hge.Callduration
on hge.Phonecall.CustomerId = hge.Callduration.tri_CustomerIDEntityReference

select * from hge.Phonecall_Callduration


alter table hge.Phonecall_Callduration add Call_outcomes nvarchar(100)

update hge.Phonecall_Callduration set Call_outcomes = 'No response'
where CallOutcome = 1

update hge.Phonecall_Callduration set Call_outcomes = 'Left voice mail'
where CallOutcome = 2

update hge.Phonecall_Callduration set Call_outcomes = 'Successful'
where CallOutcome = 3





alter table hge.Phonecall_Callduration add Call_type nvarchar(100)

update hge.Phonecall_Callduration set Call_type = 'Inbound' 
where CallType = 1

update hge.Phonecall_Callduration set Call_type = 'Outbound' 
where CallType = 2

select * from hge.Phonecall_Callduration



select count (Call_type) Inbound from hge.Phonecall_Callduration
where Call_type = 'Inbound'

select count (Call_type) Outbound from hge.Phonecall_Callduration
where Call_type = 'Outbound'


select count (Call_outcomes) [No response] from hge.Phonecall_Callduration
where Call_outcomes = 'No response'

select count (Call_outcomes) [Left voice mail] from hge.Phonecall_Callduration
where Call_outcomes = 'Left voice mail'

select count (Call_outcomes) Successful from hge.Phonecall_Callduration
where Call_outcomes = 'Successful'






select * from hge.Phonecall_Callduration

select sum (CallDuration) [Clinical Alert] from hge.Phonecall_Callduration
where [Enrollment_group] = 'Clinical Alert'

select sum (CallDuration) [Health Coaching] from hge.Phonecall_Callduration
where [Enrollment_group] = 'Health Coaching'

select sum (CallDuration) [Technixal] from hge.Phonecall_Callduration
where [Enrollment_group] = 'Technixal'

select sum (CallDuration) [Administrative] from hge.Phonecall_Callduration
where [Enrollment_group] = 'Administrative'

select sum (CallDuration) [Other] from hge.Phonecall_Callduration
where [Enrollment_group] = 'Other'

select sum (CallDuration) [Lack of Engagement] from hge.Phonecall_Callduration
where [Enrollment_group] = 'Lack of Engagement'



--5
select * into hge.DCT from Demographics 
Inner Join ChronicConditions
on [contactid] = [tri_patientid] 
inner join 
Text 
on [tri_patientid] = [tri_contactId]



select * from hge.DCT

select SenderName, datediff(wk, MIN(hge.DCT.TextSentDate), MAX(hge.DCT.TextSentDate)) as 'week'
from hge.DCT
group by SenderName

select Sendername, COUNT(*) AS 'texts' from TEXT
where TextSentDate is not NULL
group by SenderName


--6
select * from hge.DCT
select tri_name, COUNT(*) SentTexts,
datediff(wk, MIN(hge.DCT.TextSentDate), MAX(hge.DCT.TextSentDate)) week
from hge.DCT
where TextSentDate is not NULL
group by tri_name
order by tri_name
