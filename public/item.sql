create table item
(
    itemcode        serial
        primary key,
    itembarcode     char(13),
    itemdescription varchar(255),
    itemprice       numeric(10, 2)
);

alter table item
    owner to postgres;

