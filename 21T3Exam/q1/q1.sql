-- COMP3311 21T3 Exam Q1
-- Properties most recently sold; date, price and type of each
-- Ordered by price, then property ID if prices are equal

create or replace view q1(date, price, type)
as
    select sold_date as date, sold_price as price, ptype as type 
    from Properties where sold_date = (select max(sold_date) from Properties)
    order by date DESC, price ASC;
;
