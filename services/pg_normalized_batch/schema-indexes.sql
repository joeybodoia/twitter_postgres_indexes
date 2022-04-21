CREATE INDEX ON tweet_tags(tag, id_tweets);

CREATE INDEX ON tweet_tags(id_tweets, tag);

CREATE INDEX ON tweets(id_tweets, lang);

CREATE INDEX ON tweets using gin(to_tsvector('english', text)) where lang='en';
