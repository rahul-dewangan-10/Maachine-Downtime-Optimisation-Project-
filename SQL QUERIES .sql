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


-- trying to find the range for each perameter with most percentage of machine failures 
select max(`Spindle_Vibration(Âµm)`) from md_data 
select min(`Spindle_Vibration(Âµm)`) from md_data 
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

SELECT * FROM md_data

SELECT 
    COUNT(*) AS total_failures,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN -14.326454 AND 101.184167 THEN 1 ELSE 0 END) AS hydraulic_pressure_failures,
    SUM(CASE WHEN `Coolant_Pressure(bar)` BETWEEN 0.325 AND 4.955532 THEN 1 ELSE 0 END) AS coolant_pressure_failures,
    SUM(CASE WHEN `Air_System_Pressure(bar)` BETWEEN 5.063480 AND 6.499094 THEN 1 ELSE 0 END) AS air_system_pressure_failures,
    SUM(CASE WHEN `Coolant_Temperature` BETWEEN 4.100000 AND 18.518774 THEN 1 ELSE 0 END) AS coolant_temperature_failures,
    SUM(CASE WHEN `Hydraulic_Oil_Temperature(Â°C)` BETWEEN 35.200000 AND 47.616422 THEN 1 ELSE 0 END) AS hydraulic_oil_temperature_failures,
    SUM(CASE WHEN `Spindle_Bearing_Temperature(Â°C)` BETWEEN 22.600000 AND 35.064763 THEN 1 ELSE 0 END) AS spindle_bearing_temperature_failures,
    SUM(CASE WHEN `Spindle_Vibration(Âµm)` BETWEEN -0.461000 AND 1.007646 THEN 1 ELSE 0 END) AS spindle_vibration_failures,
    SUM(CASE WHEN `Tool_Vibration(Âµm)` BETWEEN 3.469000 AND 25.415098 THEN 1 ELSE 0 END) AS tool_vibration_failures,
    SUM(CASE WHEN `Spindle_Speed(RPM)` BETWEEN 0.000000 AND 20271.568249 THEN 1 ELSE 0 END) AS spindle_speed_failures,
    SUM(CASE WHEN `Voltage(volts)` BETWEEN 202.000000 AND 349.101638 THEN 1 ELSE 0 END) AS voltage_failures,
    SUM(CASE WHEN `Torque(Nm)` BETWEEN 0 AND 25.196960 THEN 1 ELSE 0 END) AS torque_failures,
    SUM(CASE WHEN `Cutting(kN)` BETWEEN 1.800000 AND 2.785586 THEN 1 ELSE 0 END) AS cutting_failures
FROM md_data
WHERE downtime = 'machine_failure';


SELECT 
    COUNT(*) AS total_failures,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN -14.326454 AND 101.184167 THEN 1 ELSE 0 END) AS hydraulic_pressure_failures,
    SUM(CASE WHEN `Coolant_Pressure(bar)` BETWEEN 0.325 AND 4.955532 THEN 1 ELSE 0 END) AS coolant_pressure_failures,
    SUM(CASE WHEN `Air_System_Pressure(bar)` BETWEEN 5.063480 AND 6.499094 THEN 1 ELSE 0 END) AS air_system_pressure_failures,
    SUM(CASE WHEN `Coolant_Temperature` BETWEEN 4.100000 AND 18.518774 THEN 1 ELSE 0 END) AS coolant_temperature_failures,
    SUM(CASE WHEN `Hydraulic_Oil_Temperature(Â°C)` BETWEEN 35.200000 AND 47.616422 THEN 1 ELSE 0 END) AS hydraulic_oil_temperature_failures,
    SUM(CASE WHEN `Spindle_Bearing_Temperature(Â°C)` BETWEEN 22.600000 AND 35.064763 THEN 1 ELSE 0 END) AS spindle_bearing_temperature_failures,
    SUM(CASE WHEN `Spindle_Vibration(Âµm)` BETWEEN -0.461000 AND 1.007646 THEN 1 ELSE 0 END) AS spindle_vibration_failures,
    SUM(CASE WHEN `Tool_Vibration(Âµm)` BETWEEN 3.469000 AND 25.415098 THEN 1 ELSE 0 END) AS tool_vibration_failures,
    SUM(CASE WHEN `Spindle_Speed(RPM)` BETWEEN 0.000000 AND 20271.568249 THEN 1 ELSE 0 END) AS spindle_speed_failures,
    SUM(CASE WHEN `Voltage(volts)` BETWEEN 202.000000 AND 349.101638 THEN 1 ELSE 0 END) AS voltage_failures,
    SUM(CASE WHEN `Torque(Nm)` BETWEEN 0 AND 25.196960 THEN 1 ELSE 0 END) AS torque_failures,
    SUM(CASE WHEN `Cutting(kN)` BETWEEN 1.800000 AND 2.785586 THEN 1 ELSE 0 END) AS cutting_failures
FROM md_data
WHERE downtime = 'no_machine_failure';


-- for perameters in their minimum to avg range
-- total_failures, hydraulic_pressure_failures, coolant_pressure_failures, air_system_pressure_failures, coolant_temperature_failures, hydraulic_oil_temperature_failures, spindle_bearing_temperature_failures, spindle_vibration_failures, tool_vibration_failures, spindle_speed_failures, voltage_failures, torque_failures, cutting_failures
-- machine_filure case = '1231', '1046', '841', '605', '510', '621', '619', '637', '623', '634', '637', '737', '578' ;
-- no machine failure case = '1150', '289', '362', '573', '524', '568', '558', '556', '565', '591', '568', '574', '628' ;


-- for  perameters when their range is between mean and maximum 
-- total_failures, hydraulic_pressure_failures, coolant_pressure_failures, air_system_pressure_failures, coolant_temperature_failures, hydraulic_oil_temperature_failures, spindle_bearing_temperature_failures, spindle_vibration_failures, tool_vibration_failures, spindle_speed_failures, voltage_failures, torque_failures, cutting_failures
-- Machine failure case = '1231', '185', '390', '626', '721', '610', '612', '594', '608', '597', '594', '494', '653';
-- No machine failure case = '1150', '861', '788', '577', '626', '582', '592', '594', '585', '559', '582', '576', '522';



-- finding range of hydrolic pressure whith most %age of machine failures
SELECT 
    count(*) as total_failures_hydrolic_pressure,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 50 AND 100 THEN 1 ELSE 0 END) AS in_range_50_to_100,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 100 AND 150 THEN 1 ELSE 0 END) AS in_range_100_to_150,
	SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 150 AND 200 THEN 1 ELSE 0 END) AS in_range_150_to_200
 from md_data
 
union all 

SELECT 
    count(*) as total_failures_hydrolic_pressure,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 50 AND 100 THEN 1 ELSE 0 END) AS in_range_50_to_100,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 100 AND 150 THEN 1 ELSE 0 END) AS in_range_100_to_150,
	SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 150 AND 200 THEN 1 ELSE 0 END) AS in_range_150_to_200
 from md_data as machine_failure
 where downtime = "machine_failure"

  
union all 
SELECT 
    count(*) as total_failures_hydrolic_pressure,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 50 AND 100 THEN 1 ELSE 0 END) AS in_range_50_to_100,
    SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 100 AND 150 THEN 1 ELSE 0 END) AS in_range_100_to_150,
	SUM(CASE WHEN `Hydraulic_Pressure(bar)` BETWEEN 150 AND 200 THEN 1 ELSE 0 END) AS in_range_150_to_200
 from md_data as no_machine_failure
 where downtime = "no_machine_failure";
