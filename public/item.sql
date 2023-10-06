create table item
(
    itemcode        serial
        primary key,
    itembarcode     char(13)     not null,
    itemdescription varchar(255) not null,
    itemprice       numeric(10, 2)
);

alter table item
    owner to postgres;

