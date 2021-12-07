
/* Creating Schema and Table */
CREATE SCHEMA aoc21;

CREATE TABLE aoc21.depths (
    id INT IDENTITY(1,1) NOT NULL,
    measurement INT NULL
);


/* Loading data from CSV */
COPY INTO aoc21.depths (id 1, measurement 2)
FROM 'https://adlsgen2paulo.blob.core.windows.net/synapse-data/aoc21/01/depth_measurements.csv'
WITH (
    CREDENTIAL=(IDENTITY= 'Shared Access Signature', SECRET='sv=2020-02-10&st=2021-12-07T07%3A15%3A55Z&se=2021-12-08T07%3A15%3A55Z&sr=d&sp=rl&sig=eop1cZUq2Fc7uKZCw9wjaq%2FgB8%2FHrzxsbmdixWzojIs%3D&sdd=2'),
    IDENTITY_INSERT='ON',
    FIELDTERMINATOR='\t'
);

/* 
Creating CTE with calculated difference using LAG
*/
WITH variation AS (
    SELECT id, measurement, measurement - LAG(measurement)
    OVER (ORDER BY id) AS delta
    FROM aoc21.depths
);

/* 
Any positive value means an increase in depth measurement, so a simple count can be used.
*/

SELECT COUNT(*) FROM variation
WHERE delta > 0;

