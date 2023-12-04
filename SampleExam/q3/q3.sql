-- COMP3311 20T3 Final Exam
-- Q3: team(s) with most players who have never scored a goal

create or replace view Q3Helper1(team, ngoals)
as
    select teams.country, count(goals.id)
    from teams, players left outer join goals on players.id = goals.scoredby 
    where players.memberOf = teams.id
    group by players.name, teams.country
    having count(goals.id) = 0 
    order by country
;

create or replace view q3(team, nplayers)
as
    select Q3Helper1.team, y.high
    from (
        select max(x.nplayers) as high
        from (
            select team, count(ngoals) as nplayers
            from Q3Helper1
            group by team, ngoals) x) y
        join Q3Helper1 on Q3Helper1.team = x.team
;