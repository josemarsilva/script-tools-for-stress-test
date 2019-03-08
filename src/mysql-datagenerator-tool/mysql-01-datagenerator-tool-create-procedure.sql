DROP PROCEDURE IF EXISTS sp_stresstest_data_generation;

DELIMITER $$
CREATE PROCEDURE sp_stresstest_data_generation 
(
  IN p_tablename VARCHAR(255), 
  IN p_n_generations BIGINT,
  IN p_pkcolumnname VARCHAR(255), 
  IN p_listcols_nplicate VARCHAR(2000),
  IN p_listcols_transform VARCHAR(2000),
  IN p_listvalues_transform VARCHAR(2000)
)
BEGIN
  --
  -- Declare ...
  --
  DECLARE v_count_rows                     BIGINT UNSIGNED DEFAULT 0;
  DECLARE v_min_pkvalue                    BIGINT UNSIGNED;
  DECLARE v_max_pkvalue                    BIGINT UNSIGNED;
  DECLARE v_index                          BIGINT UNSIGNED DEFAULT 0;
  DECLARE v_max_commit_interval            BIGINT UNSIGNED DEFAULT 10000;
  DECLARE v_comma_and_listcols_transform   VARCHAR(2000) DEFAULT '';
  DECLARE v_comma_and_listvalues_transform VARCHAR(2000) DEFAULT '';
  DECLARE v_union_all_repetition           BIGINT UNSIGNED DEFAULT 0;
  DECLARE v_pkcolumnvalue                  BIGINT UNSIGNED DEFAULT 0;
  --
  -- Check if pk was defined ...
  --
  IF p_pkcolumnname <> '' OR p_n_generations IS NOT NULL THEN
    SET @sqlstmt = CONCAT('SELECT COUNT(1), MAX(id), MIN(id) INTO @v_count_rows, @v_max_pkvalue, @v_min_pkvalue FROM customers' );
  ELSE
    SET @sqlstmt = CONCAT('SELECT COUNT(1) INTO @v_count_rows FROM customers' );
  END IF;
  --
  -- Get COUNT(), MAX(id) and MIN(id) ...
  --
  PREPARE stmt FROM @sqlstmt;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
  --
  -- Debug some data ...
  --
  SELECT CONCAT( 'v_count_rows: ', COALESCE(@v_count_rows,'') ) AS debug_msg
  UNION ALL
  SELECT CONCAT( 'v_min_pkvalue: ', COALESCE(@v_min_pkvalue, '') ) AS debug_msg
  UNION ALL
  SELECT CONCAT( 'v_max_pkvalue: ', COALESCE(@v_max_pkvalue, '') ) AS debug_msg;  
  --
  -- Check empty table ?
  --
  IF @v_count_rows = 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Tabela nao pode estar vazia!';
  END IF;
  --
  -- Check p_listcols_transform ...
  --
  SET v_comma_and_listcols_transform = '';
  IF p_listcols_transform <> '' THEN
    SET v_comma_and_listcols_transform = CONCAT( ', ', p_listcols_transform );
  END IF;
  --
  -- Check p_listvalues_transform ...
  --
  SET v_comma_and_listvalues_transform = '';
  IF p_listvalues_transform <> '' THEN
    SET v_comma_and_listvalues_transform = CONCAT( ', ', p_listvalues_transform );
  END IF;
  --
  -- N-plicate mode: pk one-by-one or all ...
  --
  IF p_pkcolumnname <> '' OR p_n_generations IS NOT NULL THEN
    --
    -- INSERT n-plicate one-by-one
    --
	SELECT 'INSERT n-plicate one-by-one' AS debug_msg;
	SET v_pkcolumnvalue = v_min_pkvalue;
    --
    -- SQL dynamic STMT - define SQL SELECT pk-value ...
    --
    SET @sqlstmtselectpk = CONCAT(
      'SELECT ', COALESCE(p_pkcolumnname,''), ' ',
	  'INTO @v_pkcolumnvalue', ' ', 
      'FROM ',   p_tablename, ' ',
      'WHERE ',  p_pkcolumnname, ' >= ', COALESCE(@v_pkcolumnvalue,''), ' '
	  'LIMIT ',  '1'
    );
    --
    -- SQL dynamic STMT - define PREPARE ...
    --
    PREPARE stmtselectpk FROM @sqlstmtselectpk;
    --
    -- SQL dynamic STMT - define SQL INSERT one-by-one ...
    --
    SET @sqlstmtnplicate = CONCAT(
      'INSERT INTO ', p_tablename,
              ' ( ', p_listcols_nplicate, COALESCE(v_comma_and_listcols_transform,''), ' ) ', ' ',
      'SELECT ', p_listcols_nplicate, COALESCE(v_comma_and_listvalues_transform,''), ' ', 
      'FROM   ', p_tablename, ' ',
      'WHERE  ', p_pkcolumnname, ' = ', COALESCE(@v_pkcolumnvalue,''), ' '
    );
    --
    -- SQL dynamic STMT - define PREPARE ...
    --
    PREPARE stmtnplicate FROM @sqlstmtnplicate;
    --
    -- LOOP one-by-one ...
    --
    SET v_index=0;
    datageneration_loop: LOOP
      --
      SET v_index=v_index+1;
      IF v_index > p_n_generations THEN
        LEAVE datageneration_loop;
      END IF;
      --
      -- SQL dynamic STMT - define EXECUTE ...
      --
      EXECUTE stmtselectpk;
      EXECUTE stmtnplicate;
      --
      -- NEXT pk ...
      --
      SET v_pkcolumnvalue = v_pkcolumnvalue + 1;
      --
      -- Commit interval  ...
      --
      IF ( v_index % v_max_commit_interval ) = 0 THEN
        SELECT CONCAT('COMMIT interval: ', v_index) AS debug_msg;
        COMMIT;
      END IF;
      --
    END LOOP datageneration_loop;
    --
    -- SQL dynamic STMT - define DEALLOCATE ...
    --
    DEALLOCATE PREPARE stmtselectpk;
    DEALLOCATE PREPARE stmtnplicate;
    --
  ELSE
    --
    -- INSERT n-plicate all
    --
	SELECT 'INSERT n-plicate all' AS debug_msg;
    -- SQL dynamic STMT - define SQL INSERT all ...
    --
    SET @sqlstmtnplicate = CONCAT(
      'INSERT ', 'INTO ', p_tablename, ' ( ', p_listcols_nplicate, COALESCE(v_comma_and_listcols_transform,''), ' ) ', ' ',
      'SELECT ', p_listcols_nplicate, COALESCE(v_comma_and_listvalues_transform,''), ' ', 
      'FROM ',   p_tablename,  ' t, (SELECT @rownum := 0) r'
    );
	-- SELECT @sqlstmtnplicate;
    --
    -- SQL dynamic STMT - define PREPARE ...
    --
    PREPARE stmtnplicate FROM @sqlstmtnplicate;
    --
    -- SQL dynamic STMT - define EXECUTE ...
    --
    EXECUTE stmtnplicate;
    --
    -- SQL dynamic STMT - define DEALLOCATE ...
    --
    DEALLOCATE PREPARE stmtnplicate;
  END IF;
  --
  -- Last commit ...
  --
  COMMIT;
  -- 
  -- End of PROCEDURE.
  --
END $$
DELIMITER ;
