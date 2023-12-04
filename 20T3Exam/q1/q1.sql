-- COMP3311 20T3 Final Exam
-- Q1: longest album(s)

-- ... helper views (if any) go here ...

create or replace view albumLengths("group",title,year,length)
as
    select groups.name, albums.title, albums.year, sum(songs.length)
    from groups, albums, songs
    where albums.made_by = groups.id and songs.on_album = albums.id
    group by groups.name, albums.title, albums.year;
;

create or replace view q1("group",album,year)
as
    select "group", title, year
    from albumLengths
    where length = (select max(length) from albumLengths)
;

