-- normalized query
/*
SELECT
    count(*)
FROM tweets
WHERE to_tsvector('english',text)@@to_tsquery('english','coronavirus')
  AND lang='en'
;
*/

-- expected output
/*
 count 
-------
    17
(1 row)
*/


-- below query is off by 2 for twitter_postgres_indexes db, use coalesce?
/*
select count(*)
from tweets_jsonb
where (
    to_tsvector('english', data->>'text')@@to_tsquery('english', 'coronavirus')
    or to_tsvector('english', data->'extended_tweet'->>'full_text')@@to_tsquery('english', 'coronavirus'))
and data->>'lang' = 'en';
*/

/*
select count(distinct data->>'id')
from tweets_jsonb
where (
    to_tsvector('english', data->>'text')@@to_tsquery('english', 'coronavirus')
    or to_tsvector('english', data->'extended_tweet'->>'full_text')@@to_tsquery('english', 'coronavirus'))
and data->>'lang' = 'en';
*/


select count(distinct data->>'id')
from tweets_jsonb
where to_tsvector('english', COALESCE(data->'extended_tweet'->>'full_text', data->>'text')) @@ to_tsquery('english', 'coronavirus')
  and data->>'lang' = 'en';
