-- COMP3311 20T3 Final Exam
-- Q2: view of amazing goal scorers

-- ... helpers go here ...

create or replace view Q2(player,ngoals)
as
    select players.name, count(goals.id) as ngoals 
    from players, goals, teams, matches 
    where goals.scoredIn = matches.id and goals.scoredBy = players.id and players.memberOf = teams.id and goals.rating = 'amazing' 
    group by players.name 
    having count(goals.id) > 1 
    order by players.name;
;
