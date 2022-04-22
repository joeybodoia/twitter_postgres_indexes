-- normalized query
/*
SELECT
    tag,
    count(*) as count
FROM (
    SELECT DISTINCT
        id_tweets,
        t2.tag
    FROM tweet_tags t1
    JOIN tweet_tags t2 USING (id_tweets)
    WHERE t1.tag='#coronavirus'
      AND t2.tag LIKE '#%'
) t
GROUP BY (1) 
ORDER BY count DESC,tag
LIMIT 1000;
*/

-- expected output on week 10 hw db
/*
       tag       | count 
-----------------+-------
 #coronavirus    |    10
 #2021makeawish  |     1
 #auguri2021     |     1
 #BuonAnno2021   |     1
 #cov            |     1
 #covid19        |     1
 #COVID19        |     1
 #COVID19italia  |     1
 #FernandoSimón  |     1
 #GoodBye2020    |     1
 #Hello2021      |     1
 #IgnacioCamacho |     1
 #lockdown       |     1
 #lockdownitalia |     1
 #StayHome       |     1
 #temaestinzione |     1
 #vaccinare24h   |     1
 #vaccinazioni   |     1
 #vaccincovid    |     1
 #vaccine        |     1
 #vaccino        |     1
 #WearAMask      |     1
(22 rows)
*/

/*
select '#' || t.jsonb_path_query as tag, count(*) as count from (
    select
        data->>'id',
        jsonb_path_query(data, '$.extended_tweet.entities.hashtags[*]')->>'text'
        from tweets_jsonb
    where data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
    union
    select
        data->>'id',
        jsonb_path_query(data, '$.entities.hashtags[*]')->>'text'
        from tweets_jsonb
    where data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
)t
group by t.jsonb_path_query
order by count DESC, t.jsonb_path_query
limit 1000;
*/

select '#' || t.hashtag as tag, count(*) as count from (
    select
        data->>'id',
        jsonb_path_query(data, '$.extended_tweet.entities.hashtags[*]')->>'text' as hashtag
        from tweets_jsonb
    where data->'extended_tweet'->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
    union
    select
        data->>'id',
        jsonb_path_query(data, '$.entities.hashtags[*]')->>'text' as hashtag
        from tweets_jsonb
    where data->'entities'->'hashtags'@@'$[*].text == "coronavirus"'
)t
group by t.hashtag
order by count DESC, t.hashtag
limit 1000;
