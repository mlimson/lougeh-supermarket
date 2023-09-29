create view information_schema.attributes
            (udt_catalog, udt_schema, udt_name, attribute_name, ordinal_position, attribute_default, is_nullable,
             data_type, character_maximum_length, character_octet_length, character_set_catalog, character_set_schema,
             character_set_name, collation_catalog, collation_schema, collation_name, numeric_precision,
             numeric_precision_radix, numeric_scale, datetime_precision, interval_type, interval_precision,
             attribute_udt_catalog, attribute_udt_schema, attribute_udt_name, scope_catalog, scope_schema, scope_name,
             maximum_cardinality, dtd_identifier, is_derived_reference_attribute)
as
SELECT current_database()::information_schema.sql_identifier                                                                           AS udt_catalog,
       nc.nspname::information_schema.sql_identifier                                                                                   AS udt_schema,
       c.relname::information_schema.sql_identifier                                                                                    AS udt_name,
       a.attname::information_schema.sql_identifier                                                                                    AS attribute_name,
       a.attnum::information_schema.cardinal_number                                                                                    AS ordinal_position,
       pg_get_expr(ad.adbin, ad.adrelid)::information_schema.character_data                                                            AS attribute_default,
       CASE
           WHEN a.attnotnull OR t.typtype = 'd'::"char" AND t.typnotnull THEN 'NO'::text
           ELSE 'YES'::text
           END::information_schema.yes_or_no                                                                                           AS is_nullable,
       CASE
           WHEN t.typelem <> 0::oid AND t.typlen = '-1'::integer THEN 'ARRAY'::text
           WHEN nt.nspname = 'pg_catalog'::name THEN format_type(a.atttypid, NULL::integer)
           ELSE 'USER-DEFINED'::text
           END::information_schema.character_data                                                                                      AS data_type,
       information_schema._pg_char_max_length(information_schema._pg_truetypid(a.*, t.*),
                                              information_schema._pg_truetypmod(a.*, t.*))::information_schema.cardinal_number         AS character_maximum_length,
       information_schema._pg_char_octet_length(information_schema._pg_truetypid(a.*, t.*),
                                                information_schema._pg_truetypmod(a.*, t.*))::information_schema.cardinal_number       AS character_octet_length,
       NULL::name::information_schema.sql_identifier                                                                                   AS character_set_catalog,
       NULL::name::information_schema.sql_identifier                                                                                   AS character_set_schema,
       NULL::name::information_schema.sql_identifier                                                                                   AS character_set_name,
       CASE
           WHEN nco.nspname IS NOT NULL THEN current_database()
           ELSE NULL::name
           END::information_schema.sql_identifier                                                                                      AS collation_catalog,
       nco.nspname::information_schema.sql_identifier                                                                                  AS collation_schema,
       co.collname::information_schema.sql_identifier                                                                                  AS collation_name,
       information_schema._pg_numeric_precision(information_schema._pg_truetypid(a.*, t.*),
                                                information_schema._pg_truetypmod(a.*, t.*))::information_schema.cardinal_number       AS numeric_precision,
       information_schema._pg_numeric_precision_radix(information_schema._pg_truetypid(a.*, t.*),
                                                      information_schema._pg_truetypmod(a.*, t.*))::information_schema.cardinal_number AS numeric_precision_radix,
       information_schema._pg_numeric_scale(information_schema._pg_truetypid(a.*, t.*),
                                            information_schema._pg_truetypmod(a.*, t.*))::information_schema.cardinal_number           AS numeric_scale,
       information_schema._pg_datetime_precision(information_schema._pg_truetypid(a.*, t.*),
                                                 information_schema._pg_truetypmod(a.*, t.*))::information_schema.cardinal_number      AS datetime_precision,
       information_schema._pg_interval_type(information_schema._pg_truetypid(a.*, t.*),
                                            information_schema._pg_truetypmod(a.*, t.*))::information_schema.character_data            AS interval_type,
       NULL::integer::information_schema.cardinal_number                                                                               AS interval_precision,
       current_database()::information_schema.sql_identifier                                                                           AS attribute_udt_catalog,
       nt.nspname::information_schema.sql_identifier                                                                                   AS attribute_udt_schema,
       t.typname::information_schema.sql_identifier                                                                                    AS attribute_udt_name,
       NULL::name::information_schema.sql_identifier                                                                                   AS scope_catalog,
       NULL::name::information_schema.sql_identifier                                                                                   AS scope_schema,
       NULL::name::information_schema.sql_identifier                                                                                   AS scope_name,
       NULL::integer::information_schema.cardinal_number                                                                               AS maximum_cardinality,
       a.attnum::information_schema.sql_identifier                                                                                     AS dtd_identifier,
       'NO'::character varying::information_schema.yes_or_no                                                                           AS is_derived_reference_attribute
FROM pg_attribute a
         LEFT JOIN pg_attrdef ad ON a.attrelid = ad.adrelid AND a.attnum = ad.adnum
         JOIN (pg_class c
    JOIN pg_namespace nc ON c.relnamespace = nc.oid) ON a.attrelid = c.oid
         JOIN (pg_type t
    JOIN pg_namespace nt ON t.typnamespace = nt.oid) ON a.atttypid = t.oid
         LEFT JOIN (pg_collation co
    JOIN pg_namespace nco ON co.collnamespace = nco.oid)
                   ON a.attcollation = co.oid AND (nco.nspname <> 'pg_catalog'::name OR co.collname <> 'default'::name)
WHERE a.attnum > 0
  AND NOT a.attisdropped
  AND c.relkind = 'c'::"char"
  AND (pg_has_role(c.relowner, 'USAGE'::text) OR has_type_privilege(c.reltype, 'USAGE'::text));

alter table information_schema.attributes
    owner to postgres;

grant select on information_schema.attributes to public;

