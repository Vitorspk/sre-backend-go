CREATE TABLE student (
    id int,
    name VARCHAR(255)
);

INSERT INTO student(id, name) VALUES
(1,'A'),
(2,'B'),
(3,'C');

CREATE TABLE IF NOT EXISTS test (
  id           INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
  secret       VARCHAR(256) NOT NULL,
  extra        VARCHAR(256) NOT NULL,
  redirect_uri VARCHAR(256) NOT NULL
);