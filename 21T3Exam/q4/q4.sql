-- COMP3311 21T3 Exam Q4
-- Return address for a property, given its ID
-- Format: [UnitNum/]StreetNum StreetName StreetType, Suburb Postode
-- If property ID is not in the database, return 'No such property'

create or replace function address(propID integer) returns text
as
$$
declare
	uno integer;
	sto integer;
	street text;
	stype StreetType;
	suburb text;
	pcode integer;
	num text;
begin
	select properties.unit_no, properties.street_no, streets.name, streets.stype, suburbs.name, suburbs.postcode
	into uno, sto, street, stype, suburb, pcode
	from properties, streets, suburbs
	where properties.street = streets.id and streets.suburb = suburbs.id and properties.id = propID;
	if not found then
		return 'No such property';
	end if;
	if uno is null then
		num := sto::text;
	else
		num := uno::text||'/'||sto::text;
	end if;
	return num||' '||street||' '||stype||' '||suburb||' '||pcode::text;
end;
$$ language plpgsql;