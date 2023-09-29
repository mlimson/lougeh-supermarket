create view information_schema.data_type_privileges
            (object_catalog, object_schema, object_name, object_type, dtd_identifier) as
SELECT current_database()::information_schema.sql_identifier AS object_catalog,
       x.objschema                                           AS object_schema,
       x.objname                                             AS object_name,
       x.objtype::information_schema.character_data          AS object_type,
       x.objdtdid                                            AS dtd_identifier
FROM (SELECT attributes.udt_schema,
             attributes.udt_name,
             'USER-DEFINED TYPE'::text AS text,
             attributes.dtd_identifier
      FROM information_schema.attributes
      UNION ALL
      SELECT columns.table_schema,
             columns.table_name,
             'TABLE'::text AS text,
             columns.dtd_identifier
      FROM information_schema.columns
      UNION ALL
      SELECT domains.domain_schema,
             domains.domain_name,
             'DOMAIN'::text AS text,
             domains.dtd_identifier
      FROM information_schema.domains
      UNION ALL
      SELECT parameters.specific_schema,
             parameters.specific_name,
             'ROUTINE'::text AS text,
             parameters.dtd_identifier
      FROM information_schema.parameters
      UNION ALL
      SELECT routines.specific_schema,
             routines.specific_name,
             'ROUTINE'::text AS text,
             routines.dtd_identifier
      FROM information_schema.routines) x(objschema, objname, objtype, objdtdid);

alter table information_schema.data_type_privileges
    owner to postgres;

grant select on information_schema.data_type_privileges to public;

