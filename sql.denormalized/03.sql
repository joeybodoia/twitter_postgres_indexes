-- normalized query
/*
SELECT
    lang,
    count(*) as count
FROM (
    SELECT DISTINCT t2.id_tweets,lang
    FROM tweet_tags t1
    JOIN tweet_tags t2 ON t1.id_tweets = t2.id_tweets
    JOIN tweets ON t2.id_tweets = tweets.id_tweets
    WHERE t1.tag='#coronavirus'
      AND t2.tag LIKE '#%'
) t
GROUP BY lang
ORDER BY count DESC,lang;
*/

-- expected output for twitter_postgres_parallel hw db
/*
 lang | count 
------+-------
 en   |     4
 es   |     4
 it   |     1
 und  |     1
(4 rows)
*/


select lang, count(*) as count from (
    select distinct data, lang from (
        select
            data->>'id' as data,
            data->>'lang' as lang
            from tweets_jsonb
        where data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
        union
        select
            data->>'id' as data,
            data->>'lang' as lang
            from tweets_jsonb
        where data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
    )t
)t
group by lang
order by count desc, lang;
