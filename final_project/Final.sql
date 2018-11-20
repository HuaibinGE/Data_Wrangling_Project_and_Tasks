--a
SELECT * into hge.IC from qbs181.hge.IC_BP
EXEC sp_RENAME '[hge].[IC].[BPAlerts]', 'BP status', 'COLUMN'
select top 10* from hge.IC




--b
-- Create a new column called Control_Uncontrol to record 
-- controlled and uncontroled blood pressure

ALTER TABLE hge.IC add Control_Uncontrol INT
UPDATE hge.IC set Control_Uncontrol = '1'
WHERE [BP status] = 'Hypo1'
update hge.IC set Control_Uncontrol = '1'
WHERE [BP status] = 'Normal'
update hge.IC set Control_Uncontrol = '0'
WHERE [BP status] = 'Hypo2'
update hge.IC set Control_Uncontrol = '0'
WHERE [BP status] = 'HTN1'
update hge.IC set Control_Uncontrol = '0'
WHERE [BP status] = 'HTN2'
update hge.IC set Control_Uncontrol = '0'
WHERE [BP status] = 'HTN3'
select top 10* from hge.IC

--c
-- Merge table hge.IC1 and Demographics to obtain
-- enrollment date:tri_enrollmentcompletedate
SELECT top 10* from Demographics
SELECT A.*, Demographics.tri_enrollmentcompletedate into hge.IC1 from Demographics 
Inner JOIN hge.IC A on Demographics.[contactid] = A.[ID]
select top 10* from hge.IC1


--d
-- Week interval record which week that they receive respection of blood pressure
ALTER TABLE hge.IC1 add Week_interval INT
UPDATE hge.IC1 set Week_interval = datediff(week, try_convert(date, tri_enrollmentcompletedate), ObservedTime)
select top 10* from hge.IC1

--The Averaged_score calculated are integer due to Control_Uncontrol are integer as well. 
-- If change Control_Uncontrol as float, Averaged_score can be calculated in decimals. 
-- The reason why I didn't do that because I think decimals in Averaged_scorefor BPstatus 
-- is hard to understand whether it is control or uncontrol. 
-- And Averaged_score in integer 1 means the people is more inclined to control.
-- And Averaged_score in integer 0 means the people is more inclined to uncontrol.
-- I think it is more easily to understand in this way. 
select ID, Week_interval, AVG(Control_Uncontrol) as Averaged_score into hge.IC5
from ( select * from hge.IC1 
-- select week from 0 to 12
where Week_interval <=12 and Week_interval >=0) m
group by ID, Week_interval
order by ID, Week_interval
select top 10* from hge.IC5


--e. Compare the scores from baseline (first week) to follow-up scores (12 weeks)

select ID, Week_interval from hge.IC5
where Week_interval = 0 or Week_interval = 12

-- Total number of scores in baseline
select count (Week_interval) from hge.IC5
where Week_interval = 0

-- Total number of scores in week 12
select count (Week_interval) from hge.IC5
where Week_interval = 12


--f

-- hge.IC2 represents people who are uncontrolled at baseline
select ID, Week_interval, Control_Uncontrol into hge.IC2 from hge.IC1
where Week_interval = 0 and Control_Uncontrol = 0


-- hge.IC3 represents people who are controlled at week 12
select ID, Week_interval, Control_Uncontrol into hge.IC3 from hge.IC1
where Week_interval = 12 and Control_Uncontrol = 1

-- Merge hge.IC2 and hge.IC3 together to find people who uncontrolled at baseline
-- and then convert to be controlled at week 12
SELECT hge.IC2.* into hge.IC4
from hge.IC2
Inner JOIN hge.IC3 on hge.IC2.ID = hge.IC3.ID

-- Use distinct to eliminate repeated ID in hge.IC4 
-- in order to get the actual number
select distinct ID from hge.IC4
--5 customers were brought from uncontrolled regime to
--controlled regime after 12 weeks of intervention
















--2
--Merge the tables Demographics, Chronic Conditions and TextMessages together
select * into hge.DCT1 from Demographics 
Inner Join ChronicConditions
on [contactid] = [tri_patientid] 
inner join 
Text 
on [tri_patientid] = [tri_contactId]

-- Inner join hge.DCT1 with tm whose 1 Row per ID by choosing on the
-- latest text sent date to form hge. DCT2
select * into hge. DCT2 from hge.DCT1 t
inner join (
-- 1 Row per ID by choosing on the
-- latest text sent date
    select tri_contactId, max(TextSentDate) as MaxDate
    from Text
    group by tri_contactId
) tm
on t.[contactid] = tm.[tri_contactId] and t.[TextSentDate] = tm.[MaxDate]
SELECT top 10* from hge. DCT2









