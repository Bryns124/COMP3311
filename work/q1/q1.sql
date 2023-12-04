-- COMP3311 22T3 Final Exam Q1
-- Horse(s) that have won the most Group 1 races

-- put helper views (if any) here

-- answer: Q1(horse)

create or replace view Q1(horse) 
as
    select max(x.maxHorse) from (select horses.name as hname, races.level, count(horses.id) as maxHorse
    from horses, races, runners, meetings, jockeys 
    where runners.horse = horses.id and runners.race = races.id and runners.jockey = jockeys.id and races.part_of = meetings.id and runners.finished = 1 and races.level = 1 
    group by horses.id, races.level) x
;
