-- Summary Statistics on Call Center Data

-- 1. What is the overall resolution time distribution?
SELECT 
    MIN(resolution_time_days) AS min_resolution_time,
    MAX(resolution_time_days) AS max_resolution_time,
    AVG(resolution_time_days) AS avg_resolution_time,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY resolution_time_days) AS median_resolution_time,
    STDDEV(resolution_time_days) AS std_dev_resolution_time
FROM call_center_data;

-- 2. What is the resolution time distribution by interaction type?
SELECT interaction_type, 
    MIN(resolution_time_days) AS min_resolution,
    MAX(resolution_time_days) AS max_resolution,
    AVG(resolution_time_days) AS avg_resolution,
    STDDEV(resolution_time_days) AS std_dev_resolution
FROM call_center_data
GROUP BY interaction_type;

-- 3. What is the ticket count and resolution time by category?
SELECT category, COUNT(*) AS ticket_count, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY category
ORDER BY ticket_count DESC;

-- 4. What is the SLA compliance rate for each interaction type?
SELECT interaction_type, 
    (SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_compliance_rate
FROM call_center_data
GROUP BY interaction_type;

-- 5. What is the SLA compliance rate by category?
SELECT category, 
    (SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_compliance_rate
FROM call_center_data
GROUP BY category;

-- 6. What are the top categories with the longest resolution times?
SELECT category, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY category
ORDER BY avg_resolution_time DESC
LIMIT 5;

-- 7. What is the percentage of tickets resolved within 24 hours?
SELECT 
    (SUM(CASE WHEN resolution_time_days <= 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS percentage_resolved_within_24_hours
FROM call_center_data;

-- 8. What is the average ticket resolution time per month?
SELECT DATE_TRUNC('month', interaction_date) AS month, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY month
ORDER BY month;

-- 9. What is the maximum ticket backlog in any given month?
SELECT DATE_TRUNC('month', interaction_date) AS month, COUNT(*) AS ticket_backlog
FROM call_center_data
GROUP BY month
ORDER BY ticket_backlog DESC
LIMIT 1;

-- 10. What is the median resolution time for each ticket category?
SELECT category, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY resolution_time_days) AS median_resolution_time
FROM call_center_data
GROUP BY category;

-- 11. What is the total number of high-resolution time outliers? (More than 10 days)
SELECT COUNT(*) AS outlier_tickets
FROM call_center_data
WHERE resolution_time_days > 10;

-- 12. What is the interaction type that takes the longest to resolve?
SELECT interaction_type, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY interaction_type
ORDER BY avg_resolution_time DESC
LIMIT 1;

-- 13. What is the total number of tickets resolved within SLA?
SELECT COUNT(*) AS tickets_within_sla
FROM call_center_data
WHERE sla_met = 'Yes';

-- 14. What is the month with the highest SLA breach rate?
SELECT DATE_TRUNC('month', interaction_date) AS month, 
    (SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_breach_rate
FROM call_center_data
GROUP BY month
ORDER BY sla_breach_rate DESC
LIMIT 1;

-- 15. What is the standard deviation of ticket resolution times by category?
SELECT category, STDDEV(resolution_time_days) AS std_dev_resolution_time
FROM call_center_data
GROUP BY category
ORDER BY std_dev_resolution_time DESC;
