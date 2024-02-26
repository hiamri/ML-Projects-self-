
-- 7 PROLEM
select c.carton_id, (c.len*c.width*c.height) as carton_vol 
from orders.carton c 
where (c.len*c.width*c.height) >= (select sum(p.len*p.width*p.height*product_quantity) as carton_vol 
from orders.order_header oh 
inner join orders.order_items oi on oh.order_id=oi.ORDER_ID 
inner join orders.product p on oi.PRODUCT_ID = p.PRODUCT_ID 
where oh.ORDER_ID = 10006) 
order by (c.len*c.width*c.height) asc 
limit 1; 

-- 8 problem
SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname, '', oc.customer_lname) customername,
    oh.order_id,
    oi.product_quantity,oh.payment_mode,
    SUM(oi.PRODUCT_QUANTITY) totalquantity
FROM
    online_customer oc
        INNER JOIN
    order_header oh ON oc.customer_ID = oh.customer_ID
        INNER JOIN
    order_items oi ON oh.ORDER_ID = oi.ORDER_ID
WHERE
    oh.payment_mode != 'cash' and oh.order_status = 'shipped'
GROUP BY order_id
HAVING SUM(oi.PRODUCT_QUANTITY) > 10;


-- 9 PROBLEM
select oi.order_id, oc.customer_id, concat(oc.customer_fname,' ',oc.customer_lname) as 
customer_name, oi.total_quantity 
from orders.order_header oh 
inner join (select order_id, sum(product_quantity) as total_quantity from orders.order_items 
group by order_id having order_id > 10030) oi on oh.order_id = oi.order_id and oh.order_status 
= 'shipped' 
inner join orders.online_customer oc on oh.customer_id = oc.customer_id WHERE oc.customer_fname like "A%";


-- 10 PROBLEM

select out_qry.product_class_desc, sum(out_qry.product_quantity) product_quanitity, 
sum(out_qry.total_value) total_value, out_qry.product_class_code 
from (select pc.product_class_desc, oi.product_quantity,(oi.product_quantity * p.product_price) 
total_value, 
pc.product_class_code from orders.order_items oi 
inner join orders.order_header oh on oh.order_id=oi.order_id and oh.order_status = 'shipped' 
inner join orders.online_customer oc on oh.customer_id = oc.customer_id 
inner join orders.address a on oc.address_id = a.address_id and a.country not in ('india', 'usa') 
left join orders.product p on oi.product_id = p.product_id 
left join orders.product_class pc on p.product_class_code = pc.product_class_code) out_qry 
group by out_qry.product_class_code, out_qry.product_class_desc 
order by sum(out_qry.product_quantity) desc 
limit 1;

