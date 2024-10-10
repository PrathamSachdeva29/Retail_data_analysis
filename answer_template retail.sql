
-----------RETAIL DATA ANALYSIS CASE STUDY---------------------------
---(sqlretail database)----

----------DATA PREPERATION AND UNDERSTANDING-------------

----Q1

select count(*) as tot_rows_cust from Customer
select count(*) as tot_rows_trans from Transactions
select count(*) as tot_rows_prods from prod_cat_info

-- Q1 end



---Q2

select COUNT(total_amt) as tot_trans from Transactions
where total_amt like '-%'

--Q2 end



--Q3

select convert (date,DOB,105) as date_of_birth from Customer
select CONVERT (date,tran_date , 103) as trans_date from Transactions

--Q3 end

---Q4 

select DATEDIFF(day,min(convert(DATE, tran_date, 103)),max(convert(DATE, tran_date, 103))) as Day,
DATEDIFF(month,min(convert(DATE,tran_date, 103)),max(convert(DATE, tran_date, 103))) as Month,
DATEDIFF(year,min(convert(DATE,tran_date, 103)),max(convert(DATE, tran_date, 103))) as Year
from Transactions

--Q4 end

--Q5

select prod_cat from prod_cat_info
where prod_subcat like 'DIY'









-------------DATA ANALYSIS-------------


--Q1
select   Store_type , count( Store_type) as trans_chn from Transactions
 group by Store_type 
 order by trans_chn desc

--Q2

select Gender,COUNT(*) from dbo.Customer
group by Gender  


--Q2 end



--Q3 

select top 1 city_code, COUNT(customer_Id) as customer_count from Customer
group by city_code
order by customer_count desc

--Q3 end


--Q4

 
 select prod_cat,COUNT(prod_subcat) as count_subcategories from prod_cat_info
 group by prod_cat
 having prod_cat='books'

 --Q4 end



 --Q5
 select top 1 MAX(Qty) as max_qty from Transactions
 order by max_qty desc

 -- Q5 end


 --Q6

 

select sum(total_amt) as net_revenue  from Transactions as t
join prod_cat_info as p on t.prod_subcat_code=p.prod_sub_cat_code and p.prod_sub_cat_code=t.prod_subcat_code
where prod_cat in ('books','electronics')

--Q6 end--


  ---Q7
      
 
select cust_id, count(transaction_id) as cust_count from Transactions as t
join Customer as c on  t.cust_id=c.customer_Id
where total_amt > 0
group by cust_id
having COUNT(transaction_id) > 10


--Q7 end--



--Q8
 
 select sum(T.total_amt) as total_amt from Transactions as t
 join prod_cat_info as p on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
 where P.prod_cat in ('electonics','clothing') and T.Store_type = 'flagship store'


 ----Q8 end


 ---Q9

 select sum(total_amt) as tot_amt , prod_subcat from prod_cat_info as p
 join  Transactions as t on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
 join Customer as c on t.cust_id=c.customer_Id
 where Gender = ('m') and prod_cat in ('electronics')
 group by prod_subcat

---Q9 end--


---Q10--

select top 5 prod_cat, ROUND((sum(total_amt)/(select sum(total_amt) from Transactions))*100,2) as sales_percentage ,
abs(ROUND(sum (case when  total_amt < 0 then total_amt else null end)/sum(total_amt)*100, 2))
as revenue_percentage from Transactions as t
join prod_cat_info as p on p.prod_cat_code=t.prod_cat_code and p.prod_sub_cat_code=t.prod_subcat_code
group by prod_cat
order by SUM(total_amt)
  


---Q10 end---

---Q11---


select sum(total_amt) AS Total_Revenue FROM Transactions
where cust_id IN (select customer_Id FROM Customer  Where datediff(year,CONVERT(DATE,DOB,103),GETDATE()) BETWEEN 25 AND 35)
AND CONVERT(DATE,tran_date,103) BETWEEN Dateadd(Day,-30,(select Max(CONVERT(date,tran_date,103)) FROM Transactions)) AND
(select MAX(convert(DATE,tran_date,103)) FROM Transactions)

----Q11 end---


--Q12--
 
 select top 1 prod_cat , SUM(total_amt) as max_return  from Transactions as t
 join prod_cat_info as p on p.prod_cat_code=t.prod_cat_code and p.prod_sub_cat_code=t.prod_subcat_code
 where total_amt<0 and
 CONVERT(date,tran_date,105) between DATEADD(MONTH,-3,(select max(convert(date,tran_date,105)) from Transactions))
 and (select MAX(convert(date,tran_date,105)) from Transactions)
 group by prod_cat
 order by COUNT(Qty) desc
  

--Q12 end----



---Q13----
select top 1 Store_type , sum(total_amt) as tot_amt  from Transactions
group by Store_type
order by tot_amt desc , COUNT(Qty) desc

---Q13end-----




--Q14--
select prod_cat, AVG(total_amt) as avg_revenue from Transactions as t
join prod_cat_info as p on p.prod_cat_code=t.prod_cat_code and p.prod_sub_cat_code=t.prod_subcat_code
group by prod_cat
having AVG(total_amt)>(select AVG(total_amt) from Transactions) 

--Q14 end--


---Q15--

select  prod_subcat , avg(total_amt) as avg_amt , sum(total_amt) as tot_amt from prod_cat_info as p
join Transactions as t on t.prod_cat_code=p.prod_cat_code and t.prod_subcat_code=p.prod_sub_cat_code
where prod_cat in 
  (
  select top 5 prod_cat from prod_cat_info as pr
   join Transactions as tr on pr.prod_cat_code=tr.prod_cat_code and
   pr.prod_sub_cat_code=tr.prod_subcat_code
   group by prod_cat
   order by sum(Qty) desc
   )
   group by prod_cat,prod_subcat
   
   ----Q15 end---







































