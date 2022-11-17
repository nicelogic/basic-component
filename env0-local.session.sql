-- INSERT INTO add_contacts_apply (user_id, contacts_id, message, update_time)
-- VALUES (
-- 	'5',
-- 	'6',
-- 	'message:text',
-- 	'2022-11-05T11:38:45.000Z'
--   );

EXPLAIN analyze
SELECT * from add_contacts_apply where contacts_id = '6'