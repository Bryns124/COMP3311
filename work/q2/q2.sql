-- COMP3311 22T3 Final Exam Q2
-- List of races with only Mares

-- put helper views (if any) here

-- answer: Q2(name,course,date)

create or replace view Q2(name,course,date)
as
    select x.rname, x.rcname, x.mrun, count(x.rname) from (select races.name as rname, racecourses.name as rcname, meetings.run_on as mrun, horses.gender as hgen
    from races, racecourses, meetings, horses, runners, jockeys 
    where races.part_of = meetings.id and meetings.run_at = racecourses.id and runners.horse = horses.id and runners.race = races.id and runners.jockey = jockeys.id
    group by horses.gender, races.name, racecourses.name, meetings.run_on 
    order by races.name) x
    group by x.rname, x.rcname, x.mrun
    having count(x.rname) = 1
    order by x.rname
;
