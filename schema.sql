-- If you want to run this schema repeatedly you'll need to drop
-- the table before re-creating it. Note that you'll lose any
-- data if you drop and add a table:

-- DROP TABLE IF EXISTS articles;

-- Define your schema here:

DROP TABLE articles;

CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title varchar(255),
  url varchar(255),
  description varchar(255)
);
--
-- DROP TABLE IF EXISTS articles;
-- CREATE TABLE articles (title varchar(255), url varchar(2247), description varchar(2000));
