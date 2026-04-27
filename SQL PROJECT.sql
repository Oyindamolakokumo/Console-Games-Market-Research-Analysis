use game_console;

describe `p9-consoledates`;
describe `p9-consolegames`;

ALTER TABLE `p9-consolegames`
MODIFY `RANK` INT PRIMARY KEY;

ALTER TABLE `p9-consolegames`
MODIFY `PLATFORM` varchar(50);

select* FROM `p9-consoledates`;
select* FROM `p9-consolegames`;

SELECT distinct Platform
FROM `p9-consolegames`
WHERE Platform NOT IN(SELECT Platform from  `p9-consoledates`);

INSERT INTO `p9-consoledates`(PLATFORM,FIRSTRETAILAVAILABILITY,DISCONTINUED,UNITSSOLDMILLIONS) valueS('PC','2017-03-03','2020-05-10',141.32);

SELECT * FROM`P9-consolegames`
WHERE PLATFORM='';

set sql_safe_update=0;

update `p9-consolegames`
set platform='Wii'
where platform='';

alter table `p9-consolegames`
add constraint fk_platform foreign key(platform) references `p9-consoledates`(platform);

select `p9-consoledates`.Platform,`p9-consoledates`.FirstRetailAvailability,`p9-consoledates`.DISCONTINUED,
`p9-consoledates`.UNITSSOLDMILLIONS,sum(`p9-consoledates`.UNITSSOLDMILLIONS* `p9-consolegames`.NA_SALES) AS NA_TOTALSALES,
`p9-consolegames`.NA_SALES/sum(`p9-consoledates`.UNITSSOLDMILLIONS*`p9-consolegames`.NA_SALES)*100 AS PERC_NA_SALES,`p9-consoledates`.`COMMENT`,
`p9-consolegames`.`RANK`,`p9-consolegames`.`NAME`, LEFT(`p9-consolegames`.`NAME`,4) AS ABV_NAME,`p9-consolegames`.`YEAR`,`p9-consolegames`.`GENRE`,
`p9-consolegames`.`PUBLISHER`,`p9-consolegames`.NA_SALES,`p9-consolegames`.EU_SALES,`p9-consolegames`.JP_Sales,`p9-consolegames`. Other_Sales
FROM `p9-consoledates`
JOIN `p9-consolegames` ON `p9-consoledates`.Platform= `p9-consolegames`.PLATFORM
WHERE month(FIRSTRETAILAVAILABILITY)=11 and day(FirstRetailAvailability) between 15 and 30 OR month(FIRSTRETAILAVAILABILITY)=12 AND day(FIRSTRETAILAVAILABILITY)<25
group by `p9-consoledates`.Platform,`p9-consoledates`.FirstRetailAvailability,`p9-consoledates`.DISCONTINUED,
`p9-consoledates`.UNITSSOLDMILLIONS,`p9-consoledates`.`COMMENT`,
`p9-consolegames`.`RANK`, `p9-consolegames`.`NAME`,`p9-consolegames`.`YEAR`,`p9-consolegames`.`GENRE`,
`p9-consolegames`.`PUBLISHER`,`p9-consolegames`.NA_SALES,`p9-consolegames`.EU_SALES,`p9-consolegames`.JP_Sales,`p9-consolegames`. Other_Sales
order by `NAME` asc,`YEAR` DESC; 

select distinct platform,FirstRetailAvailability
from `p9-consoledates`
where
-- just before black friday
(month(FirstRetailAvailability)=11 and day(FirstRetailAvailability) between 15 and 30)
or
-- just before Christmas (early to mid-december)
(month(FirstRetailAvailability) =12 and day(FirstRetailAvailability) between 1 and 24)
order by platform asc;


-- IF THE CLIENT WANTS THE COLUMN ITSELF TO CHANGE,ALTER TABLE WILL BE USED
alter table `P9-CONSOLEGAMES`
MODIFY  `YEAR` YEAR;

ALTER TABLE `P9-CONSOLEDATES`
MODIFY FirstRetailAvailability DATE;


-- COALESCE FUNCTION IS MOST LIKELY USED TO HANDLE MISSING VALUES IN A QUERY
