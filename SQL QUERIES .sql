use INTERN_PROJECT

SELECT * FROM md_data

SELECT COUNT(*) AS total_rows FROM mD_data;


-- how many diffrent machines and assembly lines are there
SELECT 
    COUNT(DISTINCT Machine_ID) AS distinct_machines, 
    COUNT(DISTINCT Assembly_Line_No) AS distinct_assembly_lines 
FROM mD_data;




-- finding missing values 
SELECT column_name, data_type, COUNT(CASE WHEN column_name IS NULL THEN 1 END) AS missing_values 
FROM information_schema.columns 
WHERE table_name = 'md_data' 
GROUP BY column_name, data_type;



-- finding mode for machine id
SELECT Machine_ID, COUNT(*) as count
FROM md_data
GROUP BY Machine_ID
ORDER BY count(*) desc;

-- finding mode for assembly line 
SELECT Assembly_Line_No, COUNT(*) as count
FROM md_data
GROUP BY Assembly_Line_No
ORDER BY count(*) desc;


-- for downtime
SELECT downtime, COUNT(*) as count
FROM md_data
GROUP BY downtime
ORDER BY count(*) desc;
 

-- looking for dates of most frequent downtime
SELECT date, COUNT(*) AS count_per_date FROM md_data  GROUP BY (Date) order by count_per_date desc;
SELECT date, COUNT(*) AS count_per_date FROM md_data where downtime = "machine_failure"  GROUP BY (Date) order by count_per_date desc;
SELECT date, COUNT(*) AS count_per_date FROM md_data where downtime = "no_machine_failure"  GROUP BY (Date) order by count_per_date desc;


-- which machine is having most frequent downtimes 
SELECT Machine_ID, COUNT(*) AS count_per_machine FROM md_data  GROUP BY Machine_ID;
SELECT Machine_ID, COUNT(*) AS count_per_machine FROM md_data where downtime = "no_machine_failure" GROUP BY Machine_ID;
SELECT Machine_ID, COUNT(*) AS count_per_machine FROM md_data where downtime = "machine_failure" GROUP BY Machine_ID;

-- which assembly lines are having most frequent downtimes 
SELECT Assembly_Line_No, COUNT(*) AS count_per_assembly_line FROM md_data where  downtime = "No_machine_failure" GROUP BY Assembly_Line_No;

-- how many downtimes are due to machine failiure and without machine failure
SELECT Downtime, COUNT(*) AS count_per_downtime FROM md_data GROUP BY Downtime;

select * from md_data

-- finding min,max,avg for hydrolic pressure
SELECT
  machine_id,
  MIN(`Hydraulic_Pressure(bar)`) AS min_value,
  MAX(`Hydraulic_Pressure(bar)`) AS max_value,
  AVG(`Hydraulic_Pressure(bar)`) AS avg_value
FROM md_data
where downtime = "No_machine_failure"
group by machine_id;




SELECT substr(date,7,4), COUNT(*) AS count_per_date FROM md_data   GROUP BY Date order by date;


SELECT Date, Machine_ID, COUNT(*) AS count_per_machine
FROM md_data
WHERE downtime = "machine_failure" 
AND MONTH(Date) IN (2, 3, 4)  -- Filter for March, April, Feb
GROUP BY MONTH(Date), Machine_ID
ORDER BY count_per_machine DESC;

SHOW COLUMNS FROM md_data;

 
use intern_project 
select * from md_data

ALTER TABLE md_data
ADD downtime_num INT AS (
  CASE WHEN downtime = 'machine_failure' THEN 1
       ELSE 0
  END
);


-- have already did same calculation for spindle speed(rpm)
select max(`Spindle_Vibration(Âµm)`) from md_data 
select count(*) from md_data where `Spindle_Vibration(Âµm)` >0 and  `Spindle_Vibration(Âµm)` <0.3  and downtime = "machine_failure"; 
-- out of 1231 failures,(no. of failures)  when spindle vibration is between() ,
-- 0 out of 1 when -0.5 to 0 (safe range but not feasible),   
--  (95 out of 162 when 0 to 0.5) -> failure rate 58.6 %,  	
-- (528 out of 1008 when 0.5 to 1) -> failure rate 52.38, 		 
-- 516 out of  1033 when 1 to 1.5) -> failure rate 49.95 %,            
-- 90 out of 173 when 1.5 to 2.5(maybe less data availible) 52 %.

-- 0 to 0.3 62% failure rate
-- 1.9 above 62% failure rate

select count(*) from md_data where `Spindle_Vibration(Âµm)` >0 and  `Spindle_Vibration(Âµm)` <0.3; 

select count(*) from md_data where  downtime = "machine_failure";

select sum(downtime_num) from md_data -- this will give number of times the machine failed

select sum(downtime_num) from md_data where  `Spindle_Vibration(Âµm)` >0 and  `Spindle_Vibration(Âµm)` <25300;

select sum(downtime_num) from md_data where`Spindle_Vibration(Âµm)`> 25100;


