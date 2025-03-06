-- Advanced Analysis on Call Center Data

-- 1. What are the peak hours for ticket inflow?
SELECT EXTRACT(HOUR FROM interaction_time) AS hour, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY hour
ORDER BY ticket_count DESC;

-- 2. What are the busiest days of the week for interactions?
SELECT EXTRACT(DOW FROM interaction_date) AS day_of_week, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY day_of_week
ORDER BY ticket_count DESC;

-- 3. What is the SLA compliance trend over time?
SELECT DATE_TRUNC('month', interaction_date) AS month,
    (SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_compliance_rate
FROM call_center_data
GROUP BY month
ORDER BY month;

-- 4. What are the top recurring customer issues?
SELECT category, COUNT(*) AS recurrence_count
FROM call_center_data
GROUP BY category
ORDER BY recurrence_count DESC
LIMIT 5;

-- 5. Which interaction type has the highest SLA breach rate?
SELECT interaction_type, 
    (SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_breach_rate
FROM call_center_data
GROUP BY interaction_type
ORDER BY sla_breach_rate DESC;

-- 6. What is the average resolution time trend over months?
SELECT DATE_TRUNC('month', interaction_date) AS month, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY month
ORDER BY month;

-- 7. Which customers have the highest number of unresolved tickets?
SELECT customer_id, COUNT(*) AS unresolved_tickets
FROM call_center_data
WHERE sla_met = 'No'
GROUP BY customer_id
ORDER BY unresolved_tickets DESC
LIMIT 5;

-- 8. What are the most problematic issue categories based on SLA violations?
SELECT category, COUNT(*) AS total_tickets, 
       SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) AS sla_violations,
       (SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_violation_rate
FROM call_center_data
GROUP BY category
ORDER BY sla_violation_rate DESC;

-- 9. How does the resolution time vary for tickets with SLA breaches?
SELECT 
    CASE WHEN sla_met = 'Yes' THEN 'Within SLA' ELSE 'Breached SLA' END AS sla_status,
    AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY sla_status;

-- 10. Which month had the highest increase in ticket volume?
SELECT month, total_tickets, 
       LAG(total_tickets) OVER (ORDER BY month) AS prev_month_tickets,
       (total_tickets - LAG(total_tickets) OVER (ORDER BY month)) AS ticket_change
FROM (
    SELECT DATE_TRUNC('month', interaction_date) AS month, COUNT(*) AS total_tickets
    FROM call_center_data
    GROUP BY month
) monthly_data;

-- 11. Which customers have reported more than 10 tickets?
SELECT customer_id, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY customer_id
HAVING COUNT(*) > 10
ORDER BY ticket_count DESC;

-- 12. What is the average resolution time per hour of the day?
SELECT EXTRACT(HOUR FROM interaction_time) AS hour, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY hour
ORDER BY avg_resolution_time DESC;

-- 13. What is the most common ticket resolution time range?
SELECT 
    CASE 
        WHEN resolution_time_days <= 1 THEN '0-1 days'
        WHEN resolution_time_days <= 3 THEN '1-3 days'
        WHEN resolution_time_days <= 7 THEN '3-7 days'
        ELSE '7+ days'
    END AS resolution_time_range,
    COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY resolution_time_range
ORDER BY ticket_count DESC;

-- 14. How do tickets with different priorities affect resolution time?
SELECT priority, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY priority
ORDER BY avg_resolution_time DESC;

-- 15. Which categories have the highest repeat issues from the same customer?
SELECT customer_id, category, COUNT(*) AS repeat_issues
FROM call_center_data
GROUP BY customer_id, category
HAVING COUNT(*) > 3
ORDER BY repeat_issues DESC;
