-- COMP3311 22T3 Assignment 1
--
-- Fill in the gaps ("...") below with your code
-- You can add any auxiliary views/function that you like
-- The code in this file *MUST* load into an empty database in one pass
-- It will be tested as follows:
-- createdb test; psql test -f ass1.dump; psql test -f ass1.sql
-- Make sure it can load without error under these conditions


-- Q1: new breweries in Sydney in 2020

create or replace view Q1(brewery,suburb)
as
	select breweries.name as brewery, locations.town as suburb
	from breweries, locations 
	where breweries.founded = 2020 and locations.metro = 'Sydney' and breweries.located_in = locations.id
;

-- Q2: beers whose name is same as their style

create or replace view Q2(beer,brewery)
as
	select beers.name as beer, breweries.name as brewery
	from beers, styles, breweries, brewed_by 
	where beers.name = styles.name and beers.style = styles.id and brewed_by.beer = beers.id and brewed_by.brewery = breweries.id
;

-- Q3: original Californian craft brewery
create or replace view Q3helper()
as
	select breweries.name, breweries.founded 
	from breweries, locations 
	where breweries.founded >= 1970 and breweries.founded <= 1989 and breweries.located_in = locations.id and locations.region = 'California'
;
-- should print 
--              name              | founded 
-- -------------------------------+---------
--  Sierra Nevada Brewing Company |    1980
--  Northcoast Brewing Co         |    1988

create or replace view Q3(brewery,founded)
as
	select breweries.name as brewery, breweries.founded 
	from Q3helper 
	where breweries.founded = (select min(breweries.founded) from Q3helper)
;

-- Q4: all IPA variations, and how many times each occurs

create or replace view Q4(style,count)
as
	select styles.name as style, count(beers.style) 
	from beers, styles 
	where styles.name ~* 'IPA' and beers.style = styles.id 
	group by styles.name order by styles.name
;

-- Q5: all Californian breweries, showing precise location

create or replace view Q5(brewery,location)
as
	select breweries.name as brewery,
		case when locations.town is not null then locations.town 
			when locations.metro is not null then locations.metro
			else '' 
		end as location 
	from locations, breweries
	where locations.region = 'California' and breweries.located_in = locations.id
;
-- Need to add constraint which is probs if one null then the other must be not null
-- and other way around.

-- Q6: strongest barrel-aged beer
create or replace view Q6helper()
as
	select beers.name as beer, breweries.name as brewery, beers.abv 
	from beers, breweries, brewed_by 
	where (beers.notes ~* 'barrel(?=s| |$).*aged' or beers.notes ~* 'aged.*barrel(?=s| |$)') and breweries.id = brewed_by.brewery and beers.id = brewed_by.beer
;
-- should print 
-- ...
-- Ola Dubh                             | Harviestoun Brewery               |    8
-- S.P.X                                | Brouwerij Kees!                   |    9
-- BBARIS                               | Mismatch Brewing Company          | 12.8
-- The Duke of Chifley                  | Moon Dog Craft Brewery            | 12.2
-- Jumping the Shark 2021a              | Moon Dog Craft Brewery            | 15.6
-- Jumping the Shark 2021               | Moon Dog Craft Brewery            | 12.6
-- Jumping the Shark 2019               | Moon Dog Craft Brewery            | 12.1
-- Jumping the Shark 2015               | Moon Dog Craft Brewery            | 18.4
-- Jumping the Shark 2013               | Moon Dog Craft Brewery            | 15.4
-- Creme de la creme de la creme brulee | Moon Dog Craft Brewery            | 13.6
-- ...

create or replace view Q6(beer,brewery,abv)
as
	select beers.name as beer, breweries.name as brewery, beers.abv
	from Q6helper
	where beers.abv = (select max(beers.abv) from Q6helper)
;

-- Q7: most popular hop
create or replace view Q7helper()
as
	select ingredients.name, contains.ingredient, count(contains.ingredient) 
	from contains, ingredients 
	where contains.ingredient = ingredients.id and ingredients.itype = 'hop' 
	group by contains.ingredient, ingredients.name order by count DESC limit 1;
;
-- should print
--  name  | ingredient | count 
-- -------+------------+-------
--  Citra |        127 |    44

create or replace view Q7(hop)
as
	select ingredients.name as hop
	from Q7helper
;

-- Q8: breweries that don't make IPA or Lager or Stout (any variation thereof)
create or replace view Q8(brewery)
as
	select breweries.name as brewery
	from breweries 
	where not exists (
		select beers.style, styles.name 
		from beers, styles, brewed_by 
		where styles.name ~* '^.*(IPA|Lager|Stout).*$' and brewed_by.brewery = breweries.id and brewed_by.beer = beers.id and beers.style = styles.id)
;

-- Q9: most commonly used grain in Hazy IPAs
create or replace view Q9helper()
as
	select styles.name, ingredients.itype, ingredients.name
	from styles, beers, ingredients, contains 
    where styles.name = 'Hazy IPA' and itype = 'grain' and contains.ingredient = ingredients.id and contains.beer = beers.id and beers.style = styles.id;
;
-- should print
--    name   | itype |     name     
-- ----------+-------+--------------
--  Hazy IPA | grain | Oats
--  Hazy IPA | grain | Oats
--  Hazy IPA | grain | Pale
--  Hazy IPA | grain | Vienna
--  Hazy IPA | grain | Flaked wheat
--  Hazy IPA | grain | Flaked oats
--  Hazy IPA | grain | Wheat
--  Hazy IPA | grain | Oat
--  Hazy IPA | grain | Oats
--  Hazy IPA | grain | Wheat
--  Hazy IPA | grain | Barley
--  Hazy IPA | grain | Oats
--  Hazy IPA | grain | Two row
--  Hazy IPA | grain | White wheat
--  Hazy IPA | grain | Wheat
create or replace view Q9(grain)
as
	select ingredients.itype as grain
	from Q9helper
	where ingredients.name = (select max(ingredients.name) from Q9helper)
;

-- Q10: ingredients not used in any beer

create or replace view Q10(unused)
as
	select ingredients.name as unused
	from ingredients 
	where not exists (
		select contains.ingredient 
		from contains 
		where contains.ingredient = ingredients.id)
;

-- Q11: min/max abv for a given country
create or replace view Q11helper()
as
	select locations.country, beers.abv 
	from locations, styles, breweries, beers, brewed_by 
	where beers.style = styles.id and breweries.located_in = locations.id and brewed_by.beer = beers.id and brewed_by.brewery = breweries.id 
	order by locations.country, beers.abv;
;
-- gives each and every beer their abvs and which country they're from. looks like this:
--     country    | abv  
-- ---------------+------
--  Australia     |    0
--  Australia     |    0
--  Australia     |    0
--  Australia     |  3.5
--  Australia     |  3.5
--  Australia     |    4
--  Australia     |    4
--  Australia     |    4
--  Australia     |    4
--  Australia     |  4.2
--  Australia     |  4.2
--  Australia     |  4.2
--  Australia     |  4.2
--  Australia     |  4.3
-- ....

drop type if exists ABVrange cascade;
create type ABVrange as (minABV float, maxABV float);

create or replace function
	Q11(_country text) returns ABVrange
as $$
declare 
	country_abv = (select locations.country, beers.abv
					from Q11helper
					where locations.country = _country);
	min_abv_country = (select beers.abv from country_abv)
	max_abv_country = 
$$
language plpgsql;

-- Q12: details of beers

drop type if exists BeerData cascade;
create type BeerData as (beer text, brewer text, info text);

create or replace function
	Q12(partial_name text) returns setof BeerData
as $$
$$
language plpgsql;
