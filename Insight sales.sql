USE sales;

select top 5 * 
	from dbo.transactions 
	where not (currency = 'USD\r' OR   currency = 'INR\r') order by product_code

--------------------------------------------------
-- Exploring the dataset
--------------------------------------------------

------------------------------------------------
-- Total amount of transaction
------------------------------------------------

select count(*) from transactions 

-----------------------------------------
select * 
from dbo.transactions 
	where market_code = 'Mark001'

---------------------------------------------
select * 
from dbo.transactions 
	where currency = 'USD'

---------------------------------------------------------
-- Let's see how many transaction where perfome in 2020
---------------------------------------------------------

select dbo.transactions.*, dbo.date.* 
from dbo.transactions 
inner join dbo.date 
on dbo.transactions.order_date = dbo.date.date
where dbo.date.year = 2020

------------------------------------------
-- Let's see the to revenu in 2020
------------------------------------------

select sum(dbo.transactions.sales_amount) 
from dbo.transactions 
inner join dbo.date 
on dbo.transactions.order_date = dbo.date.date
where dbo.date.year = 2020

--------------------------------------------------------------
-- Let's see the revenue in a specific market of our business
--------------------------------------------------------------
select sum(dbo.transactions.sales_amount) 
from dbo.transactions 
inner join dbo.date 
on dbo.transactions.order_date = dbo.date.date
where dbo.date.year = 2020 and dbo.transactions.market_code = 'Mark001'

----------------------------------------------------------------------
--- The distinct product sold in that market in 2020
----------------------------------------------------------------------
select distinct(dbo.transactions.product_code) 
from dbo.transactions 
inner join dbo.date 
on dbo.transactions.order_date = dbo.date.date
where dbo.date.year = 2020 and dbo.transactions.market_code = 'Mark001'

----------------------------------------------------------------------
--- The distinct product sold in that market in general
----------------------------------------------------------------------

select distinct(product_code) 
from dbo.transactions 
where market_code = 'Mark001'


---------------------------------------------------------------------------------------
------ Data cleaning and ETL ----------------------------------------------------------
---------------------------------------------------------------------------------------

-- 1 Filtering the data

-- on transactions table

select count(*)
from transactions
where sales_amount > 0;


SELECT *, (sales_amount*74) as new_sales_amount
FROM transactions t
inner join markets m
on m.markets_code = t.market_code
WHERE (currency='USD' or currency='USD\r') and ( markets_code != 'Mark097' and markets_code != 'Mark999')


UNION

SELECT *, sales_amount AS new_sales_amount
FROM transactions t
inner join markets m
on m.markets_code = t.market_code
WHERE (currency!='USD' or currency!='USD\r') and sales_amount > 0 and ( markets_code != 'Mark097' and markets_code != 'Mark999')
order by currency


---on customers

SELECT *, (sales_amount*74) as new_sales_amount
FROM transactions t
inner join customers c
on c.customer_code = t.customer_code
WHERE (t.currency='USD' or t.currency='USD\r') 
UNION

SELECT *, sales_amount AS new_sales_amount
FROM transactions t
inner join customers c
on c.customer_code = t.customer_code
WHERE (t.currency!='USD' or t.currency!='USD\r') and sales_amount > 0 
order by currency

-- on products table

SELECT *, (sales_amount*74) as new_sales_amount
FROM transactions t
inner join products p
on p.product_code = t.product_code
WHERE (t.currency='USD' or t.currency='USD\r') 
UNION

SELECT *, sales_amount AS new_sales_amount
FROM transactions t
inner join products p
on p.product_code = t.product_code
WHERE (t.currency!='USD' or t.currency!='USD\r') and sales_amount > 0 
order by currency

-- on date table

SELECT *, (sales_amount*74) as new_sales_amount
FROM transactions t
inner join date d
on d.date = t.order_date
WHERE (t.currency='USD' or t.currency='USD\r') 
UNION

SELECT *, sales_amount AS new_sales_amount
FROM transactions t
inner join date d
on d.date = t.order_date
WHERE (t.currency!='USD' or t.currency!='USD\r') and sales_amount > 0 
order by currency

-- on market table

select * 
from markets m
inner join transactions t
on m.markets_code = t.market_code
where markets_code != 'Mark097' and markets_code != 'Mark999' and sales_amount >0

-- ETL

SELECT *, (sales_amount*74) as new_sales_amount
FROM transactions t
inner join markets m
on m.markets_code = t.market_code
inner join customers c
on c.customer_code = t.customer_code 
inner join date d
on d.date = t.order_date
WHERE (currency='USD' or currency='USD\r') and ( markets_code != 'Mark097' and markets_code != 'Mark999')


UNION

SELECT *, sales_amount AS new_sales_amount
FROM transactions t
inner join markets m
on m.markets_code = t.market_code 
inner join customers c
on c.customer_code = t.customer_code 
inner join date d
on d.date = t.order_date
WHERE (currency!='USD' or currency!='USD\r') and sales_amount > 0 and ( markets_code != 'Mark097' and markets_code != 'Mark999')
order by currency


