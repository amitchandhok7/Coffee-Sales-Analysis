/*all data */
select 
	t.transaction_id,
	t.transaction_date,
	t.transaction_time,
	t.transaction_qty,
	p.product_category,
	p.product_type,
	p.product_detail,
	s.unit_price
from 
	sales s
left join products p on
	s.product_id = p.product_id
left join transactions t on
	s.transaction_id = t.transaction_id
order by
	t.transaction_id asc;

/* Question 1: Products with the most sales */
select 
	p.product_type,
	sum(t.transaction_qty) as sales_qty,
	cast(sum(t.transaction_qty * s.unit_price) as money) as revenue
from 
	sales s
left join products p on
	p.product_id = s.product_id
left join transactions t on
	t.transaction_id = s.transaction_id
group by
	p.product_type
order by
	sum(t.transaction_qty) desc;

/* Question 1a: Products with the highest revenue generated */
select 
	p.product_type,
	sum(t.transaction_qty) as sales_qty,
	cast(sum(t.transaction_qty * s.unit_price) as money) as revenue
from 
	sales s
left join products p on
	p.product_id = s.product_id
left join transactions t on
	t.transaction_id = s.transaction_id
group by
	p.product_type
order by
	sum(t.transaction_qty * s.unit_price) desc;

/* Question 2: What day yields the most sales */
select
	to_char(to_date(t.transaction_date,'YYYY-MM-DD'),'Day') as day,
	sum(transaction_qty),
	cast(sum(t.transaction_qty * s.unit_price) as money) as revenue
from 
	transactions t 
left join sales s on t.transaction_id=s.transaction_id 
group by
	to_char(to_date(t.transaction_date,'YYYY-MM-DD'),'Day')
order by
	sum(transaction_qty) desc;

/* Question 3: Best performing product type on the most popular day */
select 
	to_char(to_date(t.transaction_date,'YYYY-MM-DD'),'Day'),max(revenue),p.product_type
from (
	select 
		to_char(to_date(t.transaction_date,'YYYY-MM-DD'),'Day') as day,
		cast(sum(t.transaction_qty * s.unit_price) as money) as revenue,
		p.product_type
	from 
		transactions t
	left join sales s on t.transaction_id=s.transaction_id
	left join products p on p.product_id=s.product_id
	group by 
		to_char(to_date(t.transaction_date,'YYYY-MM-DD'),'Day'),
		p.product_type
	),
		transactions t
	left join sales s on t.transaction_id=s.transaction_id
	left join products p on p.product_id=s.product_id 
	group by
		to_char(to_date(t.transaction_date,'YYYY-MM-DD'),'Day'),
		p.product_type
	limit 1

/* Question 4: How many bakery items sell per day */
select 
	p.product_category,
	sum(t.transaction_qty)/count(distinct t.transaction_date) as avg_sales
from
	sales s
left join transactions t on
	s.transaction_id = t.transaction_id
left join products p on
	s.product_id = p.product_id
group by
	p.product_category;