DROP FUNCTION IF EXISTS fn_stresstest_data_generation_dictionary;

DELIMITER $$
CREATE FUNCTION fn_stresstest_data_generation_dictionary 
(
  p_tablename VARCHAR(255), 
  p_id        BIGINT
) RETURNS BIGINT
BEGIN
  --
  -- Declare ...
  --
  DECLARE v_return BIGINT UNSIGNED DEFAULT NULL;
  
  --
  -- Convert dictionary ...
  --
  SELECT dest_id
  INTO   v_return
  FROM   tb_stresstest_data_generation_dictionary
  WHERE  tablename = p_tablename
  AND    source_id = p_id;
  
  --
  -- Not found!
  --
  IF v_return IS NULL THEN
    --
    SELECT dest_id
    INTO   v_return
    FROM   tb_stresstest_data_generation_dictionary
    WHERE  tablename = p_tablename
    AND    ordinal   = MOD( p_id, (SELECT MAX(ordinal) FROM tb_stresstest_data_generation_dictionary) ) + 1
    LIMIT  1;
    --
  END IF;
  
  --
  -- Not found again 
  --
  IF v_return IS NULL THEN
    --
    SELECT dest_id
    INTO   v_return
    FROM   tb_stresstest_data_generation_dictionary
    WHERE  tablename = p_tablename
    LIMIT  1;
    --
  END IF;
  
  --
  -- Return ...
  --
  RETURN( v_return );
  
END $$
DELIMITER ;

