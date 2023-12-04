-- COMP3311 21T3 Exam Q2
-- Number of unsold properties of each type in each suburb
-- Ordered by type, then suburb

create or replace view q2(suburb, ptype, nprops)
as
    select suburbs.name as suburb, properties.ptype, count(properties.ptype) as nprops
    from suburbs, streets, properties 
    where properties.street = streets.id and streets.suburb = suburbs.id and properties.sold_price IS NULL 
    group by suburbs.name, properties.ptype 
    order by properties.ptype, suburbs.name;
;
