-- COMP3311 20T3 Final Exam
-- Q2: group(s) with no albums

-- ... helper views (if any) go here ...

create or replace view q2("group")
as
    select groups.name 
    from groups left outer join albums on albums.made_by = groups.id 
    group by groups.name 
    having count(albums.id) = 0 
    order by groups.name;
;

