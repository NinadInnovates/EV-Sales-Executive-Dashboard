SELECT * FROM ev_sales.ev;

# 1.Total EV Sales by Year(Growth of EV market over time)

select year , sum(EV_Sales_Quantity)  as Total_EV_Sales
from ev_sales.ev
group by year;

# 2. Top 5 States by EV Sales Quantity (Identify high-performing regions)

select State , sum(EV_Sales_Quantity) as Total_Sales from ev_sales.ev
group by State
order by Total_Sales desc
limit 5;

# 3. Monthly Sales Trend (Identify seasonality)

SELECT 
    FORMAT(Date, 'yyyy-MM') AS Month,
    SUM(EV_Sales_Quantity) AS Monthly_Sales
FROM ev_sales.ev
GROUP BY FORMAT(Date, 'yyyy-MM')
ORDER BY Month ;

# 4. Vehicle Category Contribution % ( Which segment dominates EV market )

WITH CategorySales AS (
    SELECT 
        Vehicle_Category,
        SUM(EV_Sales_Quantity) AS Total_Sales
    FROM ev_sales.ev
    GROUP BY Vehicle_Category
),
Total AS (
    SELECT SUM(Total_Sales) AS GrandTotal FROM CategorySales
)

SELECT 
    c.Vehicle_Category,
    c.Total_Sales,
    (c.Total_Sales * 100.0 / t.GrandTotal) AS Contribution_Percentage
FROM CategorySales c
CROSS JOIN Total t
ORDER BY Contribution_Percentage DESC;

# 5. Top 10 state wise Total sales Quantity

select State , sum(EV_Sales_Quantity) as Total_sales_quantity from ev_sales.ev
group by State
order by Total_sales_quantity desc
limit 10;

WITH StateSales AS (
    SELECT 
        State,
        SUM(EV_Sales_Quantity) AS Total_Sales
    FROM ev_sales.ev
    GROUP BY State
)
SELECT 
    State,
    Total_Sales,
    RANK() OVER (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM StateSales
ORDER BY Sales_Rank
limit 10;

# 6. Top 15 Vehicle Class by Total sales Quantity

 # Method 1: 
 
 select Vehicle_Class , sum(EV_Sales_Quantity) as Total_sales_quantity
 from ev_sales.ev
 group by Vehicle_Class
 order by Total_sales_quantity desc
 limit 15;
 
 # method 2

with Top_vehicle_class as(

select Vehicle_Class , sum(EV_Sales_Quantity) as Total_sales_quantity 
from ev_sales.ev
group by Vehicle_Class

)
select Vehicle_Class ,Total_sales_quantity ,
Rank() over (order by Total_sales_quantity desc) as Sales_Rank 
from Top_vehicle_class 
limit 15;

# 7. Vehicle Category-wise Sales

SELECT 
    Vehicle_Category,
    SUM(EV_Sales_Quantity) AS Total_Sales
FROM ev_sales.ev
GROUP BY Vehicle_Category;

# 8. Vehicle Class-wise Sales

SELECT 
    Vehicle_Class,
    SUM(EV_Sales_Quantity) AS Total_Sales
FROM ev_sales.ev
GROUP BY Vehicle_Class
ORDER BY Total_Sales DESC;

# 9. Vehicle Category and Vehicle Class by Total sales Quantity

select Vehicle_Class , Vehicle_Category , sum(EV_Sales_Quantity) as Total_sales_quantity
from ev_sales.ev
group by Vehicle_Class , Vehicle_Category
order by Total_sales_quantity desc ;

# Method 2:

with Total_sales as (

select  Vehicle_Class , Vehicle_Category , sum(EV_Sales_Quantity) as Total_sales_quantity
from ev_sales.ev
group by Vehicle_Class , Vehicle_Category
)
select Vehicle_Class , Vehicle_Category, Total_sales_quantity,
Rank() over (partition by  Vehicle_Category  order by Total_sales_quantity desc) as Rank_Within_Category
from Total_sales ;

# 10. Year wise Top Vehicle Class of Maharashtra State having Total sales Quantity greater than 1000

SELECT Year, State,Vehicle_Class, SUM(EV_Sales_Quantity) AS Total_sales_quantity
FROM ev_sales.ev
WHERE State = 'Maharashtra'
GROUP BY Year,State, Vehicle_Class
HAVING SUM(EV_Sales_Quantity) > 1000;

# Method : 2
WITH SalesData AS (
    SELECT Year, Vehicle_Class, SUM(EV_Sales_Quantity) AS Total_Sales
    FROM ev_sales.ev
    WHERE State = 'Maharashtra'
    GROUP BY Year, Vehicle_Class
    HAVING SUM(EV_Sales_Quantity) > 1000
)
SELECT Year, Vehicle_Class, Total_Sales,
    RANK() OVER (PARTITION BY Year ORDER BY Total_Sales DESC) AS Rank_Position
FROM SalesData
ORDER BY Year, Rank_Position;

# 11 . Year on Year Change (Measure annual growth/decline in EV adoption)

SELECT Year, SUM(EV_Sales_Quantity) AS Total_Sales,

LAG(SUM(EV_Sales_Quantity)) OVER (ORDER BY Year) AS Previous_Year_Sales,

SUM(EV_Sales_Quantity) - LAG(SUM(EV_Sales_Quantity)) OVER (ORDER BY Year) AS YoY_Change

FROM ev_sales.ev
GROUP BY Year
ORDER BY Year;

# 12. Year wise Top rank State by Total_Sales_Quantity

WITH StateSales AS (
    SELECT Year, State, SUM(EV_Sales_Quantity) AS Total_Sales
    FROM ev_sales.ev
    GROUP BY Year, State
)
SELECT Year, State, Total_Sales,
    RANK() OVER (PARTITION BY Year ORDER BY Total_Sales DESC) AS Rank_Position
FROM StateSales
ORDER BY Year, Rank_Position;

