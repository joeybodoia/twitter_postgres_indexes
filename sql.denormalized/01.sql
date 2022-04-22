select count(*)
from tweets_jsonb
where data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
   or data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"';


/*
SELECT count(*)
FROM tweets_jsonb
WHERE data@@'$.entities.hashtags[*}.text == "coronavirus"'
    OR data@@'$.extended_tweet.entities.hashtags[*].text == "coronavirus"';


SELECT count(*)
FROM tweets_jsonb
WHERE (data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
    OR data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"')
and data->>'lang' == 'en';
*/

-- indexes needed:
-- create index on tweets_jsonb using gin( (data->'entities'->'hashtags') );
-- create index on tweets_jsonb using gin( (data->'extended_tweet'->'entities'->'hashtags') );
