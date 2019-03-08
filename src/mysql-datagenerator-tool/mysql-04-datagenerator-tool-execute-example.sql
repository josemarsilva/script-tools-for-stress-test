-- --------------------------------------------------------------------------------------------------------------------
-- STEP #1: Gera 10.000 novos customers
-- --------------------------------------------------------------------------------------------------------------------
INSERT INTO customers
(
  cnae, document, email, ie, im, logo, mobile_phone, name_fantasy, phone, site, type, can_link_by_ean, one_time_expedition, print_quantity_invoice, print_quantity_order, printer_invoice_name, printer_tag_name, printer_tag_type, can_expedite_by_ean,
  name
)
SELECT
       cnae, document, email, ie, im, logo, mobile_phone, name_fantasy, phone, site, type, can_link_by_ean, one_time_expedition, print_quantity_invoice, print_quantity_order, printer_invoice_name, printer_tag_name, printer_tag_type, can_expedite_by_ean,
       CONCAT('STRESS TEST - #', id) AS name
FROM   (
         SELECT @rownum := @rownum + 1 AS ordinal,
                t.*
         FROM   customers t, (SELECT @rownum := 0) r
       ) stage
WHERE  stage.id = 1
;


CALL sp_stresstest_data_generation
(
  'customers', /* p_tablename: Nome da tabela */
  10000,       /* p_n_generations: Qtde de novos registros a serem gerados */
  'id',        /* p_pkcolumnname: Coluna chave primária da tabela - os registros serão inseridos um-por-um e permite acesso  variável rownum */
  'cnae, document, email, ie, im, logo, mobile_phone, name_fantasy, phone, site, type, can_link_by_ean, one_time_expedition, print_quantity_invoice, print_quantity_order, printer_invoice_name, printer_tag_name, printer_tag_type, can_expedite_by_ean', 
               /* p_listcols_nplicate: Lista das colunas que deverao ser n-plicadas */
  'name', 
               /* p_listcols_transform: Lista das colunas que serao transformadas na insercao */
  'CONCAT(''STRESS TEST - #'', id)'
               /* p_listvalues_transform: Lista dos valores transformados */
);


-- --------------------------------------------------------------------------------------------------------------------
-- STEP #2: Insere em uma tabela DE->PARA os 'customers' 
-- --------------------------------------------------------------------------------------------------------------------
INSERT INTO tb_stresstest_data_generation_dictionary ( tablename, source_id, dest_id, ordinal )
SELECT 'customers' AS tablename, id AS id, MOD(id,19)+1 AS dest_id, @rownum := @rownum + 1 AS ordinal
FROM   customers t, (SELECT @rownum := 0) r;
COMMIT;


-- --------------------------------------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------------------------------------
INSERT INTO orders
(
  bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
  customer_id, order_number
)
SELECT bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
       datagen.source_id, 
       CONCAT(order_number,'/A')
FROM   (
         SELECT 'customers' AS tablename, 
                @rownum := @rownum + 1 AS ordinal,
                t.*
         FROM   orders t, (SELECT @rownum := 0) r
         WHERE  customer_id IS NOT NULL
       ) stage,
       tb_stresstest_data_generation_dictionary datagen
WHERE  datagen.tablename = stage.tablename
AND    datagen.ordinal   = MOD( stage.ordinal, 10019) + 1
;

INSERT INTO orders
(
  bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
  customer_id, order_number
)
SELECT bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
       datagen.source_id, 
       CONCAT(order_number,'/B')
FROM   (
         SELECT 'customers' AS tablename, 
                @rownum := @rownum + 1 AS ordinal,
                t.*
         FROM   orders t, (SELECT @rownum := 0) r
         WHERE  customer_id IS NOT NULL
       ) stage,
       tb_stresstest_data_generation_dictionary datagen
WHERE  datagen.tablename = stage.tablename
AND    datagen.ordinal   = MOD( stage.ordinal, 10019) + 1
;

INSERT INTO orders
(
  bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
  customer_id, order_number
)
SELECT bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
       datagen.source_id, 
       CONCAT(order_number,'/C')
FROM   (
         SELECT 'customers' AS tablename, 
                @rownum := @rownum + 1 AS ordinal,
                t.*
         FROM   orders t, (SELECT @rownum := 0) r
         WHERE  customer_id IS NOT NULL
       ) stage,
       tb_stresstest_data_generation_dictionary datagen
WHERE  datagen.tablename = stage.tablename
AND    datagen.ordinal   = MOD( stage.ordinal, 10019) + 1
;

INSERT INTO orders
(
  bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
  customer_id, order_number
)
SELECT bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
       datagen.source_id, 
       CONCAT(order_number,'/D')
FROM   (
         SELECT 'customers' AS tablename, 
                @rownum := @rownum + 1 AS ordinal,
                t.*
         FROM   orders t, (SELECT @rownum := 0) r
         WHERE  customer_id IS NOT NULL
       ) stage,
       tb_stresstest_data_generation_dictionary datagen
WHERE  datagen.tablename = stage.tablename
AND    datagen.ordinal   = MOD( stage.ordinal, 10019) + 1
;

INSERT INTO orders
(
  bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
  customer_id, order_number
)
SELECT bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
       datagen.source_id, 
       CONCAT(order_number,'/E')
FROM   (
         SELECT 'customers' AS tablename, 
                @rownum := @rownum + 1 AS ordinal,
                t.*
         FROM   orders t, (SELECT @rownum := 0) r
         WHERE  customer_id IS NOT NULL
       ) stage,
       tb_stresstest_data_generation_dictionary datagen
WHERE  datagen.tablename = stage.tablename
AND    datagen.ordinal   = MOD( stage.ordinal, 10019) + 1
;

INSERT INTO orders
(
  bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
  customer_id, order_number
)
SELECT bling_tracking_key_id, cause, channel, complete_order_number, created, email, first_name, freight, freight_to_pay, invoice_key, last_name, last_updated, name, priority, sale_fee_freight, status, tracking_key, external_id, invoice_number, external_id_invoice, pack_number, city, state, discount, invoice_line, invoiced_issue_date, invoice_required, tracking_mode, tracking_type, tracking_carrier, tracking_method, tracking_url,
       datagen.source_id, 
       CONCAT(order_number,'/F')
FROM   (
         SELECT 'customers' AS tablename, 
                @rownum := @rownum + 1 AS ordinal,
                t.*
         FROM   orders t, (SELECT @rownum := 0) r
         WHERE  customer_id IS NOT NULL
       ) stage,
       tb_stresstest_data_generation_dictionary datagen
WHERE  datagen.tablename = stage.tablename
AND    datagen.ordinal   = MOD( stage.ordinal, 10019) + 1
;

-- --------------------------------------------------------------------------------------------------------------------
--
-- --------------------------------------------------------------------------------------------------------------------
