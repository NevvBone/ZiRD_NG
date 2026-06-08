SELECT * FROM user_recyclebin; 
DROP TABLE JOB_HISTORY; 
SELECT original_name, droptime FROM user_recyclebin WHERE original_name = 'JOB_HISTORY'; -- check if table was moved to recycle bin
FLASHBACK TABLE JOB_HISTORY TO BEFORE DROP;