-- COMP3311 21T3 Exam Q3
-- Unsold house(s) with the lowest listed price
-- Ordered by property ID

create or replace view q3(id,price,street,suburb)
as
    select properties.id, properties.list_price, properties.street_no||' '||streets.name||' '||streets.stype as street, suburbs.name 
    from properties, streets, suburbs 
    where properties.street = streets.id and streets.suburb = suburbs.id and 
        properties.list_price = (select min(list_price) from Properties where sold_price is null and ptype = 'House')
    order by properties.id;
;
