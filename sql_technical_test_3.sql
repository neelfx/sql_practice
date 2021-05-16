-- check to see if there are any incorrect click_flags with value 1 where open_flag is 0
select click_flag
from delivery_logs
where open_flag = 0 and click_flag = 1;



--Question 1
-- open_flag is 1 when opened therefore summing them will give number of opened emails.
-- counting open_flag will give number of emails in that campaign
select campaign_id, round((sum(open_flag)/count(open_flag))*100, 2) as open_rate
from delivery_logs
group by campaign_id;


--Question 2

select campaign_id,
		MONTH(date_received) as month,
    	round((sum(open_flag)/count(open_flag))*100, 2) as open_rate,
    	round((sum(click_flag)/
    			SUM(CASE 
            	 		WHEN open_flag = '1' THEN 1
             			ELSE 0
           		END))*100, 2) as click_rate
from delivery_logs
group by campaign_id, month
order by campaign_id asc, month asc;

--Question 3
select count(*) as number_of_daves
from recipient
where first_name like 'dave';

--Question 4
/*
For each recipient return the date that they received their first e-mail. We need a table with two columns: recipient_name and recipient_onboarding_date
*/

select concat(recipient.first_name, ' ', recipient.last_name) as recipient_name, 		
	min(delivery_logs.date_received) as recipient_onboarding_date
from recipient
left join delivery_logs on recipient.recipient_id = delivery_logs.recipient_id
group by recipient_name;

--Question 5
/*
Return the three weekdays (Tuesday, Thursday, etc) with the highest total amount of clicks. We are interested on the weekdays that the recipients received the e-mail and not on the weekdays that the campaign was sent.
*/

select dayname(date_received) as weekday, sum(clicks) as total_clicks
from delivery_logs
left join campaign on delivery_logs.campaign_id = campaign.campaign_id
where dayofweek(date_received) > 1 and dayofweek(date_received) < 7
group by weekday
order by total_clicks desc;