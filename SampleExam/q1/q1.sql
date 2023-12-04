-- COMP3311 20T3 Final Exam
-- Q1: view of teams and #matches

-- ... helper views (if any) go here ...

create or replace view Q1(team,nmatches)
as
    select teams.country, count(teams.country)
    from teams, involves, matches
    where involves.team = teams.id and involves.match = matches.id
    group by teams.country, involves.team
    order by teams.country;
;
