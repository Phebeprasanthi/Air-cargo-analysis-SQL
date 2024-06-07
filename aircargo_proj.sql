use aircargo;

create table route_details (route_id int primary key, flight_num int not null, origin_airport varchar(200), destination_airport varchar(200),
aircraft_id varchar(200), distance_miles int check (distance_miles > 0));
select * from route_details;

select * from passengers_on_flights where route_id between 01 and 25;

select t.class_id, count(*) total_passengers, sum(no_of_tickets * Price_per_ticket) total_revenue from ticket_details t where class_id = 'bussiness'
group by class_id;

select c.customer_id, concat(first_name,' ', last_name) as full_name, c.date_of_birth, c.gender from customer c;

select c.*, t.aircraft_id, t.no_of_tickets, t.class_id, t.a_code from ticket_details t 
left join customer c on c.customer_id = t.customer_id;

select c.* , t.aircraft_id, t.brand from ticket_details t 
left join customer c on c.customer_id = t.customer_id
where brand = 'Emirates';

select c.customer_id, c.first_name, p.route_id, p.class_id from passengers_on_flights p 
left join customer c on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, p.route_id, p.class_id
having class_id = 'Economy Plus';

select sum(no_of_tickets * price_per_ticket) total_revenue, 
(select if ((sum(no_of_tickets * price_per_ticket)) > 10000, 'Yes', 'No'))total_crossed_10000 from ticket_details;

create user `NewUser` identified by 'NewPassword';
GRANT SELECT ON *.* TO `NewUser`;

select distinct class_id, max(price_per_ticket) over (partition by  class_id order by price_per_ticket desc) Max_price_per_class
from ticket_details;

select p.customer_id, c.first_name, c.last_name, c.gender,
p.aircraft_id, p.route_id, p.depart, p.arrival, p.flight_num from passengers_on_flights p
left join customer c on c.customer_id = p.customer_id
where route_id = 4;

explain select p.customer_id, c.first_name, c.last_name, c.gender,
p.aircraft_id, p.route_id, p.depart, p.arrival, p.flight_num from passengers_on_flights p
left join customer c on c.customer_id = p.customer_id
where route_id = 4;

select t.customer_id, sum(no_of_tickets * Price_per_ticket) total_price_all_tickets from ticket_details t
left join customer c on c.customer_id = t.customer_id
group by t.customer_id
with rollup;

select t.customer_id, c.first_name, c.last_name,t.class_id, t.brand from ticket_details t
left join customer c on c.customer_id = t.customer_id
where class_id = 'Bussiness';

delimiter //
create procedure routes_2000miles()
begin
	select * from routes
    where distance_miles > 2000;
end //
delimiter ;
call routes_2000miles();

delimiter //
create procedure distance_category()
begin
	select flight_num, aircraft_id, distance_miles, case when distance_miles >= 0 and distance_miles <= 2000 then 'Short distance travel'
    when distance_miles > 2000 and distance_miles <= 6500 then 'Intermediate distance travel'
    else 'Long distance travel' end distance_category
    from routes
    group by flight_num, aircraft_id, distance_miles;
end //
delimiter ;
call distance_category();

delimiter //
create function complimentary_service(class varchar(20))
returns varchar(20)
deterministic
begin
 declare complimentary_service varchar(20);
 if (class = 'Bussiness') or (class = 'Economy Plus') 
	then set complimentary_service = 'YES';
	else set complimentary_service = 'NO';
 end if;
 return (complimentary_service);
end //

create procedure ticket_service()
begin
	select p_date, customer_id, class_id, complimentary_service(class_id) from ticket_details
    group by p_date, customer_id, class_id;
end //
delimiter ;
call ticket_service();

select *, first_value(first_name) over (order by customer_id) first_record from customer 
where last_name like 'Scott';

select * from passengers_on_flights
where travel_date BETWEEN '06-05-2020' AND '09-11-2020';

delimiter //
create procedure range_of_routes(route_id int)
begin
select * from passengers_on_flights
where if (route_id between 1 and 50, True, False) = 1;
end //
delimiter ;

call range_of_routes(50);