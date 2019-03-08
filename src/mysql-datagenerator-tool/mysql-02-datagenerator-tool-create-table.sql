DROP TABLE IF EXISTS tb_stresstest_data_generation_dictionary;

CREATE TABLE tb_stresstest_data_generation_dictionary
( 
  id        bigint       NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tablename varchar(255) NOT NULL,
  source_id bigint       NOT NULL,
  dest_id   bigint       NOT NULL,
  ordinal   bigint       NULL,
  CONSTRAINT ak_stresstest_data_generation_dictionary UNIQUE(tablename,source_id)
);

CREATE INDEX idx_stresstest_data_generation_dictionary_1 ON tb_stresstest_data_generation_dictionary (tablename, dest_id);
CREATE INDEX idx_stresstest_data_generation_dictionary_2 ON tb_stresstest_data_generation_dictionary (tablename, ordinal);
