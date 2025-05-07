create database M_Analytics;
use M_Analytics;

select * from manufacture_analytics;

select count(*) from  manufacture_analytics;





# 1. Manufacture Qty(KPI)
select sum(Manufactured_Qty)As Manufacture_Qty from  manufacture_analytics;


# 2.Rejected Qty (KPI)
select sum(Rejected_Qty) As Rejected_QTY from manufacture_analytics;

#3.Processed_Qty(KPI)
select sum(Processed_Qty) As Process_QTY from manufacture_analytics;


# 4.Wastage_Qty(KPI)
SELECT sum(WO_QTY) AS Wastage_Qty from manufacture_analytics;

# 5. Employee Wise Rejected Qty 

select  emp_name from manufacture_analytics;
#Without Joins
SELECT emp_name ,SUM(rejected_qty) AS rejected_qty
FROM manufacture_analytics group by 1;
#With Joins 
select e.emp_name,e.emp_code,
sum(e1.rejected_Qty) As rejected_Qty
from manufacture_analytics e 
left join manufacture_analytics as e1 on e.emp_name = e1.emp_name group by 1,2;


# 6 . Machine wise Rejected_Quantity
#Without join by using  aggregated function
select Machine_Code,Machine_Name ,sum(rejected_qty)  As R_Qty
from manufacture_analytics group by 1,2 order by   sum(rejected_qty) desc ;
#With Join 
select m. Machine_Code,m.Machine_Name,sum(m1.rejected_qty) as Rejected_Qty
from manufacture_analytics m inner join manufacture_analytics as m1 on 
m.Machine_Name = m1.Machine_Name group by 1,2 order by sum(m1.rejected_qty) desc;


# 7 . Production Comparison trend 

SELECT Fiscal_Date,SUM(Produced_Qty) AS total_produced, 
       SUM(Rejected_Qty) AS total_rejected,
       (SUM(Rejected_Qty) * 100.0 / NULLIF(SUM(Manufactured_Qty), 0)) AS rejection_percentage
FROM  manufacture_analytics
GROUP BY 1  order by  1 desc;


# 8.Manufacture Vs Rejected
select sum(Manufactured_Qty) AS Manufactured_Qty,
sum(rejected_qty) as Rejected_qty
from manufacture_analytics;

# 9. Department Wise Manufacture Vs Rejected
# Without join by using Aggregated Function
select department_name from manufacture_analytics;
select Department_Name,Manufactured_Qty,rejected_qty from manufacture_analytics;
select Department_Name,sum(Manufactured_Qty) As M_Qty,
sum(rejected_qty) As R_Qty from manufacture_analytics group by 1 
order by 1,2;

# With Join
select d.Department_Name,
sum(d1.Manufactured_Qty) as Manufacture_Qty,
sum(d1.rejected_qty) As Rejected_Qty 
from  manufacture_analytics d 
right join  manufacture_analytics as d1 on d.Department_Name = d1.Department_Name
group by 1;

# 10. Emp Wise Rejected Qty by using full join  
(select e.emp_name,
sum(e1.rejected_Qty) As rejected_Qty
from manufacture_analytics e 
left join manufacture_analytics as e1 on e.emp_name = e1.emp_name group by 1)
union all 
(select e.emp_name,
sum(e1.rejected_Qty) As rejected_Qty
from manufacture_analytics e 
left join manufacture_analytics as e1 on e.emp_name = e1.emp_name group by 1);





# Windows Function  emp_name ,manufacture_Qty,Rejected_Qtd ,manufacture_Qty
#Row _Number Rnk
select emp_name,Item_Name,Department_Name,Manufactured_Qty,Rejected_Qty,
row_number() over(partition by emp_name order by Manufactured_Qty,Rejected_Qty ) As T_Rownumber from manufacture_analytics;
#Rank
select emp_name,Item_Name,Department_Name,Manufactured_Qty,Rejected_Qty,
rank() over(partition by emp_name order by Manufactured_Qty,Rejected_Qty ) As T_Rank from manufacture_analytics;
#Densc Rank
select emp_name,Item_Name,Department_Name,Manufactured_Qty,Rejected_Qty,
dense_rank()over(partition by emp_name order by Manufactured_Qty,Rejected_Qty desc) As T_Desc_Rank from manufacture_analytics;

#Cum_Rank
select emp_name,Item_Name,Department_Name,Manufactured_Qty,Rejected_Qty,
round(cume_dist()over(partition by emp_name order by Manufactured_Qty,Rejected_Qty desc),2) As T_Cum_Rank from manufacture_analytics;
#Percentage_rank
select emp_name,Item_Name,Department_Name,Manufactured_Qty,Rejected_Qty,
round(percent_rank()over(partition by emp_name order by Manufactured_Qty,Rejected_Qty desc),3) As T_Percentage_rank
from manufacture_analytics;

#Lag previous year

select emp_name,Item_Name,Department_Name,Manufactured_Qty,Rejected_Qty,
lag(Manufactured_Qty)over(partition by emp_name order by Manufactured_Qty,Rejected_Qty desc) As T_Previous_year
from manufacture_analytics;

#Lead next year

select emp_name,Item_Name,Department_Name,Manufactured_Qty,Rejected_Qty,
lead(Manufactured_Qty)over(partition by emp_name order by Manufactured_Qty,Rejected_Qty desc) As T_Next_year
from manufacture_analytics;

use used_cars;

select * from cars;
select Car_Manufacturer,Model_Name,Price from cars;
 
 select Car_Manufacturer, 
 Model_Name, Fuel_Type,City,
 row_number() over(partition by Model_Name order by Fuel_Type,Car_Manufacturer) as T_Row_Number from cars;
 
 
 select Car_Manufacturer, 
 Model_Name, Fuel_Type,City,
 dense_rank() over(partition by Model_Name order by Fuel_Type,Car_Manufacturer) as T_Row_Number from cars;
 




